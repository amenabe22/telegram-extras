import json
import graphene
from pprint import pprint
from adder.mutations import(
    RequestTelegramAuthCode, SubmitTelegramAuthCode, TelegramAuthLogout, TelegramTestSession)
from adder.models import TelegramAuthorization
from django.contrib.auth.models import User
from adder.helpers import CoreProgress, Telegram
from telethon.tl.types import InputPeerEmpty
from telethon.tl.functions.messages import GetDialogsRequest
from adder.types import TelegramGroupsType
from adder.mutations import ScrapeFromTelegramGroup
from adder.mutations import AddTelegramGroupMembers


class Query(graphene.ObjectType):
    fetch_members = graphene.List(TelegramGroupsType)
    get_task_progress = graphene.JSONString(task=graphene.String())

    def resolve_get_task_progress(self, info, task):
        progress = CoreProgress(task)
        return json.dumps(progress.get_info())

    def resolve_fetch_members(self, info):
        usr = User.objects.first()
        telegram_authorization = TelegramAuthorization.objects.get(user=usr)
        client = Telegram.get_client(telegram_authorization.phone)
        chats = []
        last_date = None
        chunk_size = 200
        groups = []
        result = client(
            GetDialogsRequest(
                offset_date=last_date,
                offset_id=0,
                offset_peer=InputPeerEmpty(),
                limit=chunk_size,
                # hash=0,
            )
        )
        chats.extend(result.chats)

        for chat in chats:
            groups.append(chat)
        par = []

        for p in groups:
            par.append({"title": p.title, "id": p.id})
            # print("[{}] {}".format(p, groups[p].title))

        return par


class Mutations(graphene.ObjectType):
    request_auth_code = RequestTelegramAuthCode.Field(
        description="Request telegram auth code")
    submit_auth_code = SubmitTelegramAuthCode.Field(
        description="Submit Authorization code")
    telegram_logout = TelegramAuthLogout.Field(
        description="Logout form telegram")
    check_user_status = TelegramTestSession.Field(
        description="Check user telegram status with username")
    scrape_from_group = ScrapeFromTelegramGroup.Field(
        description="Scrape from a telegram group"
    )
    add_telegram_members = AddTelegramGroupMembers.Field(
        description="Mutation to add members to groups and members"
    )


schema = graphene.Schema(query=Query, mutation=Mutations)
