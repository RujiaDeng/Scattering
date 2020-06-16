clear all;
close all;
%输出结果文件路径
outfilepath='C:\Users\Administrator\Desktop\毕业论文\20200527\20200527\反投影结果数据存档\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%仿真系统%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%xtrans:
% numFrames=80;
%ytrans,ztrans:
% numFrames=40;
%用于存储重建x,y,z坐标与对应误差
% X=zeros(numFrames,1);
% Y=zeros(numFrames,1);
% Z=zeros(numFrames,1);
% errorx=zeros(numFrames,1);
% errory=zeros(numFrames,1);
% errorz=zeros(numFrames,1);
% error=zeros(numFrames,1);
% for i=1:numFrames
%      fileName=sprintf('C:\Users\Administrator\Desktop\仿真数据\Xtransm\Xtransm_%03d',i-1);
%      run([fileName,'.m']);
%对仿真视频每一帧（即每一m文件）调用算法对应backprojection函数来做重建
%      [X(i),Y(i),Z(i)]=main(data(:,:,1));
%参考真实运动轨迹
%xtrans:
%     x(i)=-3.95+0.1*(i-1);
%     y(i)=2;
%     z(i)=2;
%ytrans:
%       x(i)=0;
%       y(i)=0.05+0.1*(i-1);
%       z(i)=2;
%ztrans:
%     x(i)=0;
%     y(i)=2;
%     z(i)=0.05+0.1*(i-1);
%注意仿真系统对应的backprojection算法需调整散射层高度height、宽度width、深度范围参数length、系统剖分间隔step，内部已标明。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%实际系统%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参考真实运动轨迹，行表示时间(s)，列数为3，分别对应x,y,z坐标
% xtransS:
load(['C:\Users\Administrator\Desktop\毕业论文\20200527\20200527\888\xtransS.mat']);
% % % %xtransM:
% load(['C:\Users\Administrator\Desktop\888\xtransM.mat']);
% % % %xtransL:
% % % % load(['C:\Users\Administrator\Desktop\888\xtransL.mat']);
% % % %ztransS:
% % % load(['C:\Users\Administrator\Desktop\888\ztransS.mat']);
% % % %ztransm:
% % load(['C:\Users\Administrator\Desktop\888\ztransM.mat']);
% % % %ztransL:
% % % % load(['C:\Users\Administrator\Desktop\888\ztransL.mat']);
% % % %ytransM:
% % load(['C:\Users\Administrator\Desktop\888\ytransM.mat']);
x=source(:,1);
y=source(:,2);
z=source(:,3);
%预处理后视频文件路径及其起止时间
% %xtransS:
% filename=['C:\Users\Administrator\Desktop\888\MAH00956_after.avi']; 
% %xtransM:
filename=['C:\Users\Administrator\Desktop\毕业论文\20200527\20200527\888\MAH00958_after.avi']; 
% %xtransL:
% filename=['C:\Users\Administrator\Desktop\888\MAH00959_after.avi']; 
% %ztransS:
% filename=['C:\Users\Administrator\Desktop\888\MAH00965_after.avi']; 
% %ztransM:MAH00967_after
% filename=['C:\Users\Administrator\Desktop\888\MAH00967_after.avi']; 
% %ztransL:MAH00969_after
% filename=['C:\Users\Administrator\Desktop\888\MAH00969_after.avi']; 
% %ytransM:MAH00962_after
% filename=['C:\Users\Administrator\Desktop\888\MAH00962_after.avi'];
obj=VideoReader(filename);
numFrames=obj.NumberOfFrames;
numFrameRate=obj.FrameRate;
% % %xtransS
% startime=48;
% duration=116;
% % %xtransM
startime=5; %开始运动时间
duration=40; 
% %xtransL
% startime3=7; %开始运动时间
% duration=23; 
% % ztransS
% startime=13; %开始运动时间
% duration=53; 
% %ztransM
% startime=5; %开始运动时间
% duration=25; 
% %ztransL
% startime3=10; %开始运动时间
% duration=13; 
% %ytrans
% startime=24; %开始运动时间
% duration=26; 
%用于存储重建x,y,z坐标与对应误差
X=zeros(duration,1);
Y=zeros(duration,1);
Z=zeros(duration,1);
errorx=zeros(duration,1);
errory=zeros(duration,1);
errorz=zeros(duration,1);
error=zeros(duration,1);
for i=1:duration
    i
    data=im2double(read(obj,startime+(i-1)));
    %对预处理后视频每一帧调用算法对应backprojection函数来做重建
    [X(i),Y(i),Z(i)]=backprojection(data(:,:,1));
    errorx(i)=abs(X(i)-x(i));
    errory(i)=abs(Y(i)-y(i));
    errorz(i)=abs(Z(i)-z(i));
    error(i)=sqrt((X(i)-x(i))^2+(Y(i)-y(i))^2+(Z(i)-z(i))^2);
end

%存储算法重建结果，以便后续使用
save([outfilepath,'realxtrans_XYZxyzerrorxyz.mat'],'X','Y','Z','x','y','z','error','errorx','errory','errorz');
% load([outfilepath,'realxtrans_XYZxyzerrorxyz.mat']);

%绘制三维x,y,z坐标分别关于时间的变化曲线
i=1:duration;
figure;
plot(i,X,'b-o','LineWidth',1.5);
hold on;
plot(i,x,'r-*','LineWidth',1.5);
hold off;
legend({'重建\itx','真实\itx'},'FontName','microsoft yahei ui');
axis([1,duration,-8,8]);
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\itx(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransx

figure;
plot(i,Y,'b-o','LineWidth',1.5);
hold on;
plot(i,y,'r-*','LineWidth',1.5);
hold off;
legend({'重建\ity','真实\ity'},'FontName','microsoft yahei ui');
axis([1,duration,0,8]);
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\ity(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransy

figure;
plot(i,Z,'b-o','LineWidth',1.5);
hold on;
plot(i,z,'r-*','LineWidth',1.5);
hold off;
legend({'重建\itz','真实\itz'},'Location','southeast','FontName','microsoft yahei ui');
axis([1,duration,0,8]);
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\itz(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransz


%绘制x,y,z坐标重建绝对误差，与三维坐标2范数误差分别关于时间的变化曲线
figure;
plot(i,errorx,'b-o','LineWidth',1.5);
hold on;
plot(i,errory,'g-x','LineWidth',1.5);
hold on;
plot(i,errorz,'c-^','LineWidth',1.5);
hold on;
plot(i,error,'r-*','LineWidth',1.5);
hold off;
legend({'\itx','\ity','\itz','(\itx, \ity, \itz)'},'FontName','microsoft yahei ui');
axis([-inf,inf,0,8]);
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('误差(\itcm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtranserror