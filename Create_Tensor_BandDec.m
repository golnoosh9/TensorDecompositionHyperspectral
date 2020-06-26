addpath('/home/research/g.dehghanpoor/libraries/asp-master')
addpath('/home/research/g.dehghanpoor/libraries/MSVMpack1-5')
addpath('/home/research/g.dehghanpoor/libraries/MSVMpack1-5/matlab')
addpath('/home/research/g.dehghanpoor/libraries/tensorlab_2016-03-28')
diary('mnew.text');
clear all;
%%%according to indian_pines doc bands: 1,33,97,161 were all zeros and not
%%%used
rng('shuffle');
filename= 'PaviaU' ;

load('Indian_pines_corrected');

load('Indian_pines_gt');
image=indian_pines_corrected;
image_gt=indian_pines_gt;
size(image)

train_on_image=1;

databaseID=0;%%%1 for salinas, 0 for indian_pines, 2 for pavia U
[r,c,bands]=size(image);
image_added=zeros(r,c,224);


if(databaseID==1)
%      image_added(:, :, 1:108) = image(:, :, 1:108);
%              image_added(:, :, 113:154) = image(:, :, 108:149);
%              image_added(:, :, 168:224) = image(:, :, 149:205);
% 
    image(:,:,[1,33,97,161])=[]; 
end
if(databaseID==2)

    image(:,:,2)=[]; 
end
% else
%     image_added(:,:,1:104)=image(:,:,1:104);
%     image_added(:,:,110:150)=image(:,:,105:145);
%     image_added(:,:,165:220)=image(:,:,145:200);
%     end
% image=image_added;
[r,c,bands]=size(image);
for i=1:bands
    
meanImage=min(min(image(:,:,i)));
image(:,:,i)=image(:,:,i)-meanImage*ones(size(image(:,:,i)));
maxImage=max(max(image(:,:,i)));
image(:,:,i)=image(:,:,i)./maxImage*255;
end


class_num=max(max(image_gt));

T=permute(image,[3 1 2]);;
Ttemp=double(T); 
[bands row_original col_original]=size(Ttemp);

rows=row_original;
cols=col_original;

maxAccuracy=0;
im_predict_max=[];
max_features=[];


flatImage=reshape(image_gt,[rows*cols 1]);

inds=[];
for ii=1:class_num
    ii
    classInds=find(flatImage==ii);
    
   
    size_i=size(classInds,1);
    if(size_i==0)
        continue;
    end
    
 classInds=classInds(randi( size_i,1,floor(0.1*size_i)));
inds=cat(1,inds, classInds);


end

 size_i=size(inds,1);

bsize=2
begin=1
bbegin=1
count=1
bcount=1

totalFeatures=[];
for bsize=8:8:8
    R=75;
components=75;
trainingNum=75  ;



pcount=1;

if(train_on_image==1)

rand_num=2000;
clear patches;
while(pcount<rand_num)
    
    i=randi([bsize/2,rows-bsize/2-1]);
    j=randi([bsize/2,cols-bsize/2-1]);
    if(image_gt(i,j)>0)
        fcount=1;
       for x=i-bsize/2+1:i+bsize/2
           for y=j-bsize/2+1:j+bsize/2
               patch=Ttemp(:,i,j);
               patches(:,pcount,fcount)=patch;
               fcount=fcount+1;
           end
       end
     
     pcount=pcount+1;      
   end
   
   
end

   

FactorizeTensor;

CreateDictionaryBands;

save(strcat('Dictionary',int2str(bsize)),'dictionary');

else
   load(strcat('Dictionary',int2str(bsize)));
end

create_centered_features_bands;
totalFeatures=cat(3,totalFeatures,imageFeatures);
end
SVM_train;
class_accuracy=zeros(class_num,1);
for i=1:class_num
indsi=(find(labeled_pixels_crop==i));
true_labelsi=labeled_pixels_crop(indsi);
labelsi=labels(indsi);
i
class_accuracy(i)=(mean(true_labelsi==labelsi)*100);

end
class_accuracy
AverageAccuracy=mean(class_accuracy)



