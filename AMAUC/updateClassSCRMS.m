function [c,time]=updateClassSCRMS(Xt,Yt,eta)
[M,N]=size(Xt);
indices=crossvalind('Kfold', Xt(1:M,N), 5);%K折交叉
c=zeros(1,5);
time=zeros(1,5);
for k=1:5%交叉验证k=5，5个包轮流作为测试集
        test =(indices ==k); %获得test集元素在数据集中对应的单元编号
        train = ~test;%train集元素的编号为非test元素的编号
       Xtr=Xt(train,:);%/从数据集中划分出train样本的数据
Ytr=Yt(train,:);%获得样本集的测试目标，在本例中是实际分类情况
        Xte=Xt(test,:);%test样本集
Yte=Yt(test,:);
lambda=2^-10;
    m=length(Ytr);%存放最新数据个数
  d=size(Xtr,2);%存放数据维度
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
    index1=unidrnd(num1,1,epoh);%正样本中产生epoh个随机数
    index2=unidrnd(num2,1,epoh);%负样本中产生epoh个随机数
     Xt1=Xtr1(index1,:);%随机选择epoh个正样本
  Xt2=Xtr2(index2,:);%随机选择epoh个负样本
 data=Xt1-Xt2;%产生样本对
    loss=zeros(1,d);
    nnn=size(data,1);
for j=1:nnn
   tmp=data(j,:);
        if(tmp*w'<1) 
         loss=loss+(w*tmp'-1)*tmp;%计算损失
        end;
end
gt=lambda*w+(1/epoh)*loss;%计算梯度
         vt=(1-1/i)*vt+(1/i)*(gt.^2);
    w=w-eta*(gt./(i*vt+exp(-0.1*i*vt)));%更新模型
      w=min(1,(1/sqrt(lambda))/norm(w,2))*w; %投影
     www=(1-1/i)*www+1/i*w;%on the fly更新分类器
end;
time(k)=toc;
AUC=ComputeAUC(Xte,Yte,w);
c(k)=AUC;
c(isnan(c)) = 0;
end