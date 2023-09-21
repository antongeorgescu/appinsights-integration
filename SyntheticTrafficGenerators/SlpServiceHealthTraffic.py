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

parser=argparse.ArgumentParser()

parser.add_argument("--cbstype", help="Type of CBS API (eg feature, worker, etc.)")
parser.add_argument("--iterations", help="Number of request repeats)")

args=parser.parse_args()
CBS_TYPE = args.cbstype
ITERS = int(args.iterations)


if (CBS_TYPE == 'feature'):
    print("Run on ePT CBS feature services")
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
elif (CBS_TYPE == 'worker'):
    print("Run on ePT CBS worker services")
    URL_BASE = "https://nslworker-qa03.devservices.dh.com"
    services = [
        {"service": "worker", "healthurl": "env"},
        {"service": "fda", "healthurl": "env"},
        {"service": "fda", "healthurl": "health"},
        {"service": "messenger", "healthurl": "env"},
        {"service": "datahub", "healthurl": "env"},
    ]
elif (CBS_TYPE == "apigateway"):
    URL_BASE = "https://slapi-qa03.devservices.dh.com"
    services = [
        {"service": "", "healthurl": "env"},
        {"service": "", "healthurl": "health"},
    ]


ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

if __name__ == "__main__":
    for i in range(ITERS):
        # Run the specified number of iterations
        print(f'Iteration: {i}')
        # Test CBS health endpoints
        for list_index in range(0,len(services)):
            try:
                curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
                service_line = services[list_index]
                if (service_line["service"] == ''):
                    request_url = f'{URL_BASE}/{service_line["healthurl"]}'
                else:
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