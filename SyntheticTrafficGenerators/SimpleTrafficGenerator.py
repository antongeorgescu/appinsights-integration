#  
# read the data from the URL and print it
#
from urllib.request import urlopen
import ssl
import sched, time
import datetime
import random

ssl._create_default_https_context = ssl._create_unverified_context

url_archworksportal = "https://architectworksportal20221125195927.azurewebsites.net"
url_loggerapi =  "https://loggerapidemo20221127093952.azurewebsites.net"

url_ui = ["https://architectworksportal20221125195927.azurewebsites.net",
          "https://architectworksportal20221125195927.azurewebsites.net/pubs",
          "https://architectworksportal20221125195927.azurewebsites.net/logger-to-apm"]

name_contain_list = ["ee","sb","mo","ea","ar","ylv","al","te","gh","ur"]

def poll_url(scheduler):
   
    # schedule the next call first
    scheduler.enter(60, 1, poll_url, (scheduler,))

    # Test randomly the UI selects 
    list_index = random.randrange(1,len(url_ui))
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    request_url = url_ui[list_index-1] 
    webUrl = urlopen(request_url)
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
    time.sleep(0.005)

    # Test URL https://<base_url_archworkportal>/auto-synth-traffic/<logs_count>  
    # get random number of logs
    log_count = random.randrange(21,40)
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    request_url = f"{url_archworksportal}/auto-synth-traffic/{log_count}" 
    webUrl = urlopen(request_url)
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
    time.sleep(0.005)

    # Test URL https://<base_url_loggerapi>/ilogger/logfilecontent/<logfile_name>  
    curr_date = datetime.datetime.now().strftime("%Y%m%d")
    filename = f'log_{curr_date}.log'
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    request_url = f"{url_loggerapi}/ilogger/logfilecontent/{filename}" 
    webUrl = urlopen(request_url)
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
    time.sleep(0.005)
 
    # Test database performance with URL https://<base_url_archworkportal>/portalutilities/pubs/db  
    curr_date = datetime.datetime.now().strftime("%Y%m%d")
    filename = f'log_{curr_date}.log'
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    request_url = f"{url_archworksportal}/portalutilities/pubs/db" 
    webUrl = urlopen(request_url)
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
    time.sleep(0.005)

    # Create database traffic with URL https://<base_url_archworkportal>/pubs/namecontains/{author_contains}}/titlecontains/{title_contains}  
    curr_date = datetime.datetime.now().strftime("%Y%m%d")
    filename = f'log_{curr_date}.log'
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    list_index = random.randrange(1,len(name_contain_list)) - 1
    request_url = f"{url_archworksportal}/pubs/namecontains/{name_contain_list[list_index]}/titlecontains/%5E=%5E"
    webUrl = urlopen(request_url)
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
    time.sleep(0.005)

if __name__ == "__main__":
    my_scheduler = sched.scheduler(time.time, time.sleep)
    my_scheduler.enter(60, 1, poll_url, (my_scheduler,))
    my_scheduler.run()
