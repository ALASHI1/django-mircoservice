from celery import shared_task
import time
import logging

logger = logging.getLogger(__name__)

@shared_task
def handle_request_task(data):
    logger.info(f"Started processing: {data}")
    # Simulate time-consuming task
    time.sleep(5)
    # Simulate result
    result = f"Processed request with data: {data}"
    logger.info(result)
    return result
