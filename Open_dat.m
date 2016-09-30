clear all
clc
close all
[filename, pathname] = uigetfile('*.dat', 'Open file .dat');% only image Bitmap
if isequal(filename, 0) || isequal(pathname, 0)   
    disp('File input canceled.');  
   ECG_Data = [];  
else
fid=fopen(filename,'r');
end;
time=1806;
f=fread(fid,2*360*time,'ubit12');
Orig_Sig=f(1:2:length(f));
%plot(Orig_Sig)
A=(Orig_Sig-min(Orig_Sig))/(max(Orig_Sig)-min(Orig_Sig));
A=A';
Fs=360;
ind=1;
for ind=1:30
start=1+(ind-1)*21600;
la=ind*21600;
if(la>650000)
    la=650000;
end
sig=[];
sig=3.3*A(start:la);

wo = 60/(360/2);  bw = wo/35;
[b,a] = iirnotch(wo,bw);
filt_sig = filtfilt(b,a,sig);
In=[zeros(1,100) filt_sig zeros(1,100)];
Param = 'Center';
Len = 1;
Out = movavgFilt(In, Len, Param);
threshold=0.5*(-min(-sig)+mean(sig))
% threshold=input('enter a value for threshold')


position=find(Out>threshold);
aaa=zeros(1,length(Out));
aaa(position)=Out(position);


last=position(1);
max=aaa(last);
for i=2:length(position)
    current=position(i);
    if(abs(current-last)<15)
       if(aaa(current)>max)
          aaa(last)=0;
          max=aaa(current);
       else
          aaa(current)=0;
          
       end
    else   
      max=aaa(current);
    end
    last=current;
end
%plot(Out)
%hold on
position=find(aaa>0);
aaa=zeros(1,length(Out));
aaa(position)=Out(position);
stem(aaa)
%aaa(position)=1;

%%%% q peak

R_peak=find(aaa>0);
Q_range=sort([(R_peak) (R_peak-15)]);
S_range=sort([(R_peak) (R_peak+15)]);
P_range=sort([(R_peak-15) (R_peak-100)]);
T_range=sort([(R_peak+15) (R_peak+150)]);
i=1;
c=1;
while(i<length(Q_range))
   [val,I]=min(Out(Q_range(i):Q_range(i+1))); 
   Q_Index(c)=Q_range(i)+I-1;
   [val,I]=min(Out(S_range(i):S_range(i+1)));
   S_Index(c)=S_range(i)+I-1;
   
   c=c+1;
   i=i+2; 
end

i=3;
c=1;
while(i<length(P_range))
  
   [val,I]=min(-1*Out(P_range(i):P_range(i+1))); 
   P_Index(c)=P_range(i)+I-1;
%    [val,I1]=min(-1*Out(T_range(i):T_range(i+1))); 
%    T_Index(c)=T_range(i)+I1-1;
   c=c+1;
   i=i+2; 
end
i=1;
c=1;
while(i<length(T_range)-2)
   
   [val,I1]=min(-1*Out(T_range(i):T_range(i+1))); 
   T_Index(c)=T_range(i)+I1-1;
   c=c+1;
   i=i+2; 
end
aaa(R_peak)=Out(R_peak);
aaa(S_Index)=Out(S_Index);
aaa(Q_Index)=Out(Q_Index);
aaa(P_Index)=Out(P_Index);
aaa(T_Index)=Out(T_Index);
% plot(Out)
% hold on 
% stem(aaa)

%figure

% plot(Out)
% hold on
% plot(S_Index,Out(S_Index), '*', 'MarkerSize', 10);
% hold on
% plot(P_Index,Out(P_Index), '*', 'MarkerSize', 10);
% hold on
% plot(T_Index,Out(T_Index), '*', 'MarkerSize', 10);
% hold on
% plot(Q_Index,Out(Q_Index), '*', 'MarkerSize', 10);
% hold on
% plot(R_peak,Out(R_peak), '*', 'MarkerSize', 10);


RR=[];PR=[];QRS=[];QT=[];QTc=[];
le=length(R_peak(2:end));
RR=(R_peak(2:end)-R_peak(1:le))/360;
PR=(R_peak(2:end)-P_Index(1:le))/360;
QRS=-(Q_Index-S_Index)/360;
QT=-(Q_Index(1:end-1)-T_Index)/360;
if(length(QT)>length(RR))
    le=length(RR);
else
    le=length(QT);
end
QTc=QT(1:le)./sqrt(RR(1:le));

% figure
% plot(RR)
% hold on
% plot(PR)
% hold on 
% plot(QT)
% hold on
% plot(QTc)
% figure
% plot(QRS)

Results(ind,:)=[mean(RR) mean(PR) mean(QT) mean(QTc) mean(QRS) 60/mean(RR) length(R_peak)];
end