### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 7bb24acd-3c7c-48dc-b0fc-1484a26f6319
using Gadfly, PlutoUI, CSV, DataFrames, DataFramesMeta,CategoricalArrays,Box

# ╔═╡ cb57e090-a665-4071-bf63-9fa467f3d7f2
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 9fdc511f-b5ee-49c0-b695-4028f56134f1
TableOfContents(title = "目录")

# ╔═╡ 2d74fe70-5042-4647-a309-682bdf9e55a1
md"""
# 基本概念
这里主要介绍，Gadfly作图。Gadfly也是遵循图形语法的思路， 只是实现的方式与AlgebraOfGraphics.jl的稍有不同。

在AlgebraOfGraphics.jl中， 我们有 
- 数据层(data)， 这一层主要给定绘图的数据来源。

- 映射层(mapping)， 这一层主要是给定数据与图形属性之间的映射关系， 同时也可以给定一些数据的变换。

- 可视化层(visual)， 这一层的主要目的是设置图形的类型， 也是直观上看到的不同的图形类型，比如散点图、折线图等。

在Gadfly中， 也是类似的， 只是指定的方法稍有不同。在Gadfly中， 最核心的是一个函数：

```julia
plot(data::AbstractDataFrame, elements::Element...; mapping...)
```
其中， 
 - 第一个参数data是要绘制的**数据**（对应数据层,通常是dataframe或数组）
 - 第二个参数是一些“元素”， 主要是ScaleElement（尺度变换）、 CoordinateElement（坐标轴）、GeometryElement（几何元素，如散点、直线等，决定了图的种类）、GuideElement（辅助信息，比如坐标轴标题、图例标题等）、StatisticElement（统计变换，有些图形需要对原始数据做变换）；

 - 最后的关键字参数用于设置各种**图形属性**（如：颜色，形状，线型等）， 通常是用数据框中的**列**表示。
这就相当于实现了一种图形语言。因此， 下面的每一个绘图操作， 都可以尝试用语言来描述。

Gadfly的[**官方文档**](http://gadflyjl.org/stable/)有更多细节。如果想做出更漂亮、更定制化的图形， 可以参考。

"""

# ╔═╡ c41d0550-f9f4-4f4e-9751-7f652abf7ebb
# set_default_plot_size(22cm, 10cm)

# ╔═╡ 8d29dadf-5f4a-47c3-bc89-7e044f779b7e
plot(y = 1:10, Geom.bar, Guide.xlabel("x"))

# ╔═╡ d1359b56-5741-4739-b821-578032f22444
md"""
# 画图
"""

# ╔═╡ 3ea47b9f-f9b1-47b9-8a5d-6f383a6dfd89
md"""
## 画条形图
这个是一个变量分析， 通常分析离散型变量的频率。 画条形图， 默认情况下是在x的位置画出高度为y的条形，所以需要指定x和y。 条形的**几何元素是Geom.bar**。 由于没有专门的统计变换去得到频率， 所以我们需要先计算出来。
"""

# ╔═╡ 7c252276-9e9e-4fbd-abf0-c26a84e72f0f
edudata = @chain train begin
	groupby(:insured_education_level)
	@combine :count = length(:insured_education_level)
end

# ╔═╡ 0b2fa5f0-2b57-4cec-a401-ac6a9ddfe5a7
plot(edudata, Geom.bar, x = :insured_education_level, y=:count)

# ╔═╡ 8bfb1350-94b8-4c26-b2d3-2d97025e9fc1
md"""
### 换一种颜色
上面的颜色如果你不喜欢， 可以换一种颜色。 可以到**[这里](http://juliagraphics.github.io/Colors.jl/stable/namedcolors/)**找到颜色名字。然后构造一个特殊的变量向量[colorant"你要的颜色"],赋值给color字段。
"""

# ╔═╡ a7680952-c88d-4812-a0a5-e08aee1bbd65
plot(edudata, Geom.bar, x = :insured_education_level, y=:count , color = [colorant"red"])

# ╔═╡ 97c0925a-bbbc-4524-adbb-4bcdf12768d5
md"""
### 改变颜色
上面都是同一个颜色，而且没有图例，通常不是我们想要的图形。我们可以通过设置颜色实现不同的柱子不同颜色。
"""

# ╔═╡ d023de60-15c5-4f8a-8966-76a507555d19
plot(edudata, Geom.bar, x = :insured_education_level, y=:count , color = :insured_education_level)

# ╔═╡ 8f072a7f-1947-4695-8776-b37ca45e2573
md"""
!!! warn "知识点"
	上面两个地方指定颜色的方式是通过给color这个绘图属性赋予相应的值， 可以是某个字段， 也可以是一些整数。 那么它是怎么转换为颜色的呢？ 事实上， 每一个图形属性， 都有一个对应的**标度变换Scale**， 这个变换会将数据集中的对应的数据转换为相应图形属性的数据。 比如，对颜色而言， 由于这里是离散型变量， 会有一个Scale.discrete_color,将离散值（这里是7种学历水平）， 转换为一个调色板上的7个颜色。通常我们会有一个默认的调色板。 不过你可以修改为你喜欢的调色板。 

	事实上， 每一个图形属性都会有一个默认的标度变换。 他们大部分情况下不需要作图者去管， 当你需要对这个转换过程施加一定的修改的时候， 可能会用到。 比如， 你想将坐标轴转换为对数坐标轴的时候， 需要用到坐标轴的标度变换。
"""

# ╔═╡ a9f9ef67-8b94-4199-9713-dfb07e109940
md"""
### 改变间隙
如果想让柱子之间相隔的远一点， 这个是方便看图， 需要设置主题Theme 的bar_spacing 参数实现。主题通常是用来调整图形的整体显示的。当然， 很多主题可以设置的量也可以通过其他对象实现， 不过主题设置具有最高优先级。
"""

# ╔═╡ 22cdb6dd-5d2b-414f-a990-bb8baef37589
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, color = :insured_education_level, Theme(bar_spacing= 1mm))

# ╔═╡ 5b577567-14d6-4151-b812-26ba37f4f420
md"""
!!! warn "知识点"
	如果你不知道某个变量、函数可以做哪些设置， 只需要将光标停在相应的变量名后， 然后就可以在**Live Docs**中找到帮助文档， 建议你试一下Theme， 比如改变字号大小。
"""

# ╔═╡ 78c11589-29fc-4d62-94fe-b6c6ae04169b
md"""
### 改变柱子顺序
改变柱子顺序， 本质上是要将学历跟x坐标值得对应关系做一个改变。 比如， 目前是Masters、
JD、
High School、
MD、
PhD、
College、
Associate 的顺序排的（相当于x = 1:7）。要改变这一排列方式， 我们需要重新做学历到坐标的映射关系。也就是重新做x坐标轴的尺度映射， Scale.x_discrete（注意， 学历是离散型变量，所以用的是discrete）。 我们只需要重新指定这个尺度映射的水平levels即可。
"""

# ╔═╡ dd1d40b7-6c4c-4ab7-8d22-291976559cf5
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, 
	color = :insured_education_level,
	Theme(bar_spacing= 1mm),
	Scale.x_discrete( levels = ["High School",  "Associate", "College", "Masters", "JD", "MD", "PhD" ]) 
	)

# ╔═╡ 5c852a41-3eda-4036-986e-5f55f10cad54
md"""
### 改变柱子的标签
如果要改变标签， 这个还是要在Scale.x_discrete里面设置，只要指定labels就行， 这个是个函数， 相当于要将levels对应的标签映射到给定的标签。
"""

# ╔═╡ db39824e-c8b4-4880-92f4-84645219db1a
 label = Dict(["High School",  "Associate", "College", "Masters", "JD", "MD", "PhD" ] .=> ["高中", "中专","大学","研究生","法学博士","医学博士","哲学博士"])

# ╔═╡ 4980de18-22b8-470b-b75d-07cfb6f4cc94
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, 
	color = :insured_education_level,
	Theme(bar_spacing= 1mm),
	Scale.x_discrete( levels = ["High School",  "Associate", "College", "Masters", "JD", "MD", "PhD" ], labels = nm -> label[nm] ) 
	)

# ╔═╡ 193bf385-6982-4b2a-91a7-b64ad0a5d5d7
md"""
### 改变x、y轴，图例标题
像标题这种是方便读图存在的， 这些东西的改变可以通过设置**Guide**实现。
"""

# ╔═╡ a6f1b457-b9d0-4cec-8c00-1d4da0f6a246
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, 
	color = :insured_education_level,
	Theme(bar_spacing= 1mm),
	Scale.x_discrete( levels = ["High School",  "Associate", "College", "Masters", "JD", "MD", "PhD" ]),
	Guide.xlabel("学历水平"),
	Guide.ylabel("样本数量"),
	)

# ╔═╡ f165d236-7ff5-4746-9646-5e93ca7d135a
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, 
	color = :insured_education_level,
	Theme(bar_spacing= 1mm),
	Scale.x_discrete( levels = ["High School",  "Associate", "College", "Masters", "JD", "MD", "PhD" ]),
	Guide.xlabel("学历水平"),
	Guide.ylabel("样本数量"),
	Guide.ColorKey(title = "学历")
	)

# ╔═╡ 774d9f05-a576-439e-a0e9-39234db75456
md"""
### 改变文字朝向
上面x轴的标签文字是横排的， 有些重叠在了一起， 可以将其纵向排列。
"""

# ╔═╡ aeb74cf7-69d0-48a7-82d4-cfe1fceb1f92
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, 
	color = :insured_education_level,
	Theme(bar_spacing= 1mm),
	Scale.x_discrete( levels = ["High School",  "Associate", "College", "Masters", "JD", "MD", "PhD" ]),
	Guide.xlabel("学历水平"),
	Guide.ylabel("样本数量"),
	Guide.ColorKey(title = "学历"),
	Guide.xticks(orientation=:vertical)
	)

# ╔═╡ 80a25776-9e7b-4aca-b06c-3d69f778504e
plot(edudata, Geom.bar, x = :insured_education_level, y=:count, 
	color = :insured_education_level,
	Theme(bar_spacing= 1mm),
	Scale.x_discrete( levels = ["High School", "Masters", "JD", "MD", "PhD", "College", "Associate"] ),
	
	#Scale.x_discrete( levels = ["High School", "Masters", "JD", "MD", "PhD", "College", "Associate"] , lebels = ["高中","研究生", "法律博士", "医学博士", "哲学博士", "大学", "大专"]),
	# Guide.xticks(orientation=:vertical),
	#Guide.xticks(ticks=["JD","High School","MD","PhD","College","Associate"])
);

# ╔═╡ db437b28-1deb-4e8b-abc8-c14e228ffc71
md"""
## 画直方图
对单个连续变量， 我们通常会画条形图去查看其变量分布情况。 直方图的几何对象是Geom.histogram。 直方图有很多的参数可以设置， 大家可以自行探索。
"""

# ╔═╡ 2b094db5-e2b8-442d-8f68-7906ea0952c1
plot(train, x = :age, Geom.histogram)

# ╔═╡ b0dc9fec-4e39-4cd5-bef4-89f202bc7070
plot(train, x = :age, Geom.histogram(bincount = 15))

# ╔═╡ 98ce23a5-5afe-4536-a81a-0d5a459d1472
md"""
## 画密度曲线
密度曲线的几何对象是： Geom.density。
"""

# ╔═╡ 822c6d6e-90aa-4578-82c6-deaa404e8190
plot(train, x = :age, Geom.density)

# ╔═╡ 5751ac9f-c2a1-42dd-912b-aa5ca32afe05
md"""
如果想要同时画多条密度曲线， 可以将分类的变量传递给颜色属性。
"""

# ╔═╡ 4e4e5ba3-efed-4858-a68a-f2a6ffd483f9
plot(train, x = :age, color = :fraud, Geom.density)

# ╔═╡ adabceb0-ded1-4bae-a5f0-e75c7df85166
plot(train, x = :age, color = :fraud, Geom.density, Scale.discrete_color)

# ╔═╡ 7b459db6-5b44-44a9-9012-9a8520fd1391
md"""
!!! warn "注意"
	对比上面两幅图， 你会发现，在第一图中， 图例中颜色是一个范围。 这是因为， fraud是整数变量， 默认在做标度变换的时候， 会将其映射到一个范围中的颜色上去， 所以我们看到了一个颜色条。但事实上， fraud应该是一个分类变量。因此， 我们需要改变这种颜色的变换方式， 这可以通过设置， 离散颜色标度变换实现 Scale.discrete_color。
"""

# ╔═╡ acbf29cb-ddee-4838-86be-141f709e5672
md"""
## 画散点图
2个都是数值变量时， 这时候可以画散点图， 比如， 我们可以看一下，
policy\_annual\_premium 每年的保费,total\_claim\_amount 整体索赔金额 两个字段的散点图。 由于两个连续变量默认情况下就是画散点图， 我们甚至都不需要指定几何对象。
"""

# ╔═╡ a75e524f-0ce3-4745-b20e-358ef88878a1
plot(train, x = :total_claim_amount, y=:policy_annual_premium,  )

# ╔═╡ 71e53cef-06fe-4bda-b235-0b20e874d4da
md"""
在这种情形下，我们更多的是关注两个变量是否存在某种关系， 比如我们可以看一下:vehicle_claim,:total_claim_amount这两者之间是存在明显的相关关系的。 此时， 我们可以在这个图之上再增加拟合一条直线。 这可以通过一个对原始数据做一个线性拟合的统计变换得到。
"""

# ╔═╡ e317913e-584a-46a3-8ede-b21d5c3ed065
plot(train,  x = :vehicle_claim , y = :total_claim_amount, Geom.point,  )

# ╔═╡ 52f02582-742b-4d0c-b7a7-f787d78f3dbd
md"""
从上图可以明显的看得出来， 整体索赔和车辆索赔之间存在很强的线性关系。 这是符合预期的。 因为这里有一条明显的直线， 你可能很想把这个直线拟合出来，并画出来。 这是容易的。
"""

# ╔═╡ 0bc7f139-fdcf-4c45-bef7-1614281eceda
plot(train, x = :vehicle_claim , y = :total_claim_amount, 
	Geom.point, # 先画散点图
	layer(Stat.smooth(method=:lm),Geom.line, color = [colorant"red"]),# 再加一个图层
)

# ╔═╡ 615a767b-2094-4ee4-9da8-10c1bb16ef4c
md"""
!!! wran "知识"
	上面出现了一个新的知识点， 我们要在原先的散点图上增加一条拟合的直线。 这相当于增加**一个图层（layer）**。一个图层，有点类似于一幅图用plot画的图， 只是有些参数我们不能控制。一般一个图层会跟上一个图层使用相同的数据（如果没有指定的话）， 所以上面的图层用的还是plot中指定的数据， 但该图层先对原始数据（x,y）做了一个统计变换， Stat.smooth(method=:lm)， 也就是线性拟合（这个变换会生成新的x，y数据）。然后再以直线的方式展现拟合的x，y数据。
"""

# ╔═╡ ac74da48-22c9-4d54-a727-713fb7bdfad6
plot(train, x = :vehicle_claim , y = :total_claim_amount, Geom.point(), alpha = [0.1], layer(Stat.smooth(method=:lm, levels=[0.95, 0.99]), Geom.line, Geom.ribbon(fill=false), color = [colorant"red"]))

# ╔═╡ 244acc3b-e475-46bb-be3d-fe56f9971102
md"""
上面指定alpha是改变透明度。
"""

# ╔═╡ 37d0b96b-6cac-4f4d-9c35-49d369bf5e19
md"""
## 箱线图
这种情况下， 一种常见的分析就是了解不同类别下（分类变量）,数值变量的分布情况。 比如， 我们想了解不同性别的用户的年龄分布情况。 我们可以有boxplot(箱线图）, Violin（小提琴图）。本质上，可以看成是将类别变量视为分类变量， 将数据分组之后， 去给单个连续变量画图。

箱线图的几何元素是，Geom.boxplot， 小提琴图的几何元素是Geom.violin。
"""

# ╔═╡ f7f98db0-9681-479a-978a-d56fe97cdd64
plot(train, x = :insured_sex, y = :age, Geom.boxplot)

# ╔═╡ 0dceedf5-28d0-40a8-8595-6ca9327846ef
plot(train, x = :insured_sex, y = :age, Geom.violin)

# ╔═╡ 70ce0748-366b-455d-9b3b-1725b0f1a4cf
md"""
## 条形图拼接
有时候， 当我们需要分别按照某个变量统计两一个变量的频率时， 可能需要画这种图。
	
"""

# ╔═╡ 0fc7067c-da7e-4b5f-87ac-0edcca5643b5
res = @chain train begin
groupby([:insured_sex, :insured_education_level])
@combine :cnt= length(:policy_id)
end

# ╔═╡ cd9c58b8-5722-4718-9d32-80ee18f3b89a
plot(res, x = :insured_sex, y = :cnt, Geom.bar, color = :insured_education_level, Theme(bar_spacing = 5mm) )

# ╔═╡ beddc457-aba2-4d86-aebe-d07bd1d48a84
plot(res, x = :insured_sex, y = :cnt, Geom.bar(position=:dodge), color = :insured_education_level, Theme(bar_spacing = 5mm) )

# ╔═╡ da8e2ed9-5615-4bb3-bd16-71a6475a80dc


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Box = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CategoricalArrays = "324d7699-5711-5eae-9e2f-1d82baa6b597"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Gadfly = "c91e804a-d5a3-530f-b6f0-dfbca275c004"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Box = "~1.0.14"
CSV = "~0.10.9"
CategoricalArrays = "~0.10.7"
DataFrames = "~1.5.0"
DataFramesMeta = "~0.14.0"
Gadfly = "~1.3.4"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "e68b48fcded4a439de334f1a780890f8bc91d7e3"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "16b6dbc4cf7caee4e1e75c49485ec67b667098a0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cc37d689f599e8df4f464b2fa3870ff7db7492ef"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Box]]
deps = ["HypertextLiteral", "Markdown"]
git-tree-sha1 = "bee6dbf5fa690f991d4c3b018cbfbb206e59dc18"
uuid = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
version = "1.0.14"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "SnoopPrecompile", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "c700cce799b51c9045473de751e9319bdd1c6e94"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.9"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "5084cc1a28976dd1642c9f337b28a3cb03e0f7d2"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.7"

[[deps.Chain]]
git-tree-sha1 = "8c4920235f6c561e401dfe569beb8b924adad003"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.5.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "7a60c856b9fa189eb34f5f8a6f6b5529b7942957"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.Compose]]
deps = ["Base64", "Colors", "DataStructures", "Dates", "IterTools", "JSON", "LinearAlgebra", "Measures", "Printf", "Random", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "bf6570a34c850f99407b494757f5d7ad233a7257"
uuid = "a81c6b42-2e10-5240-aca2-a61377ecd94b"
version = "0.9.5"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CoupledFields]]
deps = ["LinearAlgebra", "Statistics", "StatsBase"]
git-tree-sha1 = "6c9671364c68c1158ac2524ac881536195b7e7bc"
uuid = "7ad07ef1-bdf2-5661-9d2b-286fd4296dac"
version = "0.2.0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "7f13b2f9fa5fc843a06596f1cc917ed1a3d6740b"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "49eba9ad9f7ead780bfb7ee319f962c811c6d3b2"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.8"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "13027f188d26206b9e7b863036f87d2f2e7d013a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.87"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "f9818144ce7c8c41edf5c4c179c684d92aa4d9fe"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.6.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "fc86b4fd3eff76c3ce4f5e96e2fdfa6282722885"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.0.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Gadfly]]
deps = ["Base64", "CategoricalArrays", "Colors", "Compose", "Contour", "CoupledFields", "DataAPI", "DataStructures", "Dates", "Distributions", "DocStringExtensions", "Hexagons", "IndirectArrays", "IterTools", "JSON", "Juno", "KernelDensity", "LinearAlgebra", "Loess", "Measures", "Printf", "REPL", "Random", "Requires", "Showoff", "Statistics"]
git-tree-sha1 = "13b402ae74c0558a83c02daa2f3314ddb2d515d3"
uuid = "c91e804a-d5a3-530f-b6f0-dfbca275c004"
version = "1.3.4"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Hexagons]]
deps = ["Test"]
git-tree-sha1 = "de4a6f9e7c4710ced6838ca906f81905f7385fd6"
uuid = "a1b4810d-1bce-5fbd-ac56-80944d57a21f"
version = "0.2.0"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "432b5b03176f8182bd6841fbfc42c718506a2d5f"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.15"

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
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0cb9352ef2e01574eeebdb102948a58740dcaf83"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2023.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "9816b296736292a80b9a3200eb7fbb57aaa3917a"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.5"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "46efcea75c890e5d820e670516dc156689851722"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.5.4"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

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
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "82d7c9e310fe55aa54996e6f7f94674e2a38fcb4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.9"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "67eae2738d63117a196f497d7db789821bce61d1"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.17"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "548793c7859e28ef026dba514752275ee871169f"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "6ec7ac8412e83d57e313393220879ede1740f9ee"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.8.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "77d3c4726515dca71f6d80fbb5e251088defe305"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.18"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "63e84b7fdf5021026d0f17f76af7c57772313d99"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.21"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

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

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "0b829474fed270a4b0ab07117dce9b9a2fa7581a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.12"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═7bb24acd-3c7c-48dc-b0fc-1484a26f6319
# ╠═cb57e090-a665-4071-bf63-9fa467f3d7f2
# ╠═9fdc511f-b5ee-49c0-b695-4028f56134f1
# ╟─2d74fe70-5042-4647-a309-682bdf9e55a1
# ╠═c41d0550-f9f4-4f4e-9751-7f652abf7ebb
# ╠═8d29dadf-5f4a-47c3-bc89-7e044f779b7e
# ╟─d1359b56-5741-4739-b821-578032f22444
# ╟─3ea47b9f-f9b1-47b9-8a5d-6f383a6dfd89
# ╠═7c252276-9e9e-4fbd-abf0-c26a84e72f0f
# ╠═0b2fa5f0-2b57-4cec-a401-ac6a9ddfe5a7
# ╟─8bfb1350-94b8-4c26-b2d3-2d97025e9fc1
# ╠═a7680952-c88d-4812-a0a5-e08aee1bbd65
# ╟─97c0925a-bbbc-4524-adbb-4bcdf12768d5
# ╠═d023de60-15c5-4f8a-8966-76a507555d19
# ╟─8f072a7f-1947-4695-8776-b37ca45e2573
# ╟─a9f9ef67-8b94-4199-9713-dfb07e109940
# ╠═22cdb6dd-5d2b-414f-a990-bb8baef37589
# ╟─5b577567-14d6-4151-b812-26ba37f4f420
# ╟─78c11589-29fc-4d62-94fe-b6c6ae04169b
# ╠═dd1d40b7-6c4c-4ab7-8d22-291976559cf5
# ╟─5c852a41-3eda-4036-986e-5f55f10cad54
# ╠═db39824e-c8b4-4880-92f4-84645219db1a
# ╠═4980de18-22b8-470b-b75d-07cfb6f4cc94
# ╟─193bf385-6982-4b2a-91a7-b64ad0a5d5d7
# ╠═a6f1b457-b9d0-4cec-8c00-1d4da0f6a246
# ╠═f165d236-7ff5-4746-9646-5e93ca7d135a
# ╟─774d9f05-a576-439e-a0e9-39234db75456
# ╠═aeb74cf7-69d0-48a7-82d4-cfe1fceb1f92
# ╟─80a25776-9e7b-4aca-b06c-3d69f778504e
# ╟─db437b28-1deb-4e8b-abc8-c14e228ffc71
# ╠═2b094db5-e2b8-442d-8f68-7906ea0952c1
# ╠═b0dc9fec-4e39-4cd5-bef4-89f202bc7070
# ╟─98ce23a5-5afe-4536-a81a-0d5a459d1472
# ╠═822c6d6e-90aa-4578-82c6-deaa404e8190
# ╟─5751ac9f-c2a1-42dd-912b-aa5ca32afe05
# ╠═4e4e5ba3-efed-4858-a68a-f2a6ffd483f9
# ╠═adabceb0-ded1-4bae-a5f0-e75c7df85166
# ╟─7b459db6-5b44-44a9-9012-9a8520fd1391
# ╟─acbf29cb-ddee-4838-86be-141f709e5672
# ╠═a75e524f-0ce3-4745-b20e-358ef88878a1
# ╟─71e53cef-06fe-4bda-b235-0b20e874d4da
# ╠═e317913e-584a-46a3-8ede-b21d5c3ed065
# ╟─52f02582-742b-4d0c-b7a7-f787d78f3dbd
# ╠═0bc7f139-fdcf-4c45-bef7-1614281eceda
# ╟─615a767b-2094-4ee4-9da8-10c1bb16ef4c
# ╠═ac74da48-22c9-4d54-a727-713fb7bdfad6
# ╟─244acc3b-e475-46bb-be3d-fe56f9971102
# ╟─37d0b96b-6cac-4f4d-9c35-49d369bf5e19
# ╠═f7f98db0-9681-479a-978a-d56fe97cdd64
# ╠═0dceedf5-28d0-40a8-8595-6ca9327846ef
# ╟─70ce0748-366b-455d-9b3b-1725b0f1a4cf
# ╠═0fc7067c-da7e-4b5f-87ac-0edcca5643b5
# ╠═cd9c58b8-5722-4718-9d32-80ee18f3b89a
# ╠═beddc457-aba2-4d86-aebe-d07bd1d48a84
# ╠═da8e2ed9-5615-4bb3-bd16-71a6475a80dc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
