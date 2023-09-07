import ssl
import sys
import traceback
import pyodbc
import pandas as pd
import datetime
import time
import random
import argparse

sys.tracebacklimit = 0

parser=argparse.ArgumentParser()

parser.add_argument("--testcount", help="Number of tests to be run")
args=parser.parse_args()

ssl._create_default_https_context = ssl._create_unverified_context

TEST_COUNT = args.testcount

strlikes = ['FE','DO','CS','MM','77','finastra','PP','LO','Test','ME','KR','AN','TA','MA','EZ']
CORE_QRY = 'SELECT TOP (100) [CU2_COUSYS],[CU2_CUSNUM],[CU2_RECTYP],[CU2_EMAIL],[CU2_EMAIL_UPDATE],[CU2_EMAIL_UPTIME],[CU2_EMAIL_UPTERM] FROM [Y01_LOAN].[dbo].[PCLLCU2]'

if __name__ == "__main__":
    # Test Sql Server database health
    try:
        conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=VC01WSQLQA018.devservices.dh.com\INST01;'
                      'Database=Y01_LOAN;'
                      'Trusted_Connection=yes;')
    except Exception as X:
        exc_info = sys.exc_info()
        print(f"{''.join(traceback.format_exception(*exc_info))}")   
        exit()
    
    for list_index in range(0,TEST_COUNT):
        try:
            strindex = random.randrange(1,len(strlikes))  

            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            strlike = strlikes[strindex]
            query = f'{CORE_QRY} WHERE CU2_EMAIL LIKE \'%{strlike}%\''
            df = pd.read_sql_query(query, conn)
            print(df)
            print(type(df))
            print(f'[{curr_date_time}] Returned {len(df)} rows on query {query}')
        except Exception as X:
            curr_date_time = datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")
            print(f'[{curr_date_time}] Error on request {query}')
            exc_info = sys.exc_info()
            print(f"{''.join(traceback.format_exception(*exc_info))}")   
        finally:
            time.sleep(0.005)

