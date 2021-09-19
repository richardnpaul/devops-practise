import boto3
import json
import os
from datetime import datetime


def handler(event, context):

    # Get the three fields, or if they weren't submitted set to a string identifying that fact
    body_obj = json.loads(event.get("body"))
    name_str = body_obj.get("name","no name was submitted")
    email_str = body_obj.get("email","no email was submitted")
    msg_str = body_obj.get("msg","no msg was submitted")

    # Deal with blank strings being submitted
    if not name_str or not body_obj:
        name_str = "blank"
    if not email_str or not body_obj:
        email_str = "blank"
    if not msg_str or not body_obj:
        msg_str = "blank"

    body_str = f"Name: {name_str}\nEmail: {email_str}\nMessage: {msg_str}\n"
    body_str.encode("utf-8")

    current_time = datetime.utcnow().strftime('%Y%m%d%H%M%S%f')

    bucket_name = os.getenv('bucket_name')
    file_name = f"{name_str.replace(' ', '-')}{email_str.replace(' ', '-')}.txt"
    s3_path = f"{current_time}-{file_name}"

    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=body_str)
