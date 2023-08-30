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
parser.add_argument("--environment", help="'debug' for Visual Studio or 'local' for IIS Website hosted locally")

args=parser.parse_args()

ssl._create_default_https_context = ssl._create_unverified_context

ENV = args.environment
if (ENV == "debug"):
    print("Run in Debug mode")
    URL_BASE = "http://localhost:5066"
elif (ENV == "prod"):
    print("Run in Production mode")
    URL_BASE = "http://STDLJHXX0T3.finastra.global/searchpublications"


url_ui = [f'{URL_BASE}/',
            f'{URL_BASE}/health',
            f'{URL_BASE}/health/dbschema',
            f'{URL_BASE}/pubs',
            f'{URL_BASE}/pubs/byauthor?likestr=*LIKESTR*',
            f'{URL_BASE}/pubs/bytitle?likestr=*LIKESTR*',
            f'{URL_BASE}/pubs/bycity?likestr=*LIKESTR*',
            f'{URL_BASE}/pubs/bystate?likestr=*LIKESTR*',
            f'{URL_BASE}/author/withcontract']
            

author_like_list = ["ee","sb","mo","ea","ar","ylv","al","te","gh","ur"]
title_like_list = ["our","ght","lley","Em","on","tud","fty","sh","mba","ndly"]
city_like_list = ["alo","San","kl","ville","Ci","ash","Wa","lo","ry"]
state_list = ["CA","KS","TN","OR","MI","IND","MD","UT","NY","IL"]

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
        try:
            list_index = random.randrange(1,len(url_ui))
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            request_url = url_ui[list_index-1] 
            
            if (request_url.find('byauthor')>0):
                list_index = random.randrange(1,len(author_like_list)) - 1
                request_url = request_url.replace('*LIKESTR*',author_like_list[list_index])
            elif (request_url.find('bytitle')>0):
                list_index = random.randrange(1,len(title_like_list)) - 1
                request_url = request_url.replace('*LIKESTR*',title_like_list[list_index])
            elif (request_url.find('bycity')>0):
                list_index = random.randrange(1,len(city_like_list)) - 1
                request_url = request_url.replace('*LIKESTR*',city_like_list[list_index])
            elif (request_url.find('bystate')>0):
                list_index = random.randrange(1,len(state_list)) - 1
                request_url = request_url.replace('*LIKESTR*',state_list[list_index])

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