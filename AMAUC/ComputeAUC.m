function AUC=ComputeAUC(Xte,Yte,w)
  m=length(Yte);%������ݸ���
labelval=[Yte,Xte*w'];
labelval=sortrows(labelval,2);%��Ԥ�����ֵ��������
num=[1 0;-1 0];%�����ݴ�ÿ����ǩ�����Ӧ�ĸ���
num_right=0;%��ʱ�����洢������ȷ�ĸ���
%ÿ��һ��������������������������С��������
for i=1:m
    if labelval(i,1)==1;
        num(1,2)=num(1,2)+1;%�Ե�ǰ���ݶ�Ӧ�ı�ǩ�������1
        tmp=sum(num(2,2));%ͳ�Ʊȵ�ǰ��ǩС�����ݸ���
        num_right=num_right+tmp;%��ǰ������ȷ�ĸ���
    end
   if labelval(i,1)==-1%��ǰ��ǩΪ-1��ֻ�������ݸ�����1
           num(2,2)=num(2,2)+1;
    end
end
       Numm=num(1,2)*num(2,2);
AUC=num_right/Numm;