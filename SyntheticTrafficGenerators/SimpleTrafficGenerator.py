#  
# read the data from the URL and print it
#
from urllib.request import urlopen
import ssl
import sched, time
import datetime
import random
import sys
import traceback
import argparse

sys.tracebacklimit = 0

parser=argparse.ArgumentParser()

parser.add_argument("--frequency", help="Tests session bursts in seconds")
parser.add_argument("--environment", help="'azure' for AppServices; 'local' for IIS Website hosted locally")

args=parser.parse_args()

ssl._create_default_https_context = ssl._create_unverified_context

ENV = args.environment
if (ENV == "appservices"):
    print("Run on Azure app services")
    url_loggerapi =  "https://loggerapidemo20221127093952.azurewebsites.net"
    url_ui = ["https://architectworksportal20221125195927.azurewebsites.net",
              "https://architectworksportal20221125195927.azurewebsites.net/pubs",
              "https://architectworksportal20221125195927.azurewebsites.net/logger-to-apm",
              "https://loggerapidemo20221127093952.azurewebsites.net/ilogger/logfiles",
              "https://loggerapidemo20221127093952.azurewebsites.net/ilogger/health"]
elif (ENV == "local"):
    print("Run on local IIS websites")
    url_archworksportal = "http://STDLJHXX0T3.finastra.global"
    url_loggerapi =  "http://STDLJHXX0T3.finastra.global/loggerapi"
    url_ui = ["http://STDLJHXX0T3.finastra.global",
              "http://STDLJHXX0T3.finastra.global/pubs",
              "http://STDLJHXX0T3.finastra.global/logger-to-apm",
              "http://stdljhxx0t3.finastra.global/loggerapi/ilogger/logfiles",
              "http://stdljhxx0t3.finastra.global/loggerapi/ilogger/health"]
    url_apminsights = ["http://STDLJHXX0T3.finastra.global/site24x7apminsights/health",
              "http://STDLJHXX0T3.finastra.global/site24x7apminsights/health/pubs/byauthor?likestr=ee",
              "http://STDLJHXX0T3.finastra.global/site24x7apminsights/health/pubs/bytitle?likestr=Ex",
              "http://STDLJHXX0T3.finastra.global/site24x7apminsights/health/dbschema"]
elif (ENV == "debug"):
    print("Run on local IIS websites")
    url_archworksportal = "https://localhost:44451"
    url_loggerapi =  "http://localhost:5001/ilogger"
    url_ui = ["https://localhost:44451",
              "https://localhost:44451/pubs",
              "https://localhost:44451/logger-to-apm",
              "http://localhost:5001/ilogger/logfiles",
              "http://localhost:5001/ilogger/health"]

name_contain_list = ["ee","sb","mo","ea","ar","ylv","al","te","gh","ur"]

# frequency of call burst within 60 secs interval -- in seconds
session_burst_freq = int(args.frequency)

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

def poll_url(scheduler):
   
    try:
        # schedule the next call first
        scheduler.enter(session_burst_freq, 1, poll_url, (scheduler,))

        # if env in [azurevm, local] test Site24x7APMInsights agent
        if (ENV in ['local','azurevm']):
            try:
                list_index = random.randrange(1,len(url_apminsights))
                curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
                request_url = url_apminsights[list_index-1] 
                webUrl = urlopen(request_url,context=ctx)
                print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
            except Exception as X:
                curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
                print(f'[{curr_date_time}] Error on request {request_url}')
                exc_info = sys.exc_info()
                print(f"{''.join(traceback.format_exception(*exc_info))}")   

            time.sleep(0.005)

        # Test randomly the UI selects 
        try:
            list_index = random.randrange(1,len(url_ui))
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            request_url = url_ui[list_index-1] 
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")

        time.sleep(0.005)

        # Test URL https://<base_url_archworkportal>/auto-synth-traffic/<logs_count>  
        try:
            # get random number of logs
            log_count = random.randrange(21,40)
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            request_url = f"{url_archworksportal}/auto-synth-traffic/{log_count}" 
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")
        
        time.sleep(0.005)

        # Test URL https://<base_url_loggerapi>/ilogger/logfilecontent/<logfile_name>  
        try:
            curr_date = datetime.datetime.now().strftime("%Y%m%d")
            filename = f'log_{curr_date}.log'
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            request_url = f"{url_loggerapi}/ilogger/logfilecontent/{filename}" 
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")
        
        time.sleep(0.005)
    
        # Test database performance with URL https://<base_url_archworkportal>/portalutilities/pubs/db  
        try:
            curr_date = datetime.datetime.now().strftime("%Y%m%d")
            filename = f'log_{curr_date}.log'
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            request_url = f"{url_archworksportal}/portalutilities/pubs/db" 
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")
        
        time.sleep(0.005)

        # Create database traffic with URL https://<base_url_archworkportal>/pubs/namecontains/{author_contains}}/titlecontains/{title_contains}  
        try:
            curr_date = datetime.datetime.now().strftime("%Y%m%d")
            filename = f'log_{curr_date}.log'
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            list_index = random.randrange(1,len(name_contain_list)) - 1
            request_url = f"{url_archworksportal}/pubs/namecontains/{name_contain_list[list_index]}/titlecontains/%5E=%5E"
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")
        
        time.sleep(0.005)

        # Test randomly the UI selects 
        try:
            list_index = random.randrange(1,len(url_ui))
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            request_url = url_ui[list_index-1] 
            webUrl = urlopen(request_url,context=ctx)
            print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {request_url}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")
        
        time.sleep(0.005)

    except Exception as X:
        curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
        exc_info = sys.exc_info()
        print(f"[{curr_date_time}] {''.join(traceback.format_exception(*exc_info))}")

if __name__ == "__main__":
    try:
        curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
        print(f"[{curr_date_time}] Program started.")
        my_scheduler = sched.scheduler(time.time, time.sleep)
        my_scheduler.enter(2, 1, poll_url, (my_scheduler,))
        my_scheduler.run()
    
    except Exception as X:
        curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
        exc_info = sys.exc_info()
        print(f"[{curr_date_time}] {''.join(traceback.format_exception(*exc_info))}")