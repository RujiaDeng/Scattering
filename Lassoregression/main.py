# -*- coding: UTF-8 -*-
import pickle
import time
import matplotlib.pyplot as plt
import math
from sklearn.linear_model import Lasso
import numpy as np
import os
#输出结果文件路径
outfilepath='C:/Users/Administrator/Desktop/实验数据/20200526/'

########################仿真系统############################
# #x
# frames=80
# #y/z
# frames=40
# #x
# translations = np.linspace(start=-3.95, stop=3.95, num=frames)
# #y/z
# translations = np.linspace(start=0.05, stop=3.95, num=frames)
# source=np.zeros((frames,3))
# v0=np.zeros((frames,3))
# error0=np.zeros((frames,1))
# errorx0=np.zeros((frames,1))
# errory0=np.zeros((frames,1))
# errorz0=np.zeros((frames,1))
########################实际系统############################
#参考真实运动轨迹
import scipy.io as sio
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/xtransS.mat')
source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/xtransM.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/xtransL.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ytransM.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ztransS.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ztransM.mat')
# source=sio.loadmat('C:/Users/Administrator/Desktop/实验数据/观八备份20200519/888/ztransL.mat')
ts=source['source']

import cv2
#预处理后视频文件路径及其起止时间
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
#结束时间
endtime=starttime+duration
#v0用于存储重建三维坐标,与对应误差
v0=np.zeros((duration,3))
error0=np.zeros((duration,1))
errorx0=np.zeros((duration,1))
errory0=np.zeros((duration,1))
errorz0=np.zeros((duration,1))
#对预处理后视频每一帧用套索回归来做重建
for i in range(starttime,endtime):
    print(i)
    time_start = time.time()
    cap.set(cv2.CAP_PROP_POS_FRAMES, i)  # 设置要获取的帧号
    a, data = cap.read()  # read方法返回一个布尔值和一个视频帧。若帧读取成功，则返回True
    data=data[:,:,1]
    frame=i-starttime
#对仿真数据中每一帧(每一npy文件)用套索回归来做重建
# for (frame, tranlation) in enumerate(translations, 0):
#     # for frame in range(frames):
#     time_start = time.time()
#
#     # data = np.load("E:/工作/Mitsuba 0.5.0/Xtransnpy/Xtransnpy_{n:03d}.npy".format(n=frame))
#     #     #真实源点位置
#     #     # x
#     ts = [round(tranlation, 2), 2, 2]
#     #     # y
#     #     ts = [0,round(tranlation, 2), 2]
#     #     # z
#     #     # ts = [0, 2, round(tranlation, 2)]
#     #     print("真实源点", ts)
#     source[frame, :] = ts

    h = data.shape[0]  # 图像矩阵的高度（行数）
    w = data.shape[1]  # 图像矩阵的宽度（列数）
    # 采样
    hpoints = 4  # 高度y方向（行）采样点数
    wpoints = 8  # 宽度x方向（列）采样点数
    # 默认从(1,1)开始采样，即(1,1)定为样点，故计算行列采样间隔时去掉第一行和第一列再算
    hstep = math.floor((h - 1) / (hpoints - 1))  # 行采样间隔行数
    wstep = math.floor((w - 1) / (wpoints - 1))  # 列采样间隔列数

    # height = 4  # 散射层仿真高度
    # width = 8  # 散射层仿真宽度
    # length = 4  # 仿真系统中，z的界为0到4
    height=8  # 散射层实际高度
    width=16  # 散射层实际宽度
    length=8  # 仿真系统中，z的界为0到8

    # 剖分笛卡尔空间，每一体素为边长为step的正方体
    # step = 0.1 # 实际系统剖分间隔
    step=0.2 # 实际系统剖分间隔
    V = np.zeros((math.floor(width / step) * math.floor(height / step) * math.floor(length / step) + 1, 3))  # 体素空间矩阵
    #
    alpha = 0.5  # transmittance
    beta = 1  # Lambertian BTDF
    #仿真系统中的功率
    # intensity = 10
    # power = 4 * math.pi * intensity
    # 实际系统中的功率
    power=3
    C = np.zeros((hpoints * wpoints + 1, 2))  # coordiante of sampling points
    y = np.zeros((1, hpoints * wpoints + 1))
    A = np.zeros((hpoints * wpoints + 1, math.floor(width / step) * math.floor(height / step) * math.floor(
        length / step) + 1))  # forward matrix
    # x=zeros(math.floor(width/step)*math.floor(height/step)*math.floor(length/step),1)
    #计算线性模型
    for i in range(1, hpoints * wpoints + 1):
        a1 = math.ceil(i / wpoints)
        b1 = i % wpoints
        if (b1 == 0):
            b1 = wpoints
        C[i, :] = [0.5 * width - ((b1 - 1) * wstep) * (width / w) - 0.5 * (width / w),
                   height - ((a1 - 1) * hstep) * (height / h) - 0.5 * (height / h)]  # coordinate of p
        y[0, i] = data[(a1 - 1) * hstep, (b1 - 1) * wstep]
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
            A[i, k] = alpha * V[k, 2] * beta * power / (4 * math.pi * math.sqrt(
                (V[k, 0] - C[i, 0]) ** 2 + (V[k, 1] - C[i, 1]) ** 2 + V[k, 2] ** 2) ** 3)
    #计算A
    A = A[1:A.shape[0], 1:A.shape[1]]
    #计算y
    y = y[0, 1:y.shape[1]]

    #取定lambda=0.001,在仿真系统中做套索回归
    lasso = Lasso(alpha=0.001, normalize=True, max_iter=10000, positive=True)
    #取定lambda=1,在实际系统中做套索回归
    lasso = Lasso(alpha=1, normalize=True, max_iter=10000, positive=True)
    lasso.fit(A, y)
    x = lasso.coef_
    #记录非零置信度
    coef=[]
    #记录非零置信度对应体素坐标
    s = []
    for k in range(1, math.floor(width / step) * math.floor(height / step) * math.floor(length / step)):
        if (x[k] != 0):
            coef.append(x[k])
            s.append(V[k, :])

    #记录最大置信度对应体素下标
    maxcoef=0
    maxi=0
    for i in coef:
        if (i>maxcoef):
            maxcoef=i
            maxi=coef.index(i)

    #最大置信度体素坐标及其误差
    v0[frame,:]=s[maxi]
    error0[frame, 0] = math.sqrt((v0[frame, 0] - ts[frame,0]) ** 2 + (v0[frame, 1] - ts[frame,1]) ** 2 + (v0[frame, 2] - ts[frame,2]) ** 2)
    errorx0[frame, 0]=math.fabs(v0[frame, 0] - ts[frame,0])
    errory0[frame, 0]=math.fabs(v0[frame, 1] - ts[frame,1])
    errorz0[frame, 0] = math.fabs(v0[frame, 2] - ts[frame,2])

    #计算算法重建时长
    time_end = time.time()
    print('计算总时长：', time_end - time_start)

#保存重建结果
with open(os.path.join(outfilepath,'realytrans_v0error0xyz'),'wb') as f:
    pickle.dump([v0,error0,errorx0,errory0,errorz0], f)

# 中文乱码和$x$轴负号的处理
plt.rcParams[ 'font.sans-serif'] = [ 'Microsoft YaHei']
plt.rcParams[ 'axes.unicode_minus'] = False

#绘制三维坐标x,y,z关于时间t的变化曲线(注意仿真数据中duration需替换为frames，坐标轴上下限也需改变)
plt.plot(np.linspace(1,duration,duration),v0[:,0],color='blue',marker='o',label='重建$x$')
plt.plot(np.linspace(1,duration,duration),ts[:,0],color='red',marker='*',label='真实$x$')
plt.legend(loc='upper right')
plt.xlabel("秒($s$)")
plt.ylabel("$x(cm)$")
plt.xlim(1,duration)
plt.ylim(-0.5*width,0.5*width)
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
plt.savefig(os.path.join(outfilepath,'realy2_z.png'))
plt.close()
# plt.show()

#绘制三维坐标x,y,z重建绝对误差及三维坐标重建L2误差关于时间t的变化曲线
plt.plot(np.linspace(1,duration,duration),error0,color='blue',marker='o',label='$x$')
plt.plot(np.linspace(1,duration,duration),errorx0,color='green',marker='x',label='$y$')
plt.plot(np.linspace(1,duration,duration),errory0,color='c',marker='^',label='$z$')
plt.plot(np.linspace(1,duration,duration),errorz0,color='red',marker='*',label='$(x, y, z)$')
plt.legend(loc='upper right')
plt.xlabel("秒($s$)")
plt.ylabel("误差($cm$)")
plt.xlim(1,duration)
plt.ylim(0,8)
plt.savefig(os.path.join(outfilepath,'realy2_error.png'))
plt.close()