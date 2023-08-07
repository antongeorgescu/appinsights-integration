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

def poll_url(scheduler):
   
    # schedule the next call first
    scheduler.enter(60, 1, poll_url, (scheduler,))

    # get random number of logs
    log_count = random.randrange(21,40)

    # open a connection to a URL using urllib2
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    request_url = f"{url_archworksportal}/auto-synth-traffic/{log_count}" 
    webUrl = urlopen(request_url)
      
    #get the result code and print it
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
      
    curr_date = datetime.datetime.now().strftime("%Y%m%d")
    

    filename = f'log_{curr_date}.log'
    
    curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
    request_url = f"{url_loggerapi}/ilogger/logfilecontent/{filename}" 
    webUrl = urlopen(request_url)
      
    #get the result code and print it
    print(f'[{curr_date_time}] Response {webUrl.getcode()} and content length {len(webUrl.read())} on request {request_url}')
 
if __name__ == "__main__":
    my_scheduler = sched.scheduler(time.time, time.sleep)
    my_scheduler.enter(60, 1, poll_url, (my_scheduler,))
    my_scheduler.run()
