import random
import time
from celery import Celery
from decimal import Decimal
from grad.celery import app
from .base import BaseTask
from celery_progress.backend import ProgressRecorder


@app.task(name='tasks.add')
def add(x, y):
    return x + y


@app.task(name='task.long_task')
def long_task():
    for x in range(0, 100):
        time.sleep(1)
        print(f"Running {x}")
    return True


class RunLongProcess(BaseTask):
    name = "RunLongProcess"

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
                'description': 'counting sheeps'
            }
        )

    def run(self, *args, **kwargs):
        progress_recorder = ProgressRecorder(self)
        self.ttask_id = self.request.id
        for x in range(0, 100):
            time.sleep(1)
            progress_recorder.set_progress(
                x, total=100, description=f"Running {x}")

        return {
            "detail": "Success"
        }




@app.task(bind=True, base=RunLongProcess)
def init_long_process(self, *args, **kwargs):
    return super(type(self), self).run(*args, **kwargs)