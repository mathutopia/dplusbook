### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 474a99e2-9032-11ee-2d38-95a5b97c5516
begin
using MLJ, DataFrames, PlutoUI,CSV,DataFramesMeta
include("funs.jl");# 加入通用函数
PlutoUI.TableOfContents(title = "目录", indent = true, depth = 4, aside = true)
end

# ╔═╡ 74d6dcc1-0037-47ce-8e1d-6dc46771ff62
using DecisionTree,MLJDecisionTreeInterface

# ╔═╡ 798913b3-a263-40e9-96df-35b1c5d68acf
md"""
**目的与要求**
1. 掌握MLJ做机器学习的基本框架
2. 掌握典型分类模型的应用（比如：决策树等）
""" |> fenge

# ╔═╡ 7a2fb632-ff40-41b7-bbd2-cc08cb3ed9a9
 html"<font size=\"80\">实验4 分类问题</font>"

# ╔═╡ 0ee80ce8-a007-4e26-8dd4-dbf0938fd96a
md"""
下面介绍用[MLJ](https://alan-turing-institute.github.io/MLJ.jl/stable/)做数据挖掘的方法。先用 **[iris](https://www.gairuo.com/p/iris-dataset)** 数据集做一个用 [**MLJ**](https://alan-turing-institute.github.io/MLJ.jl/dev/) 建模的基本过程。
"""

# ╔═╡ 8344e755-ffc6-4bb3-ac3b-e2a737033030
md"""
# 1. 准备数据
这里只是简单的引入已有数据， 更多的数据准备工作在前面的课程， 后面会进一步总结。
"""

# ╔═╡ 6c5de159-e6b6-459b-96e2-3feeff8a4b70
iris = DataFrame(load_iris())

# ╔═╡ 1bfc9917-68ac-415a-aea3-336728d39b37
md"""
构造预测变量X和目标变量y。 也可以使用dataframe的select去选择X和y， 不过要注意y需要转换为类别变量,例如通过下面的代码可以构造y
```julia
X1 = select(iris, Not(:target))
y1 = categorical(iris.target)
```
"""

# ╔═╡ 2079416a-f031-4313-bb81-0b51b147904b
y,X = unpack(iris, ==(:target))

# ╔═╡ 85ef2d6b-db0c-49e4-857f-01622f96e7eb
y

# ╔═╡ 6bbb67b2-f25c-48ed-938c-e6479c29aff4
X

# ╔═╡ 235ca537-f55f-4842-b81e-f791d67b67b4
md"""
# 2. MLJ建模
下面的@load 宏用于从一个注册的pkg中加载一个模型， 需要这个pkg事先安装好。 一个**模型**本质上是一个struct， 记录了模型的一些超参数。

## 2.1 加载模型结构（struct）
**搜索匹配数据的模型**
"""

# ╔═╡ 13bb7c17-1e87-46b1-bdd1-25441adc20b7
# 找到所有匹配我们数据的模型
models(matching(X, y))

# ╔═╡ 4b4dadf7-fbb3-475f-902d-391c8839b78d
md"""
**搜索包含某种字段的模型**
"""

# ╔═╡ 13c49081-8bb4-4766-bf8b-5fc53b7246bf
models("Bayes")

# ╔═╡ 766bf320-4ae5-4124-8031-1f79810e086c
md"""
**列出所有的模型**
"""

# ╔═╡ fce0a140-e63b-4e17-9c20-a9fef3797319
models()

# ╔═╡ f2c65c26-f1c4-4567-b522-4669a4d096f7
Tree = @load DecisionTreeClassifier pkg=DecisionTree

# ╔═╡ c3234c05-bf00-4bca-ac9e-268698d9f029
md"""
## 2.2 构建模型实例
相当于初始化模型结构。
"""

# ╔═╡ ecdebdad-1d76-4f60-80c7-926200119bec
tree = Tree(max_depth = 3)

# ╔═╡ e5404658-5aee-4dcd-822c-28a318cf0953
Tree()

# ╔═╡ b30728ba-cb35-4d3d-b7b2-e62cf90f9e10
md"""
当然， 可以将第一步和第二步合并到一起：
"""

# ╔═╡ a0b1219f-02a7-4a2b-9b76-d525033b2ab1
md"""
## 2.3 构造机器（machine）
**机器（machine）**可以认为是绑定了数据的模型
"""

# ╔═╡ 00a7cba8-8e18-4be6-acbe-f9b089a8def6
mach = machine(tree, X, y)

# ╔═╡ b536589e-f7ad-4d81-a532-7bcd27f12984
md"""
## 2.4 数据集划分
主要是划分训练集、测试集
"""

# ╔═╡ 284f5c91-c788-45f1-8792-f8d63b6aa627
train, test = partition(eachindex(y), 0.7, shuffle = true) # 注意，默认情况下不是随机划分

# ╔═╡ a159ffbf-07c1-4bb2-b45d-5a2dadeb2271
train

# ╔═╡ c4f4f032-a784-44a9-a258-1f00e682d588
1:length(y)

# ╔═╡ 3cc0b04d-6c56-4599-9680-f1b05ccf6b20
eachindex(y)

# ╔═╡ 08999fb3-e10b-4f64-b0cc-d41c21d4f3ed
md"""
## 2.5 拟合模型
一般在训练集上拟合模型
"""

# ╔═╡ 9519d45b-48d9-4287-a8c8-dae8a1551b0d
MLJ.fit!(mach, rows=train)

# ╔═╡ 3dd2216b-18fe-4182-bd11-f8027ce66e1f
mach.model

# ╔═╡ 7139aa61-c887-4124-bad3-a11790a9fc85
md"""
查看拟合的模型参数和模型结果
"""

# ╔═╡ e060deb3-46a6-41f8-b341-0f4597a368a9
fitted_params(mach)

# ╔═╡ 6d7d7024-2fdc-4ea5-8e45-767c2a684f80
# 
report(mach).print_tree(4)

# ╔═╡ 1bd17442-1b24-486e-b1fb-1f9c9ba1d30d
md"""
## 2.6 预测
用拟合的模型去预测测试集的类别。注意， 因为预测目标是一个类别（三种之一）， 这里预测结果是一个分布：相当于属于每一种的概率。 
"""

# ╔═╡ 15919fa0-59d6-4590-9af1-8708bbb62c2e
yhat = MLJ.predict(mach, X[test,:])

# ╔═╡ 4330b6e4-1da1-4867-940b-c874255c80b9
yhat[1:2]

# ╔═╡ a2e0f1b9-2173-4dd7-be7b-78f1d3b16f28
md"""
如果不想获得分布预测结果，可以使用predict_mode函数。也可以在分布预测结果上去求众数(mode)及获得概率最大的预测结果。
"""

# ╔═╡ 869ad4f0-9065-4362-b86b-0d70c58a6fbe
yhat2 = predict_mode(mach, X[test,:])

# ╔═╡ 8b269dd4-5366-411b-93b8-143d98f8eb64
md"""
## 2.7 评估预测结果
评估模型效果本质上是要评估预测值与实际值(ground truth)之间的差距（损失），可以使用`measure()`列出所有的损失评估函数, 参考[这里](https://alan-turing-institute.github.io/MLJ.jl/v0.3/measures/)。 MLJ中实现[LossFunctions.jl](https://github.com/JuliaML/LossFunctions.jl)包中的损失函数， 但做了一些表示上的修改。

一般， 设预测值为yhat, 实际值为y， $r = yhat - y$, 损失函数是一个关于r的函数。 

分类问题一个常见的损失函数时交叉熵(cross entropy). 这里有个简单的博客做关于**[熵的介绍.](https://blog.csdn.net/xg123321123/article/details/52864830)**
"""

# ╔═╡ cf091683-25d2-4249-bab8-7dd3b051b78c
log_loss(yhat, y[test]) |> mean

# ╔═╡ 16986288-495e-4204-ad39-28a2afb66ea8
md"""
我们可以定义自己的损失函数，比如评估预测的准确度
"""

# ╔═╡ 97248a11-ce38-490f-8fc9-a6f885297885
function myloss(yhat, y)
	sum(yhat .== y)/length(yhat)
end

# ╔═╡ 6c32a7b2-9209-472e-9bcb-0a3c6fe77745
myloss(yhat, y[test])

# ╔═╡ 3a45e417-649b-4bab-a121-4ede48c2fc94
accuracy(mode.(yhat), y[test])

# ╔═╡ fe35ac8f-baa5-42df-8bb4-aaab27595e46
measures()

# ╔═╡ c58e547e-9165-48d7-9942-8ec11e928939
auc(yhat, y[test])

# ╔═╡ 338197fd-4792-4ea2-b9be-124d3ee4f684
md"""
# 3. 处理竞赛数据
"""

# ╔═╡ ae762710-6f96-4575-a9ab-86a50e559bc6
md"""
## 数据准备
在实际建模过程中， 因为数据可能具有各种不同的类型与状况， 数据准备将是一个非常耗时的工作。
"""

# ╔═╡ 05721e0d-91ba-4460-9230-a18906c17e98
trains = CSV.read("data/trainbx.csv", DataFrame)

# ╔═╡ 9fec7844-aad4-400a-a0f6-a17d1a447b10
md"""
构造竞赛数据的X,y。 通常， X中不应该包含id字段和目标字段。
"""

# ╔═╡ 1bfb7cc7-a89a-4ce7-aa3e-3cab2258b0d1
Xt = select(trains, Not([:fraud,:policy_id]))

# ╔═╡ 75e4e8e3-6f26-4b7b-b87c-2fb8e0a13c4f
yt = categorical(trains.fraud)

# ╔═╡ 83d7ad6e-f7cd-4e70-8b38-0f06a6020dcb
models(matching(Xt,yt))

# ╔═╡ a02e8b6e-5fab-4b20-a3d8-6abc4e7c5d40
md"""
从上面可以看出， 能用的模型非常少。 原因应该不能想到：我们的Xt包含太多的数据类型。 在MLJ建模时，我们更关注数据的科学类型， 而不是存储类型。 科学类型代表的是数据的“含义”，更加接近建模中看到的数据类型， 而存储类型只是数据的存储方式。用schema函数， 可以同时看到数据的科学类型和存储类型。
"""

# ╔═╡ 6c689670-d6cb-417b-86e6-0253b3894254
schema(trains)

# ╔═╡ a5a9c896-2114-4b07-adc8-2873e6ad93c2
unique(schema(trains).scitypes)

# ╔═╡ c2d137d2-b65e-4669-a393-65887233f922
md"""
上面将数据的科学类型去重之后可以看到， 数据有4种类型的科学类型。一般而言：科学类型主要涉及以下几类：
"""

# ╔═╡ bd38191a-c57d-4dc4-ad71-814b782f1432
md"""
[科学类型]

![](https://alan-turing-institute.github.io/MLJ.jl/dev/img/scitypes_small.png)
"""

# ╔═╡ 755fb8bb-7230-48d5-ae60-448fcb217c52
md"""
一般而言， 整型（Int）存储类型会被处理为Count， 浮点数（Float）类型会被处理为Continuous， 字符串类型（String）会被处理为textual。 直接读取数据，一般不会有有序因子（OrderedFactor）和类别变量（Multiclass）， 需要转化。可以使用scitype和elscitype分别获取数据框中字段的科学类型和字段取值的科学类型。
"""

# ╔═╡ 22edcd12-5b58-49c1-9fb5-4cc8f7b1dffb
scitype(trains.age)

# ╔═╡ 07694d8c-29f4-4651-9302-bc997cc38071
elscitype(trains.age)

# ╔═╡ ab5daca3-aabb-49b8-b863-014cab8ffca9
md"""
科学类型的一个重要作用用于模型选择时的数据类型指定。 比如对于上面提到的鸢尾花分类问题， 在所有的模型中， 只有一部分是适合这个问题的。 MLJ是如何判断一个模型是否适合我们的问题的呢？事实上， 一个模型包含了许多的信息， 其中的模型名字和所在包的名字是最重要的。

下面， 我们看一下前面用到的DecisionTree包中，DecisionTreeClassifier的相关信息。
"""

# ╔═╡ d6300b07-45cc-4012-aa6e-fc717144d57e
info("DecisionTreeClassifier", pkg="DecisionTree")

# ╔═╡ a80849b4-e961-4613-869b-24c47d5db1c6
md"""
在模型返回的诸多信息中， 有两个字段input_scitype和target_scitype， 分别表示输入数据X和目标变量Y的的科学类型。比如上面的模型， 输入数据的类型是：
Table{<:Union{AbstractVector{<:Continuous}, AbstractVector{<:Count}, AbstractVector{<:OrderedFactor}}}
虽然这个看上去看复杂， 但仔细看还是比较容易理解的。首先， 输入数据必须是表格Table（dataframe是表格）， 表格中字段的类型都是向量Vector， 其元素可以是：Continuous， Count, OrderedFactor类型。
对于目标变量，其类型是：AbstractVector{<:Finite}， 也就是有限类型就行。

正是因为一个模型对输入变量和目标变量的数据类型是有要求的， 因此， 我们可以使用models(matching(X, y))去搜索所有能用于对X和y建模的模型。
"""

# ╔═╡ ac9ddcb0-96cd-4d73-8314-07e714a2025e
md"""
在实际建模中，我们的X通常会有多种数据类型， 有时候，我们需要选择某种/些类型的变量用于建模， 这时候， 需要用到类型的获取工具。 运算工具： == 可以用于比较两种类型是否相同。 type1<:type2表示判断type1类型是否是type2类型的子类型（包括type2类型）。类似的， type1>:type2表示判断type1类型是否是type2类型的父类型（包括type2类型）。
"""

# ╔═╡ abe1d9c3-6509-47a9-884d-9fbd36d13d45
elscitype(trains.age) == Count

# ╔═╡ bebc6df9-b57e-486b-ab37-4aa39fdb3a6e
elscitype(trains.age) <: Count

# ╔═╡ f08ef805-47db-4e1d-9fa4-0c604d71f8ef
elscitype(trains.age) >: Count

# ╔═╡ f696cad1-5eb2-4829-89e0-40247dcca90c
md"""
在DataFrames包中， 提供了一个函数[`names`](https://dataframes.juliadata.org/stable/lib/functions/#Base.names)用于获取一个数据框中满足条件的字段名。 这个函数有多种用法， 请自行参考帮助文档， 下面介绍两种常见的。

```julia
names(df, type)
names(df, boolvec)
```

1。 选择元素是某种存储类型(type)的字段： 比如， 选出所有整型（Int）数据字段。
"""

# ╔═╡ b839ac95-daba-4b39-97a9-27080ffd6999
names(Xt, Int)

# ╔═╡ 7db8e1cd-a3f6-4ca9-9864-b7fce67fe67b
md"""
注意， 上面的类型必须是存储类型， 用科学类型不能选出符合条件的。
"""

# ╔═╡ dcd88f53-4533-4746-8b89-50a6ee7934b2
names(Xt, Count)

# ╔═╡ 56008d6c-0bfc-4418-bf8b-26c1872a854c
md"""
如果要选出某种科学类型的字段， 需要用到更高级的用法： 通过一个函数,判断每一列是否是某种科学类型， 形成一个bool向量（boolvec），通过这个向量，选择满足条件的字段名。

下面定义一个函数， 这个函数可以用于判断参数的元素的科学类型是否是某种类型。 默认的**关键字参数**给出的是Count类型。
"""

# ╔═╡ 96616d0e-1f77-4589-b1a5-9ea15dc1a38f
fun(x;tp = Count) = elscitype(x) == tp

# ╔═╡ 3ae5298a-1284-4c5b-9fd8-cce449f116ed
fun(Xt.age)

# ╔═╡ 6b359608-f19f-4210-82fa-5a656e6c2df5
md"""
为了判断一个数据框的每一列是否是某种类型的变量， 我们需要遍历每一个字段， 用for循环当然能够实现， 但处理一个数据框的每一列是一个常见的操作， DataFrames包中提供了一个函数`eachcol`， 通过这个函数可以获得一个dataframe的每一列的可迭代对象。 可以将其想象为， 你获得了一个向量， 只是这个向量的元素会在迭代过程中一个一个取出来。 有了这个可迭代对象， 就可以实现对每一列执行某种操作了。

下面就是将上面定义的函数fun施加到Xt的每一列上， 注意函数名后的点., 这表示向量化运算， 即这个函数fun会施加到后面数据框的每一列上。

如果你还想了解更多点运算实现向量化的背景， 可以参考[这里。](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized)
"""

# ╔═╡ 437344cb-89b4-4df7-896b-9c50f7c9fe20
fun.(eachcol(Xt))

# ╔═╡ b78034cf-d2e0-487c-a3bc-6c2e7e0aad6b
md"""
有了上面的基础， 我们可以找到具有某种科学类型的字段了。
"""

# ╔═╡ 929b3de2-2c41-43b7-b25d-7c54d73682c3
names(Xt, fun.(eachcol(Xt)))

# ╔═╡ b6f069a6-fdb8-4617-88fe-fe65e7b10b10
md"""
找到了相应的字段， 然后去选择字段， 构造新的X是非常容易的。 用select函数就可以了。
"""

# ╔═╡ 0eee807f-e09b-471a-9ab7-53345dce7ee6
select(Xt, names(Xt, fun.(eachcol(Xt))))

# ╔═╡ c398af14-f25e-493f-a2ae-0fcaf240eafc
md"""
很多模型都需要输入变量是连续类型， 可以看看我们的数据中到底有多少是连续的。
"""

# ╔═╡ 0c4f87ec-daee-4670-bd08-298f74543aab
names(Xt, fun.(eachcol(Xt), tp = Continuous))

# ╔═╡ 4c57e45b-4d11-4ec7-8d3d-c437f2ab10c1
md"""
上面的结果告诉你， 我们的数据集中连续变量只有一个。 这显然不符合事实。 如果你去仔细分析， 会发现，许多Count类型的变量应该理解为连续变量更合理（比如年龄age）。因此， 我们需要一个能将Count类型转换为Continuous类型的函数。这可以方便的通过coease实现。

coease有三种不同的使用方法：
```julia
coerce(vec, type)
coerce(X, :name1=>type1, :name2=>type2,...)
coerce(X, type1=>type2, ...)
```
下面是一个例子
```julia
#将向量y中的元素都转化为Multiclass类型
coerce(y, Multiclass) 
#将表格X中的字段：x1转化为Continuous， 字段x2转化为OrderedFactor
coerce(X, :x1 => Continuous, :x2 => OrderedFactor)
#将表格中所有的Count类型都转化为Continuous类型。
coerce(X, Count => Continuous) 

```

"""

# ╔═╡ ecfe89e3-3d3f-4113-b720-9c22dc8d33a4
md"""
下面我们将所有的Count类型都转化为continous类型， 进而选择用continous类型的数据去建模， 看看能用的模型有多少。

为了更清楚的看到数据处理的流程， 我们将从最原始的数据开始， 综合上面提到的每一个步骤：
"""

# ╔═╡ 11185a67-0f19-4bc2-b651-2b01915c9159
Xtn = @chain trains begin
select(Not([:fraud,:policy_id]))
coerce(Count => Continuous)
select(_,names(_, fun.(eachcol(_),tp = Continuous)))
end

# ╔═╡ d8683ab5-8f70-4ae8-a060-8adb6bea846f
ms = models(matching(Xtn, yt))

# ╔═╡ 262bf688-0178-4150-aeba-e257242117a5
md"""
可以看到，现在的模型已经有 $(length(ms))个了。 我们可以在这中间挑选你想要的模型去建模了。 由于上面还是可以找到决策树模型（显然的）， 下面我们尝试用决策树模型去对我们的问题建模一次。
"""

# ╔═╡ d9dd8372-67c1-4fea-badf-77a8cef4e15b
md"""
## 加载模型结构
如果还是使用决策树模型， 这一步不需要做了， 因为上面的例子中， 已经把模型结构加载进来， 我们只要给定参数去构建实例就好。不过， 为了完整起见， 我还是加载一次， 并将其赋值给不同的对象。
"""

# ╔═╡ e810a496-1d60-48ca-b7e9-c741113597b1
Tree2 = @load DecisionTreeClassifier pkg=DecisionTree

# ╔═╡ a08bfc8c-cb47-49ec-95a3-9055fdc20ce6
md"""
## 构建模型实例
这时候， 我们把超参数稍作修改。
"""

# ╔═╡ f1b39c2e-7e47-4535-882f-607b02ea82f3
tree2 = Tree2(max_depth = 5)

# ╔═╡ bc97582d-6e2f-4636-be46-58e7b4ab5deb
md"""
## 构造机器
"""

# ╔═╡ 69d8cff1-b68c-41c1-b171-40a9712b94ba
mach2 = machine(tree2, Xtn, yt)

# ╔═╡ 07ec992c-530f-4bef-a603-15bddaf74817
md"""
## 数据集划分
"""

# ╔═╡ 534903b7-0ffa-4b7f-b6a4-60581419854a
train2, test2 = partition(eachindex(yt), 0.7, shuffle = true) 

# ╔═╡ 428421eb-8dd8-4692-841d-bbf1b44789e8
md"""
## 拟合模型
"""

# ╔═╡ 2d9baa60-9b06-4bd3-be1c-5c086c98512a
MLJ.fit!(mach2, rows=train2)

# ╔═╡ 2d98cfde-15ea-4154-b7e3-c3a7a7f798ce
yhat21 = MLJ.predict(mach2, Xtn[test2,:])

# ╔═╡ 7ffbaf58-f3b1-4002-93d6-5ded742ee2fb
yhat22 = MLJ.predict_mode(mach2, Xtn[test2,:])

# ╔═╡ f3215352-4f86-4f30-a4ee-0bf2d40bc43b
md"""
## 评估模型结果
由于我们竞赛用的是auc指标， 我们当然也希望用auc指标去评估模型。下面是在测试集上去评估模型。
"""

# ╔═╡ 348ab9d7-6f70-4891-8a8f-d9dfe4c3b8c9
auc(yhat21, yt[test2])

# ╔═╡ e50e1362-9169-4325-905f-7ea6ae71d8b7
md"""
上面的结果可能让你失望， 因为它可能还没有聚类分析来的效果好。 不过由于我们并没有做太多的特征处理，而且这里做的预测只是样本内的预测， 其效果不是很理想也能理解。不过， 你现在可能希望把这个模型用到真实的测试集上， 然后，提交系统，看到底能得多少分？下面我们实现这个步骤。
"""

# ╔═╡ f47f6676-bda8-4011-bdbd-f90a2c615963
md"""
# 4. 提交比赛
下面是将模型的结果用于比赛的测试集。 现在假定你认为， 我们的模型已经不错了。 提交比赛需要做以下步骤：
1. 对测试集数据通过与训练集相同的数据处理； 
2. 在所有的训练集上重新训练一下模型； 
3. 用重新训练的模型预测新构建的测试集。
4. 将预测结果， 写入csv提交系统。
"""

# ╔═╡ 6c8a368a-3fc8-4c29-9b6d-87a3d036a546
md"""
## 处理测试数据
系统提供的测试数据需要经过跟训练数据相同的处理， 才能用于预测模型。因此， 我们首先处理一下测试数据。处理的过程很简单， 只需要跟训练集施加同样的操作即可。 在上面， 我们用一个@chain对训练集做了多个操作， 下面把代码搬过来，类似操作一下即可。 只是请注意， 在测试集中， 没有:fraud字段， 所有最开始选择的时候， 不要有这个字段就好。
"""

# ╔═╡ 8bb6367f-19de-4cf5-b5df-c3eb9af8745f
testbx = CSV.read("data\\testbx.csv", DataFrame)

# ╔═╡ 16059ee1-a669-48c1-beb5-099fc55f6a50
testbxn = @chain testbx begin
select(Not([:policy_id]))
coerce(Count => Continuous)
select(_,names(_, fun.(eachcol(_),tp = Continuous)))
end

# ╔═╡ 3b513fb7-c47b-4408-881c-9346743ebe9e
md"""
## 重新训练一下模型
上面已经训练了一个模型， 可以直接用于预测了。不过，上面训练的模型只是利用训练集上的一部分数据训练得到的。 我们让模型在整个训练集上去“学习”， 理论上应该可以得到更好的模型。 这时候， 我们不再需要指定rows参数。相当于用所有的行来训练模型。
"""

# ╔═╡ de4841eb-0975-4209-94f1-f13cbb46fb58
MLJ.fit!(mach2)

# ╔═╡ f1b30e01-044a-4499-8630-9d633abc32a5
md"""
## 预测测试集
"""

# ╔═╡ d3f6c9bd-291a-4c30-bc01-1bbef2435f74
yuce = MLJ.predict(mach2,testbxn )

# ╔═╡ 469d1d36-bcec-4a01-a2e7-c5b141e19d3a
md"""
上面预测的结果是一个分布(分别给出每个样本是0和1的概率)， 但我们需要的是这个分布在1上的取值， 本质上是概率密度函数（pdf）在1上的取值。因此， 我们可以通过pdf函数获得。
"""

# ╔═╡ ee781216-8998-4073-8770-89152f5698c2
yuce2 = pdf.(yuce, 1)

# ╔═╡ 12301fef-ca85-4be9-a1e4-dafddb72864a
md"""
## 构造提交CSV
注意， 提交系统的CSV只要两列（分别是policy_id和fraud）就可以了。policy_id可以从最开始读取的测试集得到。而fraud，则是一个我们预测的概率值。
"""

# ╔═╡ a31ea97c-2130-45dc-b705-be8e1688836d
subm = DataFrame(policy_id = testbx.policy_id,fraud = yuce2)

# ╔═╡ 998cde61-0814-4177-971d-2c1bbd1382a8
CSV.write("data/submit1.csv",subm)

# ╔═╡ 0d5265c3-ba2c-4e9e-8d8c-1cfcc1dc3080
md"""
最终提交系统后， 成绩为0.6297。比本地测试的效果稍好一点。但还是很不理想。 
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
DecisionTree = "7806a523-6efd-50cb-b5f6-3fa6f1930dbb"
MLJ = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
MLJDecisionTreeInterface = "c6f25543-311c-4c74-83dc-3ea6d1015661"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.10.11"
DataFrames = "~1.6.1"
DataFramesMeta = "~0.14.1"
DecisionTree = "~0.12.4"
MLJ = "~0.20.2"
MLJDecisionTreeInterface = "~0.4.0"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "21237913cb3d44b13436013c08036ec531808c0a"

[[deps.ARFFFiles]]
deps = ["CategoricalArrays", "Dates", "Parsers", "Tables"]
git-tree-sha1 = "e8c8e0a2be6eb4f56b1672e46004463033daa409"
uuid = "da404889-ca92-49ff-9e8b-0aa6b4d38dc8"
version = "1.4.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

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

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables"]
git-tree-sha1 = "e28912ce94077686443433c2800104b061a827ed"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.39"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

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

[[deps.CategoricalDistributions]]
deps = ["CategoricalArrays", "Distributions", "Missings", "OrderedCollections", "Random", "ScientificTypes"]
git-tree-sha1 = "3124343a1b0c9a2f5fdc1d9bcc633ba11735a4c4"
uuid = "af321ab8-2d2e-40a6-b165-3d674595d28e"
version = "0.1.13"

    [deps.CategoricalDistributions.extensions]
    UnivariateFiniteDisplayExt = "UnicodePlots"

    [deps.CategoricalDistributions.weakdeps]
    UnicodePlots = "b8865327-cd53-5732-bb35-84acbb429228"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

    [deps.CompositionsBase.weakdeps]
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.ContextVariablesX]]
deps = ["Compat", "Logging", "UUIDs"]
git-tree-sha1 = "25cc3803f1030ab855e383129dcd3dc294e322cc"
uuid = "6add18c4-b38d-439d-96f6-d6bc489c04c5"
version = "0.1.3"

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
git-tree-sha1 = "6970958074cd09727b9200685b8631b034c0eb16"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.14.1"

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

[[deps.DecisionTree]]
deps = ["AbstractTrees", "DelimitedFiles", "LinearAlgebra", "Random", "ScikitLearnBase", "Statistics"]
git-tree-sha1 = "526ca14aaaf2d5a0e242f3a8a7966eb9065d7d78"
uuid = "7806a523-6efd-50cb-b5f6-3fa6f1930dbb"
version = "0.12.4"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

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
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "a6c00f894f24460379cb7136633cef54ac9f6f4a"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.103"

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

[[deps.EarlyStopping]]
deps = ["Dates", "Statistics"]
git-tree-sha1 = "98fdf08b707aaf69f524a6cd0a67858cefe0cfb6"
uuid = "792122b4-ca99-40de-a6bc-6742525f08b6"
version = "0.3.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.FLoops]]
deps = ["BangBang", "Compat", "FLoopsBase", "InitialValues", "JuliaVariables", "MLStyle", "Serialization", "Setfield", "Transducers"]
git-tree-sha1 = "ffb97765602e3cbe59a0589d237bf07f245a8576"
uuid = "cc61a311-1640-44b5-9fba-1b764f453329"
version = "0.2.1"

[[deps.FLoopsBase]]
deps = ["ContextVariablesX"]
git-tree-sha1 = "656f7a6859be8673bf1f35da5670246b923964f7"
uuid = "b9860ae5-e623-471e-878b-f6a53c775ea6"
version = "0.1.1"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "28e4e9c4b7b162398ec8004bdabe9a90c78c122d"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.8.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

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
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterationControl]]
deps = ["EarlyStopping", "InteractiveUtils"]
git-tree-sha1 = "d7df9a6fdd82a8cfdfe93a94fcce35515be634da"
uuid = "b3c1a2ee-3fec-4384-bf48-272ea71de57c"
version = "0.5.3"

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

[[deps.JuliaVariables]]
deps = ["MLStyle", "NameResolution"]
git-tree-sha1 = "49fb3cb53362ddadb4415e9b73926d6b40709e70"
uuid = "b14d175d-62b4-44ba-8fb7-3064adc8c3ec"
version = "0.2.4"

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "PrecompileTools", "Requires", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "b0737cbbe1c8da6f1139d1c23e35e7cea129c0af"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.9.13"

    [deps.KernelAbstractions.extensions]
    EnzymeExt = "EnzymeCore"

    [deps.KernelAbstractions.weakdeps]
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Requires", "Unicode"]
git-tree-sha1 = "c879e47398a7ab671c782e02b51a4456794a7fa3"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "6.4.0"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "98eaee04d96d973e79c25d49167668c5c8fb50e2"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.27+1"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LatinHypercubeSampling]]
deps = ["Random", "StableRNGs", "StatsBase", "Test"]
git-tree-sha1 = "825289d43c753c7f1bf9bed334c253e9913997f8"
uuid = "a5e1c1ea-c99a-51d3-a14d-a9a37257b02d"
version = "1.9.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LearnAPI]]
deps = ["InteractiveUtils", "Statistics"]
git-tree-sha1 = "ec695822c1faaaa64cee32d0b21505e1977b4809"
uuid = "92ad9a40-7767-427a-9ee6-6e577f1266cb"
version = "0.1.0"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

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

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MLFlowClient]]
deps = ["Dates", "FilePathsBase", "HTTP", "JSON", "ShowCases", "URIs", "UUIDs"]
git-tree-sha1 = "32cee10a6527476bef0c6484ff4c60c2cead5d3e"
uuid = "64a0f543-368b-4a9a-827a-e71edb2a0b83"
version = "0.4.4"

[[deps.MLJ]]
deps = ["CategoricalArrays", "ComputationalResources", "Distributed", "Distributions", "LinearAlgebra", "MLJBalancing", "MLJBase", "MLJEnsembles", "MLJFlow", "MLJIteration", "MLJModels", "MLJTuning", "OpenML", "Pkg", "ProgressMeter", "Random", "Reexport", "ScientificTypes", "StatisticalMeasures", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "981196c41a23cbc1befbad190558b1f0ebb97910"
uuid = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
version = "0.20.2"

[[deps.MLJBalancing]]
deps = ["MLJBase", "MLJModelInterface", "MLUtils", "OrderedCollections", "Random", "StatsBase"]
git-tree-sha1 = "e4be85602f010291f49b6a6464ccde1708ce5d62"
uuid = "45f359ea-796d-4f51-95a5-deb1a414c586"
version = "0.1.3"

[[deps.MLJBase]]
deps = ["CategoricalArrays", "CategoricalDistributions", "ComputationalResources", "Dates", "DelimitedFiles", "Distributed", "Distributions", "InteractiveUtils", "InvertedIndices", "LearnAPI", "LinearAlgebra", "MLJModelInterface", "Missings", "OrderedCollections", "Parameters", "PrettyTables", "ProgressMeter", "Random", "Reexport", "ScientificTypes", "Serialization", "StatisticalMeasuresBase", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "6d433d34a1764324cf37a1ddc47dcc42ec05340f"
uuid = "a7f614a8-145f-11e9-1d2a-a57a1082229d"
version = "1.0.1"
weakdeps = ["StatisticalMeasures"]

    [deps.MLJBase.extensions]
    DefaultMeasuresExt = "StatisticalMeasures"

[[deps.MLJDecisionTreeInterface]]
deps = ["CategoricalArrays", "DecisionTree", "MLJModelInterface", "Random", "Tables"]
git-tree-sha1 = "8059d088428cbe215ea0eb2199a58da2d806d446"
uuid = "c6f25543-311c-4c74-83dc-3ea6d1015661"
version = "0.4.0"

[[deps.MLJEnsembles]]
deps = ["CategoricalArrays", "CategoricalDistributions", "ComputationalResources", "Distributed", "Distributions", "MLJModelInterface", "ProgressMeter", "Random", "ScientificTypesBase", "StatisticalMeasuresBase", "StatsBase"]
git-tree-sha1 = "94403b2c8f692011df6731913376e0e37f6c0fe9"
uuid = "50ed68f4-41fd-4504-931a-ed422449fee0"
version = "0.4.0"

[[deps.MLJFlow]]
deps = ["MLFlowClient", "MLJBase", "MLJModelInterface"]
git-tree-sha1 = "89d0e7a7e08359476482f20b2d8ff12080d171ee"
uuid = "7b7b8358-b45c-48ea-a8ef-7ca328ad328f"
version = "0.3.0"

[[deps.MLJIteration]]
deps = ["IterationControl", "MLJBase", "Random", "Serialization"]
git-tree-sha1 = "991e10d4c8da49d534e312e8a4fbe56b7ac6f70c"
uuid = "614be32b-d00c-4edb-bd02-1eb411ab5e55"
version = "0.6.0"

[[deps.MLJModelInterface]]
deps = ["Random", "ScientificTypesBase", "StatisticalTraits"]
git-tree-sha1 = "381d99f0af76d98f50bd5512dcf96a99c13f8223"
uuid = "e80e1ace-859a-464e-9ed9-23947d8ae3ea"
version = "1.9.3"

[[deps.MLJModels]]
deps = ["CategoricalArrays", "CategoricalDistributions", "Combinatorics", "Dates", "Distances", "Distributions", "InteractiveUtils", "LinearAlgebra", "MLJModelInterface", "Markdown", "OrderedCollections", "Parameters", "Pkg", "PrettyPrinting", "REPL", "Random", "RelocatableFolders", "ScientificTypes", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "10d221910fc3f3eedad567178ddbca3cc0f776a3"
uuid = "d491faf4-2d78-11e9-2867-c94bc002c0b7"
version = "0.16.12"

[[deps.MLJTuning]]
deps = ["ComputationalResources", "Distributed", "Distributions", "LatinHypercubeSampling", "MLJBase", "ProgressMeter", "Random", "RecipesBase", "StatisticalMeasuresBase"]
git-tree-sha1 = "44dc126646a15018d7829f020d121b85b4def9bc"
uuid = "03970b2e-30c4-11ea-3135-d1576263f10f"
version = "0.8.0"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MLUtils]]
deps = ["ChainRulesCore", "Compat", "DataAPI", "DelimitedFiles", "FLoops", "NNlib", "Random", "ShowCases", "SimpleTraits", "Statistics", "StatsBase", "Tables", "Transducers"]
git-tree-sha1 = "3504cdb8c2bc05bde4d4b09a81b01df88fcbbba0"
uuid = "f1d291b0-491e-4a28-83b9-f70985020b54"
version = "0.4.3"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "629afd7d10dbc6935ec59b32daeb33bc4460a42e"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.4"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NNlib]]
deps = ["Adapt", "Atomix", "ChainRulesCore", "GPUArraysCore", "KernelAbstractions", "LinearAlgebra", "Pkg", "Random", "Requires", "Statistics"]
git-tree-sha1 = "ac86d2944bf7a670ac8bf0f7ec099b5898abcc09"
uuid = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"
version = "0.9.8"

    [deps.NNlib.extensions]
    NNlibAMDGPUExt = "AMDGPU"
    NNlibCUDACUDNNExt = ["CUDA", "cuDNN"]
    NNlibCUDAExt = "CUDA"
    NNlibEnzymeCoreExt = "EnzymeCore"

    [deps.NNlib.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    cuDNN = "02a925ec-e4fe-4b08-9a7e-0d78e3d38ccd"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NameResolution]]
deps = ["PrettyPrint"]
git-tree-sha1 = "1a0fa0e9613f46c9b8c11eee38ebb4f590013c5e"
uuid = "71a1bf82-56d0-4bbc-8a3c-48b961074391"
version = "0.1.5"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenML]]
deps = ["ARFFFiles", "HTTP", "JSON", "Markdown", "Pkg", "Scratch"]
git-tree-sha1 = "6efb039ae888699d5a74fb593f6f3e10c7193e33"
uuid = "8b6db2d4-7670-4922-a472-f9537c81ab66"
version = "0.3.1"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4e5be6bb265d33669f98eb55d2a57addd1eeb72c"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.30"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyPrint]]
git-tree-sha1 = "632eb4abab3449ab30c5e1afaa874f0b98b586e4"
uuid = "8162dcfd-2161-5ef2-ae6c-7681170c5f98"
version = "0.2.0"

[[deps.PrettyPrinting]]
git-tree-sha1 = "22a601b04a154ca38867b991d5017469dc75f2db"
uuid = "54e16d92-306c-5ea0-a30b-337be88ac337"
version = "0.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

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

[[deps.ScientificTypes]]
deps = ["CategoricalArrays", "ColorTypes", "Dates", "Distributions", "PrettyTables", "Reexport", "ScientificTypesBase", "StatisticalTraits", "Tables"]
git-tree-sha1 = "75ccd10ca65b939dab03b812994e571bf1e3e1da"
uuid = "321657f4-b219-11e9-178b-2701a2544e81"
version = "3.0.2"

[[deps.ScientificTypesBase]]
git-tree-sha1 = "a8e18eb383b5ecf1b5e6fc237eb39255044fd92b"
uuid = "30f210dd-8aff-4c5f-94ba-8e64358c1161"
version = "3.0.0"

[[deps.ScikitLearnBase]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "7877e55c1523a4b336b433da39c8e8c08d2f221f"
uuid = "6e75b9c4-186b-50bd-896f-2d2496a4843e"
version = "0.5.0"

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

[[deps.ShowCases]]
git-tree-sha1 = "7f534ad62ab2bd48591bdeac81994ea8c445e4a5"
uuid = "605ecd9f-84a6-4c9e-81e2-4798472b76a3"
version = "0.1.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

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

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StableRNGs]]
deps = ["Random", "Test"]
git-tree-sha1 = "3be7d49667040add7ee151fefaf1f8c04c8c8276"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "5ef59aea6f18c25168842bded46b16662141ab87"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.7.0"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.StatisticalMeasures]]
deps = ["CategoricalArrays", "CategoricalDistributions", "Distributions", "LearnAPI", "LinearAlgebra", "MacroTools", "OrderedCollections", "PrecompileTools", "ScientificTypesBase", "StatisticalMeasuresBase", "Statistics", "StatsBase"]
git-tree-sha1 = "b58c7cc3d7de6c0d75d8437b81481af924970123"
uuid = "a19d573c-0a75-4610-95b3-7071388c7541"
version = "0.1.3"

    [deps.StatisticalMeasures.extensions]
    LossFunctionsExt = "LossFunctions"
    ScientificTypesExt = "ScientificTypes"

    [deps.StatisticalMeasures.weakdeps]
    LossFunctions = "30fc2ffe-d236-52d8-8643-a9d8f7c094a7"
    ScientificTypes = "321657f4-b219-11e9-178b-2701a2544e81"

[[deps.StatisticalMeasuresBase]]
deps = ["CategoricalArrays", "InteractiveUtils", "MLUtils", "MacroTools", "OrderedCollections", "PrecompileTools", "ScientificTypesBase", "Statistics"]
git-tree-sha1 = "17dfb22e2e4ccc9cd59b487dce52883e0151b4d3"
uuid = "c062fc1d-0d66-479b-b6ac-8b44719de4cc"
version = "0.1.1"

[[deps.StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "30b9236691858e13f167ce829490a68e1a597782"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "3.2.0"

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

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "e579d3c991938fecbb225699e8f611fa3fbf2141"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.79"

    [deps.Transducers.extensions]
    TransducersBlockArraysExt = "BlockArrays"
    TransducersDataFramesExt = "DataFrames"
    TransducersLazyArraysExt = "LazyArrays"
    TransducersOnlineStatsBaseExt = "OnlineStatsBase"
    TransducersReferenceablesExt = "Referenceables"

    [deps.Transducers.weakdeps]
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    OnlineStatsBase = "925886fa-5bf2-5e8e-b522-a9147a512338"
    Referenceables = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

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

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "323e3d0acf5e78a56dfae7bd8928c989b4f3083e"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.3"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═474a99e2-9032-11ee-2d38-95a5b97c5516
# ╟─7a2fb632-ff40-41b7-bbd2-cc08cb3ed9a9
# ╠═798913b3-a263-40e9-96df-35b1c5d68acf
# ╟─0ee80ce8-a007-4e26-8dd4-dbf0938fd96a
# ╟─8344e755-ffc6-4bb3-ac3b-e2a737033030
# ╠═6c5de159-e6b6-459b-96e2-3feeff8a4b70
# ╟─1bfc9917-68ac-415a-aea3-336728d39b37
# ╠═2079416a-f031-4313-bb81-0b51b147904b
# ╠═85ef2d6b-db0c-49e4-857f-01622f96e7eb
# ╠═6bbb67b2-f25c-48ed-938c-e6479c29aff4
# ╟─235ca537-f55f-4842-b81e-f791d67b67b4
# ╠═13bb7c17-1e87-46b1-bdd1-25441adc20b7
# ╟─4b4dadf7-fbb3-475f-902d-391c8839b78d
# ╠═13c49081-8bb4-4766-bf8b-5fc53b7246bf
# ╟─766bf320-4ae5-4124-8031-1f79810e086c
# ╠═fce0a140-e63b-4e17-9c20-a9fef3797319
# ╠═74d6dcc1-0037-47ce-8e1d-6dc46771ff62
# ╠═f2c65c26-f1c4-4567-b522-4669a4d096f7
# ╟─c3234c05-bf00-4bca-ac9e-268698d9f029
# ╠═ecdebdad-1d76-4f60-80c7-926200119bec
# ╠═e5404658-5aee-4dcd-822c-28a318cf0953
# ╟─b30728ba-cb35-4d3d-b7b2-e62cf90f9e10
# ╟─a0b1219f-02a7-4a2b-9b76-d525033b2ab1
# ╠═00a7cba8-8e18-4be6-acbe-f9b089a8def6
# ╟─b536589e-f7ad-4d81-a532-7bcd27f12984
# ╠═284f5c91-c788-45f1-8792-f8d63b6aa627
# ╠═a159ffbf-07c1-4bb2-b45d-5a2dadeb2271
# ╠═c4f4f032-a784-44a9-a258-1f00e682d588
# ╠═3cc0b04d-6c56-4599-9680-f1b05ccf6b20
# ╟─08999fb3-e10b-4f64-b0cc-d41c21d4f3ed
# ╠═9519d45b-48d9-4287-a8c8-dae8a1551b0d
# ╠═3dd2216b-18fe-4182-bd11-f8027ce66e1f
# ╟─7139aa61-c887-4124-bad3-a11790a9fc85
# ╠═e060deb3-46a6-41f8-b341-0f4597a368a9
# ╠═6d7d7024-2fdc-4ea5-8e45-767c2a684f80
# ╟─1bd17442-1b24-486e-b1fb-1f9c9ba1d30d
# ╠═15919fa0-59d6-4590-9af1-8708bbb62c2e
# ╠═4330b6e4-1da1-4867-940b-c874255c80b9
# ╟─a2e0f1b9-2173-4dd7-be7b-78f1d3b16f28
# ╠═869ad4f0-9065-4362-b86b-0d70c58a6fbe
# ╟─8b269dd4-5366-411b-93b8-143d98f8eb64
# ╠═cf091683-25d2-4249-bab8-7dd3b051b78c
# ╟─16986288-495e-4204-ad39-28a2afb66ea8
# ╠═97248a11-ce38-490f-8fc9-a6f885297885
# ╠═6c32a7b2-9209-472e-9bcb-0a3c6fe77745
# ╠═3a45e417-649b-4bab-a121-4ede48c2fc94
# ╠═fe35ac8f-baa5-42df-8bb4-aaab27595e46
# ╠═c58e547e-9165-48d7-9942-8ec11e928939
# ╟─338197fd-4792-4ea2-b9be-124d3ee4f684
# ╟─ae762710-6f96-4575-a9ab-86a50e559bc6
# ╠═05721e0d-91ba-4460-9230-a18906c17e98
# ╟─9fec7844-aad4-400a-a0f6-a17d1a447b10
# ╠═1bfb7cc7-a89a-4ce7-aa3e-3cab2258b0d1
# ╠═75e4e8e3-6f26-4b7b-b87c-2fb8e0a13c4f
# ╠═83d7ad6e-f7cd-4e70-8b38-0f06a6020dcb
# ╟─a02e8b6e-5fab-4b20-a3d8-6abc4e7c5d40
# ╠═6c689670-d6cb-417b-86e6-0253b3894254
# ╠═a5a9c896-2114-4b07-adc8-2873e6ad93c2
# ╟─c2d137d2-b65e-4669-a393-65887233f922
# ╠═bd38191a-c57d-4dc4-ad71-814b782f1432
# ╟─755fb8bb-7230-48d5-ae60-448fcb217c52
# ╠═22edcd12-5b58-49c1-9fb5-4cc8f7b1dffb
# ╠═07694d8c-29f4-4651-9302-bc997cc38071
# ╟─ab5daca3-aabb-49b8-b863-014cab8ffca9
# ╠═d6300b07-45cc-4012-aa6e-fc717144d57e
# ╟─a80849b4-e961-4613-869b-24c47d5db1c6
# ╟─ac9ddcb0-96cd-4d73-8314-07e714a2025e
# ╠═abe1d9c3-6509-47a9-884d-9fbd36d13d45
# ╠═bebc6df9-b57e-486b-ab37-4aa39fdb3a6e
# ╠═f08ef805-47db-4e1d-9fa4-0c604d71f8ef
# ╟─f696cad1-5eb2-4829-89e0-40247dcca90c
# ╠═b839ac95-daba-4b39-97a9-27080ffd6999
# ╟─7db8e1cd-a3f6-4ca9-9864-b7fce67fe67b
# ╠═dcd88f53-4533-4746-8b89-50a6ee7934b2
# ╟─56008d6c-0bfc-4418-bf8b-26c1872a854c
# ╠═96616d0e-1f77-4589-b1a5-9ea15dc1a38f
# ╠═3ae5298a-1284-4c5b-9fd8-cce449f116ed
# ╟─6b359608-f19f-4210-82fa-5a656e6c2df5
# ╠═437344cb-89b4-4df7-896b-9c50f7c9fe20
# ╟─b78034cf-d2e0-487c-a3bc-6c2e7e0aad6b
# ╠═929b3de2-2c41-43b7-b25d-7c54d73682c3
# ╟─b6f069a6-fdb8-4617-88fe-fe65e7b10b10
# ╠═0eee807f-e09b-471a-9ab7-53345dce7ee6
# ╟─c398af14-f25e-493f-a2ae-0fcaf240eafc
# ╠═0c4f87ec-daee-4670-bd08-298f74543aab
# ╟─4c57e45b-4d11-4ec7-8d3d-c437f2ab10c1
# ╟─ecfe89e3-3d3f-4113-b720-9c22dc8d33a4
# ╠═11185a67-0f19-4bc2-b651-2b01915c9159
# ╠═d8683ab5-8f70-4ae8-a060-8adb6bea846f
# ╟─262bf688-0178-4150-aeba-e257242117a5
# ╟─d9dd8372-67c1-4fea-badf-77a8cef4e15b
# ╠═e810a496-1d60-48ca-b7e9-c741113597b1
# ╟─a08bfc8c-cb47-49ec-95a3-9055fdc20ce6
# ╠═f1b39c2e-7e47-4535-882f-607b02ea82f3
# ╟─bc97582d-6e2f-4636-be46-58e7b4ab5deb
# ╠═69d8cff1-b68c-41c1-b171-40a9712b94ba
# ╟─07ec992c-530f-4bef-a603-15bddaf74817
# ╠═534903b7-0ffa-4b7f-b6a4-60581419854a
# ╟─428421eb-8dd8-4692-841d-bbf1b44789e8
# ╠═2d9baa60-9b06-4bd3-be1c-5c086c98512a
# ╠═2d98cfde-15ea-4154-b7e3-c3a7a7f798ce
# ╠═7ffbaf58-f3b1-4002-93d6-5ded742ee2fb
# ╟─f3215352-4f86-4f30-a4ee-0bf2d40bc43b
# ╠═348ab9d7-6f70-4891-8a8f-d9dfe4c3b8c9
# ╟─e50e1362-9169-4325-905f-7ea6ae71d8b7
# ╟─f47f6676-bda8-4011-bdbd-f90a2c615963
# ╟─6c8a368a-3fc8-4c29-9b6d-87a3d036a546
# ╠═8bb6367f-19de-4cf5-b5df-c3eb9af8745f
# ╠═16059ee1-a669-48c1-beb5-099fc55f6a50
# ╟─3b513fb7-c47b-4408-881c-9346743ebe9e
# ╠═de4841eb-0975-4209-94f1-f13cbb46fb58
# ╠═f1b30e01-044a-4499-8630-9d633abc32a5
# ╠═d3f6c9bd-291a-4c30-bc01-1bbef2435f74
# ╟─469d1d36-bcec-4a01-a2e7-c5b141e19d3a
# ╠═ee781216-8998-4073-8770-89152f5698c2
# ╟─12301fef-ca85-4be9-a1e4-dafddb72864a
# ╠═a31ea97c-2130-45dc-b705-be8e1688836d
# ╠═998cde61-0814-4177-971d-2c1bbd1382a8
# ╟─0d5265c3-ba2c-4e9e-8d8c-1cfcc1dc3080
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
