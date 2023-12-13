### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 2bd50632-8cd0-11ec-1f8b-fd812996df39
begin
using CSV,DataFrames,PlutoUI,CairoMakie,StatsBase,DataFramesMeta,CategoricalArrays,MultivariateStats
include("funs.jl");# 加入通用函数,
end

# ╔═╡ 0fd40122-22a8-49a0-842b-0c22e2f136fb
using FreqTables

# ╔═╡ d81022aa-1c73-4a5c-b312-3b3979bbbd7d
PlutoUI.TableOfContents(title = "目录")

# ╔═╡ 6dc4358c-bbf7-41e5-a54a-0b04efcafd7b
 html"<font size=\"80\">实验2 数据分析与处理</font>"

# ╔═╡ dac9f5fd-b531-41cc-bf24-de036de2631d
md"""
**目的与要求**
1. 了解数据的四种类型
2. 掌握CSV格式的数据的读取
3. 了解常见的统计分析函数
4. 掌握基于DataFrame的基数据分析方法
""" |> fenge

# ╔═╡ f8cbff52-6731-482f-86bf-cd8238154bb4
md"""
# 1 数据与数据集
## 数据
数据是数据库存储的基本对象。数据可以是数字， 也可以是其他的形式。 了解数据，一方面要关注他的**表现形式**，另一方面也要搞清楚他的**语义**。比如数字67，形式上它是一个整数。他可能是某一门课程的成绩，某个人的体重，或者某个人的年龄等。

## 对象
数据通常跟某个对象相关，即某个对象的某个数据。比如， 某个人的身高，某个学生的成绩， 某张保单的日期等等。对象可以是任何我们关注的东西。

"""

# ╔═╡ f886fcf2-138c-409c-aaf8-f7fe2a43a245
md"""
## 属性
对象通常用一组刻画其基本特性的**属性**去描述。属性有时候也叫做变量、特征、字段、维等等。 对象的基本特性内容很广泛，不同的对象属性会不同。 比如， 如果是描述人可能会有身高、体重、籍贯、职业、年龄、学历等等属性。

由于属性描述的是对象的特性， 从计算机的角度看， 通常需要将其转换为某种值或符号才能够更好的存储、表示。这种将数值或者符号值与对象的属性相关联的规则或者函数，就称为**测量标度（measurement scale）**。 

测量标度本质上是一个函数，它将一个抽象的特性转换为某种具体的值。 这里具体的值是特性的某种代表，但它跟特性之间还是会有区别的。 比如我们用0和1来表示性别的男和女，相当于把性别属性，转换成了一个整数。 很明显整数可以有多种运算，但对性别来说是不行的。 你能想象代表性别的0+1的含义吗？ 所以在实际运用中属性的含义和用来表示属性的数值或符号的含义需要认真区分。 这就牵扯到属性的类型。



"""

# ╔═╡ 02ac21b8-b010-45ad-9c58-98ff44e3cd47
md"""
## 属性类型
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

# ╔═╡ 8a9a7157-d49f-4515-9cc6-d03521c9293f
md"""



## 数据集
数据挖掘中，我们接触的更多的是**数据集**。数据集可以看成是**数据对象**的集合。

**数据集的一般特性**
1. **维度** 维度是指数据集中对象具有的属性的数目。 低维度的数据和高维度的数据可能具有本质的不同。 分析高维度的数据，可能陷入维度灾难。因而在做数据处理时，可能需要怎样去减少维度，也就是维度规约。
2. **稀疏性** 稀疏性是指一个数据集中对象的大部分属性可能都是不存在的或者是0。 一个典型的例子是购物栏数据。
3. **分辨率** 通常我们都可以得到不同分辨率下的数据。 对数据挖掘来说，需要明确数据的分辨率与数据挖掘的目标是否一致。 比如，如果是为了获得股票价格的趋势，那么拿到分笔交易交易数据就需要进一步的转换； 他如果是要做实时的量化投资， 那么日线级别的股票交易数据可能就不行了。



"""

# ╔═╡ b963a3c2-7aac-4d4d-9314-7c5753afdca1
md"""

## 常见数据集形式
常见的数据进行时包括购物篮数据， 基于图形的数据， 有序数据和矩阵形式的数据等。其中矩阵形式的数据在实际中是应用最广泛的，也是最常见的。

$$\left(\begin{array}{cccc}
    a_{11} & a_{12} & \cdots & a_{1k}\\  %第一行元素
	\vdots & \vdots & \vdots & \vdots\\
    a_{n1} & a_{n2} & \cdots & a_{nk}\\  %第二行元素
  \end{array}
\right)$$ 
一般而言， 矩阵的每一行代表一个**样本（观测）**， 每一列代表一个**特征（属性）**。 由于矩阵通常要求元素具有相同的数据类型， 而样本的属性可能具有不同类型的取值， 在Julia、Python、R等数据分析语言中， 有专门为这一类数据定制的数据结构--数据框（dataframe）。 在Julia中， Dataframes.jl包（类似于Python中的Pandas包）就是专门处理这类数据的包， 对数据分析来说， 这是一个必须了解的包。
"""

# ╔═╡ e16ff49f-ffe8-4d53-a104-5241cd050f61
md"""
## （补充）数据的科学类型
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
"""


# ╔═╡ d0b1c890-c872-403d-b6fd-e0addb23b799
md"""
一些其他的数据形式， 诸如时间序列、 购物篮数据、 图数据等本课程不涉及。
"""

# ╔═╡ 1edb6679-4cf1-4f5f-9b8b-ad395f2af12b
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
"""

# ╔═╡ f02f3eb0-f07f-4458-96c0-b163cc1c77c8
md"""
读取天池数据挖掘比赛-[保险反欺诈预测](https://tianchi.aliyun.com/competition/entrance/531994/information)的训练数据， 请将其赋值给train， 并做简单探索。
"""

# ╔═╡ 1925f8df-7464-4c4c-8dad-dace0d47fffb
train = CSV.read("data/trainbx.csv", DataFrame)

# ╔═╡ c0d6a811-210f-4733-b4a6-429dc5899616
typeof(train)

# ╔═╡ 1d170b7c-1d7a-4afd-91f4-8f77808d8f82
md"""
## 数据写入CSV
在竞赛提交时， 要求我们提交一份对测试集中样本是否为欺诈的两列数据框。我们可以简单操作如下：
1. 首先读取测试集
2. 然后生成一个对每一个样本的预测概率
3. 将数据构造成一个数据框
4. 将数据框写入csv文件
"""

# ╔═╡ 6c2188d5-1b46-4a79-9d9f-4ef37422c0cd
test = CSV.read("data/testbx.csv", DataFrame)

# ╔═╡ a2069fd7-a40c-4121-91b6-36460fa20f5e
yuce = rand(300)

# ╔═╡ 8102858b-1629-455c-be2f-40c28742371f
df = DataFrame(policy_id = test.policy_id, fraud = yuce)

# ╔═╡ 4885fe3d-b764-40ff-a11e-746349210791
test.policy_id

# ╔═╡ 5b95c524-3bb1-4d38-90f6-8b6dc7e8f6bb
CSV.write("data/tijiaoaaaa.csv", df)

# ╔═╡ 76eec074-8cfe-4130-98e1-8b9779c1e123
md"""
# 3 统计函数
对数据分析来说，基本的统计分析是需要知道的。由于在概率论或者统计学相关的课程中，一般都会讲解到常见的统计量。这里就不做过多的理论介绍，仅就实际中使用较多的代码，做一些演示。 数据探索分为统计分析和数据可视化两部分。 在Julia中， 统计相关的包有不少， 可参考[JuliaStats](https://juliastats.org/)了解统计有关的包。 本课程使用的基本统计工具主要来自于[StatsBase.jl](https://juliastats.org/StatsBase.jl/stable/)包。


下面对统计量作用的描述并非严谨的数学定义， 只是为了方便理解和记忆而粗略的给出， 严谨的定义请参考有关书籍。

|统计量名称| 作用 | Julia函数 |
|----|---|---|
|计数 |统计给定的区间中（默认为：min~max）某个值出现的次数  | counts|
|众数 |出现次数最多的数 | mode|
|最大值|向量元素的最大值| maximum|
|最小值|向量元素的最小值| minimum|
|p-分位数|p%的观测的最小上界；使用最多的是四分位数（p=.25, .5, .75）|quantile|
|均值|平均值|mean|
|中值|近似0.5分位数|median|
|极值|计算极大值、极小值|extrema|
|方差|计算方差， 默认是修正的| var|
|标准差|标准差|std|
|偏度|统计数据分布偏斜方向和程度|skewness|
|峰度|分布的尖锐程度， 正态分布，峰度为0|kurtosis|
|截断|去掉最大、最小的部分值（基于截断后的数据做统计被称为截断统计或鲁棒统计）|trim|

"""

# ╔═╡ 0e6317ea-b57f-462e-8bdd-2723c6315aa1
countmap(collect(train.policy_state))

# ╔═╡ 9e73f954-1de4-445d-baf4-0a0bcaac2071
trim

# ╔═╡ c2dcae44-0be0-48d1-8934-c6947eaacabc
mean(collect(trim([5,2,4,3,1], prop=0.2)))

# ╔═╡ e3758659-83c9-430b-8dda-e6345e9e1125
collect(train.policy_state)

# ╔═╡ d9d28ede-936a-4283-a4e2-ba92f33fc8ff
md"""
有时候，我们可能需要做列联表分析， 尤其是对有限取值的变量。
"""

# ╔═╡ 16ef557a-8194-45e4-ab6e-79dcbd661f45
md"""
[FreqTables](https://github.com/nalimilan/FreqTables.jl)
"""

# ╔═╡ 967b9ad5-2293-420e-8e8c-f6f34405f4f3
freqtable(train.insured_sex,train.fraud )

# ╔═╡ 267e18dc-5e8e-4929-b604-7752d965749e
md"""
# 4 DataFrame操作
## DataFrame简介
DataFrame是数据分析中非常核心的数据结构。 在R、Python中都有相关的包多DataFrame进行分析。在Julia中， [DataFrames.jl](https://dataframes.juliadata.org/stable/)是DataFrames分析的核心包。

一个DataFrame， 可以看成是一个Excel的工作簿。 如上面的竞赛数据， 通常每一列是一个**字段(特征)**， 每一行代表一个**样本**。从数据形式上看， 每一列可以看成一个**向量**(事实上是NamedTuple)，因此，一个DataFrame也可以看成是多个向量在水平方向排列而成。

基本的DataFrames操作涵盖内容非常丰富， 下面简单介绍一下， DataFrames的创建与数据提取。更高级的操作会结合其他工具。



"""

# ╔═╡ bd88c23c-e26c-4451-98b0-3096bc21cc3c
md"""
## 创建DataFrame
###  1. 用DataFrame构造
我们说直接用类型名，当成函数调用。相当于调用类型的构造函数。
"""

# ╔═╡ d7fbd065-18d1-4b48-8565-3c7146023229
df1 = DataFrame(A=1:4, B=["M", "F", "F", "M"])

# ╔═╡ d1e0a88f-e253-49ad-a682-f3b5597d63e4
md"""
### 2. 按列构造
"""

# ╔═╡ fa6e0eee-8ac5-4ff3-a48e-1ed8f6c47974
df2 = DataFrame()

# ╔═╡ df472126-e64c-43e1-9572-6e6ac669adc6
df2.A = [1,2,3]

# ╔═╡ c22d5028-935e-4705-9487-af58fd3c50a0
df2.B = string.('a' : 'c')

# ╔═╡ 70aa6073-90a1-4c43-a999-cb7a8fa08134
df2

# ╔═╡ f872d549-75e4-4df0-9e95-2144ba510b70
md"""
## 从dataframe中抽取数据

### df[row, col]模式

给定一个dataframe df, 从中抽取数据的通用格式是： df[row, col]， 用于抽取指定row， 和col的元素。

其中：  row 可以是
- ： 冒号，表示选择所有的行
- ！ 也是选择所有的行， 但此时是没有复制的选择。
- m:n 第m到n行
- [i,j,...] 指定的第i,j,...行
- (df.A .> 500) .& (300 .< df.C .< 400): 逻辑运算， 满足给定条件的行
- in.(df.A, Ref([1, 5, 601])) ： 第A列在某个集合中的行。 精确匹配某些值对应的行。
- in([1, 5, 601]).(df.A)： 效果同上， 单参数调用in返回一个函数， 函数作用到第A列上， 返回逻辑值。

col的写法更多， 

- ： 冒号， 表示所有的列
- [:colname1, :colname2, ...] 选定的列， 注意中括号。 如果没有中括号，且只选一列， 返回结果会变为向量。
- ["colname1", ":colname2", ...] 选定的列， 注意中括号。 
- Not, Between, Cols and All 用于构造列选择器。 
"""

# ╔═╡ 4e4de5a0-32d2-48de-ab32-1b9cbd94ae44
md"""
### 初步探索
一般， 我们读取进来一份数据，首先要看看是否存在明显的问题。这时候，可以通过产看一些基本信息做大致了解。
"""

# ╔═╡ d47028ac-6365-4675-95d9-10fdb4179b04
# 查看前面5行
first(train,5)

# ╔═╡ 262d0a9d-4f5b-4b42-9490-d3ffa8fefd91
#查看后面5行
last(train, 5)

# ╔═╡ 73e7dfe0-34bb-4634-b46d-eea424e461dd
md"""
describe是一个更全面的查看数据集的函数
"""

# ╔═╡ 027e832d-4841-44d1-a218-24d67337c295
describe(train)

# ╔═╡ b6139b96-9dfe-45dd-9610-81c0ac3f56ec
md"""
### 行提取示例
下面我们从数据框train中提取一些数据，演示df[row,col]的使用。
"""

# ╔═╡ c83f4008-6f70-4c2b-b775-6a37f926a178
# 提取第1,3,5行
train[[1,3,5],:]

# ╔═╡ 2bd80968-cb1d-4924-ad1c-cc418b9d2731
md"""
下面提取60岁以上的样本
"""

# ╔═╡ 44f3353d-2b35-4a72-b611-2ca432c1b444
train[train.:age .> 60,:]

# ╔═╡ c965be35-1a6e-4601-a484-653dab41db79
train.incident_hour_of_the_day

# ╔═╡ 8fad14b4-1fe7-4797-ac3a-7d9151c1e9e6
md"""
### 列提取
"""

# ╔═╡ ba9826e6-54f5-4710-a9bc-60f0aa7b8546
train[:, :age]

# ╔═╡ a39be9ee-494b-4c38-bc6e-30fd039b33d1
train[:, "age"]

# ╔═╡ 6d7e35a8-3108-4de0-a29e-82bb8a9caf24
train[:,2] # age是第二列

# ╔═╡ 017e8060-51f4-4a3f-af3e-458667588b35
md"""
如果要一次性提取多列，需要将相关的列组织到向量中。其他都是类似的。
"""

# ╔═╡ a12e3f8d-fe78-41d8-a291-50e2b0a3ef65
train[:, [:age, :customer_months]]

# ╔═╡ 031e6d68-2ea4-446a-a008-5b42c1d08492
train[:, [2,3]]

# ╔═╡ 03af79e9-b6ad-441d-8c3a-c2cff186d4c5
train[:, ["age", "customer_months"]]

# ╔═╡ 37ab912c-6958-4b24-9c54-eb9f388aba5e
md"""
### 同时选择行与列
上面单独选择行或者列时， 对应的列和行我们都是用冒号：， 这表示选择所有列和行。 我们可以把行和列的所有选择同时写上， 去实现对相应的行和列的选择。

比如，我们要选择60岁以上的用户，同时查看其查看成为用户的月份。
"""

# ╔═╡ af3f11bd-3e33-475e-8f46-52f47ea1f427
train[train.age .> 60, :customer_months]

# ╔═╡ 237eb3af-d2b7-4fec-b40b-90f2cd20ab79
md"""
### 统计分析
提取行列是为了对数据进一步分析， 比如我们想计算顾客的平均年龄,最大值,等等
"""

# ╔═╡ 7094ec80-7772-4ada-a6a2-6c2284e47a35
mean(train[:,:age])

# ╔═╡ 557ee32c-c09f-423b-b049-5c48899fb94b
maximum(train[:,:age])

# ╔═╡ 4469604c-4b5a-4eba-bbd0-bf03e6d9ffa4
md"""
60岁以上的客户成为客户的平均时长是：$(mean(train[train.age .> 60, :customer_months]))，都是老客户。
"""

# ╔═╡ f8e82a19-daad-47e2-898b-b515fe287ab2
mean(train[train.age .> 60, :customer_months])

# ╔═╡ b7491f99-98d8-4747-a484-539308d772d8
md"""
## 高级操作
在数据分析时， 我们经常需要根据某些条件，选择某些样本，某些字段，计算一些统计值。 因此，这些操作被优化成相应的宏或函数， 可以让我们非常非常的进行操作。 下面介绍一下DataFrame的高级操作方法， 这里主要是介绍DataFramesMeta.jl包的基本使用。

在对DataFrame做数据分析时， 常见的需求是：
```
1. 选择某些特征（特征筛选）(@select)
2. 根据某些特征（列）， 计算新的特征（列）(@transform,@select)
3. 选择满足某些条件的样本（行）(@subset)
4. 按某些字段（列）排序(@order)
5. 求某些字段的统计量（汇总）(@combine)
6. 按某些字段分类后，求汇总信息（分类汇总； 数据透视表）(groupby, @combine)
7. 以上操作2个及以上同时操作。（@chain）

下面是操作函数的总结：


|宏或函数|按行版本|描述|
|---|---|---|
|@select|@rselect|选择列|
|@transform	|@rtransform|	创建新的列|	
|@subset|	@rsubset|	选择行|	
|@orderby|	@rorderby|	行排序|	
|@combine|		|汇聚信息|	
|groupby|		|按列分组数据|
"""

# ╔═╡ 3b1c62be-ffd3-49f7-bf72-9ae117d294f8
# dfcb9933-0880-4c76-9c7f-ba19af6abe88
md"""
### 选择列(字段) @select
很明显， 数据有太多字段， 不可能一下分析那么多字段。我们选择一些感兴趣的先分析一下。 这里我们选择几个跟被保险人有关的信息：

- age	年龄
- customer_months	成为客户的时长，以月为单位
- policy\_annual\_premium	每年的保费
- umbrella\_limit	保险责任上限
- insured\_sex	被保人性别：FEMALE或者MALE
- insured\_education\_level	被保人学历
- fraud	是否欺诈，1或者0

注意：

1. 宏的使用方法，既可以像函数一样， 后面的参数用逗号隔起来， 参数列表用括号括起来。也可以不加括号和逗号。
2. 在宏调用过程中（仅限这里介绍的宏）， 第一个参数永远是要处理的数据框，后面的参数中， 用到的列名必须要加冒号
3. 参数列表中， :newname = :oldname 的形式表示**对列选择的同时重命名**
4. 为了后续方便， 我把选择结果保存在data中， 这样后面就可以直接处理data了

"""

# ╔═╡ 49e4d124-85d0-4612-8f7b-85b6205dd44a
data = @select train :id = :policy_id :age :customer_months 	:premium = :policy_annual_premium	:limit = :umbrella_limit	:sex = :insured_sex	:edulevel =	:insured_education_level	:fraud

# ╔═╡ b5f156ce-e4ef-4f61-9775-70e6fc0d1fcb
# 93f0b359-5e3f-4e90-af7c-daaf33c19e82
md"""
有时候， 我们可能碰到要选择的列的名字保存在外部的变量， 或者一个字符串中， 这时候，我们需要使用\$符号。**注意：**这时候不是加冒号。
"""

# ╔═╡ 3c43a6a3-229f-49b0-bb77-6a1d3d34afe2
name1 = :age

# ╔═╡ fce707c3-1155-49a6-9c96-74c766f7c8fc
name2 = "customer_months"

# ╔═╡ e94a0599-3544-4d18-b8f8-3fe2f7143143
@select train :policy_id $name1 $name2

# ╔═╡ 60a23867-6861-4b70-b85e-8c7d581fe591
# e0afe6ff-36aa-4625-8010-c59dcbb92a40
md"""
### 选择行(样本) @subset and @rsubset
这里我们使用选择好字段的新的数据框去操作， 因为我们已经重命名了。

选择行在Excel里面就是数据筛选。 现在， 假定我们要找到所有年龄大于或等于40岁的样本。 
"""

# ╔═╡ c4dec776-9b83-4360-ba06-11de5091ff1e

@subset data :age .>= 40

# ╔═╡ b6c973c9-cfec-499e-969f-50bdb126e284
# 902f165a-5733-45ea-83b3-ab43d8c6bfa5
md"""
上面的`:age .>= 40`是一个条件表达式， 希望你注意到了大于符号前面有个点号， 这表示的是按元素比较大小， 因为:age是一个向量， 不能直接把向量和数值做大小比较， 而是应该把向量的每一个元素跟40去比较。

你可能会觉得点运算比较麻烦， 那么你可以使用按行操作的版本。 这时候， 条件会按行去执行， 每次拿来比较的就是单个元素， 而不是整列形成的向量了。 你可以选择你喜欢的方式， 不过建议你还是要熟悉Julia的点运算， 因为它很常见。

为了简单起见， 下面的选择采用按行版本。
"""

# ╔═╡ a2743bff-ab93-4c72-921b-73407e7be70b

@rsubset data :age > 40

# ╔═╡ 5f76d122-66eb-4533-8838-0d5d317fe6ec
md"""
很多时候， 我们可能会需要选择通常满足多个条件的列。 这时候， 可以将条件依次写出来。

假定我们要选择，年龄在40岁以上， 性别是男性， 又是欺诈的样本。 注意，比较是否相等是两个等号。
"""

# ╔═╡ 45ac5802-4be6-4dc3-975c-5c0c6fa6a6a2
@rsubset data :age >= 40 :sex == "MALE" :fraud == 1

# ╔═╡ c3b47b26-baaa-40f1-ba7e-3f860665596f
md"""
上面的写法虽然没错， 但可以更整洁， 我们可以将所有的条件用`begin end`形成的代码块, 每个条件占一行， 还可以注释
"""

# ╔═╡ 512099a1-17c7-4568-902b-c15783ae3d94
@rsubset data begin
	:age >= 40 # 年龄大于40
	:sex == "MALE"  # 性别是男性
	:fraud == 1 # 欺诈样本
end

# ╔═╡ e416a593-f64e-4455-bb42-f9ed0a8327ae
md"""
如果你喜欢函数调用的方式， 类似R语言， 也可以像下面这么写， 不过我们统一用宏的方式去写。
"""

# ╔═╡ 779e7e83-4cec-49fa-8906-3f344d3c8a0e
@rsubset(data ,:age >= 40 ,:sex == "MALE", :fraud == 1)

# ╔═╡ 45f4f45e-dbc3-4321-af73-f4308e3e89aa
md"""
有时候， 一个字段可能有多个取值， 你希望过滤出其中的部分。 比如， 你希望获得所有学历是研究生或博士生的样本， 当然可以使用"或"运算连接多个条件， 如`(:edulevel ==  "MD" ||  :edulevel ==  "PhD" )`。 但我们有更高效的做法。 简单来说就是把想要的取值构成一个集合， 然后去按行判断， 相应的字段取值是否在（in）该集合中。 集合可以用Set构造， 或者直接是向量也行。
"""

# ╔═╡ 9a385d37-042f-4784-8a5d-f3716995a1a1
@rsubset data :edulevel == "MD" || :edulevel == "PhD"

# ╔═╡ b8a58b6e-37fc-49b6-ab7e-c313e299f816
xueli = ["MD", "PhD"]

# ╔═╡ efb3ba14-2f87-4154-a9dc-bdefceeffd2b
@rsubset data :edulevel in xueli

# ╔═╡ 5fa8a818-f928-4a3d-bccb-70bc8ff31c82
md"""
你可以使用`>, <, >=, <=, !=, in` 和 `&& || !`去构造和组合出复杂条件
"""

# ╔═╡ 970da59b-5b22-48f4-bd89-193e9018af38
# f110d95f-2a78-4afc-9079-69072a323f12
md"""
### 管道操作@chain
数据分析中， 我们常常许多要对数据做多次处理、加工。 通常， 上一个操作得到的数据，会进入下一个操作继续加工。这相当于， 数据流过一个管道， 经过不同的环节， 进行不同的处理。 这类操作被称为管道操作， 可以使用`@chain`实现。 

假定我们要选择年龄大于40岁， 性别是男性的样本， 但我们又只想看到id列和是否欺诈两列。 如果不使用管道操作， 我们需要这么做：
1. 首先， 把需要的行选出来， 结果保存在临时变量data1中
2. 然后， 从临时变量data1中， 选择需要的列
"""

# ╔═╡ 88e2e0c4-2a71-4ed8-a197-92bed009637b
begin
data1 = @rsubset data :age >=40 :sex == "MALE"
data2 = @select data1 :id :fraud
end

# ╔═╡ 178a6620-db6a-4e16-ba76-a997e7bbba1a
md"""
很明显， 上面的操作引入了一个临时变量， 浪费了脑力（取名字不是容易的事）， 如果顺序操作的次数很多， 这种方式会很麻烦， 用管道操作就方便很多了。

下面的@chain宏， 表示管道操作。 其第一个参数是要操作的数据 data, 第二个参数是后面的一系列操作函数， 用`begin ... end`括起来了。 数据data 首先 流入 @rsubset， 这时， 这个宏第一个参数不再是数据框， 默认的就是data。 经过第一个宏处理之后， 会生成一个新的数据框， 这个数据框流入第二个宏@select， 同样，这个宏也不需要输入数据参数。

"""

# ╔═╡ 0005ca01-a71b-447c-8441-69621e6bf4b8
@chain data begin
	@rsubset  :age >=40 :sex == "MALE"
	@select  :id :fraud
end

# ╔═╡ 2f3f0373-1864-4f41-b092-fb5294de37f6
md"""
接下来， 我们所有的操作都将用管道操作的方式。
"""

# ╔═╡ ca35af98-91d6-450d-b5c8-cb256b23cb4d
md"""
### 重新排序行@orderby
如果想要对数据按照某些字段排序， 可以简单的将字段列出来

下面按照年龄和成为客户的时间排序：
age	customer_months
"""

# ╔═╡ 129b5d72-64f2-422b-8c1c-ff7721476c42
data

# ╔═╡ 64726cfa-db72-4871-8d90-5e31ef0c6d59
@orderby data :age	:customer_months

# ╔═╡ b4d3c8de-e7ba-46d5-9f6e-b461692494dd
md"""
默认的排序是按照升序排的， 你可以在变量上加上负号实现降序排列
"""

# ╔═╡ bcf0320d-ae9f-45a1-940a-a3e5e4eeb061
@orderby data begin
	:age	 # 年龄是升序
	-:customer_months # 成为顾客的时间是降序
end

# ╔═╡ c1cefc17-af10-458a-adf4-074bd642b20d
md"""
现在， 让我们把需求弄得复杂一点， 下面的代码含义很清晰， 最后的first 是用于查看一个数据框的前n行。这是一个普通函数， 因此，前面没有@符号。
"""

# ╔═╡ 71cf889f-8680-40aa-a4e1-c9ef0c198cdd
@chain data begin
	@select :age :premium :sex :fraud
	@rsubset :age >=40
	@orderby :premium
	first(10)
end

# ╔═╡ 5ed02a0b-c1fb-4ca9-9fb2-cddef37320e4
md"""
### 新增列 @transform and @rtransform
如果要增加新的列， 可以使用@transform 或 @rtransform， 以r开头的宏是按行操作的， 类似上面的按行选择宏。

在新增列时， 新的列是通过已有的列通过函数计算加工而来， 这时候， 统一的语法形式是：**`:newname = f(:oldname)`**, 即：旧的列oldname通过函数f计算得到新的列newname。 注意列名前的冒号。

为了演示方便， 我们重新选择一些列：

- total_claim_amount	整体索赔金额
- injury_claim	伤害索赔金额
- property_claim	财产索赔金额
- vehicle_claim	汽车索赔金额
"""

# ╔═╡ f0401ea2-5a61-4357-948d-05cde4a51481
data3 = @select train :age :total_claim_amount	:injury_claim	:property_claim	:fraud :vehicle_claim

# ╔═╡ a5d291d2-db0f-4b13-82ff-9e59d538e99f
md"""
接下来， 我们计算每一种索赔金额占到整体索赔金额的比例, 并将其依次命名
"""

# ╔═╡ 633e0881-ef14-4880-8622-5e92b89d1da5
@transform data3 begin
	:pop_injury = :injury_claim ./ :total_claim_amount 
	:pop_vehical = :vehicle_claim ./ :total_claim_amount
end

# ╔═╡ a86611d1-8daa-4d9d-aa74-396e9a9d17c3
md"""
上面用的是点运算， 老规矩， 我们用按行运算可能对某些同学更友好。
"""

# ╔═╡ 9ad16a8e-ed0b-419c-977b-f4d8dc7927d3
@rtransform data3 begin
	:pop_injury = :injury_claim / :total_claim_amount 
	:pop_vehical = :vehicle_claim / :total_claim_amount
end

# ╔═╡ 1e5e4de8-f940-4817-b030-2f23d1946670
data3

# ╔═╡ ff1e694c-bbcb-4261-9aac-f4a8b96fe2d1
md"""
上面新增列时， 所有旧的列都带上了， 有时候， 我们只希望留下新增的和部分旧的， 那这时候可以使用@select宏， 也就是@select宏可以实现对新增的列的选择。
"""

# ╔═╡ 7e82b42a-5b20-44cb-a2f7-1e3d490261cd
@rselect data3 begin
	:total_claim_amount # 选择旧的总量
	:pop_injury = :injury_claim / :total_claim_amount # 选择新增的列
	:pop_vehical = :vehicle_claim / :total_claim_amount # 选择新增的列
end

# ╔═╡ af3b540e-d4b8-463f-9278-d339e0ed603b
md"""
现在我们把需求提复杂一点， 我们对年龄做一个泛化处理， 将其分为老中青三个年龄段， 判断准则是： 年龄>60岁为老， [40, 60]为中， <40为青。

首先， 我们需要写一个函数， 通过一个年龄获得一个类别。
```julia
function getclass(age)
	if age > 60
		return "老"
	elseif age >= 40
		return "中"
	else
		return "青"
	end
end
```
"""

# ╔═╡ a1c6296c-3e2e-47c8-a2b6-1b43f3339a1c
function getclass(age)
	if age > 60
		return "老"
	elseif age >= 40
		return "中"
	else
		return "青"
	end
end

# ╔═╡ cd20daa8-7749-4561-bbd2-d3dc5e12cda7
getclass(45)

# ╔═╡ b08f0021-310c-4275-ba9c-0585acc35d88
@rselect data3 begin
	:age
	:class = getclass(:age)
end

# ╔═╡ 83b2a3ad-5231-4405-a9d2-3fb3b2ffbe07
# 3a1725b5-84b7-4782-bcef-a5fe97dd7f62
md"""
### 汇总信息 @combine
我们经常需要计算数据中的一些汇总信息，比如，均值、方差等等，这可以通过@combine宏实现。

比如， 假设我们要计算客户的平均年龄， 由于要使用到一些统计函数， 我们需要加载统计包
"""

# ╔═╡ 0c8373e8-f777-4106-8ed4-0dc2ea0e5a05
@combine data3 :mage = mean(:age)

# ╔═╡ caf84d92-931f-4f8a-99b3-b8ff7c5550b3
md"""
有时候， 我们需要很多的统计量, 比如我们想知道平均值，最大值，最小值
"""

# ╔═╡ cf157ac6-e8f9-4483-aaf1-dcee1a1205db
@combine data3 begin
	:mage = mean(:age)
	:maxage = maximum(:age)
	:minage = minimum(:age)
end

# ╔═╡ a16b6ef7-c2f6-462a-9b51-c54f2cd95d07
md"""
求汇总信息的一个更常见也更重要的场景是分类汇总。 假设我们要计算不同年龄类别的索赔平均值，应该怎么算呢？ 
"""

# ╔═╡ a800beb0-3383-4956-ae15-f7f375addd3f
@chain data3 begin
	@rtransform :class = getclass(:age) # 先构造一个年龄类别特征
	groupby(:class) # 然后根据这个类别将数据分组
	@combine :mamount = mean(:total_claim_amount) # 计算每一组中总的索赔额的平均值
end

# ╔═╡ 2d37210d-3d0b-418b-ae6d-2ad26d32c774
md"""
上面的代码中用到了一个分组函数groupby， 这是分类汇总中一个非常重要的操作， 可以简单看一下这个函数的返回值, 比如， 按照是否欺诈数据可以分为两个组。分组的结果是一个GroupedDataFrame， 很多操作对GroupedDataFrame还是成立的。
"""

# ╔═╡ 1e11be6c-a915-4b9c-ba6a-439575c86660
groupby(data3, :fraud)

# ╔═╡ b7261c37-e81d-4de9-a9a0-4b0b710b79dc
md"""
另一个例子， 假设我们要计算不同年龄段的欺诈比率， 这里使用到一个01向量的特性， 求和的值等于取1的数量。
"""

# ╔═╡ fb2bfad0-439c-4531-973a-ad911f40a50a
# e32ce78d-144e-488e-883e-c3012db44844
@chain data3 begin
	@rtransform :class = getclass(:age) # 先构造一个年龄类别特征
	groupby(:class) # 然后根据这个类别将数据分组
	@combine :pop = sum(:fraud)/length(:fraud) # 计算每一组中欺诈的比率
end

# ╔═╡ 0935eb67-49ab-4a37-83af-e6d143fc3d71
# a99b514c-168e-460c-bb04-c1226d280a99
md"""
有许多统计量可能常常用于计算特征，比如 std, minimum, maximum, median, sum, length (向量长度), first (返回向量前面的值), 和 last (返回向量最后的值).
"""

# ╔═╡ 6dde50cd-1a41-49d6-8495-898e1e6cb4f4
md"""
# 5 数据整理
"""

# ╔═╡ bba16b5b-c226-43d1-900e-d21bf8b7b5c2
md"""
## 数据类型分析
"""

# ╔═╡ 6836f9f5-d64e-4d16-a7f9-252bed16182c
describe(train)

# ╔═╡ 1a6d4e5a-1070-4549-bf31-2c13e0da1688
md"""
从上面可以看的出来， 大部分的数据是整数（Int64）或者字符串（String）的形式。一般而言， 如果是整数， 可能有两种内涵： 表示一个类别变量（比如，：fraud）， 或者表示一个数值型变量（如保费，:policy\_annual\_premium）。因此， 大家在做分析和画图的过程中，一定要先明确你的数据是什么类型的。

对于字符串形式的变量， 一般会将字符串默认解读为类别变量， 即不同的字符串表示不同的类别（比如：性别 :insured\_sex）。不过，有时候类别变量能取得值可能很多， 其实也不方便去分析， 比如 :auto\_model， 就有39种之多。

一般情况下， 在后续的处理中， 会默认将文本类型转换为类别类型（CategoricalArry）, 然后将其视为类别变量处理。 如果是整数类型， 或者浮点数类型， 会将其视为数值类型（nummeric）处理。 这种默认的转换方式可能会造成一些问题， 这就需要我们在分析之前，先将数据做好恰当的类型转换， 然后再去分析。 

比如目击者数量witnesses， 虽然这是一个数值类型。但其可能的取值其实并不多， 我们可能将其视为类别变量更好。又比如，：fraud列， 它的含义本身就是类别， 但确读取为整型了。

此外， 虽然数值类型我们可以直接分析， 但有时候， 我们从数值类型构造一个类别变量可能会有不一样的分析结果。 下面介绍这些操作如何实现。

"""

# ╔═╡ feb82104-ca29-45eb-9921-65a6a0795f28
md"""
## 不同类别变量获取
有时候， 我们可能需要获取某种类型的所有字段， 这可以通过中括号的形式获取，使用到的关键函数是：names.
```julia
names(df::AbstractDataFrame, cols=:)
names(df, Type)
```
names 函数可以用于获取一个数据框中的字段名， 当然， 也可以用于获取一个数据框中所有Type类型的字段名。
下面的代码获取train中所有整型（Int）字段名。 获取了字段名之后， 我们就可以提取对应的字段了。
"""

# ╔═╡ 6d3d23e5-bc33-4454-bb96-5b6c25e34cf8
names(train, String1)

# ╔═╡ b5412573-4669-45b6-8938-3bac4fa40bbe
train[:,names(train,Int)]

# ╔═╡ 1ad74717-02c9-4997-b8f9-d8d00b6fe8c1
@chain train begin
_[:,names(train,Int) ]
map(x->mean(x), eachcol(_))
end

# ╔═╡ 01cb6b7c-743c-4041-8067-7ad8526cf8c1
Symbol.(names(train,Int64 ))

# ╔═╡ 2aa6b84e-33db-4ce1-8ccd-0f4a2ffd500f
md"""
## 生成类别变量
有时候我们需要将数据转化为类别变量（类似R中的因子）， 这方便我们做一些统计分析。 类别变量在Julia中用CategoricalArray表示。

主要掌握下面几个函数：
 - categorical： 将向量转为类别数组
 - levels/levels!： 查看/修改类别数组的可能取值及顺序
 - unwrap : 重新获取原始数据
"""

# ╔═╡ 17b234f4-feb3-43d7-a271-9ec069d69acf
data4 = @select train :witnesses = categorical(:witnesses)

# ╔═╡ 0fca561f-1845-49e1-8043-146ab29134b5
levels(data4.witnesses) # 显然，目击者在数据集里面最多只有4人。

# ╔═╡ 4a218771-e78a-4ff6-881b-5c015f2b39c2
data4.witnesses[1]

# ╔═╡ 74af47b5-c34b-468b-84dd-7be54001e440
unwrap(data4.witnesses[1])

# ╔═╡ acd8fd04-66f5-4a3e-b7db-fe309e240e75
countmap(data4.witnesses)

# ╔═╡ 8355bcaf-631a-45a1-bdce-803a5ee7e3d1
md"""
下面是把上面的操作汇聚到一起， 注意最后一个函数中的下划线， 用于表示传进来的dataframe。
"""

# ╔═╡ 44c8e247-adce-436c-81bf-e82b68be4784
@chain train begin
@select :witnesses = categorical(:witnesses)
countmap(_.:witnesses)
end

# ╔═╡ 00d3209e-62f8-4a6f-92d4-2f2106c1573d
md"""
## 类别编码
如果本身是类别变量，但错误的被读取为数值类型， 我们可以将其重新编码。使用的函数是`recode`, 其基本的用法是：

```julia
recode(a::AbstractArray[, default::Any], pairs::Pair...)
```

其中， pair是 `a => b`的形式。

用replace也是可以的， 这个函数大家自己了解。
"""

# ╔═╡ c0d49aaf-b621-4b38-9fd1-541856861e6e
@select train :fraudn = recode(:fraud, 0 => "非欺诈", 1 => "欺诈")

# ╔═╡ 5ecccea3-c597-4b7d-a534-c235fc7d3bc4
#当然，可以直接将其转换为一个类别变量
@select train :fraud = categorical(:fraud)

# ╔═╡ 73113734-5394-48ba-98a7-ca820dd7c655
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

# ╔═╡ f9fbf481-b397-46ea-a546-2116cde4076d
tmp = cut(train.age, 3)

# ╔═╡ 8b6413aa-d5da-47e4-97ef-4678d9588f94
levels(tmp)

# ╔═╡ 6d11732f-23df-412a-82d8-dd82c41bf6b4
countmap(tmp)

# ╔═╡ 88fd3fd0-de95-4732-88e8-d10ea0fcfb38
md"""
从上面的结果可以看的出来， 年龄的区间被以33岁和42岁为划分点(breaks)划分为了三个区间, 并可以看到不同区间的样本数量。

上面的划分区间是通过样本估计自动生成的。 有时候， 这种划分点可能不太合理， 我们可以根据自己对数据的理解去选择划分的区间。 同时， 指定一下不同区间的标签看看效果。 
"""

# ╔═╡ 8cfabbe4-7fbf-4ca4-bd6f-96c3d1554180
tmp2 = cut(train.age, [0,40,60,100],  labels = ["青","中","老"])

# ╔═╡ ba5bf514-41b3-491a-b619-6bf0ac17b114
countmap(tmp2)

# ╔═╡ ceab2c01-624a-40fa-888e-46f32daab24f
md"""
从上面的统计结果来看， 这种划分方式会导致数据的分布不均衡， 对建模来说， 可能不是一个好事。但我们主要在于演示cut的使用，所以也就没管那么多了。
"""

# ╔═╡ 98f872ec-61db-47eb-9449-ab713dcf5bdf
md"""
	- 前两个参数是位置单数， 所以只要给值就好；但后面的参数是关键字参数， 需要给出参数名字。
	- 第一种调用方式中breaks指定的范围需要涵盖所有可能的取值， breaks的数量会比区间多一个
	- 区间通常是以左开右闭的形式[left, right）表示， 最右边会有例外。
   
""" |>attention

# ╔═╡ f1bebff0-3466-4456-960c-80a03e8c044a
md"""
## 维度规约
维度规约是指通过使用数据变换， 得到原始数据的压缩表示。 如果原始数据可以由压缩表示重新构造， 则压缩是无损的。 不过通常情况下， 压缩会导致一定程度的精度损失。 那为什么还需要维度规约呢？ 一方面是维度规约可以减少特征的数量， 避免特征爆炸。 有时候， 太多的特征可能导致模型性能低下， 因为很多特征之间可能存在一定的相关性， 特征规约可以在尽可能保留信息的信息的情况下， 减少特征的数量， 并且通常是获得相互独立的特征。 另一方面， 更少的特征数量在建模中可以更方便的去理解和解释模型。 
"""

# ╔═╡ db54b365-b5b2-4494-b0d8-bda73cfa2452
md"""
## 主成分分析
主成分分析是一种重要的维度规约方法。 本质上来说， 主成分分析(PCA)推导出一个正交投影，将给定的一组观察结果转换为线性不相关的变量，称为主成分。 

主成分分析的基本过程如下：
1. 对数据做规范化
2. 计算k个正交单位向量（被称为主成分）构成数据数据的新的基。
3. 对主成分按重要性排序。通常是用原始数据在新的坐标系下的方差度量重要性。 方差越大， 表示相应的坐标系保留了越多的原始数据信息。 
4. 按照原始数据方差的一定百分比选择主成分的数量。 原始数据被转化为新的坐标系下（主成分）的系数。

简单来说， 主成分分析是找到了一个矩阵P， 可以将原始数据X（维度是d）转化为新的数据y（维度是k）

$$y = P^T(X-\mu)$$

当然， 这种转化是可逆的， 只是逆变换之后的数据可能跟原始数据存在一定的差异（有损压缩）

$$\bar{X} = Py + \mu$$




"""

# ╔═╡ 59a8a2b2-e984-4d6c-b450-a997aee50d83
md"""
下面主要介绍在特征规约的过程中使用广泛的主成分分析（PCA）的实现。主要是基于多元统计分析包[MultivariateStats.jl]中的[PCA](https://multivariatestatsjl.readthedocs.io/en/latest/pca.html#principal-component-analysis)方法。

在[MultivariateStats.jl]， 用一个结构体表示一个主成分分析模型。设M为PCA的一个实例，d为观测（样本）的维数，p为输出维数(即主成分构成的子空间的维数)。也就是， 模型M实现的是将d维数据转化为p维。

使用PCA， 基本步骤入下：
1. 准备数据矩阵X， 满足(d, n) = size(X)。 注意数据要求是矩阵， 且每一列表示一个样本（跟通常的不同）
2. 通过函数`M = fit(PCA, X; ...)`拟合PCA模型。通常需要指定`maxoutdim=p`，即输出维度， 否则默认是输出维度跟输入维度相同。 
3. 最后使用`transform`函数实现对数据的变换， `reconstruct`函数实现逆变换。

到这里了解更多[PCA](https://juliastats.org/MultivariateStats.jl/dev/pca/#Principal-Component-Analysis)

"""

# ╔═╡ df0502aa-9435-4e9e-be37-fbfb0aba65af
trainint = train[:,names(train,Int)]

# ╔═╡ 77ae67b5-44fd-4755-bf26-72edeabdf41d
size(trainint)

# ╔═╡ d3551c64-81e4-4e2f-bdcd-d32343f553d0
Xtr = Matrix(trainint)'

# ╔═╡ aff1ccb8-3254-4e79-a7e4-cbe7948d990c
M = fit(PCA, Xtr; maxoutdim=4)

# ╔═╡ ad51c8ee-b07f-4e26-b3a0-e3eebd4d24c7
y =predict(M, Matrix(trainint)')

# ╔═╡ 1c16fa7c-a507-4262-ade0-4c8149ed7562
principalvars(M)

# ╔═╡ 546b00e4-2873-4e47-ad40-9097526073c4
md"""
## 抽样
抽样是统计学中常见的一种手段。 当我们要获取所有的数据成本太高， 或者同时分析所有的数据代价太高， 那么可以考虑抽样一部分数据。在部分数据中先做模型验证，最后再应用到所有的样本上。

抽样主要有三种类型
1. 无放回抽样。 当数据量足够大时可以采用无放回抽样。
2. 有放回抽样。 当数据量不大时可以采用有放回抽样。
3. 分层抽样。 当数据中存在明显的“层”时， 可以根据不同“层”包含的样本量按比例抽样。

在[StatsBase.jl](https://juliastats.org/StatsBase.jl/stable/sampling/#StatsBase.sample)中有一个函数`sample`可以实现上述三种抽样。

```julia
sample([rng], a, [wv::AbstractWeights])
sample([rng], a, [wv::AbstractWeights], n::Integer; replace=true, ordered=false)
```

如果要实现分层抽样， 本质上来说就是要给不同的样本赋予一个不同的被抽到的权重（概率）。 这时候需要构建[权重向量](https://juliastats.org/StatsBase.jl/stable/weights/#Weight-Vectors-1)。 不过， 这个可以很简单, 只需要将频率向量v放入Weights构造即可。

"""

# ╔═╡ 7cab62ac-df28-491d-afa5-17d598437be7
sample(1:10) # 在1:10随机抽取一个元素

# ╔═╡ 6f5d8158-2a00-42a3-aeef-18d7ea2b6a9d
sample(1:10, 8) # 在1:10随机抽取3个元素, 默认是有放回抽样。

# ╔═╡ 94774b70-a8f2-4fe2-9195-dd5e2090628d
sample(1:10, 5, replace=false) # 无放回抽样

# ╔═╡ 11e2c383-dde6-4887-ad19-4e8cb52af57d
test1 = DataFrame(a = rand(10), b = sample(1:3, 10))

# ╔═╡ a9adbdf5-2277-4ee4-9c24-1047f739630f
# 可以看到，在test中， b取不同的值得数量是不一样的
countmap(test1[:, :b])

# ╔═╡ 9ccb3988-d70f-4efa-953d-233e9daa2e9a
counts(test1[:, :b])

# ╔═╡ b7b93d68-ae39-4e9e-9969-bbe2c12f39a6
md"""
# 作业
撰写一份保险欺诈数据分析报告，主要目的是了解数据集中相关字段的分布情况， 获得欺诈行为出现哪些因素影响比较大的感性认识。 可以从投保人角度、被保险人角度、保费角度、出险角度（时间、地点、车辆等）展开分析。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
CategoricalArrays = "324d7699-5711-5eae-9e2f-1d82baa6b597"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
FreqTables = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
MultivariateStats = "6f286f6a-111f-5878-ab1e-185364afe411"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.11"
CairoMakie = "~0.11.3"
CategoricalArrays = "~0.10.8"
DataFrames = "~1.6.1"
DataFramesMeta = "~0.14.1"
FreqTables = "~0.4.6"
MultivariateStats = "~0.10.2"
PlutoUI = "~0.7.54"
StatsBase = "~0.34.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "c73e24b9eeda2e5099fa9254cee3acdc1413a0b7"

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
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "247efbccf92448be332d154d6ca56b9fcdd93c31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.6.1"

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
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "0da671c730d79b8f9a88a391556ec695ea921040"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.2"

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
deps = ["CRC32c", "Cairo", "Colors", "FFTW", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools"]
git-tree-sha1 = "966ebbf4dbd45cf0746d35d9ea8bf2c28e45ba41"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.11.3"

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

[[deps.DelaunayTriangulation]]
deps = ["DataStructures", "EnumX", "ExactPredicates", "Random", "SimpleGraphs"]
git-tree-sha1 = "26eb8e2331b55735c3d305d949aabd7363f07ba7"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "0.8.11"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "9242eec9b7e2e14f9952e8ea1c7e31a50501d587"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.104"

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
git-tree-sha1 = "ec22cbbcd01cba8f41eecd7d44aac1f23ee985e3"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.7.2"

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

[[deps.FilePaths]]
deps = ["FilePathsBase", "MacroTools", "Reexport", "Requires"]
git-tree-sha1 = "919d9412dbf53a2e6fe74af62a73ceed0bce0629"
uuid = "8fc22ac5-c921-52a6-82fd-178b2807b824"
version = "0.8.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "25a10f2b86118664293062705fd9c7e2eda881a2"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.2"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
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

[[deps.FreqTables]]
deps = ["CategoricalArrays", "Missings", "NamedArrays", "Tables"]
git-tree-sha1 = "4693424929b4ec7ad703d68912a6ad6eff103cfe"
uuid = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
version = "0.4.6"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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
git-tree-sha1 = "af13a277efd8a6e716d79ef635d5342ccb75be61"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.10.0"

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
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

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
git-tree-sha1 = "31d6adb719886d4e32e38197aae466e98881320b"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.0.0+0"

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
deps = ["LinearAlgebra", "Mods", "Permutations", "Primes", "SimplePolynomials"]
git-tree-sha1 = "89ed93300377e0742ae8a7423f7543c8f5eb73a4"
uuid = "9b3f67b0-2d00-526e-9884-9e4938f8fb88"
version = "0.2.5"

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
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "72dc3cf284559eb8f53aa593fe62cb33f83ed0c0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.0.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FilePaths", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Setfield", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "StableHashTraits", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "db14b5ba682d431317435c866734995a89302c3c"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.20.2"

[[deps.MakieCore]]
deps = ["Observables", "REPL"]
git-tree-sha1 = "e81e6f1e8a0e96bf2bf267e4bf7f94608bf09b5c"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.7.1"

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
version = "2.28.2+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mods]]
git-tree-sha1 = "9d292c7fb23e9a756094f8617a0f10e3b9582f47"
uuid = "7475f97c-0381-53b1-977b-4c60186c8d62"
version = "2.2.0"

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

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "68bf5103e002c44adfd71fea6bd770b3f0586843"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.2"

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

[[deps.NamedArrays]]
deps = ["Combinatorics", "DataStructures", "DelimitedFiles", "InvertedIndices", "LinearAlgebra", "Random", "Requires", "SparseArrays", "Statistics"]
git-tree-sha1 = "6d42eca6c3a27dc79172d6d947ead136d88751bb"
uuid = "86f7a689-2022-50b4-a561-43c23ac3c673"
version = "0.10.0"

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
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

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
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Permutations]]
deps = ["Combinatorics", "LinearAlgebra", "Random"]
git-tree-sha1 = "c7745750b8a829bc6039b7f1f0981bcda526a946"
uuid = "2ae35dd2-176d-5d53-8349-f30d82d94d4f"
version = "0.4.19"

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
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase", "Setfield", "SparseArrays"]
git-tree-sha1 = "a9c7a523d5ed375be3983db190f6a5874ae9286d"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "4.0.6"

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
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "1d05623b5952aed1307bf8b43bec8b8d1ef94b6e"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.5"

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
git-tree-sha1 = "e9330391d04241eafdc358713b48396619c83bcb"
uuid = "ec83eff0-a5b5-5643-ae32-5cbf6eedec9d"
version = "0.3.1"

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
git-tree-sha1 = "5a26dfe46e2cb5f5eca78114c7d49548b9597e71"
uuid = "c5dd0088-6c3f-4803-b00e-f31a60c170fa"
version = "1.1.3"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

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
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
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
git-tree-sha1 = "5f24e158cf4cee437052371455fe361f526da062"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.6"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "93284c28274d9e75218a416c65ec49d0e0fcdf3d"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.40+0"

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
# ╠═2bd50632-8cd0-11ec-1f8b-fd812996df39
# ╠═d81022aa-1c73-4a5c-b312-3b3979bbbd7d
# ╟─6dc4358c-bbf7-41e5-a54a-0b04efcafd7b
# ╟─dac9f5fd-b531-41cc-bf24-de036de2631d
# ╟─f8cbff52-6731-482f-86bf-cd8238154bb4
# ╟─f886fcf2-138c-409c-aaf8-f7fe2a43a245
# ╟─02ac21b8-b010-45ad-9c58-98ff44e3cd47
# ╟─8a9a7157-d49f-4515-9cc6-d03521c9293f
# ╟─b963a3c2-7aac-4d4d-9314-7c5753afdca1
# ╟─e16ff49f-ffe8-4d53-a104-5241cd050f61
# ╟─d0b1c890-c872-403d-b6fd-e0addb23b799
# ╟─1edb6679-4cf1-4f5f-9b8b-ad395f2af12b
# ╟─f02f3eb0-f07f-4458-96c0-b163cc1c77c8
# ╠═1925f8df-7464-4c4c-8dad-dace0d47fffb
# ╠═c0d6a811-210f-4733-b4a6-429dc5899616
# ╟─1d170b7c-1d7a-4afd-91f4-8f77808d8f82
# ╠═6c2188d5-1b46-4a79-9d9f-4ef37422c0cd
# ╠═a2069fd7-a40c-4121-91b6-36460fa20f5e
# ╠═8102858b-1629-455c-be2f-40c28742371f
# ╠═4885fe3d-b764-40ff-a11e-746349210791
# ╠═5b95c524-3bb1-4d38-90f6-8b6dc7e8f6bb
# ╟─76eec074-8cfe-4130-98e1-8b9779c1e123
# ╠═0e6317ea-b57f-462e-8bdd-2723c6315aa1
# ╠═9e73f954-1de4-445d-baf4-0a0bcaac2071
# ╠═c2dcae44-0be0-48d1-8934-c6947eaacabc
# ╠═e3758659-83c9-430b-8dda-e6345e9e1125
# ╠═d9d28ede-936a-4283-a4e2-ba92f33fc8ff
# ╠═0fd40122-22a8-49a0-842b-0c22e2f136fb
# ╟─16ef557a-8194-45e4-ab6e-79dcbd661f45
# ╠═967b9ad5-2293-420e-8e8c-f6f34405f4f3
# ╟─267e18dc-5e8e-4929-b604-7752d965749e
# ╟─bd88c23c-e26c-4451-98b0-3096bc21cc3c
# ╠═d7fbd065-18d1-4b48-8565-3c7146023229
# ╟─d1e0a88f-e253-49ad-a682-f3b5597d63e4
# ╠═fa6e0eee-8ac5-4ff3-a48e-1ed8f6c47974
# ╠═df472126-e64c-43e1-9572-6e6ac669adc6
# ╠═c22d5028-935e-4705-9487-af58fd3c50a0
# ╠═70aa6073-90a1-4c43-a999-cb7a8fa08134
# ╟─f872d549-75e4-4df0-9e95-2144ba510b70
# ╟─4e4de5a0-32d2-48de-ab32-1b9cbd94ae44
# ╠═d47028ac-6365-4675-95d9-10fdb4179b04
# ╠═262d0a9d-4f5b-4b42-9490-d3ffa8fefd91
# ╟─73e7dfe0-34bb-4634-b46d-eea424e461dd
# ╠═027e832d-4841-44d1-a218-24d67337c295
# ╟─b6139b96-9dfe-45dd-9610-81c0ac3f56ec
# ╠═c83f4008-6f70-4c2b-b775-6a37f926a178
# ╠═2bd80968-cb1d-4924-ad1c-cc418b9d2731
# ╠═44f3353d-2b35-4a72-b611-2ca432c1b444
# ╠═c965be35-1a6e-4601-a484-653dab41db79
# ╟─8fad14b4-1fe7-4797-ac3a-7d9151c1e9e6
# ╠═ba9826e6-54f5-4710-a9bc-60f0aa7b8546
# ╠═a39be9ee-494b-4c38-bc6e-30fd039b33d1
# ╠═6d7e35a8-3108-4de0-a29e-82bb8a9caf24
# ╠═017e8060-51f4-4a3f-af3e-458667588b35
# ╠═a12e3f8d-fe78-41d8-a291-50e2b0a3ef65
# ╠═031e6d68-2ea4-446a-a008-5b42c1d08492
# ╠═03af79e9-b6ad-441d-8c3a-c2cff186d4c5
# ╠═37ab912c-6958-4b24-9c54-eb9f388aba5e
# ╠═af3f11bd-3e33-475e-8f46-52f47ea1f427
# ╠═237eb3af-d2b7-4fec-b40b-90f2cd20ab79
# ╠═7094ec80-7772-4ada-a6a2-6c2284e47a35
# ╠═557ee32c-c09f-423b-b049-5c48899fb94b
# ╠═4469604c-4b5a-4eba-bbd0-bf03e6d9ffa4
# ╠═f8e82a19-daad-47e2-898b-b515fe287ab2
# ╟─b7491f99-98d8-4747-a484-539308d772d8
# ╟─3b1c62be-ffd3-49f7-bf72-9ae117d294f8
# ╠═49e4d124-85d0-4612-8f7b-85b6205dd44a
# ╟─b5f156ce-e4ef-4f61-9775-70e6fc0d1fcb
# ╠═3c43a6a3-229f-49b0-bb77-6a1d3d34afe2
# ╠═fce707c3-1155-49a6-9c96-74c766f7c8fc
# ╠═e94a0599-3544-4d18-b8f8-3fe2f7143143
# ╟─60a23867-6861-4b70-b85e-8c7d581fe591
# ╠═c4dec776-9b83-4360-ba06-11de5091ff1e
# ╟─b6c973c9-cfec-499e-969f-50bdb126e284
# ╠═a2743bff-ab93-4c72-921b-73407e7be70b
# ╟─5f76d122-66eb-4533-8838-0d5d317fe6ec
# ╠═45ac5802-4be6-4dc3-975c-5c0c6fa6a6a2
# ╟─c3b47b26-baaa-40f1-ba7e-3f860665596f
# ╠═512099a1-17c7-4568-902b-c15783ae3d94
# ╟─e416a593-f64e-4455-bb42-f9ed0a8327ae
# ╠═779e7e83-4cec-49fa-8906-3f344d3c8a0e
# ╟─45f4f45e-dbc3-4321-af73-f4308e3e89aa
# ╠═9a385d37-042f-4784-8a5d-f3716995a1a1
# ╠═b8a58b6e-37fc-49b6-ab7e-c313e299f816
# ╠═efb3ba14-2f87-4154-a9dc-bdefceeffd2b
# ╟─5fa8a818-f928-4a3d-bccb-70bc8ff31c82
# ╟─970da59b-5b22-48f4-bd89-193e9018af38
# ╠═88e2e0c4-2a71-4ed8-a197-92bed009637b
# ╟─178a6620-db6a-4e16-ba76-a997e7bbba1a
# ╠═0005ca01-a71b-447c-8441-69621e6bf4b8
# ╟─2f3f0373-1864-4f41-b092-fb5294de37f6
# ╟─ca35af98-91d6-450d-b5c8-cb256b23cb4d
# ╠═129b5d72-64f2-422b-8c1c-ff7721476c42
# ╠═64726cfa-db72-4871-8d90-5e31ef0c6d59
# ╟─b4d3c8de-e7ba-46d5-9f6e-b461692494dd
# ╟─bcf0320d-ae9f-45a1-940a-a3e5e4eeb061
# ╟─c1cefc17-af10-458a-adf4-074bd642b20d
# ╠═71cf889f-8680-40aa-a4e1-c9ef0c198cdd
# ╟─5ed02a0b-c1fb-4ca9-9fb2-cddef37320e4
# ╠═f0401ea2-5a61-4357-948d-05cde4a51481
# ╟─a5d291d2-db0f-4b13-82ff-9e59d538e99f
# ╟─633e0881-ef14-4880-8622-5e92b89d1da5
# ╟─a86611d1-8daa-4d9d-aa74-396e9a9d17c3
# ╠═9ad16a8e-ed0b-419c-977b-f4d8dc7927d3
# ╠═1e5e4de8-f940-4817-b030-2f23d1946670
# ╟─ff1e694c-bbcb-4261-9aac-f4a8b96fe2d1
# ╠═7e82b42a-5b20-44cb-a2f7-1e3d490261cd
# ╟─af3b540e-d4b8-463f-9278-d339e0ed603b
# ╠═a1c6296c-3e2e-47c8-a2b6-1b43f3339a1c
# ╠═cd20daa8-7749-4561-bbd2-d3dc5e12cda7
# ╠═b08f0021-310c-4275-ba9c-0585acc35d88
# ╟─83b2a3ad-5231-4405-a9d2-3fb3b2ffbe07
# ╠═0c8373e8-f777-4106-8ed4-0dc2ea0e5a05
# ╟─caf84d92-931f-4f8a-99b3-b8ff7c5550b3
# ╠═cf157ac6-e8f9-4483-aaf1-dcee1a1205db
# ╟─a16b6ef7-c2f6-462a-9b51-c54f2cd95d07
# ╠═a800beb0-3383-4956-ae15-f7f375addd3f
# ╟─2d37210d-3d0b-418b-ae6d-2ad26d32c774
# ╠═1e11be6c-a915-4b9c-ba6a-439575c86660
# ╟─b7261c37-e81d-4de9-a9a0-4b0b710b79dc
# ╠═fb2bfad0-439c-4531-973a-ad911f40a50a
# ╟─0935eb67-49ab-4a37-83af-e6d143fc3d71
# ╟─6dde50cd-1a41-49d6-8495-898e1e6cb4f4
# ╟─bba16b5b-c226-43d1-900e-d21bf8b7b5c2
# ╟─6836f9f5-d64e-4d16-a7f9-252bed16182c
# ╟─1a6d4e5a-1070-4549-bf31-2c13e0da1688
# ╟─feb82104-ca29-45eb-9921-65a6a0795f28
# ╠═6d3d23e5-bc33-4454-bb96-5b6c25e34cf8
# ╠═b5412573-4669-45b6-8938-3bac4fa40bbe
# ╠═1ad74717-02c9-4997-b8f9-d8d00b6fe8c1
# ╠═01cb6b7c-743c-4041-8067-7ad8526cf8c1
# ╟─2aa6b84e-33db-4ce1-8ccd-0f4a2ffd500f
# ╠═17b234f4-feb3-43d7-a271-9ec069d69acf
# ╠═0fca561f-1845-49e1-8043-146ab29134b5
# ╠═4a218771-e78a-4ff6-881b-5c015f2b39c2
# ╠═74af47b5-c34b-468b-84dd-7be54001e440
# ╠═acd8fd04-66f5-4a3e-b7db-fe309e240e75
# ╠═8355bcaf-631a-45a1-bdce-803a5ee7e3d1
# ╠═44c8e247-adce-436c-81bf-e82b68be4784
# ╟─00d3209e-62f8-4a6f-92d4-2f2106c1573d
# ╠═c0d49aaf-b621-4b38-9fd1-541856861e6e
# ╠═5ecccea3-c597-4b7d-a534-c235fc7d3bc4
# ╟─73113734-5394-48ba-98a7-ca820dd7c655
# ╠═f9fbf481-b397-46ea-a546-2116cde4076d
# ╠═8b6413aa-d5da-47e4-97ef-4678d9588f94
# ╠═6d11732f-23df-412a-82d8-dd82c41bf6b4
# ╟─88fd3fd0-de95-4732-88e8-d10ea0fcfb38
# ╠═8cfabbe4-7fbf-4ca4-bd6f-96c3d1554180
# ╠═ba5bf514-41b3-491a-b619-6bf0ac17b114
# ╟─ceab2c01-624a-40fa-888e-46f32daab24f
# ╟─98f872ec-61db-47eb-9449-ab713dcf5bdf
# ╟─f1bebff0-3466-4456-960c-80a03e8c044a
# ╟─db54b365-b5b2-4494-b0d8-bda73cfa2452
# ╟─59a8a2b2-e984-4d6c-b450-a997aee50d83
# ╠═df0502aa-9435-4e9e-be37-fbfb0aba65af
# ╠═77ae67b5-44fd-4755-bf26-72edeabdf41d
# ╠═d3551c64-81e4-4e2f-bdcd-d32343f553d0
# ╠═aff1ccb8-3254-4e79-a7e4-cbe7948d990c
# ╠═ad51c8ee-b07f-4e26-b3a0-e3eebd4d24c7
# ╠═1c16fa7c-a507-4262-ade0-4c8149ed7562
# ╟─546b00e4-2873-4e47-ad40-9097526073c4
# ╠═7cab62ac-df28-491d-afa5-17d598437be7
# ╠═6f5d8158-2a00-42a3-aeef-18d7ea2b6a9d
# ╠═94774b70-a8f2-4fe2-9195-dd5e2090628d
# ╠═11e2c383-dde6-4887-ad19-4e8cb52af57d
# ╠═a9adbdf5-2277-4ee4-9c24-1047f739630f
# ╠═9ccb3988-d70f-4efa-953d-233e9daa2e9a
# ╟─b7b93d68-ae39-4e9e-9969-bbe2c12f39a6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
