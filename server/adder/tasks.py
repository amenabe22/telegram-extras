import random
from celery import Celery
from grad.celery import app


@app.task(name='tasks.add')
def add(x, y):
    return x + y
