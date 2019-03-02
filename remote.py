from celery import Celery

BACKEND_URL = "redis://18.197.145.237:6379/0"
BROKER_URL = "redis://18.197.145.237:6379/1"

app = Celery('remote', broker=BROKER_URL, backend=BACKEND_URL)

@app.task
def say_hello(name=''):
    return 'Hello, '+name
