function [c,time]=updateClassSCRMS(Xt,Yt,eta)
[M,N]=size(Xt);
indices=crossvalind('Kfold', Xt(1:M,N), 5);%K�۽���
c=zeros(1,5);
time=zeros(1,5);
for k=1:5%������֤k=5��5����������Ϊ���Լ�
        test =(indices ==k); %���test��Ԫ�������ݼ��ж�Ӧ�ĵ�Ԫ���
        train = ~test;%train��Ԫ�صı��Ϊ��testԪ�صı��
       Xtr=Xt(train,:);%/�����ݼ��л��ֳ�train����������
Ytr=Yt(train,:);%����������Ĳ���Ŀ�꣬�ڱ�������ʵ�ʷ������
        Xte=Xt(test,:);%test������
Yte=Yt(test,:);
lambda=2^-10;
    m=length(Ytr);%����������ݸ���
  d=size(Xtr,2);%�������ά��
   tic;
Xtr1=Xtr(Ytr==1,:);
Xtr2=Xtr(Ytr~=1,:);
num1=size(Xtr1,1);
num2=size(Xtr2,1);
   w=zeros(1,d);
   www=zeros(1,d);
 epoh=20;
vt=zeros(1,d);
mmm=ceil(m/epoh);
for i=1:mmm
    index1=unidrnd(num1,1,epoh);%�������в���epoh�������
    index2=unidrnd(num2,1,epoh);%�������в���epoh�������
     Xt1=Xtr1(index1,:);%���ѡ��epoh��������
  Xt2=Xtr2(index2,:);%���ѡ��epoh��������
 data=Xt1-Xt2;%����������
    loss=zeros(1,d);
    nnn=size(data,1);
for j=1:nnn
   tmp=data(j,:);
        if(tmp*w'<1) 
         loss=loss+(w*tmp'-1)*tmp;%������ʧ
        end;
end
gt=lambda*w+(1/epoh)*loss;%�����ݶ�
         vt=(1-1/i)*vt+(1/i)*(gt.^2);
    w=w-eta*(gt./(i*vt+exp(-0.1*i*vt)));%����ģ��
      w=min(1,(1/sqrt(lambda))/norm(w,2))*w; %ͶӰ
     www=(1-1/i)*www+1/i*w;%on the fly���·�����
end;
time(k)=toc;
AUC=ComputeAUC(Xte,Yte,w);
c(k)=AUC;
c(isnan(c)) = 0;
end