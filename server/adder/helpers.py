import json
from functools import wraps
from typing import Union

import os
from unittest import result
from django.http import JsonResponse, HttpRequest
from telethon import TelegramClient
from telethon.sessions import SQLiteSession
from .constants import PROGRESS_STATE
from celery.result import AsyncResult, allow_join_result
from .models import TelegramAuthorization
from .exceptions import TelegramAuthorizationException, PayloadException


class CoreProgress(object):
    def __init__(self, task_id) -> None:
        self.task_id = task_id
        self.result = AsyncResult(task_id)

    def _get_completed_progress(self):
        return {
            'current': 100,
            'total': 100,
            'percent': 100,
        }

    def _get_unknown_progress(self):
        return {
            'pending': True,
            'current': 0,
            'total': 100,
            'percent': 0,
        }

    def get_info(self):
        print(self.result.state,"dawf")
        if self.result.ready():
            success = self.result.successful()
            with allow_join_result():
                return {
                    'complete': True,
                    'success': success,
                    'progress': self._get_completed_progress(),
                    'result': self.result.get(self.task_id) if success else str(self.result.info),
                }
        elif self.result.state == PROGRESS_STATE:
            return {
                'complete': False,
                'success': None,
                'progress': self.result.info
            }
        elif self.result.state in ['PENDING', 'STARTED']:
            return {
                'complete': False,
                'success': None,
                'progress': self._get_unknown_progress(),
            }


class Telegram:

    @staticmethod
    def get_client(request_or_phone: Union[HttpRequest, str], session_class=SQLiteSession) -> TelegramClient:
        """
        Create and return prepared telegram client based request or phone
        """
        session_path = "/Users/mac/projects/fun/grpadder/telegram-extras/server/sessions"
        api_id = 1027637
        api_hash = "da1df5c8b2e03ec778c97f7f74fc9649"

        if isinstance(request_or_phone, HttpRequest):
            user = request_or_phone.user
            try:
                telegram_authorization = TelegramAuthorization.objects.get(
                    user=user)
            except TelegramAuthorization.DoesNotExist:
                raise TelegramAuthorizationException(
                    "User doesn't have valid telegram session")
            phone = telegram_authorization.phone
        else:
            phone = request_or_phone

        if session_class == SQLiteSession:
            # default behavior
            if not session_path:
                raise TelegramAuthorizationException(
                    "SQLite session implementation used, but variable TG_SESSION_PATH was not set."
                )
            session = SQLiteSession(os.path.join(
                session_path, "%s.session" % phone))
        else:
            session = session_class(phone)

        client = TelegramClient(
            session,
            api_id,
            api_hash,
            spawn_read_thread=False,
            report_errors=False
        )
        connected = client.connect()
        if not connected:
            raise TelegramAuthorizationException(
                "Can't connect to telegram servers")

        return client

    @staticmethod
    def is_authorized(request) -> bool:
        """
        Determine whether user has authorized session based on HttpRequest
        """
        try:
            client = Telegram.get_client(request)
        except TelegramAuthorizationException:
            return False

        return client.is_user_authorized()


def parse_json_payload(body, *keys):
    """
    Parse request.body and yield lookup values
    """
    try:
        raw_payload = body.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PayloadException("Cant decode body '%s'\n%s" % (body, exc))
    try:
        payload = json.loads(raw_payload)
    except (ValueError, TypeError) as exc:
        raise PayloadException(
            "Can't load JSON from raw payload '%s'\n%s" % (raw_payload, exc))
    for key in keys:
        yield payload.get(key)


def require_post(func):
    @wraps(func)
    def wrapper(request, *args, **kwargs):
        if request.method == "POST":
            return func(request, *args, **kwargs)
        return JsonResponse({"success": False, "message": "Only POST requests allowed"})

    return wrapper


def login_required(func):
    @wraps(func)
    def wrapper(request, *args, **kwargs):
        if request.user.is_authenticated:
            return func(request, *args, **kwargs)
        return JsonResponse({"success": False, "message": "Authentication required"})

    return wrapper
