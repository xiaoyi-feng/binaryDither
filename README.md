# binaryDither
binary dithering by kernel-optimized based Conventional Floyd-Steinberg error diffusion kernel
该代码复现了《High-quality 3D shape measurement by kernel-optimized high sinusoidal similarity dither patterns》
复现的是核优化算法，即基于Floyd-Steinberg误差扩散核中4个误差扩散权重参数的暴力搜索过程
目标函数同时考虑了二值离焦条纹相比正弦条纹的强度误差和相位误差。
**相关实验设置如下：**
条纹周期：114像素
条纹频率：8
条纹图案分辨率：生成的正弦条纹的分辨率为1046 * 912，但是为了加快计算速度，只选取256*256大小的图像块进行二值抖动
相位展开方法：四步相移法空间相位展开
高斯滤波： 滤波窗口大小5*5；标准差5/3
误差系数γ：0.7
正弦条纹的最大强度：0.7	Max(max(sinImage))
四个待优化参数的取值范围：[1:1:32]
**优化运行结果：**
the min error is: E_all_min = 0.0032, Ei_min = 4.8583, Ep_min = 0.0032
最后做对比实验：.自己的优化核；论文中得到的优化核；Floyd优化核
