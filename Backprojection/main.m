clear all;
close all;
%�������ļ�·��
outfilepath='C:\Users\Administrator\Desktop\��ҵ����\20200527\20200527\��ͶӰ������ݴ浵\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ϵͳ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%xtrans:
% numFrames=80;
%ytrans,ztrans:
% numFrames=40;
%���ڴ洢�ؽ�x,y,z�������Ӧ���
% X=zeros(numFrames,1);
% Y=zeros(numFrames,1);
% Z=zeros(numFrames,1);
% errorx=zeros(numFrames,1);
% errory=zeros(numFrames,1);
% errorz=zeros(numFrames,1);
% error=zeros(numFrames,1);
% for i=1:numFrames
%      fileName=sprintf('C:\Users\Administrator\Desktop\��������\Xtransm\Xtransm_%03d',i-1);
%      run([fileName,'.m']);
%�Է�����Ƶÿһ֡����ÿһm�ļ��������㷨��Ӧbackprojection���������ؽ�
%      [X(i),Y(i),Z(i)]=main(data(:,:,1));
%�ο���ʵ�˶��켣
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
%ע�����ϵͳ��Ӧ��backprojection�㷨�����ɢ���߶�height�����width����ȷ�Χ����length��ϵͳ�ʷּ��step���ڲ��ѱ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ʵ��ϵͳ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ο���ʵ�˶��켣���б�ʾʱ��(s)������Ϊ3���ֱ��Ӧx,y,z����
% xtransS:
load(['C:\Users\Administrator\Desktop\��ҵ����\20200527\20200527\888\xtransS.mat']);
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
%Ԥ�������Ƶ�ļ�·��������ֹʱ��
% %xtransS:
% filename=['C:\Users\Administrator\Desktop\888\MAH00956_after.avi']; 
% %xtransM:
filename=['C:\Users\Administrator\Desktop\��ҵ����\20200527\20200527\888\MAH00958_after.avi']; 
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
startime=5; %��ʼ�˶�ʱ��
duration=40; 
% %xtransL
% startime3=7; %��ʼ�˶�ʱ��
% duration=23; 
% % ztransS
% startime=13; %��ʼ�˶�ʱ��
% duration=53; 
% %ztransM
% startime=5; %��ʼ�˶�ʱ��
% duration=25; 
% %ztransL
% startime3=10; %��ʼ�˶�ʱ��
% duration=13; 
% %ytrans
% startime=24; %��ʼ�˶�ʱ��
% duration=26; 
%���ڴ洢�ؽ�x,y,z�������Ӧ���
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
    %��Ԥ�������Ƶÿһ֡�����㷨��Ӧbackprojection���������ؽ�
    [X(i),Y(i),Z(i)]=backprojection(data(:,:,1));
    errorx(i)=abs(X(i)-x(i));
    errory(i)=abs(Y(i)-y(i));
    errorz(i)=abs(Z(i)-z(i));
    error(i)=sqrt((X(i)-x(i))^2+(Y(i)-y(i))^2+(Z(i)-z(i))^2);
end

%�洢�㷨�ؽ�������Ա����ʹ��
save([outfilepath,'realxtrans_XYZxyzerrorxyz.mat'],'X','Y','Z','x','y','z','error','errorx','errory','errorz');
% load([outfilepath,'realxtrans_XYZxyzerrorxyz.mat']);

%������άx,y,z����ֱ����ʱ��ı仯����
i=1:duration;
figure;
plot(i,X,'b-o','LineWidth',1.5);
hold on;
plot(i,x,'r-*','LineWidth',1.5);
hold off;
legend({'�ؽ�\itx','��ʵ\itx'},'FontName','microsoft yahei ui');
axis([1,duration,-8,8]);
xlabel('��(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\itx(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransx

figure;
plot(i,Y,'b-o','LineWidth',1.5);
hold on;
plot(i,y,'r-*','LineWidth',1.5);
hold off;
legend({'�ؽ�\ity','��ʵ\ity'},'FontName','microsoft yahei ui');
axis([1,duration,0,8]);
xlabel('��(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\ity(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransy

figure;
plot(i,Z,'b-o','LineWidth',1.5);
hold on;
plot(i,z,'r-*','LineWidth',1.5);
hold off;
legend({'�ؽ�\itz','��ʵ\itz'},'Location','southeast','FontName','microsoft yahei ui');
axis([1,duration,0,8]);
xlabel('��(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('\itz(cm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtransz


%����x,y,z�����ؽ�����������ά����2�������ֱ����ʱ��ı仯����
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
xlabel('��(\its)','FontSize',11,...
    'FontName','microsoft yahei ui')
ylabel('���(\itcm)','FontSize',11,...
    'FontName','microsoft yahei ui')
print -dpng  -r600 realXtranserror