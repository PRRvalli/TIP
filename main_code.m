fileID = fopen('Arry_data2.txt','r');
formatSpec = '%f';
sizeA = [1 Inf];
A=fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

tic
Fs=360;
sig=3.3*A;%(1+2048:2048+2048);
wo = 60/(360/2);  bw = wo/35;
[b,a] = iirnotch(wo,bw);
filt_sig = filtfilt(b,a,sig);
In = filt_sig;
Param = 'Center';
Len = 5;
Out = movavgFilt(In, Len, Param);
% plot(filt_sig)
% 
% 
% hold on
% plot(In,'r')
% hold on
% plot(Out ,'c')

[c,l]=wavedec(Out,4,'db4');

ca1=appcoef(c,l,'db4',1);
ca2=appcoef(c,l,'db4',2);
% ca3=appcoef(c,l,'db4',3);
% ca4=appcoef(c,l,'db4',4);

%sampling reduses by factor of 2

% figure
% subplot(221)
% plot(linspace(0,1,length(ca1)),ca1)
% subplot(222)
% plot(linspace(0,1,length(ca2)),ca2)
% subplot(223)
% plot(linspace(0,1,length(ca3)),ca3)
% subplot(224)
% plot(linspace(0,1,length(ca4)),ca4)

threshold=(min(-1*ca2)+mean(ca2))/2;
position=find(ca2>threshold);
aaa=zeros(1,length(ca2));
aaa(position)=2;
cp=position(1);
for i=2:length(position)
   diff=abs(cp-position(i)); 
   if(diff<50) 
      aaa(position(i))=0;
   end
   cp=position(i);
end


% removing the adjacent 
% update position
position=find(aaa==2);
range=[(position-10) (position+10)];
p_range=[(position-10) (position-30)];
t_range=[(position+5) (position+35)];
% aaa=zeros(1,length(ca2));
% aaa(p_range)=3;
% aaa(range)=2;
% aaa(t_range)=4;

% figure
% plot(ca2)
% hold on
% stem(aaa)

truth_sig=sig;
sig=Out;

scaled_range=sort(range*4);
pscaled_range=sort(p_range*4);
tscaled_range=sort(t_range*4);
% bbb=zeros(1,length(sig));
% bbb(pscaled_range)=1.5;
% bbb(scaled_range)=1;
% bbb(tscaled_range)=2;
% 
% figure
% plot(sig)
% hold on
% stem(bbb)

i=1;
c=1;
while(i<length(pscaled_range))
   [val,I]=min(-1*sig(pscaled_range(i):pscaled_range(i+1))); 
   p_Index(c)=pscaled_range(i)+I-1;
   sig(p_Index(c));
   c=c+1;
   i=i+2; 
end
c=1;
i=1;
while(i<length(scaled_range))
   [val,I]=min(-1*sig(scaled_range(i):scaled_range(i+1))); 
   Index(c)=scaled_range(i)+I-1;
   sig(Index(c));
   c=c+1;
   i=i+2; 
end

i=1;
c=1;
while(i<length(tscaled_range))
   [val,I]=min(-1*sig(tscaled_range(i):tscaled_range(i+1))); 
   t_Index(c)=tscaled_range(i)+I-1;
   sig(t_Index(c));
   c=c+1;
   i=i+2; 
end



q_range=sort([Index-10 Index]);
s_range=sort([Index+10 Index]);
i=1;
c=1;
while(i<length(q_range))
   [val,I]=min(sig(q_range(i):q_range(i+1))); 
   q_Index(c)=q_range(i)+I-1;
   sig(q_Index(c));
   c=c+1;
   i=i+2; 
end
i=1;
c=1;
while(i<length(q_range))
   [val,I]=min(sig(s_range(i):s_range(i+1))); 
   s_Index(c)=s_range(i)+I-1;
   sig(s_Index(c));
   c=c+1;
   i=i+2; 
end

bbb=zeros(1,length(sig));
bbb(p_Index)=sig(p_Index);
bbb(Index)=sig(Index);
bbb(t_Index)=sig(t_Index);
bbb(q_Index)=sig(q_Index);
bbb(s_Index)=sig(s_Index);
figure
plot(sig)
hold on
stem(bbb,'r')
toc

figure
plot(sig)
hold on
plot(s_Index,sig(s_Index), '*', 'MarkerSize', 10);
hold on
plot(q_Index,sig(q_Index), '*', 'MarkerSize', 10);
hold on
plot(t_Index,sig(t_Index), '*', 'MarkerSize', 10);
hold on
plot(Index,sig(Index), '*', 'MarkerSize', 10);
hold on
plot(p_Index,sig(p_Index), '*', 'MarkerSize', 10);
