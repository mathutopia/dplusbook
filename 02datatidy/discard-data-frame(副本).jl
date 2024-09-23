### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ 1cb16cc0-e59d-11ee-18d5-db8c12080e18
using PlutoUI, CSV, DataFrames, DataFramesMeta,StatsBase

# ╔═╡ 0bfed7d1-4fd6-484d-b3d5-121186a68b55
TableOfContents(title="目录")

# ╔═╡ 7cc9cf55-393b-4c18-907b-115a8eda1958
md"""
# DataFrame使用与数据探索分析
## 数据读取
"""

# ╔═╡ b024d006-8d14-4b83-9a4d-d7f1a5a50244
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 023d6149-b031-498e-9985-e27f1dbefbc8
md"""

为了方便，下面还是给出字段含义：

| 字段                      | 说明                          |  | 字段                          | 说明                                   |
|:-----------------------:|:---------------------------:|:---:|:---------------------------:|:------------------------------------:|
| policy_id               | 保险编号                        |    | collision_type              | 碰撞类型                                 |
| age                     | 年龄                          |    | incident_severity           | 事故严重程度                               |
| customer_months         | 成为客户的时长，以月为单位               |    | authorities_contacted       | 联系了当地的哪个机构                           |
| policy\_bind\_date        | 保险绑定日期                      |    | incident_state              | 出事所在的省份，已脱敏                          |
| policy_state            | 上保险所在地区                     |    | incident_city               | 出事所在的城市，已脱敏                          |
| policy_csl              | 组合单一限制Combined Single Limit |    | incident\_hour\_of\_the_day    | 出事所在的小时（一天24小时的哪个时间）                 |
| policy_deductable       | 保险扣除额                       |    | number\_of\_vehicles\_involved | 涉及的车辆数                               |
| policy\_annual\_premium   | 每年的保费                       |    | property_damage             | 是否有财产损失                              |
| umbrella_limit          | 保险责任上限                      |    | bodily_injuries             | 身体伤害                                 |
| insured_zip             | 被保人邮编                       |    | witnesses                   | 目击证人                                 |
| insured_sex             | 被保人姓名：FEMALE或者MALE          |    | police\_report\_available     | 是否有警察记录的报告                           |
| insured\_education\_level | 被保人学历                       |    | total_claim_amount          | 整体索赔金额                               |
| insured_occupation      | 被保人职业                       |    | injury_claim                | 伤害索赔金额                               |
| insured_hobbies         | 被保人兴趣爱好                     |    | property_claim              | 财产索赔金额                               |
| insured_relationship    | 被保人关系                       |    | vehicle_claim               | 汽车索赔金额                               |
| capital-gains           | 资本收益                        |    | auto_make                   | 汽车品牌，比如Audi, BMW, Toyota, Volkswagen |
| capital-loss            | 资本损失                        |    | auto_model                  | 汽车型号，比如A3,X5,Camry,Passat等           |
| incident_date           | 出险日期                        |    | auto_year                   | 汽车购买的年份                              |
| incident_type           | 出险类型                        |    | fraud                       | 是否欺诈，1或者0                            |

"""

# ╔═╡ a011fe06-e807-46d8-8549-ce0dfad359b2
md"""
## DataFrame简介
DataFrame是数据分析中非常核心的数据结构。 在R、Python中都有相关的包多DataFrame进行分析。在Julia中， [DataFrames.jl](https://dataframes.juliadata.org/stable/)是DataFrames分析的核心包。

一个DataFrame， 可以看成是一个Excel的工作簿。 如上面的竞赛数据， 通常每一列是一个**字段(特征)**， 每一行代表一个**样本**。从数据形式上看， 每一列可以看成一个**向量**(事实上是NamedTuple)，因此，一个DataFrame也可以看成是多个向量在水平方向排列而成。

基本的DataFrames操作涵盖内容非常丰富， 下面简单介绍一下， DataFrames的创建与数据提取。更高级的操作会结合其他工具。



"""

# ╔═╡ 85619e07-5afa-410a-93e8-87d486985bbc
md"""
## 创建DataFrame
###  1. 用DataFrame构造
我们说直接用类型名，当成函数调用。相当于调用类型的构造函数。
"""

# ╔═╡ bc4705e7-7ada-4c42-879f-f4cb0a841d48
df1 = DataFrame(A=1:4, B=["M", "F", "F", "M"])

# ╔═╡ a42d6415-d4f2-4a93-b789-3b334f901b22
md"""
### 2. 按列构造
"""

# ╔═╡ d05cd1c1-47f7-4fc0-bdf3-961403f5e6fa
df2 = DataFrame()

# ╔═╡ 50285b45-8a80-49e1-831f-e0ea4961c242
df2.A = [1,2,3]

# ╔═╡ f7f158b8-f302-473c-96d2-03d1e1f0fab0
df2.B = string.('a' : 'c')

# ╔═╡ 79276117-4453-44ae-b731-e1e540b2f411
df2

# ╔═╡ 55f028aa-dd73-40d4-8580-8a19c2ba522e
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

# ╔═╡ 2f079f31-2a83-494e-96fc-c9f59f5e6a86
md"""
## 初步探索
一般， 我们读取进来一份数据，首先要看看是否存在明显的问题。这时候，可以通过产看一些基本信息做大致了解。
"""

# ╔═╡ 3a524dc5-602d-4f6b-8d95-836726812521
# 查看前面5行
first(train,5)

# ╔═╡ 09093f42-cd7e-49d6-bfbf-86f924608e4b
#查看后面5行
last(train, 5)

# ╔═╡ e9f4e838-c8af-4755-8187-23a7edc74689
md"""
`describe`函数是一个更全面的查看数据集的函数。 该函数返回数据集中每一个字段的多个统计信息。可以自己定义要返回的信息。
"""

# ╔═╡ 2f21caa8-ab4c-4618-8cae-24a7e44382e3
describe(train)

# ╔═╡ b63060c1-9c77-4b30-8e3d-c5914e1e0503
md"""
### 行提取示例
下面我们从数据框train中提取一些数据，演示df[row,col]的使用。
"""

# ╔═╡ 9585c308-1c8c-486d-bd90-ef67157c4f8c
# 提取第1,3,5行
train[[1,3,5],:]

# ╔═╡ ff404d1b-e30c-4361-8b58-aba877f1442c
md"""
下面提取60岁以上的样本
"""

# ╔═╡ 3c2151db-27a8-46e9-aa06-9a03c1dd2c70
train[train.age .> 60,:]

# ╔═╡ 449b1c53-435a-4f9b-bb73-e9e8b0a49f8d
md"""
### 列提取
"""

# ╔═╡ f3d7034d-0a1d-4534-a4eb-8ab2a14ef5c5
train[:, [:age]]

# ╔═╡ 77a1f08f-d787-4da7-86bd-494ae8b8f9f9
train[:, "age"]

# ╔═╡ c0ea32b2-6719-438d-a304-501235cbcfc8
train[:,2] # age是第二列

# ╔═╡ ebb3c198-20ea-4e7c-b420-e8845a714768
md"""
如果要一次性提取多列，需要将相关的列组织到向量中。其他都是类似的。
"""

# ╔═╡ 4d63587a-e898-453a-b039-5049d00c22b1
train[:, [:age, :customer_months]]

# ╔═╡ c3b0fe8d-2dbb-48c0-8561-b0e822044369
train[:, [2,3]]

# ╔═╡ 3967bb2d-6e64-44d8-bac3-8c1850242de3
train[:, ["age", "customer_months"]]

# ╔═╡ cfe7594b-e2ac-4322-927b-9a89fc6a023a
md"""
### 同时选择行与列
上面单独选择行或者列时， 对应的列和行我们都是用冒号：， 这表示选择所有列和行。 我们可以把行和列的所有选择同时写上， 去实现对相应的行和列的选择。

比如，我们要选择60岁以上的用户，同时查看其查看成为用户的月份。
"""

# ╔═╡ f7ff9710-9ce1-45d9-9de2-391dff92aca1
train[train.age .> 60, :customer_months]

# ╔═╡ 23ec8ecd-0a1d-4cbf-9c16-e6c9e4df4a2f
md"""
### 统计分析
提取行列是为了对数据进一步分析， 比如我们想计算顾客的平均年龄,最大值,等等
"""

# ╔═╡ b91aa042-b799-484e-b8ae-3185ffcb0870
mean(train[:,:age])

# ╔═╡ 1d433d92-0d15-4d3e-8967-ce56bd0fbab8
maximum(train[:,:age])

# ╔═╡ 78052a7d-8817-40fc-bcc8-059ac863daab
md"""
60岁以上的客户成为客户的平均时长是：$(mean(train[train.age .> 60, :customer_months]))，都是老客户。
"""

# ╔═╡ 04500b18-0bc3-4832-a705-40abab0203b3
mean(train[train.age .> 60, :customer_months])

# ╔═╡ 2d426acd-0656-4d1a-a6ec-1ecec9e7578c
md"""
## DataFramesMeta高级操作
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
```
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

# ╔═╡ ecd72951-ea5d-48cf-9671-ebeaa68ed07c
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

# ╔═╡ d8572ec7-24af-49c2-a8d9-f3f2e852fca9
data = @select train :id = :policy_id :age :customer_months 	:premium = :policy_annual_premium	:limit = :umbrella_limit	:sex = :insured_sex	:edulevel =	:insured_education_level	:fraud

# ╔═╡ 5a69736c-6adb-4815-981a-9e8d76febfdd
dt = @select train  :age :sex = :insured_sex	

# ╔═╡ 9083eb06-b4da-47ba-ba48-08562e73721e
md"""
有时候， 我们可能碰到要选择的列的名字保存在外部的变量， 或者一个字符串中， 这时候，我们需要使用\$符号。**注意：**这时候不是加冒号。
"""

# ╔═╡ 1dca62f5-21fc-4619-bac2-a9708b02b98b
name1 = :age

# ╔═╡ 4266eec9-6297-48cf-bb54-a3e79dac72d7
name2 = "customer_months"

# ╔═╡ 32168499-d2ba-476a-89e9-8711df05f4e7
@select train :policy_id $name1 $name2

# ╔═╡ a1670d68-05da-4303-b5a3-27a1266e3446

md"""
### 选择行(样本) @subset and @rsubset
这里我们使用选择好字段的新的数据框去操作， 因为我们已经重命名了。

选择行在Excel里面就是数据筛选。 现在， 假定我们要找到所有年龄大于或等于40岁的样本。 
"""

# ╔═╡ bfe54191-7b29-48dd-b6bc-014f9f6f8d33
@subset data :age .>= 40

# ╔═╡ bf3740cf-0153-4c9d-b6da-e09175a2ce8e
agedy40=@rsubset data :age >= 40 

# ╔═╡ 4f01aaa9-5169-45e5-9646-6098657adf7e
md"""
上面的`:age .>= 40`是一个条件表达式， 希望你注意到了大于符号前面有个点号， 这表示的是按元素比较大小， 因为:age是一个向量， 不能直接把向量和数值做大小比较， 而是应该把向量的每一个元素跟40去比较。

你可能会觉得点运算比较麻烦， 那么你可以使用按行操作的版本。 这时候， 条件会按行去执行， 每次拿来比较的就是单个元素， 而不是整列形成的向量了。 你可以选择你喜欢的方式， 不过建议你还是要熟悉Julia的点运算， 因为它很常见。

为了简单起见， 下面的选择采用按行版本。
"""

# ╔═╡ d8c665e3-a7c0-4783-aed8-9d6a9515dcc8
@rsubset data :age > 40 

# ╔═╡ 40f82933-ffbd-407c-aaa1-3f73042da885
md"""
很多时候， 我们可能会需要选择通常满足多个条件的列。 这时候， 可以将条件依次写出来。

假定我们要选择，年龄在40岁以上， 性别是男性， 又是欺诈的样本。 注意，比较是否相等是两个等号。
"""

# ╔═╡ 2e743657-9933-4d22-980b-b4b7f465cef7
@rsubset data :age >= 40 :sex == "MALE" :fraud == 1

# ╔═╡ 5a632399-7cbd-419f-8057-15934d507137
md"""
上面的写法虽然没错， 但可以更整洁， 我们可以将所有的条件用`begin end`形成的代码块, 每个条件占一行， 还可以注释
"""

# ╔═╡ f7185c05-49d3-4b08-876f-6f1541e161c0
@rsubset data begin
	:age >= 40 # 年龄大于40
	:sex == "MALE"  # 性别是男性
	:fraud == 1 # 欺诈样本
end

# ╔═╡ 42b6e974-571c-4bfa-a77b-17fe4729920b
md"""
如果你喜欢函数调用的方式， 类似R语言， 也可以像下面这么写， 不过我们统一用宏的方式去写。
"""

# ╔═╡ 4b56ce9c-ba4b-4d57-bc85-01068bde0920
@rsubset(data ,:age >= 40 ,:sex == "MALE", :fraud == 1)

# ╔═╡ c2800bfb-a8aa-4d2b-bb98-0c97968f4ad1
md"""
有时候， 一个字段可能有多个取值， 你希望过滤出其中的部分。 比如， 你希望获得所有学历是研究生或博士生的样本， 当然可以使用"或"运算连接多个条件， 如`(:edulevel ==  "MD" ||  :edulevel ==  "PhD" )`。 但我们有更高效的做法。 简单来说就是把想要的取值构成一个集合， 然后去按行判断， 相应的字段取值是否在（in）该集合中。 集合可以用Set构造， 或者直接是向量也行。
"""

# ╔═╡ c3eef275-34b0-422f-ad89-7826dde9e629
@rsubset data :edulevel == "MD" || :edulevel == "PhD"

# ╔═╡ 0e202cf2-4607-4327-9244-801616c310b9
xueli = ["MD", "PhD"]

# ╔═╡ e39dfb59-6f6f-4dfa-90d3-9fe49d48731d
@rsubset data :edulevel in xueli

# ╔═╡ 4d45a7e0-4188-4975-96bd-8432b01c5655
# 49223c2a-bc54-4062-8fec-e4589e737815
md"""
你可以使用`>, <, >=, <=, !=, in` 和 `&& || !`去构造和组合出复杂条件
"""

# ╔═╡ 7f8c3772-5463-4f76-b57e-f11b83733fe3
md"""
### 管道操作@chain
数据分析中， 我们常常许多要对数据做多次处理、加工。 通常， 上一个操作得到的数据，会进入下一个操作继续加工。这相当于， 数据流过一个管道， 经过不同的环节， 进行不同的处理。 这类操作被称为管道操作， 可以使用`@chain`实现。 

假定我们要选择年龄大于40岁， 性别是男性的样本， 但我们又只想看到id列和是否欺诈两列。 如果不使用管道操作， 我们需要这么做：
1. 首先， 把需要的行选出来， 结果保存在临时变量data1中
2. 然后， 从临时变量data1中， 选择需要的列
"""

# ╔═╡ ddd3ffc2-8546-403b-9b00-92c5a71a7ddc
begin
data1 = @rsubset data :age >=40 :sex == "MALE"
data2 = @select data1 :id :fraud
end

# ╔═╡ bc9e1120-102f-4c76-b55a-7c563526b3dd
md"""
很明显， 上面的操作引入了一个临时变量， 浪费了脑力（取名字不是容易的事）， 如果顺序操作的次数很多， 这种方式会很麻烦， 用管道操作就方便很多了。

下面的@chain宏， 表示管道操作。 其第一个参数是要操作的数据 data, 第二个参数是后面的一系列操作函数， 用`begin ... end`括起来了。 数据data 首先 流入 @rsubset， 这时， 这个宏第一个参数不再是数据框， 默认的就是data。 经过第一个宏处理之后， 会生成一个新的数据框， 这个数据框流入第二个宏@select， 同样，这个宏也不需要输入数据参数。

"""

# ╔═╡ 85d8feb8-bdd4-4b41-9aff-12cf0ee326af
@chain data begin
	@rsubset  :age >=40 :sex == "MALE"
	@select  :id :fraud
end

# ╔═╡ 85166317-6078-4787-b749-9b7ccfd7fb5d
md"""
接下来， 我们所有的操作都将用管道操作的方式。
"""

# ╔═╡ 696b9d9c-f386-4808-bced-656c9da5cfa9
# 0a24412a-b948-4888-8e0c-185d387606cf
md"""
### 重新排序行@orderby
如果想要对数据按照某些字段排序， 可以简单的将字段列出来

下面按照年龄和成为客户的时间排序：
age	customer_months
"""

# ╔═╡ a88b586d-a135-40e3-a807-592419f3e226
data

# ╔═╡ 20fe94f4-1ef4-4081-a8be-4070915cce2f
@orderby data :age	:customer_months

# ╔═╡ 79a72752-91bf-43c4-b805-721c590024c0
md"""
默认的排序是按照升序排的， 你可以在变量上加上负号实现降序排列
"""

# ╔═╡ b07dafaf-8f3a-4541-96bf-ccb505cf1b25
@orderby data begin
	:age	 # 年龄是升序
	-:customer_months # 成为顾客的时间是降序
end

# ╔═╡ fb5b90ed-a024-413a-8e26-46a89d44ad7f
md"""
现在， 让我们把需求弄得复杂一点， 下面的代码含义很清晰， 最后的first 是用于查看一个数据框的前n行。这是一个普通函数， 因此，前面没有@符号。
"""

# ╔═╡ 59e1d8a9-1c05-4056-ac16-e54c1b7b00c8
@chain data begin
	@select :age :premium :sex :fraud
	@rsubset :age >=40
	@orderby :premium
	first(10)
end

# ╔═╡ 1520b9fa-2387-455a-85c9-b5ba74416b5b
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

# ╔═╡ 0bfdd5a7-c9bc-454e-b6f2-cead7a99d2db
data3 = @select train :age :total_claim_amount	:injury_claim	:property_claim	:fraud :vehicle_claim

# ╔═╡ 12477184-b1fa-4ff0-90d1-c91cf6be6fde
md"""
接下来， 我们计算每一种索赔金额占到整体索赔金额的比例, 并将其依次命名
"""

# ╔═╡ 7f4297b7-379b-430b-ab32-c91ac774c9d5
@transform data3 begin
	:pop_injury = :injury_claim ./ :total_claim_amount 
	:pop_vehical = :vehicle_claim ./ :total_claim_amount
end

# ╔═╡ 175a3dc8-4711-497c-a04b-d1c592d4f851
md"""
上面用的是点运算， 老规矩， 我们用按行运算可能对某些同学更友好。
"""

# ╔═╡ b79ef94d-bf5b-47ce-b772-05512bdf65a1
@rtransform data3 begin
	:pop_injury = :injury_claim / :total_claim_amount 
	:pop_vehical = :vehicle_claim / :total_claim_amount
end

# ╔═╡ 3273a797-addf-47cf-a2fc-779bbd7cb9b5
data3

# ╔═╡ a6217038-ec98-40ac-af86-d083f4f92c2f
md"""
上面新增列时， 所有旧的列都带上了， 有时候， 我们只希望留下新增的和部分旧的， 那这时候可以使用@select宏， 也就是@select宏可以实现对新增的列的选择。
"""

# ╔═╡ da874fb3-3f69-48d6-a781-f29208ce849a
@rselect data3 begin
	:total_claim_amount # 选择旧的总量
	:pop_injury = :injury_claim / :total_claim_amount # 选择新增的列
	:pop_vehical = :vehicle_claim / :total_claim_amount # 选择新增的列
end

# ╔═╡ 785ec974-fa8a-410d-9d04-5ad1298ea87e
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

# ╔═╡ 46b91bc5-ca94-49ab-ab53-22f945da19b7
function getclass(age)
	if age > 60
		return "老"
	elseif age >= 40
		return "中"
	else
		return "青"
	end
end

# ╔═╡ 54f1cb21-e3b7-4b23-942a-29e4ad7bbced
getclass(45)

# ╔═╡ fcfa3fc2-2618-4e82-ae0d-37626d6c278d
@rselect data3 begin
	:age
	:class = getclass(:age)
end

# ╔═╡ 58d65107-bdd7-4dce-84bb-b8fbbb878e0b
md"""
### 汇总信息 @combine
我们经常需要计算数据中的一些汇总信息，比如，均值、方差等等，这可以通过@combine宏实现。

比如， 假设我们要计算客户的平均年龄， 由于要使用到一些统计函数， 我们需要加载统计包
"""

# ╔═╡ 627d2d0c-9162-46b4-8569-eaee31f7bdc7
@combine data3 :mage = mean(:age)

# ╔═╡ 27081374-ef70-40ec-a645-175bdd361129
md"""
有时候， 我们需要很多的统计量, 比如我们想知道平均值，最大值，最小值
"""

# ╔═╡ 0f7e89fe-2601-4b42-8c69-91702803437f
@combine data3 begin
	:mage = mean(:age)
	:maxage = maximum(:age)
	:minage = minimum(:age)
end

# ╔═╡ 920f9495-35a0-4fdb-a909-21ec209e3b91
md"""
求汇总信息的一个更常见也更重要的场景是分类汇总。 假设我们要计算不同年龄类别的索赔平均值，应该怎么算呢？ 
"""

# ╔═╡ b436cff1-aacf-4704-a1cd-f046e50e5ea1
@chain data3 begin
	@rtransform :class = getclass(:age) # 先构造一个年龄类别特征
	groupby(:class) # 然后根据这个类别将数据分组
	@combine :mamount = mean(:total_claim_amount) # 计算每一组中总的索赔额的平均值
end

# ╔═╡ 9829a5a2-2e72-4691-a32a-e9ad56d9d82e
md"""
上面的代码中用到了一个分组函数groupby， 这是分类汇总中一个非常重要的操作， 可以简单看一下这个函数的返回值, 比如， 按照是否欺诈数据可以分为两个组。分组的结果是一个GroupedDataFrame， 很多操作对GroupedDataFrame还是成立的。
"""

# ╔═╡ 55fa6dd4-2a33-4076-909f-3094ee1d434a
groupby(data3, :fraud)

# ╔═╡ 495f5e88-c515-43cd-ae08-2069830d0bed
md"""
另一个例子， 假设我们要计算不同年龄段的欺诈比率， 这里使用到一个01向量的特性， 求和的值等于取1的数量。
"""

# ╔═╡ 202b92df-50e7-4fc2-8518-f040eaf247ff
@chain data3 begin
	@rtransform :class = getclass(:age) # 先构造一个年龄类别特征
	groupby(:class) # 然后根据这个类别将数据分组
	@combine :pop = sum(:fraud)/length(:fraud) # 计算每一组中欺诈的比率
end

# ╔═╡ b5127e3f-2bf8-40ad-8567-cdf96741080e
md"""
有许多统计量可能常常用于计算特征，比如 std, minimum, maximum, median, sum, length (向量长度), first (返回向量前面的值), 和 last (返回向量最后的值).
"""

# ╔═╡ 9670ce45-61bc-4bdf-bb44-6eff9df3f9e6
md"""
### 感兴趣的问题
"""

# ╔═╡ e334fdf4-bead-4da7-8880-d5c330cc1075
md"""
1. 哪种性别的用户欺诈可能性更高？
分析： 回答这个问题，需要
1. 先将用户按性别分组
2. 统计每一组的欺诈比率

"""

# ╔═╡ 5066933d-85e6-480f-9546-08bf4fb9670d
@chain data begin
	groupby(:sex)
	@combine :frate = sum(:fraud)/length(:fraud)
end

# ╔═╡ c20a732b-d91a-4d50-8f3b-a30d169b8e68
md"""
2. 计算不同学历水平的欺诈率，并将其按从高到低排序
"""

# ╔═╡ d4a0827c-c67c-4692-8032-c7d773e65e5e
@chain data begin
	groupby(:edulevel)
	@combine :frate = mean(:fraud)
	@orderby -:frate
end

# ╔═╡ 4212ebfe-a9d1-43ab-b113-fd15ada14485
@chain data begin
	@subset :fraud .== 1
	groupby(:sex)
	@combine :nf = length(:sex)
end

# ╔═╡ 76f62f9c-e8ea-4081-8b2d-ed0c412e713e
@chain train begin
	groupby(:insured_occupation)
	@combine :frate = mean(:fraud)
	@orderby -:frate
end

# ╔═╡ b9614744-a193-49ba-83b1-7203339e295e
md"""
# 作业
撰写一份保险欺诈数据分析报告，主要目的是了解数据集中相关字段的分布情况， 获得欺诈行为出现哪些因素影响比较大的感性认识。 可以从投保人角度、被保险人角度、保费角度、出险角度（时间、地点、车辆等）展开分析。 要求要有分析，图形（画图在下一次课程讲），有观察结果。作业时间3周。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "2da5d7242942dc98db3032203ac3418e173b9ae0"

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

[[deps.Chain]]
git-tree-sha1 = "8c4920235f6c561e401dfe569beb8b924adad003"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.5.0"

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
version = "1.1.0+0"

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

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "6970958074cd09727b9200685b8631b034c0eb16"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.14.1"

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

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

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

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

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

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

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
# ╠═1cb16cc0-e59d-11ee-18d5-db8c12080e18
# ╟─0bfed7d1-4fd6-484d-b3d5-121186a68b55
# ╟─7cc9cf55-393b-4c18-907b-115a8eda1958
# ╠═b024d006-8d14-4b83-9a4d-d7f1a5a50244
# ╟─023d6149-b031-498e-9985-e27f1dbefbc8
# ╟─a011fe06-e807-46d8-8549-ce0dfad359b2
# ╟─85619e07-5afa-410a-93e8-87d486985bbc
# ╠═bc4705e7-7ada-4c42-879f-f4cb0a841d48
# ╟─a42d6415-d4f2-4a93-b789-3b334f901b22
# ╠═d05cd1c1-47f7-4fc0-bdf3-961403f5e6fa
# ╠═50285b45-8a80-49e1-831f-e0ea4961c242
# ╠═f7f158b8-f302-473c-96d2-03d1e1f0fab0
# ╠═79276117-4453-44ae-b731-e1e540b2f411
# ╟─55f028aa-dd73-40d4-8580-8a19c2ba522e
# ╟─2f079f31-2a83-494e-96fc-c9f59f5e6a86
# ╠═3a524dc5-602d-4f6b-8d95-836726812521
# ╠═09093f42-cd7e-49d6-bfbf-86f924608e4b
# ╟─e9f4e838-c8af-4755-8187-23a7edc74689
# ╠═2f21caa8-ab4c-4618-8cae-24a7e44382e3
# ╟─b63060c1-9c77-4b30-8e3d-c5914e1e0503
# ╠═9585c308-1c8c-486d-bd90-ef67157c4f8c
# ╟─ff404d1b-e30c-4361-8b58-aba877f1442c
# ╠═3c2151db-27a8-46e9-aa06-9a03c1dd2c70
# ╟─449b1c53-435a-4f9b-bb73-e9e8b0a49f8d
# ╠═f3d7034d-0a1d-4534-a4eb-8ab2a14ef5c5
# ╠═77a1f08f-d787-4da7-86bd-494ae8b8f9f9
# ╠═c0ea32b2-6719-438d-a304-501235cbcfc8
# ╟─ebb3c198-20ea-4e7c-b420-e8845a714768
# ╠═4d63587a-e898-453a-b039-5049d00c22b1
# ╠═c3b0fe8d-2dbb-48c0-8561-b0e822044369
# ╠═3967bb2d-6e64-44d8-bac3-8c1850242de3
# ╟─cfe7594b-e2ac-4322-927b-9a89fc6a023a
# ╠═f7ff9710-9ce1-45d9-9de2-391dff92aca1
# ╟─23ec8ecd-0a1d-4cbf-9c16-e6c9e4df4a2f
# ╠═b91aa042-b799-484e-b8ae-3185ffcb0870
# ╠═1d433d92-0d15-4d3e-8967-ce56bd0fbab8
# ╟─78052a7d-8817-40fc-bcc8-059ac863daab
# ╠═04500b18-0bc3-4832-a705-40abab0203b3
# ╟─2d426acd-0656-4d1a-a6ec-1ecec9e7578c
# ╟─ecd72951-ea5d-48cf-9671-ebeaa68ed07c
# ╠═d8572ec7-24af-49c2-a8d9-f3f2e852fca9
# ╠═5a69736c-6adb-4815-981a-9e8d76febfdd
# ╟─9083eb06-b4da-47ba-ba48-08562e73721e
# ╠═1dca62f5-21fc-4619-bac2-a9708b02b98b
# ╠═4266eec9-6297-48cf-bb54-a3e79dac72d7
# ╠═32168499-d2ba-476a-89e9-8711df05f4e7
# ╟─a1670d68-05da-4303-b5a3-27a1266e3446
# ╠═bfe54191-7b29-48dd-b6bc-014f9f6f8d33
# ╠═bf3740cf-0153-4c9d-b6da-e09175a2ce8e
# ╟─4f01aaa9-5169-45e5-9646-6098657adf7e
# ╠═d8c665e3-a7c0-4783-aed8-9d6a9515dcc8
# ╟─40f82933-ffbd-407c-aaa1-3f73042da885
# ╠═2e743657-9933-4d22-980b-b4b7f465cef7
# ╟─5a632399-7cbd-419f-8057-15934d507137
# ╠═f7185c05-49d3-4b08-876f-6f1541e161c0
# ╟─42b6e974-571c-4bfa-a77b-17fe4729920b
# ╠═4b56ce9c-ba4b-4d57-bc85-01068bde0920
# ╟─c2800bfb-a8aa-4d2b-bb98-0c97968f4ad1
# ╠═c3eef275-34b0-422f-ad89-7826dde9e629
# ╠═0e202cf2-4607-4327-9244-801616c310b9
# ╠═e39dfb59-6f6f-4dfa-90d3-9fe49d48731d
# ╟─4d45a7e0-4188-4975-96bd-8432b01c5655
# ╟─7f8c3772-5463-4f76-b57e-f11b83733fe3
# ╠═ddd3ffc2-8546-403b-9b00-92c5a71a7ddc
# ╟─bc9e1120-102f-4c76-b55a-7c563526b3dd
# ╠═85d8feb8-bdd4-4b41-9aff-12cf0ee326af
# ╟─85166317-6078-4787-b749-9b7ccfd7fb5d
# ╟─696b9d9c-f386-4808-bced-656c9da5cfa9
# ╠═a88b586d-a135-40e3-a807-592419f3e226
# ╠═20fe94f4-1ef4-4081-a8be-4070915cce2f
# ╟─79a72752-91bf-43c4-b805-721c590024c0
# ╠═b07dafaf-8f3a-4541-96bf-ccb505cf1b25
# ╟─fb5b90ed-a024-413a-8e26-46a89d44ad7f
# ╠═59e1d8a9-1c05-4056-ac16-e54c1b7b00c8
# ╟─1520b9fa-2387-455a-85c9-b5ba74416b5b
# ╠═0bfdd5a7-c9bc-454e-b6f2-cead7a99d2db
# ╟─12477184-b1fa-4ff0-90d1-c91cf6be6fde
# ╠═7f4297b7-379b-430b-ab32-c91ac774c9d5
# ╟─175a3dc8-4711-497c-a04b-d1c592d4f851
# ╠═b79ef94d-bf5b-47ce-b772-05512bdf65a1
# ╠═3273a797-addf-47cf-a2fc-779bbd7cb9b5
# ╟─a6217038-ec98-40ac-af86-d083f4f92c2f
# ╠═da874fb3-3f69-48d6-a781-f29208ce849a
# ╟─785ec974-fa8a-410d-9d04-5ad1298ea87e
# ╠═46b91bc5-ca94-49ab-ab53-22f945da19b7
# ╠═54f1cb21-e3b7-4b23-942a-29e4ad7bbced
# ╠═fcfa3fc2-2618-4e82-ae0d-37626d6c278d
# ╟─58d65107-bdd7-4dce-84bb-b8fbbb878e0b
# ╠═627d2d0c-9162-46b4-8569-eaee31f7bdc7
# ╟─27081374-ef70-40ec-a645-175bdd361129
# ╠═0f7e89fe-2601-4b42-8c69-91702803437f
# ╟─920f9495-35a0-4fdb-a909-21ec209e3b91
# ╠═b436cff1-aacf-4704-a1cd-f046e50e5ea1
# ╟─9829a5a2-2e72-4691-a32a-e9ad56d9d82e
# ╠═55fa6dd4-2a33-4076-909f-3094ee1d434a
# ╟─495f5e88-c515-43cd-ae08-2069830d0bed
# ╠═202b92df-50e7-4fc2-8518-f040eaf247ff
# ╟─b5127e3f-2bf8-40ad-8567-cdf96741080e
# ╟─9670ce45-61bc-4bdf-bb44-6eff9df3f9e6
# ╟─e334fdf4-bead-4da7-8880-d5c330cc1075
# ╠═5066933d-85e6-480f-9546-08bf4fb9670d
# ╟─c20a732b-d91a-4d50-8f3b-a30d169b8e68
# ╠═d4a0827c-c67c-4692-8032-c7d773e65e5e
# ╠═4212ebfe-a9d1-43ab-b113-fd15ada14485
# ╠═76f62f9c-e8ea-4081-8b2d-ed0c412e713e
# ╟─b9614744-a193-49ba-83b1-7203339e295e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
