#  
# read the data from the URL and print it
#
from urllib.request import urlopen
import ssl
import time
import datetime
import sys
import traceback
import argparse

sys.tracebacklimit = 0

ssl._create_default_https_context = ssl._create_unverified_context

print("Run on ePT CBS services")
URL_BASE = "https://nslsvctier-qa03.devservices.dh.com"

services = [
    {"service": "service", "healthurl": "env"},
    {"service": "beh", "healthurl": "env"},
    {"service": "businessruleexecution", "healthurl": "env"},
    {"service": "casemanagement", "healthurl": "env"},
    {"service": "cjdatacollector", "healthurl": "env"},
    {"service": "contentmanager", "healthurl": "env"},
    {"service": "disbursements", "healthurl": "env"},
    {"service": "docgeneration", "healthurl": "env"},
    {"service": "document", "healthurl": "env"},
    {"service": "eapplication", "healthurl": "env"},
    {"service": "enrolment", "healthurl": "env"},
    {"service": "fda", "healthurl": "env"},
    {"service": "legacyintegration", "healthurl": "env"},
    {"service": "loaninformation", "healthurl": "env"},
    {"service": "logger", "healthurl": "health"},
    {"service": "messenger", "healthurl": "env"},
    {"service": "ontariomicroloan", "healthurl": "env"},
    {"service": "payment", "healthurl": "env"},
    {"service": "paymentreport", "healthurl": "env"}, 
    {"service": "reminder", "healthurl": "env"},   
    {"service": "repaymentassistance", "healthurl": "health"}
]

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

if __name__ == "__main__":
    # Test CBS health endpoints
    for list_index in range(0,len(services)-1):
        try:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            service_line = services[list_index]
            request_url = f'{URL_BASE}/{service_line["service"]}/{service_line["healthurl"]}'
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")   
        finally:
            time.sleep(0.005)