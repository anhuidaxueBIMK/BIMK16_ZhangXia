  function B=BufferFIFO(B,instance,t,s)
if size(B,1)<s
        B=[B;instance];
else
        index=mod(t,s);
        if index~=0
            B(index,:)=instance;
        else
            B(s,:)=instance;
    end
        end
  end