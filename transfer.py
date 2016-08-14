import socket
import time
import numpy as np
#import scipy.io as sio

def file1():
	with open('Time.txt','r') as f:
		d=f.read().split()
		g=[float(i) for i in d ]
		t=np.asarray(g)
		return t

def file2():
	with open('RR.txt','r') as f:
		d=f.read().split()
		g=[float(i) for i in d ]
		t=np.asarray(g)
		return t

def file3():
	with open('heartrate.txt','r') as f:
		d=f.read().split()
		g=[float(i) for i in d ]
		t=np.asarray(g)
		return t
#final=sio.loadmat('results.mat')
#final=final['final'];
t=file1()
RR=file2()
heart_rate=file3()

mean_RR=np.mean(RR)
std__RR=np.std(RR)
mean_Heart_beat=np.mean(heart_rate)

UDP_IP = "192.168.1.101"

UDP_PORT = 5005          # downsampled signal
UDP_PORT2 = 5000         # Heart rate
UDP_PORT3 = 5001         # RR sample
UDP_PORT4 = 5004           # start stop
UDP_PORT5 = 5003
BUFFER_SIZE = 1024


file = open("final_ecg_down.txt","r")


test_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
test_socket2 = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
test_socket3 = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
test_socket4 = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#s.bind(("192.168.1.103",5004))
#s.listen(1)

#conn, addr = s.accept()
#print 'Connection address:', addr


starting=True
running=False
data=0

				
		
		
i=0
ii=0
last_time = time.time()
last=time.time()
last2=time.time()
last3=time.time()
total=0;
time_total=0
if(std__RR>0.1):
  st="Abnormal R-R intervals observed"	
else:
  st="normal R-R interval observed"

print st



running = True
while running:
	try:
		
	    current_time = time.time()	
	    if(current_time > last_time + 0.05) :
		last_time = current_time
		test_socket.connect(("192.168.1.103", 80))
		a=file.readline()
		A=float(a)+0.0001
		test_socket.sendto(str(A), (UDP_IP, UDP_PORT))
       	        print("sent:%s " %(str(A-0.0001)))
	    if(current_time > last+10):
	    	total=total+30		
	    	last=current_time
	    	test_socket2.connect(("192.168.1.103", 80))
	    	i=np.where(t==total)
		if(len(i[0])>0):	
		   transmit=heart_rate[i[0][0]]
		   test_socket2.sendto(str(transmit),(UDP_IP,UDP_PORT2))
		   print("**********sent2:%s " %(str(transmit)))
	    if(current_time > last2 + 1):
		last2=current_time		
		time_total=time_total+1
		test_socket3.connect(("192.168.1.103", 80))

		ii=np.where(t==time_total)
		if(len(ii[0])>0): 
		    #print("ii = %s and %s" %(len(ii[0]),str(ii[0])))  
		    transmit=RR[ii[0][0]]
		    test_socket3.sendto(str(transmit),(UDP_IP,UDP_PORT3))
		    print("--------------sent3:%s " %(str(transmit))) 
	    if(current_time > last3 + 10):
		last3=current_time
	        test_socket4.connect(("192.168.1.103", 80))
                test_socket.sendto(st, (UDP_IP, UDP_PORT5))
		print("***************///// %s" %(st))		
	except Exception:
	    running = False
	    test_socket.close()
	    raise
		
test_socket.close()
#s.close()

#personalised app for ECG monitoring using Raspi
