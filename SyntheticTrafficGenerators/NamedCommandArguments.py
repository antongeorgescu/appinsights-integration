import argparse, sys

parser=argparse.ArgumentParser()

parser.add_argument("--frequency", help="Sessions bursts in seconds")
parser.add_argument("--concurrent", help="Number of concurrent sessions in a burst")
parser.add_argument("--indelay", help="Delay between sessions in a burst, in miliseconds")

args=parser.parse_args()

print(f"Args: {args}\nCommand Line: {sys.argv}\nfrequency: {args.frequency}")
print(f"Dict format: {vars(args)}")