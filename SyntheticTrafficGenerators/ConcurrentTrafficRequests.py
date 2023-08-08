import sys
import subprocess
import sys
import time
import argparse, sys

parser=argparse.ArgumentParser()

parser.add_argument("--frequency", help="Sessions bursts in seconds")
parser.add_argument("--concurrent", help="Number of concurrent sessions in a burst")
parser.add_argument("--indelay", help="Delay between sessions in a burst, in miliseconds")

args=parser.parse_args()

concurr_reqs = int(args.concurrent)          # get number of concurrent requests
in_between_milisecs = int(args.indelay)      # set number of miliseconds between session starts
burst_frequency = args.frequency             # frequency in secs of sessions bursts

print(f'# concurrent sessions in a burst: {concurr_reqs}')
print(f'# miliseconds between sessions in a burst: {in_between_milisecs}')
print(f'# seconds between sessions bursts: {burst_frequency}')
procs = []
for i in range(concurr_reqs):
    proc = subprocess.Popen([sys.executable, 'SimpleTrafficGenerator.py', burst_frequency])
    procs.append(proc)

for proc in procs:
    proc.wait()
    time.sleep(in_between_milisecs)