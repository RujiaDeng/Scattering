function [returnx,returny,returnz]=backprojection(data)
tic

data=data(:,:,1); %ȡ��һ��ͨ����ͼ�����
h=size(data,1); %ͼ�����ĸ߶ȣ�������
w=size(data,2); %ͼ�����Ŀ�ȣ�������

%����
hpoints=4; %�߶�y�����У���������
wpoints=8; %���x�����У���������
%Ĭ�ϴ�(1,1)��ʼ��������(1,1)��Ϊ���㣬�ʼ������в������ʱȥ����һ�к͵�һ������
hstep=floor((h-1)/(hpoints-1)); %�в����������
wstep=floor((w-1)/(wpoints-1)); %�в����������

% height=4; %ɢ���ʵ�ʸ߶�
% width=8;  %ɢ���ʵ�ʿ��
height=8; %ɢ���ʵ�ʸ߶�
width=16;  %ɢ���ʵ�ʿ��

X=zeros(hpoints,wpoints); %��Ų������x����
Y=zeros(hpoints,wpoints); %��Ų������y����
P=zeros(hpoints,wpoints); %��Ų������x,y�����Ӧ����ֵ
%������������ص�Ķ�Ӧʵ�����������ֵ(��������<-->ͼ�����<-->�������꣩
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

%�ʷֵѿ����ռ䣬ÿһ����Ϊ�߳�Ϊ0.1��������
% step=0.1;%�ʷּ��
step=0.2;%�ʷּ��
 D=step;

length=8; %z�Ľ�Ϊ0��4

W1=zeros(floor(width/step)*floor(height/step)*floor(length/step),1);%���ؿռ��Ӧ��weight����
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

%��ά����w������Ȩֵ�����Ȩֵ���ص��Ӧ��ʵ�ʵѿ�������x,y,z��ȡ�������ĵ�ѿ���������������±�x,y,z
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