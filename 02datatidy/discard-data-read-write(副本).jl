### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ 54d48980-e50b-11ee-01ff-833f16130cde
using CSV,DataFrames,PlutoUI,ScientificTypes,CategoricalArrays

# ╔═╡ c56f10e8-a112-40be-a6ab-8f1f7d16e6ee
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据分析与挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			数据读写
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ f67e2900-c720-44cb-8988-800f6b8e5389
TableOfContents(title="目录")

# ╔═╡ f750d333-b7c0-4925-b224-582a488d36e9
md"""
# 数据读取
## 基本概念
### 数据
数据是数据库存储的基本对象。数据可以是数字， 也可以是其他的形式。 了解数据，一方面要关注他的**表现形式**，另一方面也要搞清楚他的**语义**。比如数字67，形式上它是一个整数。他可能是某一门课程的成绩，某个人的体重，或者某个人的年龄等。

### 对象
数据通常跟某个对象相关，即某个对象的某个数据。比如， 某个人的身高，某个学生的成绩， 某张保单的日期等等。对象可以是任何我们关注的东西。

"""

# ╔═╡ d87b0937-e13a-49a1-9a8a-313533204063
md"""
### 属性
对象通常用一组刻画其基本特性的**属性**去描述。属性有时候也叫做变量、特征、字段、维等等。 对象的基本特性内容很广泛，不同的对象属性会不同。 比如， 如果是描述人可能会有身高、体重、籍贯、职业、年龄、学历等等属性。

由于属性描述的是对象的特性， 从计算机的角度看， 通常需要将其转换为某种值或符号才能够更好的存储、表示。这种将数值或者符号值与对象的属性相关联的规则或者函数，就称为**测量标度（measurement scale）**。 

测量标度本质上是一个函数，它将一个抽象的特性转换为某种具体的值。 这里具体的值是特性的某种代表，但它跟特性之间还是会有区别的。 比如我们用0和1来表示性别的男和女，相当于把性别属性，转换成了一个整数。 很明显整数可以有多种运算，但对性别来说是不行的。 你能想象代表性别的0+1的含义吗？ 所以在实际运用中属性的含义和用来表示属性的数值或符号的含义需要认真区分。 这就牵扯到属性的类型。



"""

# ╔═╡ d07f1b1c-1b30-4663-b417-9c7663468419
md"""
### 属性类型
一般而言，我们可以根据属性的基本性质去确定转换之后的数值具有的运算。 大体而言有4种类型的属性， 他们分别对应4中类型的运算：

1. 相异性 = ≠
2. 序 < ≤ > ≥
3. 减法 + -
4. 除法 × ÷ 

|属性类型|描述|例子|操作|
| ---- | ---- | ---- | ----|
|标称|标称属性的值仅仅只是不同的名字，即标称值只提供足够的信息以区分对象（ = ≠）|邮政编码、雇员ID 号、眼球颜色、性别|众数、熵、列联相关、x2检验|
|序数|序数属性的值提供足够的信息确定对象的序(<,>)|矿石硬度、{好，较好，最好}、成绩、街道号码|中值、百分位、秩相关、游程检验、符号检验|
|区间|对于区间属性，值之间的差是有意义的，即存在测量单位(+ -)|日历日期、摄氏或华氏温度|均值、标准差、皮尔逊相关、t和F检验|
|比率|对于比率变量，差和比率都是有意义的(- ÷)|绝对温度、货币量、计数、年龄、质量、长度、电流|几何平均、调和平均、百分比变差|


在上面属性的分类中，标称属性和序数属性统称为**分类**的或**定性**的属性。这类属性通常不具备数字的大部分性质，即使是用数字表示，也需要像对待符号一样对待他们。 区间属性和比例属性统称为**定量**的或数值属性。这类属性具有数字的大部分特性。通常可能是整数值或连续值。

由于属性被测量标度数据化， 因此， 对象也就被数据化。 我们称数据化的对象为数据对象。 一个数据对象有时候也被称为一条记录，一个样本，一个观测，一个实体等等。

"""

# ╔═╡ b10da61e-f5e4-4903-adea-6000b0f66e82
md"""



### 数据集
数据挖掘中，我们接触的更多的是**数据集**。数据集可以看成是**数据对象**的集合。

**数据集的一般特性**
1. **维度** 维度是指数据集中对象具有的属性的数目。 低维度的数据和高维度的数据可能具有本质的不同。 分析高维度的数据，可能陷入维度灾难。因而在做数据处理时，可能需要怎样去减少维度，也就是维度规约。
2. **稀疏性** 稀疏性是指一个数据集中对象的大部分属性可能都是不存在的或者是0。 一个典型的例子是购物栏数据。
3. **分辨率** 通常我们都可以得到不同分辨率下的数据。 对数据挖掘来说，需要明确数据的分辨率与数据挖掘的目标是否一致。 比如，如果是为了获得股票价格的趋势，那么拿到分笔交易交易数据就需要进一步的转换； 他如果是要做实时的量化投资， 那么日线级别的股票交易数据可能就不行了。



"""

# ╔═╡ b8b97e0b-bed6-4470-bec7-ca80fc9fe746
md"""

### 常见数据集形式
常见的数据进行时包括购物篮数据， 基于图形的数据， 有序数据和矩阵形式的数据等。其中矩阵形式的数据在实际中是应用最广泛的，也是最常见的。

$$\left(\begin{array}{cccc}
    a_{11} & a_{12} & \cdots & a_{1k}\\  %第一行元素
	\vdots & \vdots & \vdots & \vdots\\
    a_{n1} & a_{n2} & \cdots & a_{nk}\\  %第二行元素
  \end{array}
\right)$$ 
一般而言， 矩阵的每一行代表一个**样本（观测）**， 每一列代表一个**特征（属性）**。 由于矩阵通常要求元素具有相同的数据类型， 而样本的属性可能具有不同类型的取值， 在Julia、Python、R等数据分析语言中， 有专门为这一类数据定制的数据结构--数据框（dataframe）。 在Julia中， Dataframes.jl包（类似于Python中的Pandas包）就是专门处理这类数据的包， 对数据分析来说， 这是一个必须了解的包。
"""

# ╔═╡ b2ec798a-0010-4c95-923a-551912ad02e5
md"""
# 2 数据读写 
## 数据读取
数据读取暂时掌握CSV和EXCEL格式的数据的读取。
1. CSV格式数据读取， 采用CSV包。参考[CSV手册获取更多细节。](https://csv.juliadata.org/stable/)

在最简单的情况下， 我们只需要指定数据的路径和要保存的类型就可以了。
```julia
CSV.read(source, sink::T; kwargs...) => T
```
- 其中source是要读取的数据的地址。
- sink，表示数据要存储的类型。

下面结合天池数据挖掘比赛-[保险反欺诈预测](https://tianchi.aliyun.com/competition/entrance/531994/information)的训练数据， 请将其赋值给train， 并做简单数据理解。
"""

# ╔═╡ c7f8779b-6a0f-44ee-b0bb-396ece1a49b8
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 3c941825-3e87-4aaa-b856-db028b6aa139
md"""
## 数据写入CSV
在竞赛提交时， 要求我们提交一份对测试集中样本是否为欺诈的两列数据框。我们可以简单操作如下：
1. 首先读取测试集
2. 然后生成一个对每一个样本的预测概率
3. 将数据构造成一个数据框
4. 将数据框写入csv文件
"""

# ╔═╡ 371af7ac-1748-47fd-aa2c-ae523a4a54d4
test = CSV.read("../data/testbx.csv", DataFrame)

# ╔═╡ 1fc27622-3fd9-4fd4-b256-9bf98b847967
yuce = rand(300)

# ╔═╡ ba168910-75a6-4f41-bd04-0225711efa42
df = DataFrame(policy_id = test.policy_id, fraud = yuce)

# ╔═╡ cd6dad36-8ed5-4091-8e68-b96af6f93bee
CSV.write("../data/tijiaoaaaa.csv", df)

# ╔═╡ d360eea2-9440-42be-b4f1-8bbddbdbdf09
md"""
# 3 数据理解
为了更好的建模，深入理解数据是必要的。首先是从语义上要搞清楚， 数据中有多少样本，字段， 以及每一个字段分别有多少种可能得取值等。

通过`size`函数可以了解数据的尺寸（即由多少行与列）。 在我们的数据集中， 有 $(size(train)[1]) 行，  有 $(size(train)[2])列。
"""

# ╔═╡ 8173fc48-7e3b-4055-9868-9f124efc023a
size(train)

# ╔═╡ 94a0e1d1-759e-470a-8f5c-33b6f9ee547e
md"""
可以通过`names`函数， 获取每一个字段的名字。 可以看到分别为$(join(names(train), ", ")). 下面给出各个字段的含义。
"""

# ╔═╡ 47efe604-8110-4cb7-a358-ea720ca1b254
names(train)

# ╔═╡ ac384ae8-299f-443a-9a72-39c6c673408b
md"""
## 字段含义
了解字段含义含义是简单的， 可以直接从文档中去了解， 我将其罗列如下：


| 字段                      | 说明                          |  | 字段                          | 说明                                   |
|:-----------------------:|:---------------------------:|:---:|:---------------------------:|:------------------------------------:|
| policy_id               | 保险编号                        |    | collision_type              | 碰撞类型                                 |
| age                     | 年龄                          |    | incident_severity           | 事故严重程度                               |
| customer_months         | 成为客户的时长，以月为单位               |    | authorities_contacted       | 联系了当地的哪个机构                           |
| policy_bind_date        | 保险绑定日期                      |    | incident_state              | 出事所在的省份，已脱敏                          |
| policy_state            | 上保险所在地区                     |    | incident_city               | 出事所在的城市，已脱敏                          |
| policy_csl              | 组合单一限制Combined Single Limit |    | incident_hour_of_the_day    | 出事所在的小时（一天24小时的哪个时间）                 |
| policy_deductable       | 保险扣除额                       |    | number_of_vehicles_involved | 涉及的车辆数                               |
| policy_annual_premium   | 每年的保费                       |    | property_damage             | 是否有财产损失                              |
| umbrella_limit          | 保险责任上限                      |    | bodily_injuries             | 身体伤害                                 |
| insured_zip             | 被保人邮编                       |    | witnesses                   | 目击证人                                 |
| insured_sex             | 被保人姓名：FEMALE或者MALE          |    | police_report_available     | 是否有警察记录的报告                           |
| insured_education_level | 被保人学历                       |    | total_claim_amount          | 整体索赔金额                               |
| insured_occupation      | 被保人职业                       |    | injury_claim                | 伤害索赔金额                               |
| insured_hobbies         | 被保人兴趣爱好                     |    | property_claim              | 财产索赔金额                               |
| insured_relationship    | 被保人关系                       |    | vehicle_claim               | 汽车索赔金额                               |
| capital-gains           | 资本收益                        |    | auto_make                   | 汽车品牌，比如Audi, BMW, Toyota, Volkswagen |
| capital-loss            | 资本损失                        |    | auto_model                  | 汽车型号，比如A3,X5,Camry,Passat等           |
| incident_date           | 出险日期                        |    | auto_year                   | 汽车购买的年份                              |
| incident_type           | 出险类型                        |    | fraud                       | 是否欺诈，1或者0                            |


"""

# ╔═╡ 444ccedf-43e8-424f-8940-27ff430fb44d
md"""
## 字段存储类型
理解数据一个重要的操作是理解数据的存储情况， 即每一个字段是怎么存储的。 简单来说， 你可以将一个dataframe的每一个列看成是一个向量。 一个dataframe就是多个长度相同的向量组合而成的。 我们可以通过dataframe的`名字.字段`的形式去查看每一个字段。 有时候， 知道每一列是一个向量是不够的， 我们还希望了解， 向量中的每一个元素分别是什么类型的数据。 因为数据类型不同， 将决定其操作方式的差异。可以使用`eltype`函数， 获取一个向量中，元素的数据类型。 以查看数据中，年龄字段的数据类型为例， 可以看到其元素类型是：$(eltype(train.age)).
"""

# ╔═╡ 6cff2ee9-a941-43c2-843e-4ce3c85b1585
eltype(train.age)

# ╔═╡ 8077beaf-2116-44ba-96ea-738acd700773
typeof(train.age)

# ╔═╡ ab6bf9e2-40be-46b7-84dc-b94a39b2b057
md"""
如果要知道每一个字段的数据类别， 先需要通过`eachcol`构造一个由dataframe的字段构成的容器（可迭代对象），进而判断每一个字段的元素的数据类型。 


"""

# ╔═╡ 12fbc579-cc73-4086-bfa4-80ff672960d3
eltype.(eachcol(train))

# ╔═╡ 8bece336-c65c-41bd-86d7-9158daf783fd
md"""
由于很多字段数据类型是重复的，因此， 可以通过unique去获取去重之后的数据类型情况。下面的结果告诉我们， 数据中包含了$(join(unique(eltype.(eachcol(train))),", "))等多种类型的字段。 大体来说， Int64, Float64是数值类型， Date是日期类型。 此外， 还有各种类型的字符串。
"""

# ╔═╡ 9f48d949-2efb-4110-944b-b1c039c2d2ba
unique(eltype.(eachcol(train)))

# ╔═╡ 52013ea4-128f-4e2c-bdd2-cd2b714a566b
md"""
## 不同类型变量获取
有时候， 我们可能需要获取某种类型的所有字段， 这可以通过中括号的形式获取，使用到的关键函数是：`names`.
```julia
names(df::AbstractDataFrame, cols=:)
names(df, Type)
```
names 函数可以用于获取一个数据框中的字段名， 当然， 也可以用于获取一个数据框中所有Type类型的字段名。
下面的代码获取train中所有整型（Int）字段名。 获取了字段名之后， 我们就可以提取对应的字段了。
"""

# ╔═╡ 34bd0119-0e2d-438e-9e22-bbbf4bd4f929
names(train, Int)

# ╔═╡ 289689c9-a42d-409f-b514-4a11e456079b
md"""
如果你想单独抽取`String1`类型的字段， 可以简单使用`names(train, String1)`， 但如果想一次性把所有的字符串类型的字段都找到，用`names(train, String)`是无法获取的。这是因为String并不是数据中类似`String1`等的数据类型的共同父类型。我们可以先通过`supertype`函数获取其父类型， 用父类型来选取所有复合的子类型字段名。(更一般的，可以通过`typejoin`函数获取多个类型的共同父类型。)
```julia
julia> typejoin(String1, String3)
InlineString
```
上面的代码说明， 我们看到的`String1`等的父类型是`InlineString`。下面可以用这个类型选择所有复合的字段。
"""

# ╔═╡ f002747e-0ceb-45cc-8dd4-515d1f59b1cd
names(train, InlineString)

# ╔═╡ cad73878-cc96-4e3f-ad4b-e11124368cb6
md"""
可以看到， 这些字段:$(join(names(train, InlineString),", ")) 都是字符串类型。
"""

# ╔═╡ 9175d0a5-eb8c-4aa5-a37f-a086c90b8d74
supertype(String31)

# ╔═╡ 892427b2-ffa0-4f22-8523-c74767a7c474
md"""
类似的， 如果我们想一次性获取所有的数字类型的字段， 也需要找到一个各种数字类型的共同父类型。事实上，Number肯定是各个数字类型的父类型。 这样， 我们可以找到所有的数字类型的字段。
"""

# ╔═╡ a7569204-8677-4f3e-8cee-2e3a69e54d41
names(train,Number)

# ╔═╡ a243a924-0604-4583-857c-95975720f9e9
md"""
## 类型诊断
以上虽然可以方便的知道哪些字段是存储为什么类型的数据， 但一个常见的问题是： 数据的存储类型可能并不反映数据的语义。 如果是数值型数据，我们通常会认为是连续型的， 有无穷多种可能得取值。 如果是有限多种取值，那么应该当成是类别变量更靠谱。 但数据的存储类型可能与我们设想的并不一致。 比如， 是否欺诈对应的字段fraud被存储为一个整数， 但这应该是类别  变量。 因此， 要对数据的属性类型做进一步分析。 此外， 对文本类型的数据， 建模一般用不上， 我们可能需要对其做一定的编码转换。 比如，变成一个整数表示的类别变量。

要分析数据的存储类型和其语义是否一致， 一个关键的问题是： 判断数据的可能取值有多少个？以及，不同的取值站到样本数的比例。
"""

# ╔═╡ 17ed2a2f-96c1-46a0-9d02-2b7bc46945a0
md"""
计算某个字段包含多个不一样的值可以用前面见过的`unique`函数, 用length可以求出其数量。比如，计算`policy_state`字段有多少种可能得取值， 可以如下计算：
```julia
julia> unique(train.policy_state)
["C","B","A"]

julia> length(unique(train.policy_state))
3
```
从上面可以看到， policy_state有三种取值情况。

可以将上面的操作写成一个函数， 去返回一个字段的不同取值的数量。假定`x`表示一个数据框的一列，这个函数只要一句话就好。
```julia
jishu(x) = length(unique(x))
```
"""

# ╔═╡ 9fdb8c32-d97e-449c-8575-fb5169fbfe7e
jishu(x) = length(unique(x))

# ╔═╡ 2156bb0c-c25a-4a2a-9095-2f0dbff03e75
jishu(train.policy_state)

# ╔═╡ e75e61d9-0a52-4994-b556-5436c3bfd6ff
md"""
接下来， 我们可以统计每一个字段的不同取值数量了。这里， 我们用一个向量推导，将结果保存为一个向量。 
"""

# ╔═╡ b7b72f97-0564-4e75-ae06-856dfc5141d0
[jishu(x) for x in eachcol(train)]

# ╔═╡ 6dc203fb-6379-4d88-8899-d96052a40598
md"""
由于我们总共才700个样本， 如果一个字段的取值只有很少的量， 比如20个， 那么这个字段当成类别变量可能会更好。 怎么找到可能取值小于某一个数的所有字段呢？

下面，我们先根据上面的计数函数， 构建一个判断某一列是否可能取值小于某个阈值（n）的函数。
"""

# ╔═╡ 73197cc1-ca2d-4ab0-9e88-8b5d4e902916
pingg(x,n=20) = jishu(x) < n

# ╔═╡ 00e62772-838d-474c-887a-3e2503632e89
md"""
下面可以用定义的函数去找到所有满足条件字段。下面的代码中， `eachcol(train)`是用数据框的每一个列构成一个可迭代的容器， 其中每一个元素是一列, `pairs`函数可以将容器中取出的每一列构造成一个pair， 也就是一个`字段名=>字段值`构成的组。字段值是向量。

`for (n,v) in pairs(eachcol(train))`的作用是遍历由每一列的名字和对应的向量构成的pair， 并将其分别赋值给n, 和v。 string(n)的作用是将列名转换为字符串（默认是Symbol类型）。
"""

# ╔═╡ cdb8be44-72fd-4beb-b3d3-66dfdc7f8fdd
n1 = [string(n) for (n,v) in pairs(eachcol(train)) if pingg(v)]

# ╔═╡ eaaf9a47-19c2-4b45-842c-68ca15341322
md"""
接下来， 可以统计字符串类型的字段中， 有多少是满足条件的列， 我们可以求两个向量的交集`intersect`。 可以看到绝大部分字段都是满足条件的。 这也许并不意外， 如果你再看一下，有多少数字类型是满足条件， 可能才意外。
"""

# ╔═╡ 4e984446-61e1-4289-89bb-3a96a92a0dfb
intersect(n1,names(train, InlineString))

# ╔═╡ 7f66479b-b527-4c50-89a7-e1b76d924535
md"""
下面的结果告诉我们， 至少有6列存储为数字类型的字段， 其本质上应该是一个类别变量(如果我们把可能取值<20当成是判断字段是否为类别变量的标准。
"""

# ╔═╡ ad0c456e-f0a7-48a9-9222-42dc4130225f
intersect(n1,names(train, Number))

# ╔═╡ 38c00a69-7144-4ae6-b6b3-29a67361d6c6
md"""
通过以上分析， 我们知道， 有些字段， 虽然是文本， 但应该要表示为类别变量更好， 有些变量虽然是数字， 并其含义应该也应该是类别变量。
"""

# ╔═╡ 9ba0e85f-2081-446c-84c2-773e74a035dc
md"""
## 类型修复
对于数值类型的变量， 如果本身已经保存为数值， 后面的分析就可以直接使用了。 下面主要对类别变量进行处理。
"""

# ╔═╡ bf135ecd-8a19-494f-b312-451fdaae1fed
md"""
## 生成类别变量

有时候我们需要将数据转化为类别变量（类似R中的因子）， 这方便我们做一些统计分析。 类别变量在Julia中用CategoricalArray表示。需要使用CategoricalArrays.jl包。

主要掌握下面几个函数：
 - categorical： 将向量转为类别数组
 - levels/levels!： 查看/修改类别数组的可能取值及顺序
 - unwrap : 重新获取原始数据
"""

# ╔═╡ 6b4f0c84-935b-40ff-9ebd-122ead80191a
md"""
下面以上保险所在地区policy_state为例，演示如何将其转化为类别变量。
"""

# ╔═╡ d162902a-28a2-409b-ace6-a362869cd5ce
state = categorical(train.policy_state)

# ╔═╡ 3df9a5bd-4965-4c41-b62d-cd2db704518b
md"""
可以通过`levels`函数查看一个类别变量的可能取值情况。下面的结果表明， 该字段有三种取值， 分别为A\B\C。当然， 我们暂时不知道ABC的具体含义，但这不影响建模。
"""

# ╔═╡ 206a1df4-81c0-4c71-8695-e6304ead467c
levels(state)

# ╔═╡ dd0ab2e7-224d-4c8d-a18f-d69602fe610b
unwrap(state)

# ╔═╡ dbeec971-cda7-49a6-9000-77f0a700658e
isordered(state)

# ╔═╡ a5bfc21b-ee5a-4d45-ba4c-445a223eb864
md"""
接下来， 类似分析一下事故严重性字段。
"""

# ╔═╡ 9f328033-85cc-4a36-bb09-cf2a6275d76b
severity = categorical(train.incident_severity)

# ╔═╡ b70ecade-d025-40bc-ab48-c4f03df5dc10
levels(severity)

# ╔═╡ ce4aef6a-56a5-4200-ac2a-5537e514a2bb
md"""
可以看到有四种可能得损失程度。 这是一个类别变量， 但如果更细致的去分析， 这四个可能得取值应该有一个顺序。 也就是这是一个序数属性。 通常可以用`isordered`去判断一个类别变量是否是有序。 
"""

# ╔═╡ 19246c5b-8dbf-472d-b703-5a393f0199f5
isordered(severity)

# ╔═╡ bbe7aee2-ce64-4af2-bf78-d41e164625a2
md"""
可以看到， 默认情况下， categorical转换得到的字段不是一个有序变量。 如果要将其转换为有序变量， 可以在转化之前， 设置ordered=true参数。
"""

# ╔═╡ d158bc94-cdc9-495b-a675-3be3b93ab608
severity1 = categorical(train.incident_severity,ordered=true)

# ╔═╡ 6f05eb81-25d8-4c4b-a649-04af31919bbf
isordered(severity1)

# ╔═╡ fe0d29dc-99ce-43a4-8332-f29af678ea10
levels(severity1)

# ╔═╡ ab349d64-eb80-4471-b617-553a2d4f3a3a
md"""
此时， 虽然， severity1已经是一个有序变量， 但其取值的顺序是不对的，需求修改其取值的顺序。 一个自然的顺序应该是， "Trivial Damage" < "Minor Damage" < "Major Damage" < "Total Loss". 我们可以使用levels!函数去修改其水平， 以满足以上的顺序条件。
"""

# ╔═╡ 6597fd52-f8a6-4196-8643-5c2c799de72e
levels!(severity1,["Trivial Damage" ,"Minor Damage","Major Damage" ,"Total Loss"])

# ╔═╡ 0c69bcf6-9b81-4597-b4d4-d6cdc8b50fff
md"""
设置了有序变量的水平的顺序后， 我们可以比较不同元素的大小了。
"""

# ╔═╡ c8ccbf7d-6602-407a-9600-ab9e722d407c
severity1[1]  < severity1[2]

# ╔═╡ 3d159bb4-8afb-4222-ac17-04d2786816b1
md"""
一个类别变量， 只是在原先变量的基础上做了一点点包装。 有时候， 我们希望重新获得原始的数据， 这时候， 可以使用unwrap函数。
"""

# ╔═╡ 9db89fdf-46ae-492e-92df-84d65bfa5d69
severity1[1] 

# ╔═╡ 1f07bf9d-cea7-41f8-99f7-db1430335cd9
unwrap.(severity1)

# ╔═╡ c33e7b30-7ea5-41c8-9084-422783104016
md"""
数字类型的变量， 也可能本质上应该是类别变量， 我们可以通过同样的方式去转化。 比如， 我们可以将fraud字段转化为类别变量。 比如， 我们可以将bodily_injuries字段转化为类别变量，此外， 由于身体伤害本身应该也有严重程度的区别， 我们可以将其转化为有序变量。此时， 由于该字段已经表示为数值， 且我们也不知道数值的具体含义， 因此， 可以认为数值大小就反映了该字段取值的顺序。因而不需要调整取值的顺序关系。
"""

# ╔═╡ 8ca617be-3d51-4bc5-9da6-54603dca80ad
injur = categorical(train.bodily_injuries,ordered=true)

# ╔═╡ 035959c7-7533-41e6-8249-92a815838817
levels(injur)

# ╔═╡ 6a16f3de-08a1-4bf5-9244-de85cc396102
md"""
# 4 （补充）数据的科学类型
在做数据分析时， 我们要区分数据的存储类型（比如， 整型Int， 浮点型Float）和数据的科学类型（数据的含义）。 同样的存储类型， 可能意味着完全不同的含义， 比如，整数0和1， 既可以是通常意义下的数值， 也可能表示性别（这时候表示一个类别）。在这种情况下， 我们需要通过科学类型来区分数据表示的含义（本质上， 科学类型时是为了区分属性的类型而设计的）。 
在Julia的机器学习框架[MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/)中（包括很多机器学习模型包）， 引入了多种科学类型。如下图所示：
![good](https://alan-turing-institute.github.io/MLJ.jl/dev/img/scitypes_small.png)

上面的图展示了在MLJ中数据的表示。 除去缺失值Missing和文本值（Textual）以外， 可以将一个字段按照可能的取值数量分为有限型（取值数量有限, Finite{N}表示有N种可能的取值）和无穷型(可能的取值有无穷多种)。 有限型变量

|类别|科学类型scitype|含义|举例|
| ---- | ---- | ---- | ----|
|有限型Finite{N}|有序因子OrderedFactor{N}**序数属性**|有N种可能的取值， 取值之间存在顺序关系（大小比较有意义）|成绩：不及格，及格，良好，优秀； |
||多类别因子Multiclass{N}**标称属性**|有N种类别， 类别之间无顺序关系|性别：男女；|中值、百分位、秩相关、游程检验、符号检验|
|无穷型Infinite|连续型（Continuous）(**比率属性**）|取值是某个区间中的所有值|身高， 体重|
||计数型Count**区间属性**|有无穷多取值， 但只能是正整数|家庭成员数量；班上学生人数|

在建模过程中， 如果数据的科学类型是错误的， 很有可能导致有问题的结果， 这时候， 可以使用`coerce(data, scitype)`去实现对数据的强制类型转换。

如果要使用科学类型， 需要用到ScientificTypes.jl包。 科学类型会在后续的建模中使用， 此处暂时不做展开。
"""


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CategoricalArrays = "324d7699-5711-5eae-9e2f-1d82baa6b597"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ScientificTypes = "321657f4-b219-11e9-178b-2701a2544e81"

[compat]
CSV = "~0.10.12"
CategoricalArrays = "~0.10.8"
DataFrames = "~1.6.1"
PlutoUI = "~0.7.58"
ScientificTypes = "~3.0.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "7116913cea764426299d1b215f8768436addef40"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "679e69c611fff422038e9e21e270c4197d49d918"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.12"

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

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

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
version = "1.1.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1fb174f0d48fe7d142e1109a10636bc1d14f5ac2"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.17"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "7c302d7a5fec5214eb8a5a4c466dcf7a51fcf169"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.107"

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

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"
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

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

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

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

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
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "71a22244e352aa8c5f0f2adde4150f62368a3f2e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.58"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[deps.ScientificTypes]]
deps = ["CategoricalArrays", "ColorTypes", "Dates", "Distributions", "PrettyTables", "Reexport", "ScientificTypesBase", "StatisticalTraits", "Tables"]
git-tree-sha1 = "75ccd10ca65b939dab03b812994e571bf1e3e1da"
uuid = "321657f4-b219-11e9-178b-2701a2544e81"
version = "3.0.2"

[[deps.ScientificTypesBase]]
git-tree-sha1 = "a8e18eb383b5ecf1b5e6fc237eb39255044fd92b"
uuid = "30f210dd-8aff-4c5f-94ba-8e64358c1161"
version = "3.0.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "30b9236691858e13f167ce829490a68e1a597782"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "3.2.0"

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
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

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

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "54194d92959d8ebaa8e26227dbe3cdefcdcd594f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.3"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

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

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
# ╠═c56f10e8-a112-40be-a6ab-8f1f7d16e6ee
# ╠═54d48980-e50b-11ee-01ff-833f16130cde
# ╠═f67e2900-c720-44cb-8988-800f6b8e5389
# ╟─f750d333-b7c0-4925-b224-582a488d36e9
# ╟─d87b0937-e13a-49a1-9a8a-313533204063
# ╟─d07f1b1c-1b30-4663-b417-9c7663468419
# ╟─b10da61e-f5e4-4903-adea-6000b0f66e82
# ╟─b8b97e0b-bed6-4470-bec7-ca80fc9fe746
# ╟─b2ec798a-0010-4c95-923a-551912ad02e5
# ╠═c7f8779b-6a0f-44ee-b0bb-396ece1a49b8
# ╟─3c941825-3e87-4aaa-b856-db028b6aa139
# ╠═371af7ac-1748-47fd-aa2c-ae523a4a54d4
# ╠═1fc27622-3fd9-4fd4-b256-9bf98b847967
# ╠═ba168910-75a6-4f41-bd04-0225711efa42
# ╠═cd6dad36-8ed5-4091-8e68-b96af6f93bee
# ╟─d360eea2-9440-42be-b4f1-8bbddbdbdf09
# ╠═8173fc48-7e3b-4055-9868-9f124efc023a
# ╟─94a0e1d1-759e-470a-8f5c-33b6f9ee547e
# ╠═47efe604-8110-4cb7-a358-ea720ca1b254
# ╟─ac384ae8-299f-443a-9a72-39c6c673408b
# ╟─444ccedf-43e8-424f-8940-27ff430fb44d
# ╠═6cff2ee9-a941-43c2-843e-4ce3c85b1585
# ╠═8077beaf-2116-44ba-96ea-738acd700773
# ╟─ab6bf9e2-40be-46b7-84dc-b94a39b2b057
# ╠═12fbc579-cc73-4086-bfa4-80ff672960d3
# ╟─8bece336-c65c-41bd-86d7-9158daf783fd
# ╠═9f48d949-2efb-4110-944b-b1c039c2d2ba
# ╟─52013ea4-128f-4e2c-bdd2-cd2b714a566b
# ╠═34bd0119-0e2d-438e-9e22-bbbf4bd4f929
# ╟─289689c9-a42d-409f-b514-4a11e456079b
# ╠═f002747e-0ceb-45cc-8dd4-515d1f59b1cd
# ╟─cad73878-cc96-4e3f-ad4b-e11124368cb6
# ╠═9175d0a5-eb8c-4aa5-a37f-a086c90b8d74
# ╟─892427b2-ffa0-4f22-8523-c74767a7c474
# ╠═a7569204-8677-4f3e-8cee-2e3a69e54d41
# ╟─a243a924-0604-4583-857c-95975720f9e9
# ╟─17ed2a2f-96c1-46a0-9d02-2b7bc46945a0
# ╠═9fdb8c32-d97e-449c-8575-fb5169fbfe7e
# ╠═2156bb0c-c25a-4a2a-9095-2f0dbff03e75
# ╟─e75e61d9-0a52-4994-b556-5436c3bfd6ff
# ╠═b7b72f97-0564-4e75-ae06-856dfc5141d0
# ╟─6dc203fb-6379-4d88-8899-d96052a40598
# ╠═73197cc1-ca2d-4ab0-9e88-8b5d4e902916
# ╟─00e62772-838d-474c-887a-3e2503632e89
# ╠═cdb8be44-72fd-4beb-b3d3-66dfdc7f8fdd
# ╟─eaaf9a47-19c2-4b45-842c-68ca15341322
# ╠═4e984446-61e1-4289-89bb-3a96a92a0dfb
# ╟─7f66479b-b527-4c50-89a7-e1b76d924535
# ╠═ad0c456e-f0a7-48a9-9222-42dc4130225f
# ╟─38c00a69-7144-4ae6-b6b3-29a67361d6c6
# ╟─9ba0e85f-2081-446c-84c2-773e74a035dc
# ╟─bf135ecd-8a19-494f-b312-451fdaae1fed
# ╟─6b4f0c84-935b-40ff-9ebd-122ead80191a
# ╠═d162902a-28a2-409b-ace6-a362869cd5ce
# ╟─3df9a5bd-4965-4c41-b62d-cd2db704518b
# ╠═206a1df4-81c0-4c71-8695-e6304ead467c
# ╠═dd0ab2e7-224d-4c8d-a18f-d69602fe610b
# ╠═dbeec971-cda7-49a6-9000-77f0a700658e
# ╟─a5bfc21b-ee5a-4d45-ba4c-445a223eb864
# ╠═9f328033-85cc-4a36-bb09-cf2a6275d76b
# ╠═b70ecade-d025-40bc-ab48-c4f03df5dc10
# ╟─ce4aef6a-56a5-4200-ac2a-5537e514a2bb
# ╠═19246c5b-8dbf-472d-b703-5a393f0199f5
# ╟─bbe7aee2-ce64-4af2-bf78-d41e164625a2
# ╠═d158bc94-cdc9-495b-a675-3be3b93ab608
# ╠═6f05eb81-25d8-4c4b-a649-04af31919bbf
# ╠═fe0d29dc-99ce-43a4-8332-f29af678ea10
# ╟─ab349d64-eb80-4471-b617-553a2d4f3a3a
# ╠═6597fd52-f8a6-4196-8643-5c2c799de72e
# ╟─0c69bcf6-9b81-4597-b4d4-d6cdc8b50fff
# ╠═c8ccbf7d-6602-407a-9600-ab9e722d407c
# ╟─3d159bb4-8afb-4222-ac17-04d2786816b1
# ╠═9db89fdf-46ae-492e-92df-84d65bfa5d69
# ╠═1f07bf9d-cea7-41f8-99f7-db1430335cd9
# ╟─c33e7b30-7ea5-41c8-9084-422783104016
# ╠═8ca617be-3d51-4bc5-9da6-54603dca80ad
# ╠═035959c7-7533-41e6-8249-92a815838817
# ╟─6a16f3de-08a1-4bf5-9244-de85cc396102
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
