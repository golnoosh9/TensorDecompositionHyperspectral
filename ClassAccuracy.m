class_accuracy=zeros(class_num,1);
for i=1:class_num
   indsi=(find(labeled_pixels_crop==i));
   true_labelsi=labeled_pixels_crop(indsi);
   labelsi=labels(indsi);
   class_accuracy(i)=(mean(true_labelsi==labelsi)*100);
    
end

AverageAccuracy=mean(class_accuracy)
