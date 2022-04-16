from concurrent.futures import process
import random
import time
from adder.helpers import Telegram
from adder.models import TelegramAuthorization
from adder.utils import add_to_grp
from celery import Celery
from decimal import Decimal
from grad.celery import app
from .base import BaseTask
from celery_progress.backend import ProgressRecorder
from django.contrib.auth.models import User


@app.task(name='tasks.add')
def add(x, y):
    return x + y


@app.task(name='task.long_task')
def long_task():
    for x in range(0, 100):
        time.sleep(1)
        print(f"Running {x}")
    return True


class RunTelegramGroupAddProcess(BaseTask):
    name = "RunTelegramGroupAddProcess"

    def __init__(self) -> None:
        self.ttask_id = None

    def progress(self, duration, time_):
        current = round(time_ / duration * 100)
        total = 100
        percent = 0
        if total > 0:
            percent = (Decimal(current) / Decimal(total)) * Decimal(100)
            percent = float(round(percent, 2))

        self.update_state(
            task_id=self.ttask_id,
            state='PROGRESS',
            meta={
                'current': current,
                'total': total,
                'percent': percent,
            }
        )

    def run(self, targets, group, mode, *args, **kwargs):
        progress_recorder = ProgressRecorder(self)
        self.ttask_id = self.request.id
        print(type(targets), "Dawg")
        targets_count = len(targets)
        updates = 0
        for idx, target in enumerate(targets):
            finished = 100*(idx/targets_count)
            # TODO: get user id from parent
            usr = User.objects.first()
            telegram_authorization = TelegramAuthorization.objects.get(
                user=usr)
            client = Telegram.get_client(telegram_authorization.phone)
            group_entity = client.get_entity(group)

            add_to_grp(
                client,
                mode=mode,
                data={"uid": target["id"], "uhash": target["access_hash"]},
                uname=int(target["id"]),
                grid=group_entity.id,
                grhash=group_entity.access_hash,
            )
            if divmod(finished, 10) == (updates, 0):
                updates += 1
                process_msg = 'Finished processing {} % of all events'.format(
                    int(finished))
                print(process_msg)
                progress_recorder.set_progress(
                    int(finished), total=100, description=f"Running {process_msg}")

        # for x in range(0, 100):
        #     time.sleep(1)
        #     progress_recorder.set_progress(
        #         x, total=100, description=f"Running {x}")

        return {
            "detail": "Success"
        }


@app.task(bind=True, base=RunTelegramGroupAddProcess)
def init_telegram_invite_process(self, *args, **kwargs):
    return super(type(self), self).run(*args, **kwargs)
