import sys
import subprocess
import sys

# get number of consurrent requests
concurr_reqs = int(sys.argv[1])

print(f'# concurrent requests: {concurr_reqs}')
procs = []
for i in range(concurr_reqs):
    proc = subprocess.Popen([sys.executable, 'SimpleTrafficGenerator.py'])
    procs.append(proc)

for proc in procs:
    proc.wait()