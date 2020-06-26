disp('entered dictionary creation');
dictionary=zeros(bsize*bsize*bands,R);
for i=1:components
    for j=1:(bsize*bsize)
      dictionary((j-1)*bands+1:j*bands,i)=neighbors(j,i)*filters(:,i);
    end
    
end