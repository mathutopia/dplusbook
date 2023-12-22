### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 18687dc0-c17c-11ed-25fe-d790175bd663
using PlutoUI, CSV, DataFrames, DataFramesMeta,CairoMakie,StatsBase

# ╔═╡ 3e4aee85-62b4-4c36-9442-f8bf65204f44
using FreqTables

# ╔═╡ 94f1ba50-9e77-4e5e-88b7-b6ebb5af611b
include("funs.jl")

# ╔═╡ ac825a43-a897-485d-9d04-1f6d3cf5c853
TableOfContents(title = "目录")

# ╔═╡ 1d51bf81-c99a-4d3c-aff2-84fa65ca2f87
md"""
# 数据读取
读取天池数据挖掘比赛-[保险反欺诈预测](https://tianchi.aliyun.com/competition/entrance/531994/information)的训练数据， 请将其赋值给train， 并做简单探索。

这份数据是简单的CSV格式数据， CSV格式数据是用逗号分隔的数据， 读取相对很简单， 使用CSV.jl这个包即可。在Pluto里面， 只需要using CSV即可。
"""


# ╔═╡ 0b4f89dc-4d94-4639-b0e6-70472923c232
train = CSV.read(datapath*"/trainbx.csv", DataFrame)

# ╔═╡ 99bf8265-959f-4c61-af87-fda42af4b45b
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

# ╔═╡ ccbd227c-9450-4527-bc67-c0678fd90620
md"""
# 统计函数
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


# ╔═╡ e3ea4d0c-e795-47e6-92a0-2d1baedda6f4
countmap(collect(train.policy_state))

# ╔═╡ cb4136f0-88d1-4e89-9871-3edebc552173
trim

# ╔═╡ c68908dc-e9d4-4cfc-bf86-5cad601300b0
mean(collect(trim([5,2,4,3,1], prop=0.2)))

# ╔═╡ f182d7cc-4080-4e15-b582-5249120d9c37
collect(train.policy_state)

# ╔═╡ 98ac2295-5903-4b1f-8365-bc3ec86862a3
md"""
有时候，我们可能需要做列联表分析， 尤其是对有限取值的变量。
"""

# ╔═╡ e69cee0c-19d4-4896-ab81-f8ca4648fcfb
md"""
[FreqTables](https://github.com/nalimilan/FreqTables.jl)
"""

# ╔═╡ fa1d0369-2e2e-4d59-bda5-6c709700e945
freqtable(train.insured_sex,train.fraud )

# ╔═╡ 8dbc5f84-696b-4357-a8b5-76b93718fdb9
md"""
# DataFrame操作
## DataFrame简介
DataFrame是数据分析中非常核心的数据结构。 在R、Python中都有相关的包多DataFrame进行分析。在Julia中， [DataFrames.jl](https://dataframes.juliadata.org/stable/)是DataFrames分析的核心包。

一个DataFrame， 可以看成是一个Excel的工作簿。 如上面的竞赛数据， 通常每一列是一个**字段(特征)**， 每一行代表一个**样本**。从数据形式上看， 每一列可以看成一个**向量**(事实上是NamedTuple)，因此，一个DataFrame也可以看成是多个向量在水平方向排列而成。

基本的DataFrames操作涵盖内容非常丰富， 下面简单介绍一下， DataFrames的创建与数据提取。更高级的操作会结合其他工具。



"""

# ╔═╡ f74ef472-7f69-4c27-970d-b7803bd9131a
md"""
## 创建DataFrame
###  1. 用DataFrame构造
我们说直接用类型名，当成函数调用。相当于调用类型的构造函数。
"""

# ╔═╡ 8f1be529-b2d5-41c4-b60f-38632280c42e
df1 = DataFrame(A=1:4, B=["M", "F", "F", "M"])

# ╔═╡ 5960f7d7-49b8-4c98-92e9-1ab93846990c
md"""
### 2. 按列构造
"""

# ╔═╡ e2e602ce-e942-4813-a797-fad318a4ed82
df2 = DataFrame()

# ╔═╡ ade22154-88f7-4ef7-b0c7-daa8b66e5e85
df2.A = [1,2,3]

# ╔═╡ ad0e9640-b5ae-4c36-b6a4-1c947878ffcd
df2.B = string.('a' : 'c')

# ╔═╡ 5ca1fba6-1108-4e38-a23f-4be5f2af0344
df2

# ╔═╡ ebfbd466-4538-45e0-9744-ac5f9de5308c
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

# ╔═╡ 8236591f-069b-4d47-bdbc-58d274d37600
md"""
### 初步探索
一般， 我们读取进来一份数据，首先要看看是否存在明显的问题。这时候，可以通过产看一些基本信息做大致了解。
"""

# ╔═╡ 9d002c1c-6654-4006-832e-1e63f5cae8f5
# 查看前面5行
first(train,5)

# ╔═╡ 7039ba40-7215-4969-9baa-309843d31ffc
#查看后面5行
last(train, 5)

# ╔═╡ f61ee923-34b1-427f-a742-8972c549e9cb
md"""
describe是一个更全面的查看数据集的函数
"""

# ╔═╡ 08497226-e8b7-49ec-bc1c-8e4c4a2a7c63
describe(train)

# ╔═╡ 833be572-f838-472b-90a3-0cfc1a9b79b1
md"""
### 行提取示例
下面我们从数据框train中提取一些数据，演示df[row,col]的使用。
"""

# ╔═╡ 133e214b-808d-42ea-aff5-6c446fa0b6d4
# 提取第1,3,5行
train[[1,3,5],:]

# ╔═╡ 07bea206-06a1-4b75-9b8b-f3c4a0a2c43d
md"""
下面提取60岁以上的样本
"""

# ╔═╡ dbb6b259-039f-4ceb-833c-bab5cc9d9af6
train[train.:age .> 60,:]

# ╔═╡ d5220075-37e0-4fc7-badf-5ea04a674c28
train.incident_hour_of_the_day

# ╔═╡ cbc9b358-05e0-463a-b6c2-49110a272359
md"""
### 列提取
"""

# ╔═╡ 80fd065a-707e-4702-8519-5a5362e28e2c
train[:, :age]

# ╔═╡ 87accdc3-cf86-4df1-81e6-03d01a95f8b9
train[:, "age"]

# ╔═╡ ce1d85ee-05a4-4bf5-a478-b289c7c41353
train[:,2] # age是第二列

# ╔═╡ 9321f889-91c5-4255-920c-d70c8c1f1f7f
md"""
如果要一次性提取多列，需要将相关的列组织到向量中。其他都是类似的。
"""

# ╔═╡ f83412a7-865d-435a-bdd4-5d390a60744f
train[:, [:age, :customer_months]]

# ╔═╡ dd07a0ca-0931-4d49-828a-0b328e0e0c07
train[:, [2,3]]

# ╔═╡ 438ce43b-749f-4ef4-b228-1b6308871449
train[:, ["age", "customer_months"]]

# ╔═╡ f6ca620b-7640-443d-b806-6d9f6ca65090
md"""
### 同时选择行与列
上面单独选择行或者列时， 对应的列和行我们都是用冒号：， 这表示选择所有列和行。 我们可以把行和列的所有选择同时写上， 去实现对相应的行和列的选择。

比如，我们要选择60岁以上的用户，同时查看其查看成为用户的月份。
"""

# ╔═╡ 00f8169d-5bcd-44f7-b021-b87e630c9b80
train[train.age .> 60, :customer_months]

# ╔═╡ 5d7fc199-6e7c-4277-bb23-f907320af8e1
md"""
### 统计分析
提取行列是为了对数据进一步分析， 比如我们想计算顾客的平均年龄,最大值,等等
"""

# ╔═╡ 0e2af04e-6b0e-4b2f-853e-f891f6c6727a
mean(train[:,:age])

# ╔═╡ a8a01b87-189b-4557-8dae-a6352f68d310
maximum(train[:,:age])

# ╔═╡ 7d6acdab-2068-48af-b99e-955b1b1d6fad
md"""
60岁以上的客户成为客户的平均时长是：$(mean(train[train.age .> 60, :customer_months]))，都是老客户。
"""

# ╔═╡ 3ac886cc-3302-4e52-848b-4eff35a36277
mean(train[train.age .> 60, :customer_months])

# ╔═╡ daf08d45-841d-47c0-8035-944de2c5cab6
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

# ╔═╡ cbbcdd63-0e4f-42fe-b073-a6eb695a2a12
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

# ╔═╡ d1bc36e6-31bb-4fc4-8ec8-f6c8b8713cf7
data = @select train :id = :policy_id :age :customer_months 	:premium = :policy_annual_premium	:limit = :umbrella_limit	:sex = :insured_sex	:edulevel =	:insured_education_level	:fraud

# ╔═╡ a73003d6-f521-4d91-aa0e-b80a23a0d00d
# 93f0b359-5e3f-4e90-af7c-daaf33c19e82
md"""
有时候， 我们可能碰到要选择的列的名字保存在外部的变量， 或者一个字符串中， 这时候，我们需要使用\$符号。**注意：**这时候不是加冒号。
"""

# ╔═╡ c2d4c6f8-1065-4669-8b8b-9616e8ddd587
name1 = :age

# ╔═╡ e4425d11-c52f-4f5a-9174-ff3e52852923
name2 = "customer_months"

# ╔═╡ 8c6c870c-8583-4632-8e84-1797978aedd2
@select train :policy_id $name1 $name2

# ╔═╡ 89d30746-96c0-43f1-ab78-4cb41ca3c886
# e0afe6ff-36aa-4625-8010-c59dcbb92a40
md"""
### 选择行(样本) @subset and @rsubset
这里我们使用选择好字段的新的数据框去操作， 因为我们已经重命名了。

选择行在Excel里面就是数据筛选。 现在， 假定我们要找到所有年龄大于或等于40岁的样本。 
"""

# ╔═╡ ed6533b8-c9da-4f6a-b4fe-eb83195506b3
# 2ae5c2b3-d7f4-45cb-b5f4-8f407ea5e74c
@subset data :age .>= 40

# ╔═╡ a44f714f-d82b-47da-a921-c39dd8becc2a
# 902f165a-5733-45ea-83b3-ab43d8c6bfa5
md"""
上面的`:age .>= 40`是一个条件表达式， 希望你注意到了大于符号前面有个点号， 这表示的是按元素比较大小， 因为:age是一个向量， 不能直接把向量和数值做大小比较， 而是应该把向量的每一个元素跟40去比较。

你可能会觉得点运算比较麻烦， 那么你可以使用按行操作的版本。 这时候， 条件会按行去执行， 每次拿来比较的就是单个元素， 而不是整列形成的向量了。 你可以选择你喜欢的方式， 不过建议你还是要熟悉Julia的点运算， 因为它很常见。

为了简单起见， 下面的选择采用按行版本。
"""

# ╔═╡ 629c6409-d534-4406-9c7a-618217d73d2f
# 8e47be00-27c4-43f9-8f1d-30e3dcc41629
@rsubset data :age > 40

# ╔═╡ ee694eda-c684-40a6-a629-5331a49065d6
md"""
很多时候， 我们可能会需要选择通常满足多个条件的列。 这时候， 可以将条件依次写出来。

假定我们要选择，年龄在40岁以上， 性别是男性， 又是欺诈的样本。 注意，比较是否相等是两个等号。
"""

# ╔═╡ 052a9258-7c4f-487d-87ba-cddf329f7827
@rsubset data :age >= 40 :sex == "MALE" :fraud == 1

# ╔═╡ 356bcb80-3f77-4e5b-a93c-3d2954336f43
md"""
上面的写法虽然没错， 但可以更整洁， 我们可以将所有的条件用`begin end`形成的代码块, 每个条件占一行， 还可以注释
"""

# ╔═╡ 3fa74396-f856-4a5f-a68d-bd4d6b880064
@rsubset data begin
	:age >= 40 # 年龄大于40
	:sex == "MALE"  # 性别是男性
	:fraud == 1 # 欺诈样本
end

# ╔═╡ a3b38cef-af26-4b65-a52f-40d8a3cff4a5
# d926ce40-2aff-47c6-a028-9001a3ba8d98
md"""
如果你喜欢函数调用的方式， 类似R语言， 也可以像下面这么写， 不过我们统一用宏的方式去写。
"""

# ╔═╡ 12121da1-d940-48d9-a3fd-e1463bdc3d14
@rsubset(data ,:age >= 40 ,:sex == "MALE", :fraud == 1)

# ╔═╡ 03fcf0f6-69f5-425c-89d0-89abe3ae73b7
md"""
有时候， 一个字段可能有多个取值， 你希望过滤出其中的部分。 比如， 你希望获得所有学历是研究生或博士生的样本， 当然可以使用"或"运算连接多个条件， 如`(:edulevel ==  "MD" ||  :edulevel ==  "PhD" )`。 但我们有更高效的做法。 简单来说就是把想要的取值构成一个集合， 然后去按行判断， 相应的字段取值是否在（in）该集合中。 集合可以用Set构造， 或者直接是向量也行。
"""

# ╔═╡ ec7517ad-316a-47c9-93cf-178376bbfdee
@rsubset data :edulevel == "MD" || :edulevel == "PhD"

# ╔═╡ acc166d9-ca4e-4676-a73d-c4e45f14b2e2
xueli = ["MD", "PhD"]

# ╔═╡ 8988e3c6-eb6a-45f2-b0da-7b850852ff6b
@rsubset data :edulevel in xueli

# ╔═╡ b9d50321-7886-4224-8763-f1cd55ea2209
# 49223c2a-bc54-4062-8fec-e4589e737815
md"""
你可以使用`>, <, >=, <=, !=, in` 和 `&& || !`去构造和组合出复杂条件
"""

# ╔═╡ 6afa46b0-476f-4c70-843b-8849e8898726
# f110d95f-2a78-4afc-9079-69072a323f12
md"""
### 管道操作@chain
数据分析中， 我们常常许多要对数据做多次处理、加工。 通常， 上一个操作得到的数据，会进入下一个操作继续加工。这相当于， 数据流过一个管道， 经过不同的环节， 进行不同的处理。 这类操作被称为管道操作， 可以使用`@chain`实现。 

假定我们要选择年龄大于40岁， 性别是男性的样本， 但我们又只想看到id列和是否欺诈两列。 如果不使用管道操作， 我们需要这么做：
1. 首先， 把需要的行选出来， 结果保存在临时变量data1中
2. 然后， 从临时变量data1中， 选择需要的列
"""

# ╔═╡ f12f67d7-f046-437d-a7c6-e223da6a6ad8
begin
data1 = @rsubset data :age >=40 :sex == "MALE"
data2 = @select data1 :id :fraud
end

# ╔═╡ 6d419e50-934d-4f44-a015-aca2a29e2348
md"""
很明显， 上面的操作引入了一个临时变量， 浪费了脑力（取名字不是容易的事）， 如果顺序操作的次数很多， 这种方式会很麻烦， 用管道操作就方便很多了。

下面的@chain宏， 表示管道操作。 其第一个参数是要操作的数据 data, 第二个参数是后面的一系列操作函数， 用`begin ... end`括起来了。 数据data 首先 流入 @rsubset， 这时， 这个宏第一个参数不再是数据框， 默认的就是data。 经过第一个宏处理之后， 会生成一个新的数据框， 这个数据框流入第二个宏@select， 同样，这个宏也不需要输入数据参数。

"""

# ╔═╡ 413f9c98-82a0-4b4f-b6c2-45ec885a06e7
@chain data begin
	@rsubset  :age >=40 :sex == "MALE"
	@select  :id :fraud
end

# ╔═╡ 0ff96098-810b-47e3-a24a-613cee05a83a
md"""
接下来， 我们所有的操作都将用管道操作的方式。
"""

# ╔═╡ bbabfbee-c64a-4b48-9541-389654d4a8e6
# 0a24412a-b948-4888-8e0c-185d387606cf
md"""
### 重新排序行@orderby
如果想要对数据按照某些字段排序， 可以简单的将字段列出来

下面按照年龄和成为客户的时间排序：
age	customer_months
"""

# ╔═╡ bcf8e170-d4a9-4a13-9b63-2183cbd6f4bd
data

# ╔═╡ 52b299e8-8ba2-4f32-b6dd-ba9458d7c381
@orderby data :age	:customer_months

# ╔═╡ 7d87b844-585e-4fd2-ac96-8b1c783cebd1
md"""
默认的排序是按照升序排的， 你可以在变量上加上负号实现降序排列
"""

# ╔═╡ d17b9e27-8da2-4974-b8fe-6a36ee9056ff
@orderby data begin
	:age	 # 年龄是升序
	-:customer_months # 成为顾客的时间是降序
end

# ╔═╡ 0c1c904a-0e76-4598-ac36-729b3e6e2f82
md"""
现在， 让我们把需求弄得复杂一点， 下面的代码含义很清晰， 最后的first 是用于查看一个数据框的前n行。这是一个普通函数， 因此，前面没有@符号。
"""

# ╔═╡ 1e386ff1-87f0-4124-a42d-59c735b00012
@chain data begin
	@select :age :premium :sex :fraud
	@rsubset :age >=40
	@orderby :premium
	first(10)
end

# ╔═╡ 5328ab8f-7df4-4c0d-baf2-46e1e97968b8
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

# ╔═╡ 0ed61cb9-f17e-4ced-b6cc-66cee0b568be
data3 = @select train :age :total_claim_amount	:injury_claim	:property_claim	:fraud :vehicle_claim

# ╔═╡ 4d9dba10-d532-4458-9c35-634c42a099ba
md"""
接下来， 我们计算每一种索赔金额占到整体索赔金额的比例, 并将其依次命名
"""

# ╔═╡ 8a4420f8-d466-497a-834d-b039eccd5506
@transform data3 begin
	:pop_injury = :injury_claim ./ :total_claim_amount 
	:pop_vehical = :vehicle_claim ./ :total_claim_amount
end

# ╔═╡ 38a2a2d5-b963-442c-bb76-853e22b29cf2
md"""
上面用的是点运算， 老规矩， 我们用按行运算可能对某些同学更友好。
"""

# ╔═╡ 49159f93-bbf3-42fa-bf2e-7dcc866d8211
@rtransform data3 begin
	:pop_injury = :injury_claim / :total_claim_amount 
	:pop_vehical = :vehicle_claim / :total_claim_amount
end

# ╔═╡ 9400bc0c-6552-4697-b52e-43206af991a1
data3

# ╔═╡ b140b8b1-aa2c-4439-a6de-3d8305119678
md"""
上面新增列时， 所有旧的列都带上了， 有时候， 我们只希望留下新增的和部分旧的， 那这时候可以使用@select宏， 也就是@select宏可以实现对新增的列的选择。
"""

# ╔═╡ fee3a825-30a5-458b-b236-6bff8983f728
@rselect data3 begin
	:total_claim_amount # 选择旧的总量
	:pop_injury = :injury_claim / :total_claim_amount # 选择新增的列
	:pop_vehical = :vehicle_claim / :total_claim_amount # 选择新增的列
end

# ╔═╡ 3a16a803-6e74-4321-98b1-e8ffdf0fdced
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

# ╔═╡ b573b264-55e2-48d9-8e24-1832c490b1f7
function getclass(age)
	if age > 60
		return "老"
	elseif age >= 40
		return "中"
	else
		return "青"
	end
end

# ╔═╡ 9347980c-4d48-4ced-b518-ac0c6a112a7d
getclass(45)

# ╔═╡ 5a2282dc-e00d-4b25-945a-9c94c961e9ef
@rselect data3 begin
	:age
	:class = getclass(:age)
end

# ╔═╡ e5d9da3a-fd95-4a0a-93e7-9aabdc16744f
# 3a1725b5-84b7-4782-bcef-a5fe97dd7f62
md"""
### 汇总信息 @combine
我们经常需要计算数据中的一些汇总信息，比如，均值、方差等等，这可以通过@combine宏实现。

比如， 假设我们要计算客户的平均年龄， 由于要使用到一些统计函数， 我们需要加载统计包
"""

# ╔═╡ cf8b1950-74e9-48ce-aacb-f8e7ecbf60a7
@combine data3 :mage = mean(:age)

# ╔═╡ c31428a3-8320-4cec-b2e3-010b34d5b94a
md"""
有时候， 我们需要很多的统计量, 比如我们想知道平均值，最大值，最小值
"""

# ╔═╡ a8e92e3e-e0e4-4083-b75e-97351f45b25f
@combine data3 begin
	:mage = mean(:age)
	:maxage = maximum(:age)
	:minage = minimum(:age)
end

# ╔═╡ ddbc8323-c3b1-4405-9d3a-cd1889f93431
md"""
求汇总信息的一个更常见也更重要的场景是分类汇总。 假设我们要计算不同年龄类别的索赔平均值，应该怎么算呢？ 
"""

# ╔═╡ 079c123d-d4ca-43e9-b1e1-4be511dff177
@chain data3 begin
	@rtransform :class = getclass(:age) # 先构造一个年龄类别特征
	groupby(:class) # 然后根据这个类别将数据分组
	@combine :mamount = mean(:total_claim_amount) # 计算每一组中总的索赔额的平均值
end

# ╔═╡ 7312c0cd-626f-41e5-8630-4ea5418fbcef
md"""
上面的代码中用到了一个分组函数groupby， 这是分类汇总中一个非常重要的操作， 可以简单看一下这个函数的返回值, 比如， 按照是否欺诈数据可以分为两个组。分组的结果是一个GroupedDataFrame， 很多操作对GroupedDataFrame还是成立的。
"""

# ╔═╡ 096f8f70-064a-48ef-a75d-cf7cffb8d326
groupby(data3, :fraud)

# ╔═╡ eb93df77-e211-4f99-be2e-d5514385534c
md"""
另一个例子， 假设我们要计算不同年龄段的欺诈比率， 这里使用到一个01向量的特性， 求和的值等于取1的数量。
"""

# ╔═╡ 3d1eb08d-da10-4f61-8352-8fd09ff9df12
# e32ce78d-144e-488e-883e-c3012db44844
@chain data3 begin
	@rtransform :class = getclass(:age) # 先构造一个年龄类别特征
	groupby(:class) # 然后根据这个类别将数据分组
	@combine :pop = sum(:fraud)/length(:fraud) # 计算每一组中欺诈的比率
end

# ╔═╡ 966a1adb-8d92-4828-b885-edc233ca4eb1
# a99b514c-168e-460c-bb04-c1226d280a99
md"""
有许多统计量可能常常用于计算特征，比如 std, minimum, maximum, median, sum, length (向量长度), first (返回向量前面的值), 和 last (返回向量最后的值).
"""

# ╔═╡ 291840a8-b2c8-4978-aa47-eb3819e23977
md"""
### 感兴趣的问题
"""

# ╔═╡ af6a97fd-cf4d-4318-a660-0ba83c7654c9
md"""
1. 哪种性别的用户欺诈可能性更高？
分析： 回答这个问题，需要
1. 先将用户按性别分组
2. 统计每一组的欺诈比率

"""

# ╔═╡ 745e97ba-dc49-45e8-9ec2-6b62c2a22404
@chain data begin
	groupby(:sex)
	@combine :frate = sum(:fraud)/length(:fraud)
end

# ╔═╡ 7476af1d-c18f-4c1e-bdcd-595d19e49052
md"""
2. 计算不同学历水平的欺诈率，并将其按从高到低排序
"""

# ╔═╡ a94d1806-e844-45c6-b4ad-7a19658d2b25
@chain data begin
	groupby(:edulevel)
	@combine :frate = mean(:fraud)
	@orderby -:frate
end

# ╔═╡ 1745c6f0-740e-459e-8e45-8e91679d7194
@chain data begin
	@subset :fraud .== 1
	groupby(:sex)
	@combine :nf = length(:sex)
end

# ╔═╡ 24be2298-7a36-436d-83c8-fb7627f0ea4d
@chain train begin
	groupby(:insured_occupation)
	@combine :frate = mean(:fraud)
	@orderby -:frate
end

# ╔═╡ 798e666e-178b-4616-a915-55b640d6b285
md"""
# 作业
撰写一份保险欺诈数据分析报告，主要目的是了解数据集中相关字段的分布情况， 获得欺诈行为出现哪些因素影响比较大的感性认识。 可以从投保人角度、被保险人角度、保费角度、出险角度（时间、地点、车辆等）展开分析。 要求要有分析，图形（画图在下一次课程讲），有观察结果。作业时间3周。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
FreqTables = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.9"
CairoMakie = "~0.10.2"
DataFrames = "~1.5.0"
DataFramesMeta = "~0.13.0"
FreqTables = "~0.4.5"
PlutoUI = "~0.7.50"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "9081c6cc9a61bb125c3ddc6faf3ad1429111165d"

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

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
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

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["Printf", "ScanByte", "TranscodingStreams"]
git-tree-sha1 = "d50976f217489ce799e366d9561d56a98a30d7fe"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "0.8.2"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "1dd4d9f5beebac0c03446918741b1a03dc5e5788"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.6"

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

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "ed28c86cbde3dc3f53cf76643c2e9bc11d56acc7"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.10"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.CairoMakie]]
deps = ["Base64", "Cairo", "Colors", "FFTW", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools", "SHA"]
git-tree-sha1 = "9e7f01dd16e576ebbdf8b453086f9d0eff814a09"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.10.5"

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
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "be6ab11021cd29f0344d5c4357b163af05a48cba"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.21.0"

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
version = "1.0.5+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"
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

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "c72970914c8a21b36bbc244e9df0ed1834a0360b"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.95"

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

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

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

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "299dc33549f68299137e51e6d49a13b5b1da9673"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.1"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "ed569cb9e7e3590d5ba884da7edc50216aac5811"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.1.0"

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

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "cabd77ab6a6fdff49bfd24af2ebe76e6e018a2b4"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.0.0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "38a92e40157100e796690421e34a11c107205c86"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.0"

[[deps.FreqTables]]
deps = ["CategoricalArrays", "Missings", "NamedArrays", "Tables"]
git-tree-sha1 = "488ad2dab30fd2727ee65451f790c81ed454666d"
uuid = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
version = "0.4.5"

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
git-tree-sha1 = "bb198ff907228523f3dee1070ceee63b9359b6ab"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "659140c9375afa2f685e37c1a0b9c9a60ef56b40"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.7"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

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
git-tree-sha1 = "678d136003ed5bceaab05cf64519e3f956ffa4ba"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.9.1"

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
git-tree-sha1 = "84204eae2dd237500835990bcade263e27674a93"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.16"

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
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

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
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

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
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

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

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "16c0cc91853084cb5f58a78bd209513900206ce6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.4"

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

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "106b6aa272f294ba47e96bd3acbabdc0407b5c60"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.2"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

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

[[deps.Makie]]
deps = ["Animations", "Base64", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG", "FileIO", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "Match", "MathTeXEngine", "MiniQhull", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Setfield", "Showoff", "SignedDistanceFields", "SparseArrays", "StableHashTraits", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "3a9ca622a78dcbab3a034df35d1acd3ca7ad487d"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.19.5"

[[deps.MakieCore]]
deps = ["Observables"]
git-tree-sha1 = "9926529455a331ed73c19ff06d16906737a876ed"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.6.3"

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

[[deps.MiniQhull]]
deps = ["QhullMiniWrapper_jll"]
git-tree-sha1 = "9dc837d180ee49eeb7c8b77bb1c860452634b0d1"
uuid = "978d7f02-9e05-4691-894f-ae31a51d76ca"
version = "0.4.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NamedArrays]]
deps = ["Combinatorics", "DataStructures", "DelimitedFiles", "InvertedIndices", "LinearAlgebra", "Random", "Requires", "SparseArrays", "Statistics"]
git-tree-sha1 = "b84e17976a40cb2bfe3ae7edb3673a8c630d4f95"
uuid = "86f7a689-2022-50b4-a561-43c23ac3c673"
version = "0.9.8"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "5ae7ca23e13855b3aba94550f26146c01d259267"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "82d7c9e310fe55aa54996e6f7f94674e2a38fcb4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.9"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "67eae2738d63117a196f497d7db789821bce61d1"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.17"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "f809158b27eba0c18c269cf2a2be6ed751d3e81d"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.17"

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
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "84a314e3926ba9ec66ac097e3635e270986b0f10"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.50.9+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a5aef8d4a6e8d81f171b2bd4be5265b01384c74c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.10"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f6cf8e7944e50901594838951729a1861e668cb8"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.2"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "259e206946c293698122f63e2b513a7c99a244e8"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "213579618ec1f42dea7dd637a42785a608b1ea9c"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.4"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QhullMiniWrapper_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Qhull_jll"]
git-tree-sha1 = "607cf73c03f8a9f83b36db0b86a3a9c14179621f"
uuid = "460c41e3-6112-5d7f-b78c-b6823adb3f2d"
version = "1.0.0+1"

[[deps.Qhull_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be2449911f4d6cfddacdf7efc895eceda3eee5c1"
uuid = "784f63db-0788-585a-bace-daefebcd302b"
version = "8.0.1003+0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "6ec7ac8412e83d57e313393220879ede1740f9ee"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.8.2"

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
git-tree-sha1 = "6d7bb727e76147ba18eed998700998e17b8e4911"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.4"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

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

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "0e270732477b9e551d884e6b07e23bb2ec947790"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.4.5"

[[deps.ScanByte]]
deps = ["Libdl", "SIMD"]
git-tree-sha1 = "2436b15f376005e8790e318329560dcc67188e84"
uuid = "7b38b023-a4d7-4c5e-8d43-3f3097f304eb"
version = "0.3.3"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "77d3c4726515dca71f6d80fbb5e251088defe305"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.18"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

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

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

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

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableHashTraits]]
deps = ["CRC32c", "Compat", "Dates", "SHA", "Tables", "TupleTools", "UUIDs"]
git-tree-sha1 = "0b8b801b8f03a329a4e86b44c5e8a7d7f4fe10a3"
uuid = "c5dd0088-6c3f-4803-b00e-f31a60c170fa"
version = "0.3.1"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "8982b3607a212b070a5e46eea83eb62b4744ae12"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.25"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

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

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "GPUArraysCore", "StaticArraysCore", "Tables"]
git-tree-sha1 = "521a0e828e98bb69042fec1809c1b5a680eb7389"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.15"

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
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

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
git-tree-sha1 = "8621f5c499a8aa4aa970b1ae381aae0ef1576966"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.4"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.TupleTools]]
git-tree-sha1 = "3c712976c47707ff893cf6ba4354aa14db1d8938"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.3.0"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

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
# ╠═18687dc0-c17c-11ed-25fe-d790175bd663
# ╠═ac825a43-a897-485d-9d04-1f6d3cf5c853
# ╠═94f1ba50-9e77-4e5e-88b7-b6ebb5af611b
# ╟─1d51bf81-c99a-4d3c-aff2-84fa65ca2f87
# ╠═0b4f89dc-4d94-4639-b0e6-70472923c232
# ╟─99bf8265-959f-4c61-af87-fda42af4b45b
# ╟─ccbd227c-9450-4527-bc67-c0678fd90620
# ╠═e3ea4d0c-e795-47e6-92a0-2d1baedda6f4
# ╠═cb4136f0-88d1-4e89-9871-3edebc552173
# ╠═c68908dc-e9d4-4cfc-bf86-5cad601300b0
# ╠═f182d7cc-4080-4e15-b582-5249120d9c37
# ╟─98ac2295-5903-4b1f-8365-bc3ec86862a3
# ╠═3e4aee85-62b4-4c36-9442-f8bf65204f44
# ╟─e69cee0c-19d4-4896-ab81-f8ca4648fcfb
# ╠═fa1d0369-2e2e-4d59-bda5-6c709700e945
# ╟─8dbc5f84-696b-4357-a8b5-76b93718fdb9
# ╟─f74ef472-7f69-4c27-970d-b7803bd9131a
# ╠═8f1be529-b2d5-41c4-b60f-38632280c42e
# ╟─5960f7d7-49b8-4c98-92e9-1ab93846990c
# ╠═e2e602ce-e942-4813-a797-fad318a4ed82
# ╠═ade22154-88f7-4ef7-b0c7-daa8b66e5e85
# ╠═ad0e9640-b5ae-4c36-b6a4-1c947878ffcd
# ╠═5ca1fba6-1108-4e38-a23f-4be5f2af0344
# ╟─ebfbd466-4538-45e0-9744-ac5f9de5308c
# ╟─8236591f-069b-4d47-bdbc-58d274d37600
# ╠═9d002c1c-6654-4006-832e-1e63f5cae8f5
# ╠═7039ba40-7215-4969-9baa-309843d31ffc
# ╟─f61ee923-34b1-427f-a742-8972c549e9cb
# ╠═08497226-e8b7-49ec-bc1c-8e4c4a2a7c63
# ╟─833be572-f838-472b-90a3-0cfc1a9b79b1
# ╠═133e214b-808d-42ea-aff5-6c446fa0b6d4
# ╟─07bea206-06a1-4b75-9b8b-f3c4a0a2c43d
# ╠═dbb6b259-039f-4ceb-833c-bab5cc9d9af6
# ╠═d5220075-37e0-4fc7-badf-5ea04a674c28
# ╟─cbc9b358-05e0-463a-b6c2-49110a272359
# ╠═80fd065a-707e-4702-8519-5a5362e28e2c
# ╠═87accdc3-cf86-4df1-81e6-03d01a95f8b9
# ╠═ce1d85ee-05a4-4bf5-a478-b289c7c41353
# ╟─9321f889-91c5-4255-920c-d70c8c1f1f7f
# ╠═f83412a7-865d-435a-bdd4-5d390a60744f
# ╠═dd07a0ca-0931-4d49-828a-0b328e0e0c07
# ╠═438ce43b-749f-4ef4-b228-1b6308871449
# ╟─f6ca620b-7640-443d-b806-6d9f6ca65090
# ╠═00f8169d-5bcd-44f7-b021-b87e630c9b80
# ╟─5d7fc199-6e7c-4277-bb23-f907320af8e1
# ╠═0e2af04e-6b0e-4b2f-853e-f891f6c6727a
# ╠═a8a01b87-189b-4557-8dae-a6352f68d310
# ╟─7d6acdab-2068-48af-b99e-955b1b1d6fad
# ╠═3ac886cc-3302-4e52-848b-4eff35a36277
# ╟─daf08d45-841d-47c0-8035-944de2c5cab6
# ╟─cbbcdd63-0e4f-42fe-b073-a6eb695a2a12
# ╠═d1bc36e6-31bb-4fc4-8ec8-f6c8b8713cf7
# ╟─a73003d6-f521-4d91-aa0e-b80a23a0d00d
# ╠═c2d4c6f8-1065-4669-8b8b-9616e8ddd587
# ╠═e4425d11-c52f-4f5a-9174-ff3e52852923
# ╠═8c6c870c-8583-4632-8e84-1797978aedd2
# ╟─89d30746-96c0-43f1-ab78-4cb41ca3c886
# ╠═ed6533b8-c9da-4f6a-b4fe-eb83195506b3
# ╟─a44f714f-d82b-47da-a921-c39dd8becc2a
# ╠═629c6409-d534-4406-9c7a-618217d73d2f
# ╟─ee694eda-c684-40a6-a629-5331a49065d6
# ╠═052a9258-7c4f-487d-87ba-cddf329f7827
# ╟─356bcb80-3f77-4e5b-a93c-3d2954336f43
# ╠═3fa74396-f856-4a5f-a68d-bd4d6b880064
# ╟─a3b38cef-af26-4b65-a52f-40d8a3cff4a5
# ╠═12121da1-d940-48d9-a3fd-e1463bdc3d14
# ╟─03fcf0f6-69f5-425c-89d0-89abe3ae73b7
# ╠═ec7517ad-316a-47c9-93cf-178376bbfdee
# ╠═acc166d9-ca4e-4676-a73d-c4e45f14b2e2
# ╠═8988e3c6-eb6a-45f2-b0da-7b850852ff6b
# ╟─b9d50321-7886-4224-8763-f1cd55ea2209
# ╟─6afa46b0-476f-4c70-843b-8849e8898726
# ╠═f12f67d7-f046-437d-a7c6-e223da6a6ad8
# ╟─6d419e50-934d-4f44-a015-aca2a29e2348
# ╠═413f9c98-82a0-4b4f-b6c2-45ec885a06e7
# ╟─0ff96098-810b-47e3-a24a-613cee05a83a
# ╟─bbabfbee-c64a-4b48-9541-389654d4a8e6
# ╠═bcf8e170-d4a9-4a13-9b63-2183cbd6f4bd
# ╠═52b299e8-8ba2-4f32-b6dd-ba9458d7c381
# ╟─7d87b844-585e-4fd2-ac96-8b1c783cebd1
# ╠═d17b9e27-8da2-4974-b8fe-6a36ee9056ff
# ╟─0c1c904a-0e76-4598-ac36-729b3e6e2f82
# ╠═1e386ff1-87f0-4124-a42d-59c735b00012
# ╟─5328ab8f-7df4-4c0d-baf2-46e1e97968b8
# ╟─0ed61cb9-f17e-4ced-b6cc-66cee0b568be
# ╟─4d9dba10-d532-4458-9c35-634c42a099ba
# ╠═8a4420f8-d466-497a-834d-b039eccd5506
# ╟─38a2a2d5-b963-442c-bb76-853e22b29cf2
# ╠═49159f93-bbf3-42fa-bf2e-7dcc866d8211
# ╠═9400bc0c-6552-4697-b52e-43206af991a1
# ╟─b140b8b1-aa2c-4439-a6de-3d8305119678
# ╠═fee3a825-30a5-458b-b236-6bff8983f728
# ╟─3a16a803-6e74-4321-98b1-e8ffdf0fdced
# ╟─b573b264-55e2-48d9-8e24-1832c490b1f7
# ╠═9347980c-4d48-4ced-b518-ac0c6a112a7d
# ╠═5a2282dc-e00d-4b25-945a-9c94c961e9ef
# ╟─e5d9da3a-fd95-4a0a-93e7-9aabdc16744f
# ╠═cf8b1950-74e9-48ce-aacb-f8e7ecbf60a7
# ╟─c31428a3-8320-4cec-b2e3-010b34d5b94a
# ╠═a8e92e3e-e0e4-4083-b75e-97351f45b25f
# ╟─ddbc8323-c3b1-4405-9d3a-cd1889f93431
# ╠═079c123d-d4ca-43e9-b1e1-4be511dff177
# ╟─7312c0cd-626f-41e5-8630-4ea5418fbcef
# ╠═096f8f70-064a-48ef-a75d-cf7cffb8d326
# ╟─eb93df77-e211-4f99-be2e-d5514385534c
# ╠═3d1eb08d-da10-4f61-8352-8fd09ff9df12
# ╟─966a1adb-8d92-4828-b885-edc233ca4eb1
# ╟─291840a8-b2c8-4978-aa47-eb3819e23977
# ╟─af6a97fd-cf4d-4318-a660-0ba83c7654c9
# ╠═745e97ba-dc49-45e8-9ec2-6b62c2a22404
# ╟─7476af1d-c18f-4c1e-bdcd-595d19e49052
# ╠═a94d1806-e844-45c6-b4ad-7a19658d2b25
# ╠═1745c6f0-740e-459e-8e45-8e91679d7194
# ╠═24be2298-7a36-436d-83c8-fb7627f0ea4d
# ╟─798e666e-178b-4616-a915-55b640d6b285
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
