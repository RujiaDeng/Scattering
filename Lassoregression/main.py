# -*- coding: UTF-8 -*-
import pickle
import time
import matplotlib.pyplot as plt
import math
from sklearn.linear_model import Lasso,LassoCV,LassoLarsCV
from sklearn.metrics import mean_squared_error
import numpy as np
import os
outfilepath='C:/Users/Administrator/Desktop/实验数据/20200526/'
with open(os.path.join(outfilepath,'realytrans_v0error0xyz'),'rb') as f:
    v0,error0,errorx0,errory0,errorz0=pickle.load(f)
import scipy.io as sio
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/xtransS.mat')
source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/xtransM.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/xtransL.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ytransM.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ztransS.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ztransM.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ztransL.mat')
ts=source['source']
# print(np.shape(ts))
import cv2

# # xtransS: MAH00956.mp4
# cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00956_after.avi')
# starttime=48
# duration=116
# xtransM: MAH00958.mp4
cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00958_after.avi')  # 返回一个capture对象
starttime=5
duration=40
# xtransL: MAH00959.mp4
# cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00959_after.avi')
# starttime3=7
# duration=23
#ztransS:MAH00965
# cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00965_after.avi')
# starttime=12
# duration=54
# ztransM: MAH00967_after
# cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00967_after.avi')
# starttime=5
# duration=25
#ztransL:MAH00969_after
# cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00969_after.avi')
# starttime=7
# duration=15
# ytrans:MAH00962_after.mp4
# cap = cv2.VideoCapture('C:/Users/Administrator/Desktop/实验数据/预处理后视频/MAH00962_after.avi')  # 返回一个capture对象
# starttime=24
# duration=26
endtime=starttime+duration
source=np.zeros((duration,3))
v0=np.zeros((duration,3))
error0=np.zeros((duration,1))
errorx0=np.zeros((duration,1))
errory0=np.zeros((duration,1))
errorz0=np.zeros((duration,1))

for i in range(starttime,endtime):
    print(i)
    time_start = time.time()
    cap.set(cv2.CAP_PROP_POS_FRAMES, i)  # 设置要获取的帧号
    a, data = cap.read()  # read方法返回一个布尔值和一个视频帧。若帧读取成功，则返回True
    # print(np.shape(data))
    data=data[:,:,1]
    frame=i-starttime

    h = data.shape[0]  # 图像矩阵的高度（行数）
    w = data.shape[1]  # 图像矩阵的宽度（列数）
    # 采样
    hpoints = 4  # 高度y方向（行）采样点数
    wpoints = 8  # 宽度x方向（列）采样点数
    # 默认从(1,1)开始采样，即(1,1)定为样点，故计算行列采样间隔时去掉第一行和第一列再算
    hstep = math.floor((h - 1) / (hpoints - 1))  # 行采样间隔行数
    wstep = math.floor((w - 1) / (wpoints - 1))  # 列采样间隔列数

    # height = 4  # 散射层实际高度
    # width = 8  # 散射层实际宽度
    # length = 4  # z的界为0到4
    height=8
    width=16
    length=8

    # 剖分笛卡尔空间，每一体素为边长为step的正方体
    # step = 0.1
    step=0.2
    V = np.zeros((math.floor(width / step) * math.floor(height / step) * math.floor(length / step) + 1, 3))  # 体素空间$x$矩阵
    alpha = 0.5  # transmittance
    beta = 1  # Lambertian BTDF
    # intensity = 10
    # power = 4 * math.pi * intensity
    power=3
    # power=1
    C = np.zeros((hpoints * wpoints + 1, 2))  # coordiante of sampling points
    y = np.zeros((1, hpoints * wpoints + 1))
    A = np.zeros((hpoints * wpoints + 1, math.floor(width / step) * math.floor(height / step) * math.floor(
        length / step) + 1))  # forward matrix
    # x=zeros(math.floor(width/step)*math.floor(height/step)*math.floor(length/step),1)
    for i in range(1, hpoints * wpoints + 1):
        a1 = math.ceil(i / wpoints)
        b1 = i % wpoints
        if (b1 == 0):
            b1 = wpoints
        C[i, :] = [0.5 * width - ((b1 - 1) * wstep) * (width / w) - 0.5 * (width / w),
                   height - ((a1 - 1) * hstep) * (height / h) - 0.5 * (height / h)]  # coordinate of p
        # print(C[i,:])
        y[0, i] = data[(a1 - 1) * hstep, (b1 - 1) * wstep]
        # y.append(data[(a1-1)*hstep,(b1-1)*wstep])#y luminance vector
        for k in range(1, math.floor(width / step) * math.floor(height / step) * math.floor(length / step) + 1):
            a = k % math.floor(width / step)
            b = k % (math.floor(width / step) * math.floor(height / step))
            if (a == 0):
                a = math.floor(width / step)
            if (b == 0):
                b = math.floor(width / step) * math.floor(height / step)
            x1 = a
            y1 = math.ceil(b / math.floor(width / step))
            z1 = math.ceil(k / (math.floor(width / step) * math.floor(height / step)))
            V[k, :] = [0.5 * width - (x1 - 1) * step - 0.5 * step, height - (y1 - 1) * step - 0.5 * step,
                       (z1 - 1) * step + 0.5 * step]  # coordinate of vk
            # print(V[k,:])
            A[i, k] = alpha * V[k, 2] * beta * power / (4 * math.pi * math.sqrt(
                (V[k, 0] - C[i, 0]) ** 2 + (V[k, 1] - C[i, 1]) ** 2 + V[k, 2] ** 2) ** 3)

    A = A[1:A.shape[0], 1:A.shape[1]]
    y = y[0, 1:y.shape[1]]

    print("lasso:")
    lasso = Lasso(alpha=1, normalize=True, max_iter=10000, positive=True)
    lasso.fit(A, y)
    x = lasso.coef_
    coef=[]
    s = []
    for k in range(1, math.floor(width / step) * math.floor(height / step) * math.floor(length / step)):
        if (x[k] != 0):
            coef.append(x[k])
            s.append(V[k, :])
            # print(V[k,:])
#     # print("x非零分量",coef)
#     # print("对应体素$x$",s)
#     # #
    maxcoef=0
    maxi=0
    for i in coef:
        if (i>maxcoef):
            maxcoef=i
            maxi=coef.index(i)
    # print("最大回归系数对应的体素$x$",s[maxi])
    v0[frame,:]=s[maxi]
    error0[frame, 0] = math.sqrt((v0[frame, 0] - ts[frame,0]) ** 2 + (v0[frame, 1] - ts[frame,1]) ** 2 + (v0[frame, 2] - ts[frame,2]) ** 2)
    errorx0[frame, 0]=math.fabs(v0[frame, 0] - ts[frame,0])
    errory0[frame, 0]=math.fabs(v0[frame, 1] - ts[frame,1])
    errorz0[frame, 0] = math.fabs(v0[frame, 2] - ts[frame,2])
    print("估计的L2误差", error0[frame, 0])
    print("x的L1误差",errorx0[frame, 0])
    print("y的L1误差", errory0[frame, 0])
    print("z的L1误差", errorz0[frame, 0])

    #
    time_end = time.time()
    print('计算总时长：', time_end - time_start)

with open(os.path.join(outfilepath,'realytrans_v0error0xyz'),'wb') as f:
    pickle.dump([v0,error0,errorx0,errory0,errorz0], f)
# #
# 绘制alpha的对数与回归系数的关系# 中文乱码和$x$轴负号的处理

plt.rcParams[ 'font.sans-serif'] = [ 'Microsoft YaHei']
plt.rcParams[ 'axes.unicode_minus'] = False
#
plt.plot(np.linspace(1,duration,duration),v0[:,0],color='blue',marker='o',label='重建$x$')
plt.plot(np.linspace(1,duration,duration),ts[:,0],color='red',marker='*',label='真实$x$')
plt.legend(loc='upper right')
plt.xlabel("秒($s$)")
plt.ylabel("$x(cm)$")
plt.xlim(1,duration)
plt.ylim(-0.5*width,0.5*width)
# plt.title( '关于x的一维运动轨迹')
plt.savefig(os.path.join(outfilepath,'realy2_x.png'))
plt.close()
#plt.show()


plt.plot(np.linspace(1,duration,duration),v0[:,1],color='blue',marker='o',label='重建$y$')
plt.plot(np.linspace(1,duration,duration),ts[:,1],color='red',marker='*',label='真实$y$')
plt.legend(loc='upper right')
plt.xlabel("秒($s$)")
plt.ylabel("$y(cm)$")
plt.xlim(1,duration)
plt.ylim(0,height)
# plt.title( '关于y的一维运动轨迹')
plt.savefig(os.path.join(outfilepath,'realy2_y.png'))
plt.close()
#plt.show()


plt.plot(np.linspace(1,duration,duration),v0[:,2],color='blue',marker='o',label='重建$z$')
plt.plot(np.linspace(1,duration,duration),ts[:,2],color='red',marker='*',label='真实$z$')
plt.legend(loc='upper right')
plt.xlabel("秒($s$)")
plt.ylabel("$z(cm)$")
plt.xlim(1,duration)
plt.ylim(0,length)
# plt.title( '关于z的一维运动轨迹')
plt.savefig(os.path.join(outfilepath,'realy2_z.png'))
plt.close()
# plt.show()

plt.plot(np.linspace(1,duration,duration),error0,color='blue',marker='o',label='$x$')
plt.plot(np.linspace(1,duration,duration),errorx0,color='green',marker='x',label='$y$')
plt.plot(np.linspace(1,duration,duration),errory0,color='c',marker='^',label='$z$')
plt.plot(np.linspace(1,duration,duration),errorz0,color='red',marker='*',label='$(x, y, z)$')
# plt.plot(np.linspace(1,duration,duration),errorz0,color='m',marker='s')
# plt.plot(np.linspace(1,duration,duration),error1,color='green',marker='x',label='估计源点与真实源点三维$x$的L2误差曲线')
plt.legend(loc='upper right')
plt.xlabel("秒($s$)")
plt.ylabel("误差($cm$)")
plt.xlim(1,duration)
plt.ylim(0,8)
# plt.title( 'L2误差与秒数的关系')
plt.savefig(os.path.join(outfilepath,'realy2_error.png'))
plt.close()