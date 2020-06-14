clear all;
close all;
outfilepath='C:\Users\Administrator\Desktop\毕业论文\20200527\20200527\反投影结果数据存档\';
% xtransS:
% load(['C:\Users\Administrator\Desktop\888\xtransS.mat']);
% % % %xtransM:
load(['C:\Users\Administrator\Desktop\888\xtransM.mat']);
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
% x=source(:,1);
% y=source(:,2);
% z=source(:,3);
% % % % filename=['C:\Users\Administrator\Desktop\20200519\MAH00972_after.avi']; 
% % % % load(['C:\Users\Administrator\Desktop\888\888\background072.mat']);
% % % % backdata=img_imcrop;
% % % filename=['C:\Users\Administrator\Desktop\20200519\MAH00975_after.avi']; 
% % % load(['C:\Users\Administrator\Desktop\888\888\background075.mat']);
% % % backdata=img_imcrop;
% % % % filename=['C:\Users\Administrator\Desktop\20200519\MAH00975_after.avi']; 
% % % %xtransS:
% % filename=['C:\Users\Administrator\Desktop\888\MAH00956_after.avi']; 
% % % %xtransM:
% filename=['C:\Users\Administrator\Desktop\888\MAH00958_after.avi']; 
% % % %xtransL:
% % filename3=['C:\Users\Administrator\Desktop\888\MAH00959_after.avi']; 
% % % %ztransS:
% % filename=['C:\Users\Administrator\Desktop\888\MAH00965_after.avi']; 
% % % ztransM:MAH00967_after
% % filename=['C:\Users\Administrator\Desktop\888\MAH00967_after.avi']; 
% % %ztransL:MAH00969_after
% % filename3=['C:\Users\Administrator\Desktop\888\MAH00969_after.avi']; 
% % % % %ytransM:MAH00962_after
% % filename=['C:\Users\Administrator\Desktop\888\MAH00962_after.avi'];
% obj=VideoReader(filename);
% % obj2=VideoReader(filename2);
% % obj3=VideoReader(filename3);
% % numFrames=obj.NumberOfFrames;
% % numFrameRate=obj.FrameRate;
% % % % Totaltime=obj.Duration;
% % % % online=1
% % % % %xtransS
% % startime=48;
% % duration=116;
% % % %xtransM
startime=5; %开始运动时间
duration=40; 
% % % % %xtransL
% % startime3=7; %开始运动时间
% % duration=23; 
% % % % ztransS
% % startime=13; %开始运动时间
% % % % duration=53; 
% % % ztransM
% % startime=5; %开始运动时间
% % duration=25; 
% % % % % ztransL
% % startime3=10; %开始运动时间
% % duration=13; 
% % % % %ytrans
% % startime=24; %开始运动时间
% % duration=26; 
% % % % start_num=numFrameRate*startime;
% % % % end_num=start_num+numFrameRate*duration-1;
% % % 
% % % X=zeros(numFrames,1);
% % % Y=zeros(numFrames,1);
% % % Z=zeros(numFrames,1);
% % % 
X=zeros(duration,1);
Y=zeros(duration,1);
Z=zeros(duration,1);
% % X2=zeros(duration,1);
% % Y2=zeros(duration,1);
% % Z2=zeros(duration,1);
% % X3=zeros(duration,1);
% % Y3=zeros(duration,1);
% % Z3=zeros(duration,1);
% % X4=zeros(duration,1);
% % Y4=zeros(duration,1);
% % Z4=zeros(duration,1);
% % % 
errorx=zeros(duration,1);
errory=zeros(duration,1);
errorz=zeros(duration,1);
error=zeros(duration,1);
% % errorx2=zeros(duration,1);
% % errory2=zeros(duration,1);
% % errorz2=zeros(duration,1);
% % error2=zeros(duration,1);
% % errorx3=zeros(duration,1);
% % errory3=zeros(duration,1);
% % errorz3=zeros(duration,1);
% % error3=zeros(duration,1);
% % % errorx4=zeros(duration,1);
% % % errory4=zeros(duration,1);
% % % errorz4=zeros(duration,1);
% % % error4=zeros(duration,1);
% % % % for i=1:duration
% % % %     frame=read(obj,i);
% % % %     [X(i),Y(i),Z(i)]=ProcessXYZ(frame(:,:,1));
% % % % end
% % % %     fileName=sprintf('myscene_%03d',i);
% % % %     run([framesPath,fileName,'.m']);
% % % %     frames=data;
% % % for i=1:numFrames
for i=1:duration
    i
%     data=im2double(read(obj,i));
    data=im2double(read(obj,startime+(i-1)));
%     data2=im2double(read(obj2,startime2+(i-1)));
%     data3=im2double(read(obj3,startime3+(i-1)));
%      fileName=sprintf('Ytranslation_%03d',i-1);
%      fileName=sprintf('Ytranslation_%03d',i-1);
%     fileName=sprintf('y%01d',i);
%     fileName=sprintf('z%01d',i);
%      run([framesPath,fileName,'.m']);

    [X(i),Y(i),Z(i)]=backprojection(data(:,:,1));
    errorx(i)=abs(X(i)-x(i));
    errory(i)=abs(Y(i)-y(i));
    errorz(i)=abs(Z(i)-z(i));
    error(i)=sqrt((X(i)-x(i))^2+(Y(i)-y(i))^2+(Z(i)-z(i))^2);
%     errorx2(i)=abs(X2(i)-x(i));
%     errory2(i)=abs(Y2(i)-y(i));
%     errorz2(i)=abs(Z2(i)-z(i));
%     error2(i)=sqrt((X2(i)-x(i))^2+(Y2(i)-y(i))^2+(Z2(i)-z(i))^2);
%     errorx3(i)=abs(X3(i)-x(i));
%     errory3(i)=abs(Y3(i)-y(i));
%     errorz3(i)=abs(Z3(i)-z(i));
%     error3(i)=sqrt((X3(i)-x(i))^2+(Y3(i)-y(i))^2+(Z3(i)-z(i))^2);
%     errorx4(i)=abs(X4(i)-x(i));
%     errory4(i)=abs(Y4(i)-y(i));
%     errorz4(i)=abs(Z4(i)-z(i));
%     error4(i)=sqrt((X4(i)-x(i))^2+(Y4(i)-y(i))^2+(Z4(i)-z(i))^2);
%       backdata=backdata*i/(i+1)+data/(i+1);
end
save([outfilepath,'realxtrans_XYZxyzerrorxyz.mat'],'X','Y','Z','x','y','z','error','errorx','errory','errorz');
% load([outfilepath,'realxtrans_XYZxyzerrorxyz.mat']);
% sumerrorx=sum(errorx);
% sumerrory=sum(errory);
% sumerrorz=sum(errorz);
% sumerror3=sum(error);
% meanerrorx=sumerrorx/duration
% meanerrory=sumerrory/duration
% meanerrorz=sumerrorz/duration
% meanerror3=sumerror3/duration
% i=start_num:numFrameRate:end_num;
% duration=40; 
i=1:duration;

figure;
plot(i,X,'b-o','LineWidth',1.5);
hold on;
% plot(i,X2,'g-x');
% hold on;
% plot(i,X3,'c-^');
% hold on;
% plot(i,X4,'m-s');
% hold on;
plot(i,x,'r-*','LineWidth',1.5);
hold off;
% legend('S=8','s=32','S=128','真实x坐标');
% legend('alpha=0','alpha=1','alpha=2','alpha=3','真实x坐标');
% legend('D=0.5','D=1','D=1.414','D=1.732','真实x坐标');
% legend('v1','v2','v3');
legend({'重建\itx','真实\itx'},'FontName','microsoft yahei ui');
axis([1,duration,-8,8]);
% axis([start_num,end_num,-8,8]);
% title('关于x的一维运动轨迹')
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\itx(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransx

figure;
plot(i,Y,'b-o','LineWidth',1.5);
hold on;
% plot(i,Y2,'g-x');
% hold on;
% plot(i,Y3,'c-^');
% hold on;
% plot(i,Y4,'m-s');
% hold on;
plot(i,y,'r-*','LineWidth',1.5);
hold off;
% legend('S=8','s=32','S=128','真实y坐标');
% legend('alpha=0','alpha=1','alpha=2','alpha=3','真实y坐标');
% legend('D=0.5','D=1','D=1.414','D=1.732','真实y坐标');
% legend('v1','v2','v3');
legend({'重建\ity','真实\ity'},'FontName','microsoft yahei ui');
axis([1,duration,0,8]);
% title('关于y的一维运动轨迹')
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\ity(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransy

figure;
plot(i,Z,'b-o','LineWidth',1.5);
hold on;
% plot(i,Z2,'g-x');
% hold on;
% plot(i,Z3,'c-^');
% hold on;
% plot(i,Z4,'m-s');
% hold on;
plot(i,z,'r-*','LineWidth',1.5);
hold off;
% legend('S=8','s=32','S=128','真实z坐标');
% legend('alpha=0','alpha=1','alpha=2','alpha=3','真实z坐标');
% legend('D=0.5','D=1','D=1.414','D=1.732','真实z坐标');
% legend('v1','v2','v3');
legend({'重建\itz','真实\itz'},'Location','southeast','FontName','microsoft yahei ui');
axis([1,duration,0,8]);
% title('关于y的一维运动轨迹')
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\itz(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransz
% 
% 
figure;
plot(i,errorx,'b-o','LineWidth',1.5);
hold on;
plot(i,errory,'g-x','LineWidth',1.5);
hold on;
plot(i,errorz,'c-^','LineWidth',1.5);
hold on;
plot(i,error,'r-*','LineWidth',1.5);
hold off;
% % legend('S=8','s=32','S=128','真实y坐标');
% % legend('alpha=0','alpha=1','alpha=2','alpha=3','真实y坐标');
% legend('D=0.5','D=1','D=1.414','D=1.732','真实y坐标');
legend({'\itx','\ity','\itz','(\itx, \ity, \itz)'},'FontName','microsoft yahei ui');
axis([-inf,inf,0,8]);
% title('关于y的一维运动轨迹')
xlabel('秒(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('误差(\itcm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtranserror