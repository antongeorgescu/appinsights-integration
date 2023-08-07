import sys
import subprocess
import sys
import time


concurr_reqs = int(sys.argv[1])     # get number of concurrent requests
in_between_secs = int(sys.argv[2])  # set number of seconds between session starts

print(f'# concurrent sessions: {concurr_reqs}')
print(f'# seconds between sessions: {in_between_secs}')
procs = []
for i in range(concurr_reqs):
    proc = subprocess.Popen([sys.executable, 'SimpleTrafficGenerator.py'])
    procs.append(proc)

for proc in procs:
    proc.wait()
    time.sleep(in_between_secs)