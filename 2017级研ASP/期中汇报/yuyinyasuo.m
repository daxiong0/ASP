clc;
clear all;
[xk,fs]=audioread('D:\�о���ʱ��\�γ�����\����Ӧ�źŴ���\�ҵ����л㱨\����8000.wav');
%[xk,fs,bits]=wavread('F:\Documents\sound\222.wav');
% xk=xk(:,1);
% k=length(xk);
wlen=320;win=hanning(wlen);
inc=320;
x=enframe(xk,win,inc)';
fn=size(x,2);

k=wlen;
%fs=44100;
u0=0.05;u1=0.1;%��������
k1=cell(1,300);
s2=cell(1,300);
S2=cell(1,300);
for i=1:fn
    k1{i}=zeros(2,k);%���ó�ʼȨֵ
    
    S0(1)=x(1,i);S0(2)=x(2,i);
    s0(1)=x(1,i);s0(2)=x(2,i);
    for j=3:k
        S0(j)=x(j,i);
        s0(j)=x(j,i);%s0����S'
        S1(j)=S0(j)+k1{i}(1,j).*s0(j-1);%s0����S'
        s1(j-1)=k1{i}(1,j-1).*S0(j-1)+s0(j-2);%s0����S'
        S2{i}(j)=S1(j)+k1{i}(1,j).*s1(j-1);%s0����S'
        s2{i}(j)=k1{i}(2,j).*S1(j)+s1(j-1);
        k1{i}(1,j+1)=k1{i}(1,j)-2*u0*S1(j).*s0(j-1);
        k1{i}(2,j+1)=k1{i}(2,j)-2*u1*S2{i}(j).*s1(j-1);
    end
end
%----------------��ͼ-----------------------------------------------------
% x=-2.0:0.005:0.5;
% y=-2:0.012:4;
% [x y]=meshgrid(x,y);
% %�����ܱ���
% z=(y.^2+1).*[(x.^2+1).*p0+2*x.*p1]+2*y.*[x.^2.*p0+2*x.*p1+p2];
% % �����ܱ���ĵȸ���
% figure,contour(x,y,z,[0.048 0.06 0.095 0.172 0.224 0.272 0.6]);%�ȸ���ͼ
% %��Ȩֵ�����켣
% hold on;
% plot(k0,k1,'r');
% title('LatticeLMS');
% xlabel('Ȩ��k0');
% ylabel('Ȩ��k1');
% text(0,0,'��ʼ��');

% figure;subplot(2,1,1)
% plot(S2)
% subplot(2,1,2)
% plot(s2)
% k0=-0.9945;
% k0=-0.2931;%�����
% k1=0.7400;%�����
%k0=-0.67924;%Ů��
%k1=0.19924;%Ů��
% k1=0.9111;
L=cell(1,fn);
for i=1:fn
    k0opt=mean(k1{i}(1,k-4:k));
    k1opt=mean(k1{i}(2,k-4:k));
    L{i}(1)=0;L{i}(2)=0;
    %sound(S2,fs)
    for j=3:k-1
        %         %L1(i)=(S2(i)/k1opt-s2(i))*(k1opt/(1-k1opt));
        %         L1(j)=-1*k1opt*(k0opt*L{i}(j-1)+L{i}(j-2))+S2{i}(j);
        % % l1(i-1)=s2(i)-k1*L1(i);
        % % L2(i)=(L1(i)/k0-l1(i))*(k0/(1-k0));
        %         L{i}(j)=L1(j)-k0opt*L{i}(j-1);
        L1(j)=(S2{i}(j)/k1opt-s2{i}(j))*(k1opt/(1-k1opt));
        L{i}(j)=L1(j)-k0opt*L{i}(j-1);
    end
end
xx=L{1};
s=s2{1};
for i=2:fn
    xx=[xx L{i}];
    s=[s,s2{i}];
end
figure;subplot(2,1,1)
plot(xk);
axis([1 426318 -2 2])
title('ԭʼ��Ƶ');
xlabel('������');
ylabel('��ֵ')
%  subplot(3,1,2)
%  plot(s)
subplot(2,1,2)
plot(xx);
title('��ѹ����Ƶ');

xlabel('������');
ylabel('��ֵ')
axis([1 426318 -2 2])
sound(xx,fs);
audiowrite('D:\�о���ʱ��\�γ�����\����Ӧ�źŴ���\�ҵ����л㱨\�ָ���Ƶ.wav',xx,fs);