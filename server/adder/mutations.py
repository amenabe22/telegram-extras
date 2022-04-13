import csv
import os
import logging
import graphene
import pandas as pd

from .utils import add_to_grp, cleanCSVData
from .helpers import Telegram
from django.conf import settings
from .types import MembersResponse
from django.utils.text import slugify
from .models import TelegramAuthorization
from django.contrib.auth.models import User
from telethon.tl.types import PeerUser, InputPeerChat
from .exceptions import TelegramAuthorizationException
from telethon.errors import RPCError, SessionPasswordNeededError

logger = logging.getLogger("django-telethon-authorization")

# TODO: add better exception handling


class RequestTelegramAuthCode(graphene.Mutation):
    status = graphene.Boolean()

    class Arguments:
        phone = graphene.String()

    # only admins can do this
    def mutate(self, info, phone):
        stat = False
        usr = User.objects.all()[0]
        auth, _ = TelegramAuthorization.objects.get_or_create(
            user=usr, phone=phone)

        try:
            client = Telegram.get_client(phone)

        except TelegramAuthorizationException as e:
            stat = False

        if client.is_user_authorized():
            stat = False

        try:
            response = client.send_code_request(phone)
            auth.phone_code_hash = response.phone_code_hash
            auth.save()
            client.disconnect()
            stat = True

        except Exception as e:
            return False

        return RequestTelegramAuthCode(status=stat)


class SubmitTelegramAuthCode(graphene.Mutation):
    status = graphene.Boolean()

    class Arguments:
        phone = graphene.String()
        password = graphene.String()
        code = graphene.String()

    def mutate(self, info, phone, password, code):
        fin_response = True
        try:
            user = User.objects.all()[0]
            auth = TelegramAuthorization.objects.get(user=user, phone=phone)
        except TelegramAuthorization.DoesNotExist as e:
            print(e, "error")
            fin_response = False

        client = Telegram.get_client(phone)

        try:
            client.sign_in(auth.phone, code,
                           phone_code_hash=auth.phone_code_hash)
        except SessionPasswordNeededError:
            if password:
                client.sign_in(password=password)
            else:
                fin_response = False
                # return JsonResponse({
                #     "success": False, "message": "Two Factor Authorization enabled. Please provide both code and password"
                # })

        except RPCError as e:
            fin_response = False
            # return JsonResponse(
            #     {"success": False, "message": "Telegram exception occurred. %s. %s. %s" % (e.code, e.message, str(e))})

        except Exception as e:
            logger.warning(
                "TG Login. POST. Error occurred during telegram sign-in\n%s" % e)
            fin_response = False
            # return JsonResponse({"success": False, "message": "'Error occurred during telegram sign-in\n%s'" % e})

        client.disconnect()

        # do not store hash after successful login
        auth.phone_code_hash = None
        auth.save()

        return SubmitTelegramAuthCode(status=fin_response)


class TelegramAuthLogout(graphene.Mutation):
    status = graphene.Boolean()

    class Arguments:
        phone = graphene.String()

    def mutate(self, info, phone):
        stat = True
        try:
            user = User.objects.first()
            telegram_authorization = TelegramAuthorization.objects.get(
                user=user, phone=phone)
        except TelegramAuthorization.DoesNotExist:
            stat = False
            # return JsonResponse({"success": False, "message": "Phone '%s' is invalid'" % phone})

        client = Telegram.get_client(telegram_authorization.phone)

        if client.log_out():
            # delete auth record
            telegram_authorization.delete()
            stat = True
        else:
            stat = False

        return TelegramAuthLogout(status=stat)


class TelegramTestSession(graphene.Mutation):
    status = graphene.String()

    class Arguments:
        username = graphene.String()

    def mutate(self, info, username):
        # TODO: change first user object to a user base independent layout
        usr = User.objects.first()
        telegram_authorization = TelegramAuthorization.objects.get(user=usr)
        client = Telegram.get_client(telegram_authorization.phone)
        last_date = None
        chunk_size = 200
        groups = []

        target = client.get_input_entity(username)
        my_chat = client.get_entity(PeerUser(target.user_id))
        print("Activity Status: ", my_chat.status)

        return TelegramTestSession(status=str(my_chat.status))


class ScrapeFromTelegramGroup(graphene.Mutation):
    download_path = graphene.String()

    class Arguments:
        id = graphene.Int()

    def mutate(self, info, id):
        members_list = []
        usr = User.objects.first()
        telegram_authorization = TelegramAuthorization.objects.get(user=usr)
        client = Telegram.get_client(telegram_authorization.phone)
        group_entity = client.get_entity(id)
        members = client.get_participants(group_entity)
        for mb in members:
            members_list.append({
                # "id": mb.id,
                "name": mb.first_name,
                "username": mb.username,
                "phone": mb.phone
            })
        df = pd.DataFrame.from_dict(members_list)
        storage_path = os.path.join(settings.BASE_DIR, "media/members_export")
        clean_title = slugify(group_entity.title)
        df.to_csv(f'{storage_path}/{clean_title}.csv',
                  index=False, header=True)
        download_path = f"http://{info.context.get_host()}/media/members_export/{clean_title}.csv"
        return ScrapeFromTelegramGroup(download_path=download_path)


class AddTelegramGroupMembers(graphene.Mutation):
    stat = graphene.Boolean()

    class Arguments:
        group = graphene.String()
        username = graphene.String()

    def mutate(self, info, group, username):
        usr = User.objects.first()
        telegram_authorization = TelegramAuthorization.objects.get(user=usr)
        client = Telegram.get_client(telegram_authorization.phone)
        group_entity = client.get_entity(group)

        # TODO: add identifier for the scraped file.
        storage_path = os.path.join(settings.BASE_DIR, "media/members_export/Coders_Needed.csv")

        csvUsrs = cleanCSVData(storage_path)
        for usr in csvUsrs[0:10]:
            add_to_grp(
                client,
                mode="uname",
                data=None,
                uname=usr["username"],
                grid=group_entity.id,
                grhash=group_entity.access_hash,
            )
            print("Added: {}".format(usr["username"]))
        return AddTelegramGroupMembers(stat=True)
