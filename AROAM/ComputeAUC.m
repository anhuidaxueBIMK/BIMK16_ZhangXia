function AUC=ComputeAUC(Xte,Yte,w)
  m=length(Yte);%存放数据个数
labelval=[Yte,Xte*w'];
labelval=sortrows(labelval,2);%对预测决策值升序排序
num=[1 0;-1 0];%数组暂存每个标签及其对应的个数
num_right=0;%临时变量存储划分正确的个数
%每来一个样本，对其计数，对最后结果从小到大排序
for i=1:m
    if labelval(i,1)==1;
        num(1,2)=num(1,2)+1;%对当前数据对应的标签其个数加1
        tmp=sum(num(2,2));%统计比当前标签小的数据个数
        num_right=num_right+tmp;%当前划分正确的个数
    end
   if labelval(i,1)==-1%当前标签为-1，只对其数据个数加1
           num(2,2)=num(2,2)+1;
    end
end
       Numm=num(1,2)*num(2,2);
AUC=num_right/Numm;