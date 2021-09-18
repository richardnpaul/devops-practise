import boto3
import os
from datetime import datetime


def handler(event, context):

    if not event.get('Content-Length') or int(event['Content-Length']) > 4096:
        # POST requests should be a reasonable size or we should reject them
        # Check header exists, check size
        exit(1)

    if event.get('Authorization') != os.getenv('auth_token'):
        # Super simple check on authorization
        exit(1)

    # Get the three fields, or if they weren't submitted set to a string identifying that fact
    name_str = event.get("name","no name was submitted")
    email_str = event.get("email","no email was submitted")
    msg_str = event.get("msg","no msg was submitted")

    # Deal with blank strings being submitted
    if not name_str:
        name_str = "blank"
    if not email_str:
        email_str = "blank"
    if not msg_str:
        msg_str = "blank"

    body_str = f"Name: {name_str}\nEmail: {email_str}\nMessage: {msg_str}\n"
    body_str.encode("utf-8")

    current_time = datetime.utcnow().strftime('%Y%m%d%H%M%S%f')

    bucket_name = os.getenv('bucket_name')
    file_name = f"{name_str.replace(' ', '-')}{email_str.replace(' ', '-')}.txt"
    s3_path = f"{current_time}-{file_name}"

    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=body_str)
