### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ a80a35ad-1286-459e-9efa-2e1100430cb4
using PlutoUI, CairoMakie,DataFramesMeta

# ╔═╡ a5fc4e03-6647-417b-b817-b7fbad12d3c5
using Colors

# ╔═╡ b87784b8-2355-4402-b9a9-f8d27c5efe34
using CSV, DataFrames,AlgebraOfGraphics

# ╔═╡ 2372f2f8-6260-404c-b750-8f52fb7d99ac
using CategoricalArrays

# ╔═╡ dd5017c0-c5b0-4149-8fad-2b7b616fe0ca
PlutoUI.TableOfContents(title = "目录")

# ╔═╡ 013a1710-9853-49f1-822f-c2285d40fb69
md"""
## 基本对象
1. Scenes
Scenes是Makie图形的基本组成部分。 一个场景（Scene）就像一个装载图形（plots）和其他场景（scenes）的容器。每个场景都有一个由缩放（scale）、平移（translation）和旋转（rotation）组成的转换（transformation）。 

2. Figure
Figure对象包含一个Scene和一个布局GridLayout,以及一些放置其上的块blocks 如，轴Axis, 色条Colorbar, 滑块Slider, 图例Legend等.

"""

# ╔═╡ 878e9d79-9234-4695-adc2-5fd2b8383bba
md"""
一个图形Figure， 可以按照一个类似矩阵的方式布局去放置想要放的任何的块。同时块还可以嵌套。
"""

# ╔═╡ 09daf82e-b538-4638-b827-0c487e5cb57a
md"""
# 基本框架

设想现实生活中， 我们要画一张图，大致需要以下步骤：

1. 挑选一张合适的画布。 所有的图形都会放在这个画布中。
2. 选好要画图的区域（想象画布被打上了格子）， 每个区域可能画不同的图形。
3. 在要画图的区域设定坐标系。
4. 将数据按照某种图形的要求画在设定的坐标系上。

在makie中， 绘图跟现实生活中的绘图是非常类似的， 只是有些操作可能合并到一起了而已。 

1. 定义画布。fig = Figure()
2. 选定区域， 放置坐标系。 ax = Axis(fig[i,j])
3. 在坐标系中画入图形。 plotfun!(ax, data...; ...)

从Julia的视角看， 上面的Figure， Axis都是复合数据类型。 这些类型的各个字段， 保存着跟图、坐标等有关的各种属性信息。 一幅图会有各种的属性， 比如对画布来说， 可能会有底色， 尺寸等， 对坐标轴来说， 会有标题、刻度、标签等等。

简单来说， 点和线（线也由点构成）就可以构建出所有图形。因此， 画入图形的含义是将数据视为坐标， 在对应的坐标位置描绘出点或者需要的几何图形。所以， 提供给绘图函数的数据需要能确定出一个点（或者一系列的点）。 这通常情况下用两个向量（x,y）给出。如果是三维图形需要给出三个坐标（x,y,z）。 


[Figure](https://docs.makie.org/stable/api/#Figure)
"""

# ╔═╡ b11430bc-4397-4c3e-9b7f-9cf7a924b03e
md"""

在下面的代码中， 我们先给出了一张画布， 并设定了画布的一些属性。然后，在画布的第一行第一列[1,1]，设定了坐标系ax。接下来定义了两个向量x1,y1, 用这两个向量的值向坐标系ax中画出了一条曲线。 请注意， 这里画曲线的函数是带惊叹号的， 这表明， 这个函数会修改其参数值。 事实上， 它修改的是第一个参数ax。 如果不带惊叹号， 我们会另外画出一幅图来。这个后面还会讲到。
```julia
f = Figure(backgroundcolor = :green, resolution = (800, 600), figure_padding = (10,10,10,10))
ax = Axis(f[1, 1])
x1 = 0:0.01:10
y1 = 0.5 .* sin.(x1)
lines!(ax, x1, y1)
f
```

在指定画布时， 我们设定了一些属性， 其含义分别如下：

- resolution = (800, 600) 指定画布的尺寸（width, height）
- figure_padding = (left,right,bottom,top)指定画布与图形之间的的空隙大小
- backgroundcolor = 颜色名； 指定画布的背景色。可以是任何Colors中的颜色名。 这里可以看到一个[颜色名称列表](https://juliagraphics.github.io/Colors.jl/stable/namedcolors/)， 或者在加载Colors包后， 可以用Colors.color_names查看一个颜色字典。

"""

# ╔═╡ 76d0bd9d-d3ec-4c3e-8e67-9294b68e9e4a
begin
f = Figure(backgroundcolor = :green, resolution = (800, 600), figure_padding = (10,10,10,10))
ax = Axis(f[1, 1])
x1 = 0:0.01:10
y1 = 0.5 .* sin.(x1)
lines!(ax, x1, y1)
f
end

# ╔═╡ 182a7a5d-5078-4184-9a19-fa6a8e0d026d
md"""
在上面我们没有对坐标轴做任何的设置。 这样的图形可能不是我们想要的。 因此， 下面的代码，我们继续向轴中增加一些常见的设置。 主要实现如下设置：
1. 增加整个图的标题
2. 增加x,y轴的标题。
3. 调整x，y轴的范围。

```julia
ax.title = L"y=0.5sin(x)"
ax.xlabel = "x轴"
ax.ylabel = "y轴"
limits!(ax, 0, 4*π, -1,1)
```
"""

# ╔═╡ f3ac5f2c-69f5-4e48-8f7c-0eae182a3683
begin
limits!(ax, 0, 4*π, -1,1)
ax.title = L"y=0.5sin(x)"
ax.xlabel = "x轴"
ax.ylabel = "y轴"
end;

# ╔═╡ 9041e7f2-d104-448f-bec7-e48a5c79ac40
f

# ╔═╡ d01b6583-183a-4637-8ac5-85dfe6aff7c3
md"""
这种在事后更改坐标轴的一些属性是可以的。但更多的时候， 我们可以在建立坐标轴的时候，就对其相关属性做出设置。 这对某些属性的设置可能更方便， 比如， 我们想要对x轴上的刻度改为用nπ来表示， 那么可以参考下面的方式，我们通过另外设置一个坐标轴来演示。

```julia
ax2 = Axis(f[1,2], 
	limits = (0, 4*π, -1,1), 
	title = L"y=0.5×sin(x)",
	xlabel = "x轴",
	ylabel = "y轴",
	xticks = 1:π:4π, 
	xtickformat = values ->["$(Int(floor(x/π)))π" for x in values],
)

lines!(ax2, x1, y1)
```

"""

# ╔═╡ 182b787b-ea4f-41a7-8ffc-92ec0fce1811
f

# ╔═╡ 825489d0-9d7e-4c12-a863-6522f5aa8e9f
begin
ax2 = Axis(f[1,2], 
	limits = (0, 4*π, -1,1), 
	title = L"y=0.5×sin(x)",
	xlabel = "x轴",
	ylabel = "y轴",
	xticks = 1:π:4π, 
	xtickformat = values ->["$(Int(floor(x/π)))π" for x in values],
)
	lines!(ax2, x1, y1)
end;

# ╔═╡ 09ecfd41-664e-416f-8bff-a2fa53ce0fe3
md"""
上面演示了一些常见的坐标轴的属性的设置方法。 但你可能想要做更多的设置， 这可以通过`@doc Axis`获得可以设置的所有属性的名称。
"""

# ╔═╡ 4e51edd6-4bb7-4aaa-b245-eb08babd9f36
@doc Axis

# ╔═╡ 1bcc2ad1-bed7-4d43-8053-05dd25d70aed
md"""
# 绘图函数
你可能觉得如果每个图形都要像上面那样绘制的话会很麻烦。 事实上， Makie中提供了多种常见的图形对应的绘图函数。可以通过绘图函数直接得到图形， 而不需要创建画布和坐标轴。一般而言， 这种绘图函数都是没有带惊叹号的函数， 它们会自己创建画布和坐标轴。

比如，像上面的图形， 我们可以直接使用lines函数画出来。
```julia
lines(x1, y1)
```
如果你要设置画布和坐标轴的一些属性的话：可以通过关键字参数figure和axis去设置。下面的代码绘制的是跟上面类似的图形。
```julia
lines(x1, y1, 
	# 分号的作用是表明括号是一个命名元组， 在元组元素多于一个时， 可以没有； 
	# 设置画布属性
	figure = (; 
	backgroundcolor = :green, 
	resolution = (400, 300), 
	figure_padding = (10,30,30,50)), 
	# 设置坐标轴属性
	axis = (; limits = (0, 4*π, -1,1), 
	title = L"y=0.5×sin(x)",
	xlabel = "x轴",
	ylabel = "y轴",
	xticks = 1:π:4π, 
	xtickformat = values ->["$(Int(floor(x/π)))π" for x in values])
)
```

"""

# ╔═╡ db1e972f-5113-4e21-9290-8903e07b7bbe
lines(x1, y1, 
	# 分号的作用是表明括号是一个命名元组， 在元组元素多于一个时， 可以没有； 
	# 设置画布属性
	figure = (; 
	backgroundcolor = :green, 
	resolution = (400, 300), 
	figure_padding = (10,30,30,50)), 
	# 设置坐标轴属性
	axis = (; limits = (0, 4*π, -1,1), 
	title = L"y=0.5×sin(x)",
	xlabel = "x轴",
	ylabel = "y轴",
	xticks = 1:π:4π, 
	xtickformat = values ->["$(Int(floor(x/π)))π" for x in values])
)

# ╔═╡ ed4e8cc0-dc27-4bb9-bf29-64705a2d8004
md"""
如果你想了解更多的绘图函数， 文档中提供了所有绘图函数的列表[plotting_functions](https://makie.juliaplots.org/stable/examples/plotting_functions/)。 你可以大致了解一下都有哪些绘图函数， 在需要的时候再去看如何调用。


这里有一个[教程](https://cn.julialang.org/JuliaDataScience/DataVisualizationMakie)
"""

# ╔═╡ e7a468b9-7ce9-4350-9423-73a1f2cffc6e
md"""
## BoxPlot

"""

# ╔═╡ 659660bc-0659-43b7-9ec2-a1a13d8643d3
begin
xs = rand(1:3, 1000)
ys = randn(1000)
dodge = rand(1:2, 1000)

fb, axb, bp = boxplot(xs, ys, dodge = dodge, show_notch = true, color = dodge,width=0.8, axis = (xticks = (1:3, ["left", "middle", "right"]),
                title = "Stacked bars"))


end

# ╔═╡ 11b9d570-1260-498c-abcf-2e2ca6a79ef7
md"""
# AoG画图
## 基本概念
这里主要介绍AlgebraOfGraphics.jl的绘图方法， 这是一个以Makie.jl为后端的绘图包。 这里有一个关于AoG包的[简短教程](https://tutorials.pumas.ai/html/PlottingInJulia/).


AlgebraOfGraphics.jl绘图的核心思想是将图形进行了分层。不同层解决不同的问题。大致来说， 一个图形可能包括三个层次：
1. 数据层(data)， 这一层主要给定绘图的数据来源。
2. 变换层(mapping)， 这一层主要是给定数据与图形属性之间的映射关系， 同时也可以给定一些数据的变换。
3. 可视化层(visual)， 这一层的主要目的是设置图形的类型， 也是直观上看到的不同的图形类型，比如散点图、折线图等。
有时候， 我们可能会对数据做一些统计变换， 比如， 在散点图的基础上， 增加一个拟合的曲线。这时候，需要用到统计变换层。

不同的层之间有两种可能的运算 
```julia
	*：表示层之间是融合在一起， 
	+:表示层之间是叠加在一起
```

有了上面的介绍， 我们可以打造一个基本的绘图本框架如下：
```julia
data(数据源) * mapping(属性映射) * visual(图形类别) |> draw

```
上面的**|>** 是管道操作， 表示将前面的对象放到后面的函数draw里面。draw的作用是把图形绘制出来。

所以，总的来说， 绘图分为三步： 
- **第一步是指定数据源： **
指定数据源时， 一般是dataframe， 但实际上，只要是实现了。

- **第二步，指定图形映射**

指定映射mapping时，其含义是数据和图的属性之间建立关系。mapping() 函数有三个位置参数和多个关键字参数，这里简单做个介绍。

三个位置参数分别为：
- x-axis
- y-axis
- z-axis

这三个位置参数的赋值情况，决定了图形的基本形状。 其他可选的参数包括：
- color  
- marker 
- dodge
- stack
- col
- row
- layout
这些参数会决定图形的外貌。

 - **第三步 确定图形类型(visual)**
在确定了数据和映射关系之后，要决定需要画什么类型的图。 常见的图形有很多种， 由于AlgebraOfGraphics.jl是以makie.jl作为后端的， 所以makie中实现的所有图形类型（看[这里](https://docs.makie.org/dev/examples/plotting_functions/)）， 都可以在AlgebraOfGraphics.jl中使用。 不过，这里的类型，不是简单的绘图函数。而是驼峰形式表示的。 比如， 条形图的函数是barplot， 对应的图形类型是BarPlot。


"""

# ╔═╡ d2e24c1a-ddba-4630-9150-2a68acda2325
md"""
## 每一层演示
"""

# ╔═╡ 4b32f4e0-1dd0-4b46-8a27-3bcf199994fe
train = CSV.read("data/trainbx.csv", DataFrame)

# ╔═╡ 02081620-ec0a-4200-8f85-38885a8e8672
md"""
### 数据层
将一个数据框填入函数data()即可构建数据层。这个层里面主要存储用于可视化的数据和可视化的一些设置。一般就是数据。
"""

# ╔═╡ d50d683b-f452-4850-8b8c-bedea4ae0d04
df = data(train)

# ╔═╡ 79e9b3c4-4fdf-4681-8827-0141338df7b2
md"""
### 映射层
映射层用于实现数据到图形的映射。这些参数有两类， 一类是位置参数，用于指定图形的x，y，z轴。另一类是关键字参数， 主要用于指定图形的一些可视化属性。

其指定的格式是：
```julia
mapping(:x轴映射变量, :y轴映射变量,[：z轴映射变量])
```
注意， 其中的变量名应该是数据层中列的名字（尽管可以暂时不指定数据层）， 且前面要加冒号，表示Symbol。 比如， 下面索赔

"""

# ╔═╡ 30393893-10dd-4913-a78b-5d2c6a521593
axn = mapping(:injury_claim, :property_claim)

# ╔═╡ c3cd9e41-aaf6-4720-b4f8-c8f9b8b0bd97
md"""
### 可视化层
可视化层用于表示展示数据的图形类型。比如， 我们要做的散点图， 那么可以构建Scatter的visual层。
"""

# ╔═╡ 9a26bac8-4d2a-4beb-ab11-adaa968ca648
geom = visual(Scatter)

# ╔═╡ 59ec4ea5-a32a-46f6-9487-5d08d343ce90
md"""
现在我们将三层揉到一起， 只需要用乘法*操作。乘法操作的结果是一个层， 也就是三层变成了完整的一层。下面可以看到结果。
"""

# ╔═╡ 50bf65da-8a0f-4974-bcee-2b609dd64395
df * axn * geom

# ╔═╡ 89505491-76e7-404d-9ef0-fec49e49783d
md"""
上面虽然明确的显示出了绘图的三层， 但没有显示出图形， 如果要将图形显示出来， 需要将上面的三层输入绘图函数draw
"""

# ╔═╡ c91e6758-65f2-4ea7-bb63-88c8e72c759b
df * axn * geom |> draw

# ╔═╡ 8dc43655-9864-497c-90ec-46eeab09949a
md"""
上面的 |> 是Julia中管道操作符， 其含义是将左边的对象输入右边函数的第一个参数。 在这里，相当于将绘图的配置信息输入，并将图形绘制出来。 

这种调用方式是适用于默认绘图的设置。draw函数还有三个axis, figure or palettes，分别用于设置坐标轴，图形属性以及调色板。
"""

# ╔═╡ dcc1ddc0-36ee-4be9-8761-b73686f4cf5d
draw(df * axn * geom;
	 axis=(;
		 title="My Fancy Title",
		 aspect=4/3,
		 ylabel="KG",
	 	 xticklabelrotation=π/8),
	 figure=(;
		 resolution=(600, 600),
		 figure_padding=6,
		 backgroundcolor=:pink,
		 fontsize=16),
	 palettes=(;
		 color=[:purple, :green])
)

# ╔═╡ c273e1cf-ae5c-44db-b3e7-ac362e2a2700
md"""
## 写在画图之前
在画图分析时， 我们首先要搞清楚， 你分析的目标是什么， 然后根据你的分析目标去确定要用什么类别的图形，做什么属性映射。

在这里， 我将分析目标按要分析的变量的个数来分类， 分别分为， 1个变量分析，2个变量分析和多个变量分析（3个及以上）。 对每个类别， 我们还需要考虑变量的属性是类别变量？还是数值变量。
"""

# ╔═╡ 086ec222-740a-4d3c-b48c-412ac5cb26a5
md"""
## 1个变量分析
### 1. 分类变量
分析一个分类变量， 通常情况下是计算频率， 画出频率直方图。
比如，我们要分析学历的分布情况,即字段insured\_education\_level。 

由于我们的原始数据中没有包含这个字段的频率信息， 一种首先想到的方案是， 我们可以先将频率信息计算出来， 然后再画图。
"""

# ╔═╡ fb16b0e8-c4f8-472d-abcd-7a08c2cc0980
edudata = @chain train begin
	groupby(:insured_education_level)
	@combine :count = length(:insured_education_level)
end

# ╔═╡ a030e817-7634-43f3-ac1e-f91403163c25
data(edudata) * mapping(:count) * visual(BarPlot) |> draw

# ╔═╡ 751ab302-fbf5-4fa2-a9a7-f616ffcca7c0
md"""
上面这种方式当然是OK的， 但计算频率这种事情， 对每个离散变量的分析可能都需要， 这时， 我们可以用到画图包中给我们已经实现的统计变换。

一个统计变换是基于原始数据，经过统计计算之后得到的一份新数据， 然后这个变换默认情况下会绑定某种可视化图形。所以，如果你的画图里面已经有统计变换了， 那么不指定绘图类型也是可以的。 

由于频率统计的默认展示方式就是条形图， 下面两行代码结果是一样的。
"""

# ╔═╡ 29d99c5d-266c-4549-8154-0e3675038ab7
data(train) * mapping(:insured_education_level) * frequency() * visual(BarPlot) |> draw

# ╔═╡ dccbccd7-d62b-467f-9f0e-c6b3e9560577
data(train) * mapping(:insured_education_level) * frequency() |> draw

# ╔═╡ d5ac1f6f-2c33-468c-af97-143ba6fb7e8a
md"""
你可能想要对图形属性做一定程度的设置， 这需要你对一种图形类型到底可以设置哪些属性有一个基本的了解，你可以通过绘图函数的帮助文档获得其相应的可设置的字段。 你可以将下面的代码放进一个cell， 然后运行得到barplot的帮助文档。改成其他的绘图函数可以得到相应的帮助信息。
```julia 
with_terminal() do
 help(barplot)
end
```
这些绘图属性的设置是通过visual函数中相应的参数名称设置的。 一些跟坐标轴相关的设置，需要通过draw函数设置， 这里暂时不涉及。

下面演示一下对条形图我们常见的设置， 条形颜色和条形数字展示。
"""

# ╔═╡ 2ca8b2ea-3446-4093-8717-f1bb37c64659
data(train) * mapping(:insured_education_level) * frequency() * visual(BarPlot, color = :blue, bar_labels = :x) |> draw

# ╔═╡ 2506ac1b-67e6-4277-b477-8502a3d1e26c
md"""
上面看到的是BarPlot图的画法， 其他很多图也是类似的画法。由于AoG.jl其实是将画图的代码翻译成Makie画图的代码， 所以Makie能画的图， AoG也是能画的。到[**Makie的官方网站**](https://docs.makie.org/dev/reference/plots/index.html)可以看到所有的绘图函数
"""

# ╔═╡ 6fcf7dec-a583-419a-875f-5eedc52ae462
md"""
### 练习
试画出性别分布的条形图。
"""

# ╔═╡ 4c86c58f-7f6a-4e90-9152-a27dfbd4be94
md"""
### 2 一个数值变量
一个数值变量一般可能的取值有无穷多。这时候， 可以画直方图（Hist）或者密度图(Density)来了解数值的分布情况。下面以年龄为例做简单分析。
"""

# ╔═╡ d960a054-b2db-421f-a1db-07a1f6ea4bd7
data(train) * mapping(:age) * visual(Hist) |> draw

# ╔═╡ 839e62d4-733f-4281-82c1-ca0be9867da9
data(train) * mapping(:age) * visual(Density) |> draw

# ╔═╡ 9bd311b1-2eeb-49f9-a452-63e3e2898ad4
md"""
### 练习
试画出保费:policy\_annual\_premium的分布直方图和密度图
"""

# ╔═╡ 22f98a6c-7ee0-4c07-a6b4-abbaeeb9aa78
#data(train) * mapping(:policy_annual_premium) * visual(Density, color = (:red, 0.3)) |> draw

# ╔═╡ 6223a9e6-7459-42ba-9020-9ce6a1e2c8dd
md"""
## 2个变量
2个变量的分析可以有多种情况， 

### 2个都是数值变量
即两个变量的取值可能都是无穷多， 这时候可以画散点图， 比如， 我们可以看一下，
policy\_annual\_premium 每年的保费,total\_claim\_amount 整体索赔金额 两个字段的散点图。
"""

# ╔═╡ 30a3ce35-e5ba-4234-9f7d-356b692530c9
data(train) * mapping(:total_claim_amount,:policy_annual_premium) * visual(Scatter) |> draw

# ╔═╡ 5ad30622-c510-4ba6-a50b-2af30375bf17
md"""
从上面的图形可以看出， 有一部分用户有交保费， 但索赔很少。而另一部分用户， 保费金额与索赔金额之间存在一定的线性关系。上面图形中的x，y轴的坐标时自动生成的。你可能不喜欢这个名字， 需要做一定的修改。这可以在mapping中实现。
"""

# ╔═╡ 9da06881-bad0-480d-918c-a7668ebc9106
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费) * visual(Scatter) |> draw

# ╔═╡ 728ea751-4342-4413-aa86-97d87214ccea
md"""
上面演示了在mapping中指定坐标映射的同时，实现对变量的重命名。事实上， mapping中还可以有三种操作方法，分别有不同含义。
```julia
:column_name => "新的名字":  重命名

:column_name => function(): 对列进行处理（计算）， 但不重命名.

：column_name => function() => "新的名字": 对数据进行操作的同时， 进行重命名。
```

"""

# ╔═╡ a22617d3-f5ab-4bb3-befc-248ec2cc6ffe
md"""
!!! tip "💡 提 示"
	上面对列的操作函数要么是没有参数的函数， 这时不需要加括号， 比如  :col => mean； 要么如果有参数， 需要是匿名函数，比如 col => (x -> round(x; digits=2)). 
"""

# ╔═╡ 4ce9e829-815a-4aad-937d-86adccd89bf3
fig1 = data(train) * mapping(:total_claim_amount,:policy_annual_premium) * visual(Scatter) ;

# ╔═╡ 9c64fdc7-86ee-4d53-bff8-02833a8aadbb
fig2 = mapping([2.5*10^4,1.0*10^5] ) * visual(VLines);

# ╔═╡ 2824df98-236e-41ad-bcc0-9cf934b8f498
fig1 + fig2 |> draw;

# ╔═╡ a9643ce7-0562-4a95-a52e-cf01bc4d33d1
data(train) * mapping(:total_claim_amount,:policy_annual_premium, color = :fraud =>nonnumeric) * visual(Scatter) |> draw;

# ╔═╡ ff5505e3-2400-4686-b878-576275cc598f
data(train) * mapping(:total_claim_amount,:policy_annual_premium) * AlgebraOfGraphics.density()|> draw;

# ╔═╡ 9bc7f8d9-0e20-4d84-8149-5e08640a8022
data(train) * mapping(:total_claim_amount,:policy_annual_premium) * AlgebraOfGraphics.density() * visual(Contour) |> draw;

# ╔═╡ 8e97e93d-0444-43c1-9a33-90a7d7fcffb1
md"""
在这种情形下，我们更多的是关注两个变量是否存在某种关系， 比如我们可以看一下:vehicle\_claim,:total\_claim\_amount这两者之间是存在明显的相关关系的。 此时， 我们可以在这个图之上再增加拟合一条直线。
"""

# ╔═╡ 3f29511c-6eed-424b-ace3-8c1c81c15a49
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * visual(Scatter) |> draw

# ╔═╡ 15f2b1da-0898-48e0-a00a-33653a5cd349
md"""
从上图可以明显的看得出来， 整体索赔和车辆索赔之间存在很强的线性关系。 这是符合预期的。 因为这里有一条明显的直线， 你可能很想把这个直线拟合出来，并画出来。 这是容易的。 AoG。jl包中提供了一个统计变换linear()， 对数据做这个变换可以获得一个拟合的直线， 然后可以把这个直线画出来。
"""

# ╔═╡ d2cda005-00ac-4f0c-bdbe-46cefbde4a78
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * linear() |> draw

# ╔═╡ 243119e0-fa1d-4451-bfd9-1fa74ca52e40
md"""
直线虽然画出来了， 但点不见了。能不能把两幅图叠加到一起呢？ 答案是可以的， 用 + 运算即可。
"""

# ╔═╡ cdc668e2-aa2d-43b6-8670-cee1e44bcb9e
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * linear() + data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * visual(Scatter) |> draw

# ╔═╡ a218091d-2023-4bde-9d97-a42a562250e7
md"""
当然，上面的写法有很多重复信息。 我们可以对乘法和加法提取同类项。
"""

# ╔═╡ baff2184-48db-4425-affb-fa7544b1500e
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * (linear() +  visual(Scatter) )|> draw

# ╔═╡ f723486c-7dc2-4e26-aec9-3744bf39407a
md"""
当然， 那个直线是黑色的，你很有可能不喜欢。如果要改变直线的颜色， 不能在linear中， 必须要给其加上一层visual。
"""

# ╔═╡ 60fbcbaf-48bb-4119-b6d4-8c7884b8c18b
data(train) * mapping(:vehicle_claim,:total_claim_amount) * (visual(Scatter) + linear()*visual(color = :red)) |> draw

# ╔═╡ 47f86951-5874-4bbd-98e2-7e776b1be378
md"""
### 一个数值变量一个分类变量
这种情况下， 一种常见的分析就是了解不同类别下（分类变量）,数值变量的分布情况。 比如， 我们想了解不同性别的用户的年龄分布情况。 我们可以有boxplot(箱线图）, Violin（小提琴图）。本质上，可以看成是将类别变量视为分类变量， 将数据分组之后， 去给单个连续变量画图。
"""

# ╔═╡ ca1d28fd-19ca-460b-bc4b-2d256a342cee
data(train) * mapping(:insured_sex,:age) * visual(BoxPlot) |> draw

# ╔═╡ 27c3facc-d031-4900-9888-c04feedd0490
data(train) * mapping(:insured_sex,:age) * visual(Violin)  |> draw

# ╔═╡ 4649d58d-38a2-4a2f-ba39-2e7f29ae5eb1
md"""
上面两种情况， 展示的都是不同类别下， 数值变量的分布信息， 有时候， 我们可能需要的是不同类别下， 数值变量的均值（期望）信息。 这可以通过统计变换expectation实现。
"""

# ╔═╡ 07392891-edeb-47ab-998c-8da4e6a889fe
data(train) * mapping(:insured_sex,:age) * expectation() * visual(BarPlot) |> draw

# ╔═╡ a94d1adf-1206-4b63-bc4f-9a53ea2d43e2
md"""
### 2个分类变量
如果两个都是分类变量， 这种情况可能更适合做列联表分析。可以参考Freqtable.jl的frequtable.

如果硬要画图， 无非是用条形图展示一个类别变量下，另一个类别的计数信息。 这个可以实现， 但如果我们同时指定两个变量分别为x，y， 效果会很差（另一个的计数信息无法区分）。必须要将其中一个映射到一个图形属性上去， 比如，另一个维度用颜色表示。 而且， 还必须要指定条形之间要stack或者doggle， 否则， 很有可能条形之间会重叠覆盖。

比如， 我们想要分析性别跟学历行为之间的关系。
"""

# ╔═╡ c1d87c7e-d438-4ab6-9223-4a0d7cd6e80c
data(train)* # 准备数据
mapping(:insured_sex, :insured_education_level ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ c358b554-581c-42f5-abad-22093ece4325
md"""
下面这个图， 我们将两一个变量的情况用颜色表示， 不过你可能会发现， 这里面似乎没有Associate， 是什么原因?
"""

# ╔═╡ e84f8bb0-9d87-429c-893c-d913e9a8b215
data(train)* # 准备数据
mapping(:insured_sex, color = :insured_education_level) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 838f8871-7ebc-4865-b323-5617f944601a
data(train)* # 准备数据
mapping(:insured_sex, color = :insured_education_level, stack = :insured_education_level ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ e72b730c-4623-4176-8012-597e91394df4
md"""
stack表示的是我们的“条形”是堆叠(stack)起来的， 有时候，我们希望把他们放在一起， 稍微隔开一点就行， 这可以通过设置doggle实现。
"""

# ╔═╡ 146c7065-607c-48c8-9b23-870e222a77fd
data(train)* # 准备数据
mapping(:insured_sex, color = :insured_education_level, dodge = :insured_education_level ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ b345d1bd-987e-4044-943d-40778096fa12
md"""
是否欺诈才是我们更加关注的， 下面我们用同样的方法简单分析一下， 欺诈跟性别的关系。
"""

# ╔═╡ 19f842ac-1aed-4510-a5a1-718c1e9916aa
data(train)* # 准备数据
mapping(:insured_sex, color = :fraud, stack = :fraud ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 7c99a62c-965c-4e47-9007-289dfff8bbd8
md"""
😭上面的代码出错了， 你很有可能手足无措， 不知道该怎么办。 事实上， 如果你仔细看看出错信息， 这里涉及到一个颜色关键词(color)。没错， 就是颜色设置出了问题。 本来我们不同类别用不同颜色表示就好了， 然后，我们用：fraud的类别来表示不同的颜色本来是没错的。 问题就出在， fraud不是一个类别变量。 因此， 我们需要对其做转化。

可以有以下两种处理方案， 

1、 我们可以将fraud 先转换为类别变量， 这可以通过将其重新编码实现。
"""

# ╔═╡ c9527fb0-f809-44c0-93ab-e1eda3c6bafa
data(
	@transform train :fraud = recode(:fraud, 0=>"非欺诈", 1=>"欺诈")
) * # 准备数据
mapping(:insured_sex, color = :fraud, stack = :fraud ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw # 把图画出来

# ╔═╡ c8cac90a-a1c4-4fae-9074-fdc868f07c3e
md"""
当然， 我们也可以在映射的时候通过nonnumeric函数告诉后端， fraud不是数值变量。
"""

# ╔═╡ e52617bb-dc57-4b3b-b9f3-97376d48ae25
data(train)* # 准备数据
mapping(:insured_sex, color = :fraud => nonnumeric, stack = :fraud => nonnumeric) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 72044f03-0623-4d2d-9310-ca0f05c6973d
md"""
## 3个以上变量的分析
如果要同时画出三个以上的变量， 这时候可以是三维图（比较少见）。或者，更多的是增加的变量是类别变量， 然后可以将变量映射给不同的图形属性， 从而实现展示不同属性下数据变化的情况。这有点在做统计分析时做分类汇总的味道， 只是现在是分类绘图。

换句话说， 如果我们不增加图形的空间维度（只有x,y两个空间维度）， 那就只能用图形的属性去表示多出来的维度信息。

这里， 常见的图形属性包括： 颜色（color）， 标记（marker）， 布局等。前面提到的mapping的关键字参数都是用来干这个的。下面演示几种情形。
"""

# ╔═╡ cf88ac19-cf88-4d49-9204-5741708e905c
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费, marker = :fraud => nonnumeric) * visual(Scatter) |> draw

# ╔═╡ ae6d7246-5fbc-428b-bf22-50823a1c0ca5
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费, color = :fraud => nonnumeric, marker = :insured_education_level =>"学历" ) * visual(Scatter) |> draw

# ╔═╡ 6deb8e15-9a52-4666-b502-1060756f0e87
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费, color = :fraud => nonnumeric, row =  :insured_education_level =>"学历" ) * visual(Scatter) |> draw

# ╔═╡ 93c2798d-4c1a-4c80-bc95-8ee85028cf1a
data(train) * mapping(:fraud => nonnumeric, :age ) * visual(BoxPlot) |> draw

# ╔═╡ 9cf8a7e6-4344-4d61-8baf-33cfbbeae853
data(train) * mapping(:age,color = :fraud => nonnumeric, row =  :insured_sex =>"学历") * visual(Density,alpha = 0.3) |> draw

# ╔═╡ afaa9cf4-bf03-47e5-9190-fb8193262e00
md"""
你很有可能会觉得， 上面的图形太简陋了， 你可能想增加更丰富的信息上去， 这可以通过映射关系去添加更多的信息， 当然，你也可以修改图形的一些展示属性。

比如， 你可能希望， 条形图里面还能用不同的颜色去展示涉及欺诈的不同的样本的数量。 这时候， 你可以在映射层，将：fraud字段绑定到图形的颜色上去，  color = :fraud。 但有一个问题， 在数据集里面， fraud是整数， AlgebraOfGraphics会将其当成一个连续属性， 这时没办法将其不同的取值分配不同的颜色。 我们需要做的是将：fraud列转换为一个分类变量， 这可以通过将数字重新编码(recode）为文本实现。
"""

# ╔═╡ 05486b6b-32c2-4bc7-a9fd-102a5242391a
md"""
可以看的出来， 上面按颜色区分不同类别的主子是以堆叠的方式呈现的。我们可以可以将其改为并排形式。这只要设置dodge参数即可。
"""

# ╔═╡ f577e6b8-3309-495e-99d0-c723e57976d7
md"""
# 画图保存
有时候， 你可能想将画好的图形保存为一个图片文件。 这个很简单， 只要把draw的结果用save保存下来即可。

```julia
save("my_image.png", draw(plt); px_per_unit=3)
```
将前面准备好的图在传入draw之前先保存， 然后将其传入draw，并嵌入save。
"""

# ╔═╡ 46c04480-e98d-4f5b-8ce1-4fcd200bbc99
plt = data(train) * mapping(:injury_claim , :property_claim, color = :fraud => nonnumeric)

# ╔═╡ 7a597644-3c16-4963-9156-093e1826bd63
save("data/my_image.png", draw(plt); px_per_unit=3)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AlgebraOfGraphics = "cbdf2221-f076-402e-a563-3d30da359d67"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
CategoricalArrays = "324d7699-5711-5eae-9e2f-1d82baa6b597"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AlgebraOfGraphics = "~0.6.16"
CSV = "~0.10.11"
CairoMakie = "~0.10.11"
CategoricalArrays = "~0.10.8"
Colors = "~0.12.10"
DataFrames = "~1.6.1"
DataFramesMeta = "~0.14.0"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "ce0e4e1695f913e513898035edb262391b0609c2"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractLattices]]
git-tree-sha1 = "f35684b7349da49fcc8a9e520e30e45dbb077166"
uuid = "398f06c4-4d28-53ec-89ca-5b2656b7603d"
version = "0.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "02f731463748db57cc2ebfbd9fbc9ce8280d3433"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AlgebraOfGraphics]]
deps = ["Colors", "Dates", "Dictionaries", "FileIO", "GLM", "GeoInterface", "GeometryBasics", "GridLayoutBase", "KernelDensity", "Loess", "Makie", "PlotUtils", "PooledArrays", "PrecompileTools", "RelocatableFolders", "StatsBase", "StructArrays", "Tables"]
git-tree-sha1 = "c58b2c0f1161b8a2e79dcb1a0ec4b639c2406f15"
uuid = "cbdf2221-f076-402e-a563-3d30da359d67"
version = "0.6.16"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "eba0af42241f0cb648806604222bab1e064edb67"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.5.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["TranscodingStreams"]
git-tree-sha1 = "ef9997b3d5547c48b41c7bd8899e812a917b409d"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "0.8.4"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"

[[deps.CRlibm]]
deps = ["CRlibm_jll"]
git-tree-sha1 = "32abd86e3c2025db5172aa182b982debed519834"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "1.0.1"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.CairoMakie]]
deps = ["Base64", "Cairo", "Colors", "FFTW", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools", "SHA"]
git-tree-sha1 = "74384dc4aba2b377e22703e849154252930c434d"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.10.11"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "1568b28f91293458345dabba6a5ea3f183250a61"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.8"

    [deps.CategoricalArrays.extensions]
    CategoricalArraysJSONExt = "JSON"
    CategoricalArraysRecipesBaseExt = "RecipesBase"
    CategoricalArraysSentinelArraysExt = "SentinelArrays"
    CategoricalArraysStructTypesExt = "StructTypes"

    [deps.CategoricalArrays.weakdeps]
    JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    SentinelArrays = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
    StructTypes = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"

[[deps.Chain]]
git-tree-sha1 = "8c4920235f6c561e401dfe569beb8b924adad003"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.5.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e0af648f0692ec1691b5d094b8724ba1346281cf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.18.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "7f13b2f9fa5fc843a06596f1cc917ed1a3d6740b"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelaunayTriangulation]]
deps = ["DataStructures", "EnumX", "ExactPredicates", "Random", "SimpleGraphs"]
git-tree-sha1 = "bea7984f7e09aeb28a3b071c420a0186cb4fabad"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "0.8.8"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "e82c3c97b5b4ec111f3c1b55228cebc7510525a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.25"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "5225c965635d8c21168e32a12954675e7bea1151"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.10"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "3d5873f811f582873bb9871fc9c451784d5dc8c7"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.102"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ErrorfreeArithmetic]]
git-tree-sha1 = "d6863c556f1142a061532e79f611aa46be201686"
uuid = "90fa49ef-747e-5e6f-a989-263ba693cf1a"
version = "0.5.2"

[[deps.ExactPredicates]]
deps = ["IntervalArithmetic", "Random", "StaticArraysCore"]
git-tree-sha1 = "499b1ca78f6180c8f8bdf1cabde2d39120229e5c"
uuid = "429591f6-91af-11e9-00e2-59fbe8cec110"
version = "2.2.6"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.Extents]]
git-tree-sha1 = "2140cd04483da90b2da7f99b2add0750504fc39c"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "b4fbdd20c889804969571cc589900803edda16b7"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.1"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FastRounding]]
deps = ["ErrorfreeArithmetic", "LinearAlgebra"]
git-tree-sha1 = "6344aa18f654196be82e62816935225b3b9abe44"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.3.1"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "35f0c0f345bff2c6d636f95fdb136323b5a796ef"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.7.0"
weakdeps = ["SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "c6e4a1fbe73b31a3dea94b1da449503b8830c306"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.21.1"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "50351f83f95282cf903e968d7c6e8d44a5f83d0b"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "38a92e40157100e796690421e34a11c107205c86"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "273bd1cd30768a2fddfa3fd63bbc746ed7249e5f"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.9.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "d53480c0793b13341c40199190f92c611aa2e93c"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.2"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "424a5a6ce7c5d97cca7bcc4eac551b97294c54af"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.9"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Observables"]
git-tree-sha1 = "f57a64794b336d4990d90f80b147474b869b1bc4"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.9.2"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ad37c091f7d7daf900963171600d7c1c5c3ede32"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalArithmetic]]
deps = ["CRlibm", "EnumX", "FastRounding", "LinearAlgebra", "Markdown", "Random", "RecipesBase", "RoundingEmulator", "SetRounding", "StaticArrays"]
git-tree-sha1 = "f59e639916283c1d2e106d2b00910b50f4dab76c"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.21.2"

[[deps.IntervalSets]]
deps = ["Dates", "Random"]
git-tree-sha1 = "3d8866c029dd6b16e69e0d4a939c4dfcb98fac47"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.8"
weakdeps = ["Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "4ced6667f9974fc5c5943fa5e2ef1ca43ea9e450"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.8.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "d65930fa2bc96b07d7691c652d701dcbe7d9cf0b"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "90442c50e202a5cdf21a7899c66b240fdef14035"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.7"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LightXML]]
deps = ["Libdl", "XML2_jll"]
git-tree-sha1 = "e129d9391168c677cd4800f5c0abb1ed8cb3794f"
uuid = "9c8b4983-aa76-5018-a973-4c85ecc9e179"
version = "0.9.0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearAlgebraX]]
deps = ["LinearAlgebra", "Mods", "Permutations", "Primes", "SimplePolynomials"]
git-tree-sha1 = "558a338f1eeabe933f9c2d4052aa7c2c707c3d52"
uuid = "9b3f67b0-2d00-526e-9884-9e4938f8fb88"
version = "0.1.12"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "a113a8be4c6d0c64e217b472fb6e61c760eb4022"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.6.3"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "eb006abbd7041c28e0d16260e50a24f8f9104913"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2023.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "Match", "MathTeXEngine", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Setfield", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "StableHashTraits", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "1d16d20279a145119899b4205258332f0fbeaa94"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.19.11"

[[deps.MakieCore]]
deps = ["Observables", "REPL"]
git-tree-sha1 = "a94bf3fef9c690a2a4ac1d09d86a59ab89c7f8e4"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.6.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Match]]
git-tree-sha1 = "1d9bc5c1a6e7ee24effb93f175c9342f9154d97f"
uuid = "7eb4fadd-790c-5f42-8a69-bfa0b872bfbf"
version = "1.2.0"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "Test", "UnicodeFun"]
git-tree-sha1 = "8f52dbaa1351ce4cb847d95568cb29e62a307d93"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.5.6"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mods]]
git-tree-sha1 = "61be59e4daffff43a8cec04b5e0dc773cbb5db3a"
uuid = "7475f97c-0381-53b1-977b-4c60186c8d62"
version = "1.3.3"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.Multisets]]
git-tree-sha1 = "8d852646862c96e226367ad10c8af56099b4047e"
uuid = "3b2b4ff1-bcff-5658-a3ee-dbcf1ce5ac09"
version = "0.4.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "2ac17d29c523ce1cd38e27785a7d23024853a4bb"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.10"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "01f85d9269b13fedc61e63cc72ee2213565f7a72"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.8"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "66b2fcd977db5329aa35cac121e5b94dd6472198"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.28"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "5ded86ccaf0647349231ed6c0822c10886d4a1ee"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.1"

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "ec3edfe723df33528e085e632414499f26650501"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.5.0"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4745216e94f71cb768d58330b059c9b76f32cb66"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.14+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Permutations]]
deps = ["Combinatorics", "LinearAlgebra", "Random"]
git-tree-sha1 = "25e2bb0973689836bf164ecb960762f1bb8794dd"
uuid = "2ae35dd2-176d-5d53-8349-f30d82d94d4f"
version = "0.4.17"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase", "Setfield", "SparseArrays"]
git-tree-sha1 = "ea78a2764f31715093de7ab495e12c0187f231d1"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "4.0.4"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsFFTWExt = "FFTW"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "6842ce83a836fbbc0cfeca0b5a4de1a4dcbdb8d1"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.8"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "4c9f306e5d6603ae203c2000dd460d81a5251489"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.4"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.RingLists]]
deps = ["Random"]
git-tree-sha1 = "f39da63aa6d2d88e0c1bd20ed6a3ff9ea7171ada"
uuid = "286e9d63-9694-5540-9e3c-4e6708fa07b2"
version = "0.2.8"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SetRounding]]
git-tree-sha1 = "d7a25e439d07a17b7cdf97eecee504c50fedf5f6"
uuid = "3cc68bcd-71a2-5612-b932-767ffbe40ab0"
version = "0.2.1"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "db0219befe4507878b1a90e07820fed3e62c289d"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.4.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

[[deps.SimpleGraphs]]
deps = ["AbstractLattices", "Combinatorics", "DataStructures", "IterTools", "LightXML", "LinearAlgebra", "LinearAlgebraX", "Optim", "Primes", "Random", "RingLists", "SimplePartitions", "SimplePolynomials", "SimpleRandom", "SparseArrays", "Statistics"]
git-tree-sha1 = "b608903049d11cc557c45e03b3a53e9260579c19"
uuid = "55797a34-41de-5266-9ec1-32ac4eb504d3"
version = "0.8.4"

[[deps.SimplePartitions]]
deps = ["AbstractLattices", "DataStructures", "Permutations"]
git-tree-sha1 = "dcc02923a53f316ab97da8ef3136e80b4543dbf1"
uuid = "ec83eff0-a5b5-5643-ae32-5cbf6eedec9d"
version = "0.3.0"

[[deps.SimplePolynomials]]
deps = ["Mods", "Multisets", "Polynomials", "Primes"]
git-tree-sha1 = "d537c31cf9995236166e3e9afc424a5a1c59ff9d"
uuid = "cc47b68c-3164-5771-a705-2bc0097375a0"
version = "0.2.14"

[[deps.SimpleRandom]]
deps = ["Distributions", "LinearAlgebra", "Random"]
git-tree-sha1 = "3a6fb395e37afab81aeea85bae48a4db5cd7244a"
uuid = "a6525b86-64cd-54fa-8f65-62fc48bdc0e8"
version = "0.3.1"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableHashTraits]]
deps = ["Compat", "SHA", "Tables", "TupleTools"]
git-tree-sha1 = "30edbce1c797dc7d4c74bc07b2b6a57b891bead3"
uuid = "c5dd0088-6c3f-4803-b00e-f31a60c170fa"
version = "1.1.0"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "0adf069a2a490c47273727e029371b31d44b72b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.5"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsAPI", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "5cf6c4583533ee38639f73b880f35fc85f2941e0"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.7.3"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.StructArrays]]
deps = ["Adapt", "ConstructionBase", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "0a3db38e4cce3c54fe7a71f831cd7b6194a54213"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.16"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "34cc045dd0aaa59b8bbe86c644679bc57f1d5bd0"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.8"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.TupleTools]]
git-tree-sha1 = "155515ed4c4236db30049ac1495e2969cc06be9d"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.4.3"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "24b81b59bd35b3c42ab84fa589086e19be919916"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.11.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
"""

# ╔═╡ Cell order:
# ╠═a80a35ad-1286-459e-9efa-2e1100430cb4
# ╠═dd5017c0-c5b0-4149-8fad-2b7b616fe0ca
# ╟─013a1710-9853-49f1-822f-c2285d40fb69
# ╟─878e9d79-9234-4695-adc2-5fd2b8383bba
# ╟─09daf82e-b538-4638-b827-0c487e5cb57a
# ╟─a5fc4e03-6647-417b-b817-b7fbad12d3c5
# ╟─b11430bc-4397-4c3e-9b7f-9cf7a924b03e
# ╟─76d0bd9d-d3ec-4c3e-8e67-9294b68e9e4a
# ╟─182a7a5d-5078-4184-9a19-fa6a8e0d026d
# ╟─f3ac5f2c-69f5-4e48-8f7c-0eae182a3683
# ╟─9041e7f2-d104-448f-bec7-e48a5c79ac40
# ╟─d01b6583-183a-4637-8ac5-85dfe6aff7c3
# ╟─182b787b-ea4f-41a7-8ffc-92ec0fce1811
# ╟─825489d0-9d7e-4c12-a863-6522f5aa8e9f
# ╟─09ecfd41-664e-416f-8bff-a2fa53ce0fe3
# ╠═4e51edd6-4bb7-4aaa-b245-eb08babd9f36
# ╟─1bcc2ad1-bed7-4d43-8053-05dd25d70aed
# ╟─db1e972f-5113-4e21-9290-8903e07b7bbe
# ╟─ed4e8cc0-dc27-4bb9-bf29-64705a2d8004
# ╠═e7a468b9-7ce9-4350-9423-73a1f2cffc6e
# ╠═659660bc-0659-43b7-9ec2-a1a13d8643d3
# ╟─11b9d570-1260-498c-abcf-2e2ca6a79ef7
# ╟─d2e24c1a-ddba-4630-9150-2a68acda2325
# ╠═b87784b8-2355-4402-b9a9-f8d27c5efe34
# ╠═4b32f4e0-1dd0-4b46-8a27-3bcf199994fe
# ╠═02081620-ec0a-4200-8f85-38885a8e8672
# ╠═d50d683b-f452-4850-8b8c-bedea4ae0d04
# ╟─79e9b3c4-4fdf-4681-8827-0141338df7b2
# ╠═30393893-10dd-4913-a78b-5d2c6a521593
# ╠═c3cd9e41-aaf6-4720-b4f8-c8f9b8b0bd97
# ╠═9a26bac8-4d2a-4beb-ab11-adaa968ca648
# ╠═59ec4ea5-a32a-46f6-9487-5d08d343ce90
# ╠═50bf65da-8a0f-4974-bcee-2b609dd64395
# ╠═89505491-76e7-404d-9ef0-fec49e49783d
# ╠═c91e6758-65f2-4ea7-bb63-88c8e72c759b
# ╟─8dc43655-9864-497c-90ec-46eeab09949a
# ╠═dcc1ddc0-36ee-4be9-8761-b73686f4cf5d
# ╟─c273e1cf-ae5c-44db-b3e7-ac362e2a2700
# ╟─086ec222-740a-4d3c-b48c-412ac5cb26a5
# ╠═fb16b0e8-c4f8-472d-abcd-7a08c2cc0980
# ╠═a030e817-7634-43f3-ac1e-f91403163c25
# ╟─751ab302-fbf5-4fa2-a9a7-f616ffcca7c0
# ╠═29d99c5d-266c-4549-8154-0e3675038ab7
# ╠═dccbccd7-d62b-467f-9f0e-c6b3e9560577
# ╟─d5ac1f6f-2c33-468c-af97-143ba6fb7e8a
# ╠═2ca8b2ea-3446-4093-8717-f1bb37c64659
# ╟─2506ac1b-67e6-4277-b477-8502a3d1e26c
# ╟─6fcf7dec-a583-419a-875f-5eedc52ae462
# ╟─4c86c58f-7f6a-4e90-9152-a27dfbd4be94
# ╠═d960a054-b2db-421f-a1db-07a1f6ea4bd7
# ╠═839e62d4-733f-4281-82c1-ca0be9867da9
# ╟─9bd311b1-2eeb-49f9-a452-63e3e2898ad4
# ╠═22f98a6c-7ee0-4c07-a6b4-abbaeeb9aa78
# ╟─6223a9e6-7459-42ba-9020-9ce6a1e2c8dd
# ╠═30a3ce35-e5ba-4234-9f7d-356b692530c9
# ╟─5ad30622-c510-4ba6-a50b-2af30375bf17
# ╠═9da06881-bad0-480d-918c-a7668ebc9106
# ╟─728ea751-4342-4413-aa86-97d87214ccea
# ╟─a22617d3-f5ab-4bb3-befc-248ec2cc6ffe
# ╠═4ce9e829-815a-4aad-937d-86adccd89bf3
# ╠═9c64fdc7-86ee-4d53-bff8-02833a8aadbb
# ╠═2824df98-236e-41ad-bcc0-9cf934b8f498
# ╠═a9643ce7-0562-4a95-a52e-cf01bc4d33d1
# ╠═ff5505e3-2400-4686-b878-576275cc598f
# ╠═9bc7f8d9-0e20-4d84-8149-5e08640a8022
# ╟─8e97e93d-0444-43c1-9a33-90a7d7fcffb1
# ╠═3f29511c-6eed-424b-ace3-8c1c81c15a49
# ╟─15f2b1da-0898-48e0-a00a-33653a5cd349
# ╠═d2cda005-00ac-4f0c-bdbe-46cefbde4a78
# ╟─243119e0-fa1d-4451-bfd9-1fa74ca52e40
# ╠═cdc668e2-aa2d-43b6-8670-cee1e44bcb9e
# ╟─a218091d-2023-4bde-9d97-a42a562250e7
# ╠═baff2184-48db-4425-affb-fa7544b1500e
# ╟─f723486c-7dc2-4e26-aec9-3744bf39407a
# ╠═60fbcbaf-48bb-4119-b6d4-8c7884b8c18b
# ╟─47f86951-5874-4bbd-98e2-7e776b1be378
# ╠═ca1d28fd-19ca-460b-bc4b-2d256a342cee
# ╠═27c3facc-d031-4900-9888-c04feedd0490
# ╠═4649d58d-38a2-4a2f-ba39-2e7f29ae5eb1
# ╠═07392891-edeb-47ab-998c-8da4e6a889fe
# ╟─a94d1adf-1206-4b63-bc4f-9a53ea2d43e2
# ╠═c1d87c7e-d438-4ab6-9223-4a0d7cd6e80c
# ╠═c358b554-581c-42f5-abad-22093ece4325
# ╠═e84f8bb0-9d87-429c-893c-d913e9a8b215
# ╠═838f8871-7ebc-4865-b323-5617f944601a
# ╠═e72b730c-4623-4176-8012-597e91394df4
# ╠═146c7065-607c-48c8-9b23-870e222a77fd
# ╠═b345d1bd-987e-4044-943d-40778096fa12
# ╠═19f842ac-1aed-4510-a5a1-718c1e9916aa
# ╟─7c99a62c-965c-4e47-9007-289dfff8bbd8
# ╠═2372f2f8-6260-404c-b750-8f52fb7d99ac
# ╠═c9527fb0-f809-44c0-93ab-e1eda3c6bafa
# ╟─c8cac90a-a1c4-4fae-9074-fdc868f07c3e
# ╠═e52617bb-dc57-4b3b-b9f3-97376d48ae25
# ╟─72044f03-0623-4d2d-9310-ca0f05c6973d
# ╠═cf88ac19-cf88-4d49-9204-5741708e905c
# ╠═ae6d7246-5fbc-428b-bf22-50823a1c0ca5
# ╠═6deb8e15-9a52-4666-b502-1060756f0e87
# ╠═93c2798d-4c1a-4c80-bc95-8ee85028cf1a
# ╠═9cf8a7e6-4344-4d61-8baf-33cfbbeae853
# ╟─afaa9cf4-bf03-47e5-9190-fb8193262e00
# ╟─05486b6b-32c2-4bc7-a9fd-102a5242391a
# ╠═f577e6b8-3309-495e-99d0-c723e57976d7
# ╠═46c04480-e98d-4f5b-8ce1-4fcd200bbc99
# ╠═7a597644-3c16-4963-9156-093e1826bd63
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
