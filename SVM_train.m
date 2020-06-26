
indexes=randi([1 200],1,30)
% imageFeatures=cat(3,imageFeatures,indian_pines_corrected(:,:,indexes));
% trainingNum=trainingNum+3;
thisScaleMax=0;
thisScale_features=[];

for i=1:1
train_patch=[];%patch_factorss()
train_labels=[];%
class_num=max(max(image_gt));
flatImage=reshape(image_gt,[rows*cols 1]);
% for j=1:trainingNum
%   
%    meanImage=min(min(imageFeatures(:,:,j)));
%    imageFeatures(:,:,j)=imageFeatures(:,:,j)-meanImage*ones(size(imageFeatures(:,:,j)));
%    maxImage=max(max(imageFeatures(:,:,j)));
%    imageFeatures(:,:,j)=imageFeatures(:,:,j)./maxImage;
% end
flatFeatures=reshape(totalFeatures(:,:,1:trainingNum),[rows*cols trainingNum]);

%trainingNum=48*9;
% m = csvread('foo_salinas.csv');
% m=reshape(m,[rows cols trainingNum]);
% 
% 
% 
% newm=zeros(217,512,trainingNum);
% for j=1:trainingNum
%    newm(:,:,j)=m(:,:,j)'; 
%    meanImage=min(min(newm(:,:,j)));
%    newm(:,:,j)=newm(:,:,j)-meanImage*ones(size(newm(:,:,j)));
%    maxImage=max(max(newm(:,:,j)));
%    newm(:,:,j)=newm(:,:,j)./maxImage*20;
% end
% 
% newm=reshape(newm,[rows*cols trainingNum]);
% 
% flatFeatures=newm;

train_patch= flatFeatures(inds,:);


train_labels=flatImage(inds,:);
 flatImage(inds)=0;

%   train_patch=cat(1,train_patch,tc);%%sample image from ith class
%   train_labels=cat(1,train_labels,gt);
  

training_samples=train_patch;
training_labels=train_labels;

nzinds=find(flatImage>0);


 
feature_data=reshape( flatFeatures ,[rows*cols trainingNum]);
labeled_pixels=reshape(flatImage ,[rows*cols 1]);

labeled_pixels_crop=labeled_pixels(nzinds);
feature_data_crop=feature_data(nzinds,:);






Mdl = fitcecoc(train_patch,train_labels);
k=10;
CVSVMModel = crossval(Mdl,'kfold',k);

for i=1:k
labels = predict(CVSVMModel.Trained{i},feature_data_crop);
 Accuracy=mean(labeled_pixels_crop==labels)*100
end

% if(Accuracy>thisScaleMax)
%    thisScaleMax=Accuracy;
%    thisScale_features=train_patch;
%    
% end
% fprintf('\nAccuracy =%d\n',thisScaleMax)
fprintf('\nAccuracy =%d\n',Accuracy)
 end
image_predict=zeros(rows*cols,1);
image_predict(nzinds)=labels;

image_predict=uint8(reshape(image_predict,[rows cols]));
%unsignedGT=uint8(image_gt);

% 
% save('pavia.mat','total_comp'); 




    
    
    
