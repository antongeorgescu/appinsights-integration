import lorem
import random
import sys
import datetime
import time
import requests
import ssl
import uuid
import json

ssl._create_default_https_context = ssl._create_unverified_context

ex_class_list = [
    "IndexOutOfRangeException",
    "NullReferenceException",
    "InvalidOperationException",
    "ArgumentNullException",
    "ArgumentOutOfRangeException"
]

log_level = ['ERROR','WARN','INFO']

url_loggerapi = 'https://logc.site24x7.com/event/receiver?token=ODgyMDk3ZjVjODU4YTQxZmMzYjc0YzFjOTc5ZDU3NzUvc3R1ZGVudGxlbmRpbmdwb2Nsb2d0eXBl'

# create new test file
logfile = f'docs/{str(uuid.uuid4())}.log'

print("START TEST...")

for inx in range(25):
    # generate lorem ipsum random sentence
    sent = lorem.sentence()
    # para = lorem.paragraph()
    # text = lorem.text()

    # generate random exception class from the list
    inx = random.randint(0, len(ex_class_list)-1)
    hash_str = hash(sent) % ((sys.maxsize + 1) * 2)
    log_msg = f'SOURCE*NetCoreILogger*ID*{hash_str}*CLASS*{ex_class_list[inx]}*MESSAGE*{sent}'
    print(log_msg)

    # get current datetime
    date_time = datetime.datetime.now()
    # print(date_time)

    # get unix timestamp
    ts_unix = int(time.mktime(date_time.timetuple()))
    # print(ts_unix)

    ojson = {'_zl_timestamp':ts_unix,'loglevel': log_level[random.randint(0,2)],'message':log_msg}
    strjson = json.dumps(ojson)
    weburl = requests.post(url_loggerapi,data=strjson,headers={"Content-Type": "application/json"})
    response = f'[{datetime.datetime.now()}] Status code={weburl.status_code}, headers={weburl.headers}, request object={ojson}'
    print(response)

    with open(logfile, 'a') as file:
        file.write(f'{response}\n')

    time.sleep(10)

print("END TEST.")