function [returnx,returny,returnz]=backprojection(data)
tic

data=data(:,:,1); %取第一个通道的图像矩阵
h=size(data,1); %图像矩阵的高度（行数）
w=size(data,2); %图像矩阵的宽度（列数）

%采样
hpoints=4; %高度y方向（行）采样点数
wpoints=8; %宽度x方向（列）采样点数
%默认从(1,1)开始采样，即(1,1)定为样点，故计算行列采样间隔时去掉第一行和第一列再算
hstep=floor((h-1)/(hpoints-1)); %行采样间隔行数
wstep=floor((w-1)/(wpoints-1)); %列采样间隔列数

% height=4; %散射层实际高度
% width=8;  %散射层实际宽度
height=8; %散射层实际高度
width=16;  %散射层实际宽度

X=zeros(hpoints,wpoints); %存放采样点的x坐标
Y=zeros(hpoints,wpoints); %存放采样点的y坐标
P=zeros(hpoints,wpoints); %存放采样点的x,y坐标对应像素值
%计算采样的像素点的对应实际坐标和像素值(采样矩阵<-->图像矩阵<-->世界坐标）
for i=1:hpoints
    for j=1:wpoints
        X(i,j)=0.5*width-((j-1)*wstep)*(width/w)-0.5*(width/w);
        Y(i,j)=height-((i-1)*hstep)*(height/h)-0.5*(height/h);
        P(i,j)=data((i-1)*hstep+1,(j-1)*wstep+1);
    end
end
X=X(:);
Y=Y(:);
P=P(:);

%剖分笛卡尔空间，每一体素为边长为0.1的正方体
% step=0.1;%剖分间隔
step=0.2;%剖分间隔
 D=step;

length=8; %z的界为0到4

W1=zeros(floor(width/step)*floor(height/step)*floor(length/step),1);%体素空间对应的weight矩阵
Z1=zeros(floor(width/step)*floor(height/step)*floor(length/step),1);
Z2=zeros(floor(width/step)*floor(height/step)*floor(length/step),1);
Z3=zeros(floor(width/step)*floor(height/step)*floor(length/step),1);
for i=1:floor(width/step)*floor(height/step)*floor(length/step)
    a=mod(i,floor(width/step));
    b=mod(i,floor(width/step)*floor(height/step));
    if(a==0)
        a=floor(width/step);
    end
    if(b==0)
        b=floor(width/step)*floor(height/step);
    end
    x1=a;
    y1=ceil(b/floor(width/step));
    z1=ceil(i/(floor(width/step)*floor(height/step)));
    Z1(i)=0.5*width-(x1-1)*step-0.5*step;
    Z2(i)=height-(y1-1)*step-0.5*step;
    Z3(i)=(z1-1)*step+0.5*step;%coordinate of vk
end

for i=1:hpoints*wpoints
    for j=1:hpoints*wpoints
        if(j~=i)
            if(P(i)~=0)
                p=[X(i),Y(i)];
                q=[X(j),Y(j)];
                c=nthroot(P(i)/P(j),3)^2;
                for k=1:floor(width/step)*floor(height/step)*floor(length/step)
                    if(c~=1)
                        x0=(q(1)-c*p(1))/(1-c);
                        y0=(q(2)-c*p(2))/(1-c);
                        R=sqrt(c*(p(1)-q(1))^2+c*(p(2)-q(2))^2)/(1-c);
                        d=abs(sqrt((Z1(k)-x0)^2+(Z2(k)-y0)^2+Z3(k)^2)-R);
                    end
                    if(c==1)
                        d=((p(1)-q(1))*Z1(k)+(p(2)-q(2))*Z2(k)+(q(1)^2+q(2)^2-c*p(1)^2-c*p(2)^2)*0.5)/sqrt((p(1)-q(1))^2+(p(2)-q(2))^2);
                    end
                    if(d<D)
                        W1(k)=W1(k)+1;
                    end
                end
            end
        end
    end
end

%四维向量w存放最大权值，最大权值体素点对应的实际笛卡尔坐标x,y,z（取体素中心点笛卡尔坐标替代）和下标x,y,z
w1=[0,0,0,0,0,0,0];
for i=1:floor(width/step)*floor(height/step)*floor(length/step)
    if(W1(i)>w1(1))
        w1(1)=W1(i);
        w1(2)=Z1(i);
        w1(3)=Z2(i);
        w1(4)=Z3(i);
        w1(5)=ceil(i/(floor(height/step))*floor(length/step));
        w1(6)=ceil(mod(i,floor(height/step)*floor(length/step))/floor(length/step));
        w1(7)=mod(i,floor(length/step));
    end

end
returnx=w1(2);
returny=w1(3);
returnz=w1(4);

toc