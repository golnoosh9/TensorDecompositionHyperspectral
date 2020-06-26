disp('feature calculation enter');
imageFeatures=zeros(rows,cols,R);
count=1;
parpool(36)
parfor i=1:rows
    for j=1:cols
        count=1;
        temp_patch=zeros(1,bsize*bsize*bands);
        xrange=i-bsize/2+1:i+bsize/2;
        yrange=j-bsize/2+1:j+bsize/2;
        if(i<bsize/2 )
          xrange=1:bsize;
        end
        if(i>rows-bsize)
          xrange=rows-bsize+1:rows;
        end
        
        if(j<bsize/2 )
          yrange=1:bsize;
        end
        if(j>cols-bsize)
          yrange=cols-bsize+1:cols;
        end
      %  patch_temp=
        for kx=1:bsize
            for ky=1:bsize
                temp_patch((count-1)*bands+1:count*bands)=reshape(image(xrange(kx),yrange(ky),:),[1 bands]);    
                 count=count+1;
            end
        end
        imageFeatures(i,j,:)=as_nnls(dictionary,temp_patch');
    end 
end
delete(gcp('nocreate'));
                                     


