---
title: 地铁站的马赛克墙，究竟是随机还是有序？
date: 2026-07-05 09:30:00+08:00
categories: [技术]
tags: [Python, 数据分析, 统计, 可视化]
slug: is-the-pattern-random
math: true
toc: true
---

某天地铁站等车间隙，拍下柱子上的马赛克墙面。大约四五种深浅不同的绿色，排列成棋盘格。盯着看久了，一个问题挥之不去：

**这面墙的图案，是纯随机的吗，还是有什么规律？**

<img class="img-half" src="/uploads/2026/0705/pattern.png" alt="原始照片">

这不是一个"是或否"就能回答的问题。它涉及：怎么从照片提取出网格数据？怎么定义"随机"？怎么用统计指标衡量？如果存在规律，又该怎么描述它？下面就从这几个方面展开。

---

## 一、从照片到数据

照片是像素，我需要把它变成可计算的矩阵。三个步骤：纠偏、颜色量化、网格检测。

**纠偏。** 照片有约 1.8° 的旋转，直接切网格会切偏。用了自相关法：旋转不同角度后计算行投影的周期性强度，选取峰值最大的角度。

```python
for angle in np.arange(-5, 5.1, 0.2):
    rotated = ndi.rotate(center, angle, reshape=False, order=1)
    proj = rotated.mean(axis=1)
    ac = correlate(proj - proj.mean(), proj - proj.mean(), mode="same")
    peak = find_peaks(ac_right, height=...)[0]
```

检测结果：**+1.80°**，自动回正并裁剪。

**颜色量化。** 原始照片有上万种颜色。用 K-means 聚类压缩到 5 种：

```python
pixels = img.reshape(-1, 3)
kmeans = KMeans(n_clusters=5, random_state=42, n_init=5)
labels = kmeans.fit_predict(pixels)
palette = kmeans.cluster_centers_.astype(np.uint8)
```

**网格检测。** 瓷砖排列有周期性。把每一行平均亮度画成曲线，计算自相关——平移多少后曲线和自己最相似——第一显著峰的位置就是瓷砖的像素周期：

```python
def find_period(signal, max_period=200):
    ac = correlate(signal, signal, mode="same", method="fft")
    mid = len(signal) // 2
    ac_right = ac[mid + 2 : mid + max_period]
    peaks, _ = find_peaks(ac_right, height=ac_right.max() * 0.3)
    return 2 + peaks[0]  # 第一显著峰 = 瓷砖周期
```

检测到周期 ~32x36 像素，对应 **23 行 x 30 列**的网格。每个格子的颜色由区域内的多数投票决定。

<img class="img-fluid" src="/uploads/2026/0705/extraction_diagnostic.png" alt="提取全流程">

5 种颜色的比例：深绿 18.4%、中绿 9.4%、深中绿 **35.4%**、浅中绿 20.7%、浅绿 16.1%。颜色分布并不均匀。

---

## 二、如何量化"随机"

把主观判断变成客观数值。用三个核心指标：

**莫兰指数（Moran's I）**——衡量相邻瓷砖的相似度。计算每个瓷砖和邻居颜色值的协方差，归一化。同色经常相邻则 I 为正，完全随机则 I 接近 0。

**游程比（Runs Ratio）**——水平/垂直方向上相邻异色的次数，除以随机期望值。比值 &lt; 1 表示扎堆，&gt; 1 表示交替频繁。

**互信息（Mutual Information）**——\\(I = \\sum p(x,y) \\log_2 \\frac{p(x,y)}{p(x)p(y)}\\)。统计瓷砖和右邻居的联合分布。MI = 0 表示独立，&gt; 0 表示存在依赖。

为了对比，生成几组对照样本：
- **纯随机**：每个格子独立抽取。两种变体——均匀分布（各色 20%）和匹配原图分布（35.4% 颜色 2、9.4% 颜色 1……）
- **柏林噪声**：叠加多层梯度噪声后量化，产生连续的聚集区域
- **波函数坍缩（WFC）**：预设邻接规则表，通过约束传播逐步确定每个格子颜色

所有生成图案加灰色边框模拟灰缝，与原图风格一致：

```python
def render_with_mortar(matrix, palette, tile_size=10, mortar_width=2):
    h = rows * tile_size + (rows + 1) * mortar_width
    w = cols * tile_size + (cols + 1) * mortar_width
    img = np.full((h, w, 3), [20, 25, 18], dtype=np.uint8)
    for i in range(rows):
        for j in range(cols):
            y = i * (tile_size + mortar_width) + mortar_width
            x = j * (tile_size + mortar_width) + mortar_width
            img[y:y+tile_size, x:x+tile_size] = palette[matrix[i, j]]
    return img
```

<img class="img-fluid" src="/uploads/2026/0705/comparison_figure.png" alt="综合对比图">

---

## 三、对比结果

| 方法 | 莫兰指数 I | 游程比 | 互信息 MI |
|------|-----------|--------|----------|
| **原始照片** | **0.142** | **0.85** | **0.086** |
| 纯随机（匹配原图比例） | -0.007 | 0.99 | 0.013 |
| 纯随机（均匀分布） | 0.010 | 1.02 | 0.011 |
| 柏林噪声 | 0.603 | 0.75 | 0.355 |
| WFC | 0.102 | 0.90 | 0.335 |

原始照片的三个指标都偏离了纯随机。但有两个问题需要验证。

**问题一：是否因为颜色比例本身就不均匀？**

生成 999 个纯随机样本，与原图保持完全相同尺寸（23x30）和颜色比例（35.4% 颜色 2、9.4% 颜色 1……）：

<img class="img-fluid" src="/uploads/2026/0705/monte_carlo_histograms.png" alt="直方图">

| 指标 | 原始值 | 999 个随机均值 | 标准差倍数 | p 值 |
|------|--------|--------------|-----------|------|
| 莫兰指数 | 0.142 | -0.002 | +5.09 | &lt; 0.00001 |
| 互信息 | 0.086 | 0.017 | +11.04 | &lt; 0.00001 |
| 游程比 | 0.85 | 1.00 | -10.26 | &lt; 0.00001 |

三个指标 p &lt; 0.00001。颜色分布不均不是原因。

**问题二：是否因为颜色数量少（只有 5 种）？**

从 2 种颜色试到 15 种，纯随机的莫兰指数始终围绕 0。颜色数量不影响空间指标。

<img class="img-fluid" src="/uploads/2026/0705/monte_carlo_color_count.png" alt="颜色数量影响">

两个假说都被排除。图案**确实**存在可统计检测的空间结构。

---

## 四、簇大小分析：更直观的角度

莫兰指数能检测微弱信号，但不直观。一个更朴素的问题是：**相邻的同色瓷砖连成一片，形成的斑块有多大？**

连通区域分析（8 邻域），统计每个斑块的瓷砖数：

```python
from scipy import ndimage

for color in range(n_colors):
    binary = (matrix == color)
    labeled, n = ndimage.label(binary, structure=np.ones((3, 3)))
    sizes = np.bincount(labeled.ravel())[1:]  # 每个斑块的大小
```

| 方法 | 平均斑块大小 | 最大斑块 | 最大斑块占比 |
|------|------------|---------|------------|
| **原始照片** | **3.9 块** | **194 块** | **28.1%** |
| 纯随机（匹配） | 2.8 块 | 29 块 | 4.2% |
| 柏林噪声 | 9.6 块 | 302 块 | 43.8% |
| WFC | 4.3 块 | 48 块 | 7.0% |

原始照片的最大斑块（194 块）远超随机（29 块），但远小于柏林噪声（302 块）。后者最大斑块占了近一半墙面。

<img class="img-fluid" src="/uploads/2026/0705/cluster_distribution.png" alt="簇大小分布">

视觉对比也传递了同样信息——12 张图中你能找出哪张是原图吗？

<img class="img-fluid" src="/uploads/2026/0705/monte_carlo_visual.png" alt="视觉对比">

---

## 五、答案

**这面墙的图案不是纯随机的。** 存在统计上可检测的聚集倾向，三个指标均 p &lt; 0.00001，斑块分析也显示明显更大的最大聚集区域。

但这种聚集程度并不夸张，不像是刻意排列的结果（对比柏林噪声和 WFC 的视觉差异）。更可能的来源：
- **批次差异**——同一小包的瓷砖颜色略有偏差，施工时自然形成小范围聚集
- **混合不完美**——施工前大致混合不同颜色的瓷砖，但难以做到完全均匀

工人们很可能是随手从混合袋里取出瓷砖贴上墙的。这个过程本身是随机的，但现实世界的随机——不像数学上的"独立同分布"——总会带着物理过程的微弱痕迹。

---

## 六、代码与用法

文章涉及的所有脚本和依赖配置打包在以下链接中：

<a class="btn btn-primary" href="/uploads/2026/0705/scripts.zip" role="button">下载全部代码 (scripts.zip, 30 KB)</a>

### 安装依赖

需先安装 Python 和 [uv](https://docs.astral.sh/uv/)：

```bash
unzip scripts.zip -d mosaic-analysis
cd mosaic-analysis
uv sync
```

### 依次执行

```bash
uv run python 01_extract_pattern.py
uv run python 02_eval_randomness.py
uv run python 03_generate_random.py
uv run python 04_generate_perlin.py --rows 23 --cols 30
uv run python 05_generate_wfc.py --rows 23 --cols 30
uv run python 06_metrics_comparison.py --rows 23 --cols 30
uv run python 07_monte_carlo_test.py
uv run python 08_cluster_analysis.py
```

### 各脚本功能速览

| 脚本 | 功能 | 核心方法 |
|------|------|---------|
| `01_extract_pattern.py` | 从照片提取瓷砖矩阵 | 自动纠偏 + K-means 量化 + 自相关网格检测 |
| `02_eval_randomness.py` | 评估随机性 | 卡方检验、熵、Moran's I、游程比、互信息 |
| `03_generate_random.py` | 生成纯随机图案 | 独立同分布采样，带砂浆边框渲染 |
| `04_generate_perlin.py` | 柏林噪声图案 | 多层梯度噪声叠加 + 量化 |
| `05_generate_wfc.py` | 波函数坍缩图案 | 最小熵选择 + 约束传播 |
| `06_metrics_comparison.py` | 多方法综合对比 | 表格 + 可视化 + 柱状图 |
| `07_monte_carlo_test.py` | 置换检验 | 999 次随机采样 + 经验 p 值 |
| `08_cluster_analysis.py` | 连通区域分析 | scipy.ndimage.label 斑块统计 |
