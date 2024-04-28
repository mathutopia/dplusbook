### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 1a10c180-c327-11ed-223b-1183f5350f3b
using PlutoUI, CSV, DataFrames, DataFramesMeta,CairoMakie,StatsBase,CategoricalArrays, AlgebraOfGraphics,Box

# ╔═╡ d89b23a1-c58f-49bb-9cc1-4134176b7e3d
TableOfContents(title = "目录")

# ╔═╡ 5606dee2-1714-4865-bf9a-2ce2f992fa01
md"""

本实验通过以天池数据挖掘比赛-[保险反欺诈预测](https://tianchi.aliyun.com/competition/entrance/531994/information)的训练数据为例，完成对数据可视化分析的基本实验。
"""

# ╔═╡ ed3df13a-3622-47ff-92e4-2c0a1f256c14
md"""
# 数据可视化-AlgebraOfGraphics
## 数据读取

"""

# ╔═╡ b264515e-7230-42cc-81a0-a2be0977362b
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ fc284c77-979c-445e-89b5-5ef58fa25bc6
md"""
### 数据字段描述
字段	说明

- policy_id	保险编号
- age	年龄
- customer\_months	成为客户的时长，以月为单位
- policy\_bind\_date	保险绑定日期
- policy\_state	上保险所在地区
- policy\_csl	组合单一限制Combined Single Limit
- policy\_deductable	保险扣除额
- policy\_annual_premium	每年的保费
- umbrella\_limit	保险责任上限
- insured\_zip	被保人邮编
- insured\_sex	被保人姓名：FEMALE或者MALE
- insured\_education_level	被保人学历
- insured\_occupation	被保人职业
- insured\_hobbies	被保人兴趣爱好
- insured\_relationship	被保人关系
- capital\-gains	资本收益
- capital\-loss	资本损失
- incident\_date	出险日期
- incident\_type	出险类型
- collision\_type	碰撞类型
- incident\_severity	事故严重程度
- authorities\_contacted	联系了当地的哪个机构
- incident\_state	出事所在的省份，已脱敏
- incident\_city	出事所在的城市，已脱敏
- incident\_hour_of_the_day	出事所在的小时（一天24小时的哪个时间）
- number\_of_vehicles_involved	涉及的车辆数
- property\_damage	是否有财产损失
- bodily\_injuries	身体伤害
- witnesses	目击证人
- police\_report\_available	是否有警察记录的报告
- total\_claim_amount	整体索赔金额
- injury\_claim	伤害索赔金额
- property\_claim	财产索赔金额
- vehicle\_claim	汽车索赔金额
- auto\_make	汽车品牌，比如Audi, BMW, Toyota, Volkswagen
- auto\_model	汽车型号，比如A3,X5,Camry,Passat等
- auto\_year	汽车购买的年份
- fraud	是否欺诈，1或者0
"""

# ╔═╡ b2107628-bb7b-4fdf-9a3b-7920b8eebfbe
md"""
## 数据类型分析
"""

# ╔═╡ 9c6d4886-66c1-485d-8f26-d59af544d2e8
describe(train)

# ╔═╡ fe82e4cb-238d-42dc-8f08-04cacaeabf8b
md"""
从上面可以看的出来， 大部分的数据是整数（Int64）或者字符串（String）的形式。一般而言， 如果是整数， 可能有两种内涵： 表示一个类别变量（比如，：fraud）， 或者表示一个数值型变量（如保费，:policy\_annual\_premium）。因此， 大家在做分析和画图的过程中，一定要先明确你的数据是什么类型的。

对于字符串形式的变量， 一般会将字符串默认解读为类别变量， 即不同的字符串表示不同的类别（比如：性别 :insured\_sex）。不过，有时候类别变量能取得值可能很多， 其实也不方便去分析， 比如 :auto\_model， 就有39种之多。

一般情况下， 在后续的处理中， 会默认将文本类型转换为类别类型（CategoricalArry）, 然后将其视为类别变量处理。 如果是整数类型， 或者浮点数类型， 会将其视为数值类型（nummeric）处理。 这种默认的转换方式可能会造成一些问题， 这就需要我们在分析之前，先将数据做好恰当的类型转换， 然后再去分析。 

比如目击者数量witnesses， 虽然这是一个数值类型。但其可能的取值其实并不多， 我们可能将其视为类别变量更好。又比如，：fraud列， 它的含义本身就是类别， 但确读取为整型了。

此外， 虽然数值类型我们可以直接分析， 但有时候， 我们从数值类型构造一个类别变量可能会有不一样的分析结果。 下面介绍这些操作如何实现。

"""

# ╔═╡ 34216185-e0af-4329-8c30-e4f1138a6b26
md"""
## 生成类别变量
有时候我们需要将数据转化为类别变量（类似R中的因子）， 这方便我们做一些统计分析。 类别变量在Julia中用CategoricalArray表示。

主要掌握下面几个函数：
 - categorical： 将向量转为类别数组
 - levels/levels!： 查看/修改类别数组的可能取值及顺序
 - unwrap : 重新获取原始数据
"""

# ╔═╡ 8f1873f8-2272-4344-a858-d3779fb44795
data1 = @select train :witnesses = categorical(train.witnesses)

# ╔═╡ 815f23d4-1f25-4b5c-b97a-a2154d026b95
levels(data1.witnesses) # 显然，目击者在数据集里面最多只有4人。

# ╔═╡ 1e397e6a-0007-44bf-8282-f72ad7d514dc
data1.witnesses[1]

# ╔═╡ 96428119-e77a-451e-bc98-134a855bfe87
unwrap(data1.witnesses[1])

# ╔═╡ 33924413-490c-4a11-b004-c58f83c5086c
md"""
## 类别编码
如果本身是类别变量，但错误的被读取为数值类型， 我们可以将其重新编码。使用的函数是`recode`, 其基本的用法是：

```julia
recode(a::AbstractArray[, default::Any], pairs::Pair...)
```

其中， pair是 `a => b`的形式。

用replace也是可以的， 这个函数大家自己了解。
"""

# ╔═╡ fa7f56e4-fa4a-4f62-8304-f3ceda20c453
@select train :fraudn = recode(:fraud, 0 => "非欺诈", 1 => "欺诈")

# ╔═╡ b344b516-4f6a-4af4-9cf7-ae0c6d7abb7f
#当然，可以直接将其转换为一个类别变量
@select train :fraud = categorical(:fraud)

# ╔═╡ ae603dc7-a957-49b5-bdfc-9e94d522d909
md"""
## 连续值离散化
有时候， 我们希望将数值泛化为一个类别变量， 这可以用`cut`函数实现, 其使用方法如下：

```julia
cut(x::AbstractArray, breaks::AbstractVector;
    labels::Union{AbstractVector,Function},
    extend::Union{Bool,Missing}=false, allowempty::Bool=false)

cut(x::AbstractArray, ngroups::Integer;
    labels::Union{AbstractVector{<:AbstractString},Function},
    allowempty::Bool=false)
```

简单来说， 在对一个数据进行划分时， 我们可以指定区间（breaks）， 也可以直接指定要划分的类别（ngroups）的数量， 于此同时， 我们可以指定每一个类别的标签(labels)。

下面我们将年龄:age, 划分为老中青三个类别：
"""

# ╔═╡ 9b23ac6c-d113-4bdc-9fe4-fdd708f64d7c
tmp = cut(train.age, 3)

# ╔═╡ 31558248-bf16-4b4e-b99e-e2b47a7a4d2a
levels(tmp)

# ╔═╡ 223548b7-46d6-4cdb-ba7c-03738d1a905d
countmap(tmp)

# ╔═╡ e99df1f7-ba2e-432e-8376-9f2d1d947654
md"""
从上面的结果可以看的出来， 年龄的区间被以33岁和42岁为划分点(breaks)划分为了三个区间, 并可以看到不同区间的样本数量。

上面的划分区间是通过样本估计自动生成的。 有时候， 这种划分点可能不太合理， 我们可以根据自己对数据的理解去选择划分的区间。 同时， 指定一下不同区间的标签看看效果。 
"""

# ╔═╡ d9e777dc-d141-4d93-8286-97adb27e2b95
tmp2 = cut(train.age, [0,40,60,100],  labels = ["青","中","老"])

# ╔═╡ fbc45f88-81fe-4655-aa03-0f345c3ba4f0
countmap(tmp2)

# ╔═╡ 8ed3879a-4552-4600-89d5-30250d0c5387
md"""
从上面的统计结果来看， 这种划分方式会导致数据的分布不均衡， 对建模来说， 可能不是一个好事。但我们主要在于演示cut的使用，所以也就没管那么多了。
"""

# ╔═╡ e90cb70d-091a-487f-a2d5-929ceba5a786
md"""
!!! warning "⚡ 注意"
	- 前两个参数是位置单数， 所以只要给值就好；但后面的参数是关键字参数， 需要给出参数名字。
	- 第一种调用方式中breaks指定的范围需要涵盖所有可能的取值， breaks的数量会比区间多一个
	- 区间通常是以左开右闭的形式[left, right）表示， 最右边会有例外。
   
"""

# ╔═╡ a43a8d6f-f63e-47bf-8615-ad80c8a50df6
md"""
# 画图
## 基本概念
这里主要介绍AlgebraOfGraphics.jl的绘图方法， 这是一个以Makie.jl为后端的绘图包。
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
指定数据源时， 一般是dataframe。

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

# ╔═╡ 460e0884-ca42-4e75-a131-c8f2a46daa70
@chain train begin
  @combine :mcs = mean(:"capital-loss" ) :maxs = maximum(:"capital-loss")
end

# ╔═╡ b7d1e6cb-b8f9-4f76-b2b9-063a8e14b46f
[x for x in names(train) if contains(x, "sex") ]

# ╔═╡ 7073165e-4246-494d-bf6b-1ce84a72224f
contains

# ╔═╡ 54d5c406-44ef-46f9-aab6-04ba6e820777
md"""
## 写在画图之前
在画图分析时， 我们首先要搞清楚， 你分析的目标是什么， 然后根据你的分析目标去确定要用什么类别的图形，做什么属性映射。

在这里， 我将分析目标按要分析的变量的个数来分类， 分别分为， 1个变量分析，2个变量分析和多个变量分析（3个及以上）。 对每个类别， 我们还需要考虑变量的属性是类别变量？还是数值变量。
"""

# ╔═╡ 803b65f7-3e8b-456b-b110-5cb92090a145
md"""
## 1个变量分析
### 1. 分类变量
分析一个分类变量， 通常情况下是计算频率， 画出频率直方图。
比如，我们要分析学历的分布情况,即字段insured\_education\_level。 

由于我们的原始数据中没有包含这个字段的频率信息， 一种首先想到的方案是， 我们可以先将频率信息计算出来， 然后再画图。
"""

# ╔═╡ 8ef34ef1-2c48-49a7-99a0-b9ea30b67745
edudata = @chain train begin
	groupby(:insured_education_level)
	@combine :count = length(:insured_education_level)
end

# ╔═╡ deef0e79-91dd-4633-a9a0-c7b3575045d0
data(edudata) * mapping(:count) * visual(BarPlot) |> draw

# ╔═╡ 0e8004d2-64ca-4b09-9c0b-cc3350995001
md"""
上面这种方式当然是OK的， 但计算频率这种事情， 对每个离散变量的分析可能都需要， 这时， 我们可以用到画图包中给我们已经实现的统计变换。

一个统计变换是基于原始数据，经过统计计算之后得到的一份新数据， 然后这个变换默认情况下会绑定某种可视化图形。所以，如果你的画图里面已经有统计变换了， 那么不指定绘图类型也是可以的。 

由于频率统计的默认展示方式就是条形图， 下面两行代码结果是一样的。
"""

# ╔═╡ d0198bde-110b-4102-8a02-2cefaf443e64
data(train) * mapping(:insured_education_level) * frequency() * visual(BarPlot) |> draw

# ╔═╡ cfbcfa14-c20c-4bb9-83a5-d1cd964a3d05
data(train) * mapping(:insured_education_level) * frequency() |> draw

# ╔═╡ 3c8eb473-4493-4645-adc5-565af6066756
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

# ╔═╡ 9219d869-59e5-4d88-afdd-ab664cf054df
data(train) * mapping(:insured_education_level) * frequency() * visual(BarPlot, color = :blue, bar_labels = :x) |> draw

# ╔═╡ bfd83d38-5de1-4fb2-951f-ef4d089b3f6c
md"""
### 练习
试画出性别分布的条形图。
"""

# ╔═╡ f47c4c12-9652-4609-880b-dfa9a6a24222
md"""
### 2 一个数值变量
一个数值变量一般可能的取值有无穷多。这时候， 可以画直方图（Hist）或者密度图(Density)来了解数值的分布情况。下面以年龄为例做简单分析。
"""

# ╔═╡ 0d5ba460-d092-47eb-993f-afa6ce465cd9
data(train) * mapping(:age) * visual(Hist) |> draw

# ╔═╡ 934307dc-0b90-4a3f-9698-4f878f936a09
data(train) * mapping(:age) * visual(Density) |> draw

# ╔═╡ 47ce0189-6c0e-4804-9fc2-24b223eb2547
md"""
### 练习
试画出保费:policy\_annual\_premium的分布直方图和密度图
"""

# ╔═╡ e39fbd0d-63a5-4df1-aa88-62c3977c2fdf
#data(train) * mapping(:policy_annual_premium) * visual(Density, color = (:red, 0.3)) |> draw

# ╔═╡ e0435d39-be94-4bda-8538-74bac034c8d2
md"""
## 2个变量
2个变量的分析可以有多种情况， 

### 2个都是数值变量
即两个变量的取值可能都是无穷多， 这时候可以画散点图， 比如， 我们可以看一下，
policy\_annual\_premium 每年的保费,total\_claim\_amount 整体索赔金额 两个字段的散点图。
"""

# ╔═╡ 505b931d-bcfd-4299-a344-1e8f83ce7f28
data(train) * mapping(:total_claim_amount,:policy_annual_premium) * visual(Scatter) |> draw

# ╔═╡ 3fbe27f7-7979-4c8b-ba80-b2fbb6bd3029
md"""
从上面的图形可以看出， 有一部分用户有交保费， 但索赔很少。而另一部分用户， 保费金额与索赔金额之间存在一定的线性关系。上面图形中的x，y轴的坐标时自动生成的。你可能不喜欢这个名字， 需要做一定的修改。这可以在mapping中实现。
"""

# ╔═╡ 7aff1fc4-0b06-4157-8f8d-81a4fb22791b
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费) * visual(Scatter) |> draw

# ╔═╡ 42cb702e-a962-4240-9872-8a1b9a902b24
md"""
上面演示了在mapping中指定坐标映射的同时，实现对变量的重命名。事实上， mapping中还可以有三种操作方法，分别有不同含义。
```julia
:column_name => "新的名字":  重命名

:column_name => function(): 对列进行处理（计算）， 但不重命名.

：column_name => function() => "新的名字": 对数据进行操作的同时， 进行重命名。
```

"""

# ╔═╡ c6826574-d5e9-4b56-8622-0bae5c2cc3bf
md"""
!!! tip "💡 提 示"
	上面对列的操作函数要么是没有参数的函数， 这时不需要加括号， 比如  :col => mean； 要么如果有参数， 需要是匿名函数，比如 col => (x -> round(x; digits=2)). 
"""

# ╔═╡ e79c7097-ed22-4050-a4dc-6dec971494e2
fig1 = data(train) * mapping(:total_claim_amount,:policy_annual_premium) * visual(Scatter) ;

# ╔═╡ 01f9c7f7-0ea1-408e-976c-b91c9840644c
fig2 = mapping([2.5*10^4,1.0*10^5] ) * visual(VLines);

# ╔═╡ 01d78cec-fb9d-4087-ac4c-abec2c1a2fa6
fig1 + fig2 |> draw;

# ╔═╡ 3dd8e165-dead-47a6-8a6c-c7eea48dae52
data(train) * mapping(:total_claim_amount,:policy_annual_premium, color = :fraud =>nonnumeric) * visual(Scatter) |> draw;

# ╔═╡ 89afe7c7-3a8a-4046-8b33-600c78a16ae5
data(train) * mapping(:total_claim_amount,:policy_annual_premium) * AlgebraOfGraphics.density()|> draw;

# ╔═╡ c51f6d69-ca01-4559-898d-58d99bebf1d9
data(train) * mapping(:total_claim_amount,:policy_annual_premium) * AlgebraOfGraphics.density() * visual(Contour) |> draw;

# ╔═╡ f3aefb90-2c31-4061-b2e4-8025f3bf08f4
md"""
在这种情形下，我们更多的是关注两个变量是否存在某种关系， 比如我们可以看一下:vehicle\_claim,:total\_claim\_amount这两者之间是存在明显的相关关系的。 此时， 我们可以在这个图之上再增加拟合一条直线。
"""

# ╔═╡ 5df505a0-7a0a-48b3-852a-fdf627587ff3
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * visual(Scatter) |> draw

# ╔═╡ c163f3f9-54f1-4e2e-9a5b-10b5f3584aab
md"""
从上图可以明显的看得出来， 整体索赔和车辆索赔之间存在很强的线性关系。 这是符合预期的。 因为这里有一条明显的直线， 你可能很想把这个直线拟合出来，并画出来。 这是容易的。 AoG。jl包中提供了一个统计变换linear()， 对数据做这个变换可以获得一个拟合的直线， 然后可以把这个直线画出来。
"""

# ╔═╡ a581a643-ba4f-43c1-90d5-5c762babc5ec
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * linear() |> draw

# ╔═╡ 4585e2aa-cd3e-4281-ae83-7b68531f1f46
md"""
直线虽然画出来了， 但点不见了。能不能把两幅图叠加到一起呢？ 答案是可以的， 用 + 运算即可。
"""

# ╔═╡ b55f500e-a075-4d34-9a7b-1c6f7d3b90e2
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * linear() + data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * visual(Scatter) |> draw

# ╔═╡ 5608748a-b493-4a74-8b57-bf2c2cf65ce9
md"""
当然，上面的写法有很多重复信息。 我们可以对乘法和加法提取同类项。
"""

# ╔═╡ 9b7b1f80-e888-464d-ad37-f1601c958b2d
data(train) * mapping(:vehicle_claim => "车辆索赔",:total_claim_amount => "整体索赔") * (linear() +  visual(Scatter) )|> draw

# ╔═╡ 2ba13415-30bf-469d-b4cc-4579b1370c9c
md"""
当然， 那个直线是黑色的，你很有可能不喜欢。如果要改变直线的颜色， 不能在linear中， 必须要给其加上一层visual。
"""

# ╔═╡ f33b0901-fdce-489a-aef8-1096cae25e23
data(train) * mapping(:vehicle_claim,:total_claim_amount) * (visual(Scatter) + linear()*visual(color = :red)) |> draw

# ╔═╡ d173ae80-dd6b-4671-a1fa-f6ef9434517a
md"""
### 一个数值变量一个分类变量
这种情况下， 一种常见的分析就是了解不同类别下（分类变量）,数值变量的分布情况。 比如， 我们想了解不同性别的用户的年龄分布情况。 我们可以有boxplot(箱线图）, Violin（小提琴图）。本质上，可以看成是将类别变量视为分类变量， 将数据分组之后， 去给单个连续变量画图。
"""

# ╔═╡ 75525914-d4f6-4b3a-968b-f5ea908dc9f8
data(train) * mapping(:insured_sex,:age) * visual(BoxPlot) |> draw

# ╔═╡ e6555520-665c-40af-a6fb-f71f5903109c
data(train) * mapping(:insured_sex,:age) * visual(Violin)  |> draw

# ╔═╡ c53e80e4-9544-4eec-93cf-2cc6bbf8d5ca
md"""
上面两种情况， 展示的都是不同类别下， 数值变量的分布信息， 有时候， 我们可能需要的是不同类别下， 数值变量的均值（期望）信息。 这可以通过统计变换expectation实现。
"""

# ╔═╡ d791dee7-8307-43f0-b211-60464a31be1c
data(train) * mapping(:insured_sex,:age) * expectation() * visual(BarPlot) |> draw

# ╔═╡ 07e1fe1b-b829-44b0-a579-4928405a8c63
md"""
### 2个分类变量
如果两个都是分类变量， 这种情况可能更适合做列联表分析。可以参考Freqtable.jl的frequtable.

如果硬要画图， 无非是用条形图展示一个类别变量下，另一个类别的计数信息。 这个可以实现， 但如果我们同时指定两个变量分别为x，y， 效果会很差（另一个的计数信息无法区分）。必须要将其中一个映射到一个图形属性上去， 比如，另一个维度用颜色表示。 而且， 还必须要指定条形之间要stack或者doggle， 否则， 很有可能条形之间会重叠覆盖。

比如， 我们想要分析性别跟学历行为之间的关系。
"""

# ╔═╡ 58f16371-cc3c-447b-b40b-51c4403736ef
data(train)* # 准备数据
mapping(:insured_sex, :insured_education_level ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 273bfd81-7913-494c-a01c-ef398abfd694
md"""
下面这个图， 我们将两一个变量的情况用颜色表示， 不过你可能会发现， 这里面似乎没有Associate， 是什么原因?
"""

# ╔═╡ e8e8f4ff-7d9a-4a27-8915-96b1d3a71950
data(train)* # 准备数据
mapping(:insured_sex, color = :insured_education_level) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 13ca0e00-2dd1-4504-9e7e-3786740b12d2
data(train)* # 准备数据
mapping(:insured_sex, color = :insured_education_level, stack = :insured_education_level ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 1a458cec-3e9c-4da5-bf81-f69abb49338c
md"""
stack表示的是我们的“条形”是堆叠(stack)起来的， 有时候，我们希望把他们放在一起， 稍微隔开一点就行， 这可以通过设置doggle实现。
"""

# ╔═╡ c9275ff0-7de9-4f8c-a8fc-402dcc6fcee6
data(train)* # 准备数据
mapping(:insured_sex, color = :insured_education_level, dodge = :insured_education_level ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ cdf3558e-903b-4c7e-8599-f915a19a523c
md"""
是否欺诈才是我们更加关注的， 下面我们用同样的方法简单分析一下， 欺诈跟性别的关系。
"""

# ╔═╡ 1e60fe11-bac8-4bc4-8aa7-f2897c9e7b5e
data(train)* # 准备数据
mapping(:insured_sex, color = :fraud, stack = :fraud ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ d65f1554-57ee-4c45-a8ec-b5e7037d9d23
md"""
😭上面的代码出错了， 你很有可能手足无措， 不知道该怎么办。 事实上， 如果你仔细看看出错信息， 这里涉及到一个颜色关键词(color)。没错， 就是颜色设置出了问题。 本来我们不同类别用不同颜色表示就好了， 然后，我们用：fraud的类别来表示不同的颜色本来是没错的。 问题就出在， fraud不是一个类别变量。 因此， 我们需要对其做转化。

可以有以下两种处理方案， 

1、 我们可以将fraud 先转换为类别变量， 这可以通过将其重新编码实现。
"""

# ╔═╡ d62b9206-b887-4aaa-b777-56e6d29adec5
data(
	@transform train :fraud = recode(:fraud, 0=>"非欺诈", 1=>"欺诈")
) * # 准备数据
mapping(:insured_sex, color = :fraud, stack = :fraud ) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw # 把图画出来

# ╔═╡ 69f965ed-0e73-4f3d-9561-495bdad7ec51
md"""
当然， 我们也可以在映射的时候通过nonnumeric函数告诉后端， fraud不是数值变量。
"""

# ╔═╡ 995e9df4-0c1b-4645-a421-86e37a9d714b
data(train)* # 准备数据
mapping(:insured_sex, color = :fraud => nonnumeric, stack = :fraud => nonnumeric) * # 准备映射
frequency() * # 选择统计变换
visual(BarPlot) |> # 准备图形类型
draw

# ╔═╡ 43d17b7e-5bd1-4be1-a1e5-15cb16bdea99
md"""
## 3个以上变量的分析
如果要同时画出三个以上的变量， 这时候可以是三维图（比较少见）。或者，更多的是增加的变量是类别变量， 然后可以将变量映射给不同的图形属性， 从而实现展示不同属性下数据变化的情况。这有点在做统计分析时做分类汇总的味道， 只是现在是分类绘图。

换句话说， 如果我们不增加图形的空间维度（只有x,y两个空间维度）， 那就只能用图形的属性去表示多出来的维度信息。

这里， 常见的图形属性包括： 颜色（color）， 标记（marker）， 布局等。前面提到的mapping的关键字参数都是用来干这个的。下面演示几种情形。
"""

# ╔═╡ a3798c93-7d0a-4a0c-9990-c642a6d576be
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费, marker = :fraud => nonnumeric) * visual(Scatter) |> draw

# ╔═╡ 9d3cc8e3-0bce-409f-b029-b88b29fb6a5c
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费, color = :fraud => nonnumeric, marker = :insured_education_level =>"学历" ) * visual(Scatter) |> draw

# ╔═╡ 531dcd4f-fc0b-4007-849b-646fdf436a48
data(train) * mapping(:total_claim_amount => :整体索赔,:policy_annual_premium => :保费, color = :fraud => nonnumeric, row =  :insured_education_level =>"学历" ) * visual(Scatter) |> draw

# ╔═╡ a83ffdbd-35eb-4fcf-8a27-f24413891b79
data(train) * mapping(:fraud => nonnumeric, :age ) * visual(BoxPlot) |> draw

# ╔═╡ 079ecd34-5551-46cb-b783-6f332225e4a4
data(train) * mapping(:age,color = :fraud => nonnumeric, row =  :insured_sex =>"学历") * visual(Density,alpha = 0.3) |> draw

# ╔═╡ a5d15ca5-6031-4eba-8e3b-19a5dd6ea4e3
md"""
你很有可能会觉得， 上面的图形太简陋了， 你可能想增加更丰富的信息上去， 这可以通过映射关系去添加更多的信息， 当然，你也可以修改图形的一些展示属性。

比如， 你可能希望， 条形图里面还能用不同的颜色去展示涉及欺诈的不同的样本的数量。 这时候， 你可以在映射层，将：fraud字段绑定到图形的颜色上去，  color = :fraud。 但有一个问题， 在数据集里面， fraud是整数， AlgebraOfGraphics会将其当成一个连续属性， 这时没办法将其不同的取值分配不同的颜色。 我们需要做的是将：fraud列转换为一个分类变量， 这可以通过将数字重新编码(recode）为文本实现。
"""

# ╔═╡ 44b63870-1dbd-4742-8b20-280d4008e901
md"""
可以看的出来， 上面按颜色区分不同类别的主子是以堆叠的方式呈现的。我们可以可以将其改为并排形式。这只要设置dodge参数即可。
"""

# ╔═╡ cf22a0eb-04fb-43f0-bbd7-4a0845855047
md"""
# 画图保存
有时候， 你可能想将画好的图形保存为一个图片文件。 这个很简单， 只要把draw的结果用save保存下来即可。

```julia
save("my_image.png", draw(plt); px_per_unit=3)
```
将前面准备好的图在传入draw之前先保存， 然后将其传入draw，并嵌入save。
"""

# ╔═╡ 3e1d2f5c-9b36-44c7-9637-6c92050625d7
plt = data(train) * mapping(:injury_claim , :property_claim, color = :fraud => nonnumeric)

# ╔═╡ 4116eb6b-1e88-4014-bccf-a32a31808316
save("../data/my_image.png", draw(plt); px_per_unit=3)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AlgebraOfGraphics = "cbdf2221-f076-402e-a563-3d30da359d67"
Box = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
CategoricalArrays = "324d7699-5711-5eae-9e2f-1d82baa6b597"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
AlgebraOfGraphics = "~0.6.14"
Box = "~1.0.14"
CSV = "~0.10.9"
CairoMakie = "~0.10.2"
CategoricalArrays = "~0.10.7"
DataFrames = "~1.5.0"
DataFramesMeta = "~0.13.0"
PlutoUI = "~0.7.50"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "7359093aa4e73d94fac657dc47b4b3686ab965aa"

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
git-tree-sha1 = "222ee9e50b98f51b5d78feb93dd928880df35f06"
uuid = "398f06c4-4d28-53ec-89ca-5b2656b7603d"
version = "0.3.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "297b6b41b66ac7cbbebb4a740844310db9fd7b8c"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.1"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AlgebraOfGraphics]]
deps = ["Colors", "Dates", "Dictionaries", "FileIO", "GLM", "GeoInterface", "GeometryBasics", "GridLayoutBase", "KernelDensity", "Loess", "Makie", "PlotUtils", "PooledArrays", "PrecompileTools", "RelocatableFolders", "StatsBase", "StructArrays", "Tables"]
git-tree-sha1 = "c58b2c0f1161b8a2e79dcb1a0ec4b639c2406f15"
uuid = "cbdf2221-f076-402e-a563-3d30da359d67"
version = "0.6.16"

[[deps.AliasTables]]
deps = ["Random"]
git-tree-sha1 = "ca95b2220ef440817963baa71525a8f2f4ae7f8f"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.0.0"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "133a240faec6e074e07c31ee75619c90544179cf"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.10.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "588e0d680ad1d7201d4c6a804dcb1cd9cba79fbb"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.3"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Box]]
deps = ["HypertextLiteral", "Markdown"]
git-tree-sha1 = "bee6dbf5fa690f991d4c3b018cbfbb206e59dc18"
uuid = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
version = "1.0.14"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.CairoMakie]]
deps = ["Base64", "Cairo", "Colors", "FFTW", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools", "SHA"]
git-tree-sha1 = "5e21a254d82c64b1a4ed9dbdc7e87c5d9cf4a686"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.10.12"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a4c43f59baa34011e303e76f5c8c91bf58415aaf"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+1"

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
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

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
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

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
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "f9db5b04be51162fbeacf711005cb36d8434c55b"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.13.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelaunayTriangulation]]
deps = ["DataStructures", "EnumX", "ExactPredicates", "Random", "SimpleGraphs"]
git-tree-sha1 = "d4e9dc4c6106b8d44e40cd4faf8261a678552c7c"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "0.8.12"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "1f3b7b0d321641c1f2e519f7aed77f8e1f6cb133"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.29"

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
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "22c595ca4146c07b16bcf9c8bea86f731f7109d2"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.108"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.ExactPredicates]]
deps = ["IntervalArithmetic", "Random", "StaticArrays"]
git-tree-sha1 = "b3f2ff58735b5f024c392fde763f29b057e4b025"
uuid = "429591f6-91af-11e9-00e2-59fbe8cec110"
version = "2.2.8"

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
git-tree-sha1 = "ab3f7e1819dba9434a3a5126510c8fda3a4e7000"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "6.1.1+0"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "881275fc6b8c6f0dfb9cfa4a878979a33cb26be3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.10.1"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "2de436b72c3422940cbe1367611d137008af7ec3"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.23.1"

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
deps = ["Logging", "Printf"]
git-tree-sha1 = "fb409abab2caf118986fc597ba84b50cbaf00b87"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.3"

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
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "2493cdfd0740015955a8e46de4ef28f49460d8bc"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.3"

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

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "801aef8228f7f04972e596b09d4dba481807c913"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.4"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "5694b56ccf9d15addedc35e9a4ba9c317721b788"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.10"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "359a1ba2e320790ddbe4ee8b4d54a305c0ea2aff"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.0+0"

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
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "b2a7eaa169c13f5bcae8131a83bc30eff8f71be0"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.2"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be50fe8df3acbffa0274a744f1a99d29c45a57f4"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IntervalArithmetic]]
deps = ["CRlibm_jll", "MacroTools", "RoundingEmulator"]
git-tree-sha1 = "23ddd329f4a2a65c7a55b91553b60849bd038575"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.22.11"
weakdeps = ["DiffRules", "ForwardDiff", "RecipesBase"]

    [deps.IntervalArithmetic.extensions]
    IntervalArithmeticDiffRulesExt = "DiffRules"
    IntervalArithmeticForwardDiffExt = "ForwardDiff"
    IntervalArithmeticRecipesBaseExt = "RecipesBase"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
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
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

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
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3336abae9a713d2210bb57ab484b1e065edd7d23"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.2+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "fee018a29b60733876eb557804b5b109dd3dd8a7"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.8"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dae976433497a2f841baadea93d27e68f1a12a97"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.39.3+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0a04a1318df1bf510beb2562cf90fb0c386f58c4"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.39.3+1"

[[deps.LightXML]]
deps = ["Libdl", "XML2_jll"]
git-tree-sha1 = "3a994404d3f6709610701c7dabfc03fed87a81f8"
uuid = "9c8b4983-aa76-5018-a973-4c85ecc9e179"
version = "0.9.1"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearAlgebraX]]
deps = ["LinearAlgebra", "Mods", "Primes", "SimplePolynomials"]
git-tree-sha1 = "d76cec8007ec123c2b681269d40f94b053473fcf"
uuid = "9b3f67b0-2d00-526e-9884-9e4938f8fb88"
version = "0.2.7"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "a113a8be4c6d0c64e217b472fb6e61c760eb4022"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.6.3"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

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
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "80b2833b56d466b3858d565adcd16a4a05f2089b"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.1.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Setfield", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "StableHashTraits", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "35fa3c150cd96fd77417a23965b7037b90d6ffc9"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.19.12"

[[deps.MakieCore]]
deps = ["Observables", "REPL"]
git-tree-sha1 = "9b11acd07f21c4d035bd4156e789532e8ee2cc70"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.6.9"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "96ca8a313eb6437db5ffe946c457a401bbb8ce1d"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.5.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mods]]
git-tree-sha1 = "924f962b524a71eef7a21dae1e6853817f9b658f"
uuid = "7475f97c-0381-53b1-977b-4c60186c8d62"
version = "2.2.4"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

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
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "e64b4f5ea6b7389f6f046d13d4896a8f9c1ba71e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

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
version = "0.8.1+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3da7367955dcc5c54c1ba4d402ccdc09a1a3e046"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+1"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "d9b79c4eed437421ac4285148fcadf42e0700e89"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.9.4"

    [deps.Optim.extensions]
    OptimMOIExt = "MathOptInterface"

    [deps.Optim.weakdeps]
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

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
git-tree-sha1 = "cb5a2ab6763464ae0f19c86c56c63d4a2b0f5bda"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.52.2+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Permutations]]
deps = ["Combinatorics", "LinearAlgebra", "Random"]
git-tree-sha1 = "eb3f9df2457819bf0a9019bd93cc451697a0751e"
uuid = "2ae35dd2-176d-5d53-8349-f30d82d94d4f"
version = "0.4.20"

[[deps.PikaParser]]
deps = ["DocStringExtensions"]
git-tree-sha1 = "d6ff87de27ff3082131f31a714d25ab6d0a88abf"
uuid = "3bbf5609-3e7b-44cd-8549-7c69f321e792"
version = "0.6.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase", "Setfield", "SparseArrays"]
git-tree-sha1 = "81a2a9462003a423fdc59e2a3ff84cde93c4637b"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "4.0.7"

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
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "cb420f77dc474d23ee47ca8d14c90810cafe69e7"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.6"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "763a8ceb07833dd51bb9e3bbca372de32c0605ad"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
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
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "79123bc60c5507f035e6d1d9e563bb2971954ec8"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.4.1"

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
git-tree-sha1 = "f65caa24a622f985cc341de81d3f9744435d0d0f"
uuid = "55797a34-41de-5266-9ec1-32ac4eb504d3"
version = "0.8.6"

[[deps.SimplePartitions]]
deps = ["AbstractLattices", "DataStructures", "Permutations"]
git-tree-sha1 = "e182b9e5afb194142d4668536345a365ea19363a"
uuid = "ec83eff0-a5b5-5643-ae32-5cbf6eedec9d"
version = "0.3.2"

[[deps.SimplePolynomials]]
deps = ["Mods", "Multisets", "Polynomials", "Primes"]
git-tree-sha1 = "7063828369cafa93f3187b3d0159f05582011405"
uuid = "cc47b68c-3164-5771-a705-2bc0097375a0"
version = "0.2.17"

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

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableHashTraits]]
deps = ["Compat", "PikaParser", "SHA", "Tables", "TupleTools"]
git-tree-sha1 = "10dc702932fe05a0e09b8e5955f00794ea1e8b12"
uuid = "c5dd0088-6c3f-4803-b00e-f31a60c170fa"
version = "1.1.8"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

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
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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
git-tree-sha1 = "71509f04d045ec714c4748c785a59045c3736349"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.7"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.TupleTools]]
git-tree-sha1 = "41d61b1c545b06279871ef1a4b5fcb2cac2191cd"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.5.0"

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
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "532e22cf7be8462035d092ff21fada7527e2c488"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.6+0"

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
version = "1.2.13+1"

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
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

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
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
# ╠═1a10c180-c327-11ed-223b-1183f5350f3b
# ╟─d89b23a1-c58f-49bb-9cc1-4134176b7e3d
# ╟─ed3df13a-3622-47ff-92e4-2c0a1f256c14
# ╟─5606dee2-1714-4865-bf9a-2ce2f992fa01
# ╠═b264515e-7230-42cc-81a0-a2be0977362b
# ╟─fc284c77-979c-445e-89b5-5ef58fa25bc6
# ╟─b2107628-bb7b-4fdf-9a3b-7920b8eebfbe
# ╠═9c6d4886-66c1-485d-8f26-d59af544d2e8
# ╟─fe82e4cb-238d-42dc-8f08-04cacaeabf8b
# ╟─34216185-e0af-4329-8c30-e4f1138a6b26
# ╠═8f1873f8-2272-4344-a858-d3779fb44795
# ╠═815f23d4-1f25-4b5c-b97a-a2154d026b95
# ╠═1e397e6a-0007-44bf-8282-f72ad7d514dc
# ╠═96428119-e77a-451e-bc98-134a855bfe87
# ╟─33924413-490c-4a11-b004-c58f83c5086c
# ╠═fa7f56e4-fa4a-4f62-8304-f3ceda20c453
# ╠═b344b516-4f6a-4af4-9cf7-ae0c6d7abb7f
# ╟─ae603dc7-a957-49b5-bdfc-9e94d522d909
# ╠═9b23ac6c-d113-4bdc-9fe4-fdd708f64d7c
# ╠═31558248-bf16-4b4e-b99e-e2b47a7a4d2a
# ╠═223548b7-46d6-4cdb-ba7c-03738d1a905d
# ╟─e99df1f7-ba2e-432e-8376-9f2d1d947654
# ╠═d9e777dc-d141-4d93-8286-97adb27e2b95
# ╠═fbc45f88-81fe-4655-aa03-0f345c3ba4f0
# ╟─8ed3879a-4552-4600-89d5-30250d0c5387
# ╟─e90cb70d-091a-487f-a2d5-929ceba5a786
# ╟─a43a8d6f-f63e-47bf-8615-ad80c8a50df6
# ╠═460e0884-ca42-4e75-a131-c8f2a46daa70
# ╠═b7d1e6cb-b8f9-4f76-b2b9-063a8e14b46f
# ╠═7073165e-4246-494d-bf6b-1ce84a72224f
# ╟─54d5c406-44ef-46f9-aab6-04ba6e820777
# ╟─803b65f7-3e8b-456b-b110-5cb92090a145
# ╠═8ef34ef1-2c48-49a7-99a0-b9ea30b67745
# ╠═deef0e79-91dd-4633-a9a0-c7b3575045d0
# ╟─0e8004d2-64ca-4b09-9c0b-cc3350995001
# ╠═d0198bde-110b-4102-8a02-2cefaf443e64
# ╠═cfbcfa14-c20c-4bb9-83a5-d1cd964a3d05
# ╟─3c8eb473-4493-4645-adc5-565af6066756
# ╠═9219d869-59e5-4d88-afdd-ab664cf054df
# ╟─bfd83d38-5de1-4fb2-951f-ef4d089b3f6c
# ╟─f47c4c12-9652-4609-880b-dfa9a6a24222
# ╠═0d5ba460-d092-47eb-993f-afa6ce465cd9
# ╠═934307dc-0b90-4a3f-9698-4f878f936a09
# ╟─47ce0189-6c0e-4804-9fc2-24b223eb2547
# ╟─e39fbd0d-63a5-4df1-aa88-62c3977c2fdf
# ╠═e0435d39-be94-4bda-8538-74bac034c8d2
# ╠═505b931d-bcfd-4299-a344-1e8f83ce7f28
# ╟─3fbe27f7-7979-4c8b-ba80-b2fbb6bd3029
# ╠═7aff1fc4-0b06-4157-8f8d-81a4fb22791b
# ╟─42cb702e-a962-4240-9872-8a1b9a902b24
# ╟─c6826574-d5e9-4b56-8622-0bae5c2cc3bf
# ╟─e79c7097-ed22-4050-a4dc-6dec971494e2
# ╟─01f9c7f7-0ea1-408e-976c-b91c9840644c
# ╟─01d78cec-fb9d-4087-ac4c-abec2c1a2fa6
# ╟─3dd8e165-dead-47a6-8a6c-c7eea48dae52
# ╟─89afe7c7-3a8a-4046-8b33-600c78a16ae5
# ╟─c51f6d69-ca01-4559-898d-58d99bebf1d9
# ╟─f3aefb90-2c31-4061-b2e4-8025f3bf08f4
# ╠═5df505a0-7a0a-48b3-852a-fdf627587ff3
# ╟─c163f3f9-54f1-4e2e-9a5b-10b5f3584aab
# ╠═a581a643-ba4f-43c1-90d5-5c762babc5ec
# ╟─4585e2aa-cd3e-4281-ae83-7b68531f1f46
# ╠═b55f500e-a075-4d34-9a7b-1c6f7d3b90e2
# ╟─5608748a-b493-4a74-8b57-bf2c2cf65ce9
# ╠═9b7b1f80-e888-464d-ad37-f1601c958b2d
# ╟─2ba13415-30bf-469d-b4cc-4579b1370c9c
# ╠═f33b0901-fdce-489a-aef8-1096cae25e23
# ╠═d173ae80-dd6b-4671-a1fa-f6ef9434517a
# ╠═75525914-d4f6-4b3a-968b-f5ea908dc9f8
# ╠═e6555520-665c-40af-a6fb-f71f5903109c
# ╟─c53e80e4-9544-4eec-93cf-2cc6bbf8d5ca
# ╠═d791dee7-8307-43f0-b211-60464a31be1c
# ╟─07e1fe1b-b829-44b0-a579-4928405a8c63
# ╠═58f16371-cc3c-447b-b40b-51c4403736ef
# ╟─273bfd81-7913-494c-a01c-ef398abfd694
# ╠═e8e8f4ff-7d9a-4a27-8915-96b1d3a71950
# ╠═13ca0e00-2dd1-4504-9e7e-3786740b12d2
# ╟─1a458cec-3e9c-4da5-bf81-f69abb49338c
# ╠═c9275ff0-7de9-4f8c-a8fc-402dcc6fcee6
# ╟─cdf3558e-903b-4c7e-8599-f915a19a523c
# ╠═1e60fe11-bac8-4bc4-8aa7-f2897c9e7b5e
# ╟─d65f1554-57ee-4c45-a8ec-b5e7037d9d23
# ╠═d62b9206-b887-4aaa-b777-56e6d29adec5
# ╟─69f965ed-0e73-4f3d-9561-495bdad7ec51
# ╠═995e9df4-0c1b-4645-a421-86e37a9d714b
# ╟─43d17b7e-5bd1-4be1-a1e5-15cb16bdea99
# ╠═a3798c93-7d0a-4a0c-9990-c642a6d576be
# ╠═9d3cc8e3-0bce-409f-b029-b88b29fb6a5c
# ╠═531dcd4f-fc0b-4007-849b-646fdf436a48
# ╠═a83ffdbd-35eb-4fcf-8a27-f24413891b79
# ╠═079ecd34-5551-46cb-b783-6f332225e4a4
# ╟─a5d15ca5-6031-4eba-8e3b-19a5dd6ea4e3
# ╟─44b63870-1dbd-4742-8b20-280d4008e901
# ╟─cf22a0eb-04fb-43f0-bbd7-4a0845855047
# ╠═3e1d2f5c-9b36-44c7-9637-6c92050625d7
# ╠═4116eb6b-1e88-4014-bccf-a32a31808316
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
