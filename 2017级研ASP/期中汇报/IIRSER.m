clear all;
close all;
clc;
[b1,b2]=meshgrid(-2:0.02:2,-1:0.01:1);
z1=0.5*(b1+sqrt(b1.^2+4*b2));%极点z1
z2=0.5*(b1-sqrt(b1.^2+4*b2));%极点z2
%极点z1处的留数
R1=(1./(1-b1.*z1-b2.*z1.^2)-2./(0.6*z1.^2-1.2*z1+1)).*z1./(z1-z2);
%极点z2处的留数
R2=(1./(1-b1.*z2-b2.*z2.^2)-2./(0.6*z2.^2-1.2*z2+1)).*z2./(z2-z1);
MSE=25/7+R1+R2;
figure;contour(b1,b2,real(MSE),[0.1, 0.3, 0.5 ,0.7 ,0.9 ,0.99]*5);%等高线
axis([-2 2 -1 1]);

%IIR-SER
k=600;
lamda=0.51;%λav
a=0.93;
q0=1;
%设置起始值
Q{3}=q0*eye(3);%Q0的逆矩阵的起始值
wk1=zeros(3,k);
wk1(:,1)=[0 0 0]';% 起始权值,其中第一行表示权值a0，第二行表示权值b1，第二行表示权值b2

alpha0=zeros(1,k);  %此处初始化alpha0 beita1，beita2
beita1=zeros(1,k);
beita2=zeros(1,k);
xk=sqrt(0.5)*randn(1,k);%输入白噪声
M=diag([0.05 0.01 0.005]);%M的值
dk=zeros(1,k);%定义dk的数组
dk(1)=xk(1);  %先计算dk的前两个值
dk(2)=xk(2)+dk(1)*1.2;
yk=zeros(1,k);
yk(1)=xk(1);%先计算yk的前两个值
yk(2)=xk(2)+yk(1)*wk1(2,2);
Uk=zeros(3,k);
Uk(:,1)=[xk(1) 0 0]';%先计算U的前两个值
Uk(:,2)=[xk(2) yk(1) 0]';

for i=3:k-1
    Uk(:,i)=[xk(i) yk(i-1) yk(i-2)]';
    yk(i)=wk1(:,i)'*Uk(:,i);%输出信号
    dk(i)=xk(i)+1.2*dk(i-1)-0.6*dk(i-2);%期望信号
    err(i)=dk(i)-yk(i);%误差
    alpha0(i)=xk(i)+wk1(2,i)*alpha0(i-1)+wk1(3,i)*alpha0(i-2);
    beita1(i)=yk(i-1)+wk1(2,i)*beita1(i-1)+wk1(3,i)*beita1(i-2);
    beita2(i)=yk(i-2)+wk1(2,i)*beita2(i-1)+wk1(3,i)*beita2(i-2);
    gra=-2*err(i)*[alpha0(i),beita1(i) beita2(i)]';
    S{i}=Q{i}*Uk(:,i);
    v=a+Uk(:,i)'*S{i};
    Q{i+1}=(1/a)*(Q{i}-S{i}*S{i}'/v);
    wk1(:,i+1)=wk1(:,i)-M*lamda*(1-a^(i+1))*Q{i+1}*gra/(1-a);
end
hold on;plot(wk1(2,:),wk1(3,:),'b');
xlabel('权，b1')
ylabel('权，b2')
title('IIRSER,600次迭代')
%标注最佳权值的位置
hold on;plot(1.2,-0.6,'*');