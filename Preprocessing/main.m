clear all
close all

%原始视频文件路径
filename=['G:\我的实验数据\MP4\MAH00956.mp4']; 
obj=VideoReader(filename);
numFrames=obj.NumberOfFrames;
numFrameRate=obj.FrameRate;
Totaltime=obj.Duration;

lighttime=46;
Background = numFrameRate*lighttime;
frame=read(obj,Background);
imshow(frame)
imwrite(frame,'原图.png');
%灰度化
gray_frame=im2double(rgb2gray(frame));
imshow(gray_frame)
imwrite(gray_frame,'灰度图.png');
%倾斜校正
dot=ginput(4);%取四个点，依次是左上，右上，左下，右下,这里我取的是散射层的四个角
rectify_frame=Rectification(gray_frame,dot);
imshow(rectify_frame);
imwrite(rectify_frame,'倾斜矫正图.png');
[x,y] = ginput(2);%取散射层未被遮挡的左上与右下两个点
crop_frame = imcrop(rectify_frame,[x(1),y(1),abs(x(1)-x(2)),abs(y(1)-y(2))]);
figure,imshow(crop_frame);
imwrite(crop_frame,'剪切图.png');

%预处理后视频文件路径
filename=['G:\我的实验数据\MP4\MAH00956_after.mp4']; 
WriterObj=VideoWriter(filename);
%帧率为1
WriterObj.FrameRate=1;

open(WriterObj);

%一秒取一帧来做灰度化、倾斜校正、剪切
for i=1:numFrameRate:numFrames
    i
    img_origin=im2double(rgb2gray(read(obj,i)));
    img_rectify=Rectification(img_origin,dot);
    img_result=imcrop(img_rectify,[x(1),y(1),abs(x(1)-x(2)),abs(y(1)-y(2))]);
    writeVideo(WriterObj,mat2gray(img_result));
end

close(WriterObj);
