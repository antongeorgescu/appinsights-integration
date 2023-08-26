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
if (ENV == "appservices_nuget"):
    print("Run on Azure app services")
    URL_AWPORTAL = "https://architectworksportal20221125195927.azurewebsites.net"  # APMInsights .NET Core Agent (NUGET): ArchitectWorksPortal20221125195927
    URL_LOGGERAPI =  "https://loggerapidemo20221127093952.azurewebsites.net"  # APMInsights .NET Core Agent (NUGET): LoggerApiDemo20221127093952
    URL_APMINSIGHTS =  None
elif (ENV == "appservices_ext"):
    print("Run on Azure app services")
    URL_AWPORTAL = "https://architectworksportal20221125195927.azurewebsites.net"  # APMInsights .NET Core Agent (NUGET): ArchitectWorksPortal20221125195927
    URL_LOGGERAPI =  "https://loggerapidemo20221127093952.azurewebsites.net"  # APMInsights .NET Core Agent (NUGET): LoggerApiDemo20221127093952
    URL_APMINSIGHTS =  "https://xsite24x7netcoreinsights20230826121210.azurewebsites.net"  # <apminsights agent with Azure extension - NOT WORKING>
elif (ENV == "local"):
    print("Run on local IIS websites")
    URL_AWPORTAL = "http://STDLJHXX0T3.finastra.global"     # <apminsights agent with with ClrProfiler - NOT WORKING>
    URL_LOGGERAPI =  "http://STDLJHXX0T3.finastra.global/loggerapi"  # <apminsights agent with ClrProfiler - NOT WORKING>
    URL_APMINSIGHTS =  "http://STDLJHXX0T3.finastra.global/site24x7apminsights"     # APMInsights .NET Core Agent (NUGET): ArwopoNugetAgent
elif (ENV == "debug"):
    print("Run on local IIS websites")
    URL_AWPORTAL = "https://localhost:44451"  # <apminsights agent with with ClrProfiler - NOT WORKING>
    URL_LOGGERAPI =  "http://localhost:5001/ilogger"  # <apminsights agent with ClrProfiler - NOT WORKING>
    URL_APMINSIGHTS =  "http://localhost:5097" # <apminsights agent with ClrProfiler - NOT WORKING>

url_ui = [f'{URL_AWPORTAL}',
            f'{URL_AWPORTAL}/pubs',
            f'{URL_AWPORTAL}/logger-to-apm',
            f'{URL_LOGGERAPI}/ilogger/logfiles',
            f'{URL_LOGGERAPI}/ilogger/health']
if URL_APMINSIGHTS is not None:
    url_apminsights = [f'{URL_APMINSIGHTS}/health',
                f'{URL_APMINSIGHTS}/health/pubs/byauthor?likestr=ee',
                f'{URL_APMINSIGHTS}/health/pubs/bytitle?likestr=Ex',
                f'{URL_APMINSIGHTS}/health/dbschema']

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

        # Test apm insights
        if URL_APMINSIGHTS is not None:
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
            request_url = f"{URL_AWPORTAL}/auto-synth-traffic/{log_count}" 
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
            request_url = f"{URL_LOGGERAPI}/ilogger/logfilecontent/{filename}" 
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
            request_url = f"{URL_AWPORTAL}/portalutilities/pubs/db" 
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
            request_url = f"{URL_AWPORTAL}/pubs/namecontains/{name_contain_list[list_index]}/titlecontains/%5E=%5E"
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