clear all
close all

%ԭʼ��Ƶ�ļ�·��
filename=['G:\�ҵ�ʵ������\MP4\MAH00956.mp4']; 
obj=VideoReader(filename);
numFrames=obj.NumberOfFrames;
numFrameRate=obj.FrameRate;
Totaltime=obj.Duration;

lighttime=46;
Background = numFrameRate*lighttime;
frame=read(obj,Background);
imshow(frame)
imwrite(frame,'ԭͼ.png');
%�ҶȻ�
gray_frame=im2double(rgb2gray(frame));
imshow(gray_frame)
imwrite(gray_frame,'�Ҷ�ͼ.png');
%��бУ��
dot=ginput(4);%ȡ�ĸ��㣬���������ϣ����ϣ����£�����,������ȡ����ɢ�����ĸ���
rectify_frame=Rectification(gray_frame,dot);
imshow(rectify_frame);
imwrite(rectify_frame,'��б����ͼ.png');
[x,y] = ginput(2);%ȡɢ���δ���ڵ�������������������
crop_frame = imcrop(rectify_frame,[x(1),y(1),abs(x(1)-x(2)),abs(y(1)-y(2))]);
figure,imshow(crop_frame);
imwrite(crop_frame,'����ͼ.png');

%Ԥ�������Ƶ�ļ�·��
filename=['G:\�ҵ�ʵ������\MP4\MAH00956_after.mp4']; 
WriterObj=VideoWriter(filename);
%֡��Ϊ1
WriterObj.FrameRate=1;

open(WriterObj);

%һ��ȡһ֡�����ҶȻ�����бУ��������
for i=1:numFrameRate:numFrames
    i
    img_origin=im2double(rgb2gray(read(obj,i)));
    img_rectify=Rectification(img_origin,dot);
    img_result=imcrop(img_rectify,[x(1),y(1),abs(x(1)-x(2)),abs(y(1)-y(2))]);
    writeVideo(WriterObj,mat2gray(img_result));
end

close(WriterObj);
