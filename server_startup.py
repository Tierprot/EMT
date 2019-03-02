import asyncio
import os

async def create_task(command):
    process = await asyncio.create_subprocess_shell(command)
    await process.wait()

def celery_task_string(functions='remote'):
    return 'celery -A {functions} worker --loglevel=info --concurrency=1'.format(functions=functions)

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    celery = celery_task_string()
    commands = asyncio.gather(create_task(celery))
    loop.run_until_complete(commands)
    loop.close()
