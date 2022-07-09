import subprocess

f = open("/tmp/private_ips.txt")
ips = f.read().split("\n")

for i in ips:
    subprocess.run([f"ssh-keyscan -H {i} >> ~/.ssh/known_hosts"], stdout=subprocess.PIPE, shell=True)
