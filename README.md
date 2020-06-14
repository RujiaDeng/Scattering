# 透过散射层的运动对象重建研究

## 输入数据
Mitsuba仿真数据集与实际拍摄视频后续将上传至我的百度云盘

Mitsuba为一基于物理模型的光学渲染软件，其官网为，包含下载和使用手册。

## 算法实现

1. 对实际拍摄视频预处理
  见Matlab代码文件Preprocessing，主函数为main函数

2. 基于曲面约束的反投影算法
  见Matlab代码文件Backprojection，主函数为main函数

3. 基于最大后验估计的套索回归 
  见Python代码文件Lassoregression
