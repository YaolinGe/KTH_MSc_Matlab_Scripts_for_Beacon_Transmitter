function [res]=filterC(data,filt,Ndata,Nfilt)

% res=zeros(1,Ndata+2-2*Nfilt);
res=re2complex(zeros(1,Ndata));
intersum=re2complex(zeros(1,Nfilt));

% iires=1; % Index of result
for i=1:Ndata
    if(i==Ndata)
        a=1;
    end
    dataslice.re=data.re(i:i+Nfilt-1); 
    dataslice.im=data.im(i:i+Nfilt-1); 
    intersum(:)=mult_complexC(dataslice,filt);
%         intersum(:)=data(i:i+Nfilt-1).*filt;
    res=assign_complex(res,i,sum_complexC(intersum));
%     iires=iires+1;
%     i
end
% Nvalid=iires-1;
end