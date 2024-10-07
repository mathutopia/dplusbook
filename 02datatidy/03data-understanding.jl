### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 54d48980-e50b-11ee-01ff-833f16130cde
using TidierFiles, TidierData, PlutoUI,ScientificTypes, StatsBase,TidierCats, PlutoTeachingTools,TidierDates

# ╔═╡ aec56a53-fb02-4fd9-a30d-603fe4583a47
using MultivariateStats

# ╔═╡ be3b73ca-f440-4273-a268-77f5a7780bae
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据分析与挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			数据理解
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 2aa3bad3-cf55-4b7d-b9ff-b9a3bc6813cb
md"""
# 基本概念
## 属性类型理解
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

"""

# ╔═╡ 47212dab-e290-42a3-b3c5-2a5db45ff946
md"""

## 常见数据集形式
常见的数据进行时包括购物篮数据， 基于图形的数据， 有序数据和矩阵形式的数据等。其中矩阵形式的数据在实际中是应用最广泛的，也是最常见的。

$$\left(\begin{array}{cccc}
    a_{11} & a_{12} & \cdots & a_{1k}\\  %第一行元素
	\vdots & \vdots & \vdots & \vdots\\
    a_{n1} & a_{n2} & \cdots & a_{nk}\\  %第二行元素
  \end{array}
\right)$$ 
一般而言， 矩阵的每一行代表一个**样本（观测）**， 每一列代表一个**特征（属性）**。 由于矩阵通常要求元素具有相同的数据类型， 而样本的属性可能具有不同类型的取值， 在Julia、Python、R等数据分析语言中， 有专门为这一类数据定制的数据结构--数据框（dataframe）。 在Julia中， Dataframes.jl包（类似于Python中的Pandas包）就是专门处理这类数据的包， 对数据分析来说， 如果操作dataframe是一定要掌握的。 下面的内容我都会用Tidier下面的包来实现。
"""

# ╔═╡ ac7998a8-56e9-470e-ab9e-eaeb2e16f118
md"""
# 数据理解
为了更好的建模，深入理解数据是必要的。首先是从语义上要搞清楚， 数据中有多少样本，字段， 以及每一个字段的含义，分别有多少种可能得取值等。

下面的数据来自天池的竞赛:[零基础入门金融风控-贷款违约预测](https://tianchi.aliyun.com/competition/entrance/531830/introduction?spm=a2c22.12281925.0.0.200671373g8WgN). 用这份数据的原因是， 这份数据中包含缺失值， 方便演示如何处理缺失值。 不过， 原始数据有80W行， 为了简单期间， 我们的数据只是取了一个子集， 1万行。
"""

# ╔═╡ 7cc9cf55-393b-4c18-907b-115a8eda1958
md"""
## 数据读取
"""

# ╔═╡ f67e2900-c720-44cb-8988-800f6b8e5389
TableOfContents(title="目录")

# ╔═╡ b024d006-8d14-4b83-9a4d-d7f1a5a50244
train = read_csv("../data/train1w.csv")

# ╔═╡ 023d6149-b031-498e-9985-e27f1dbefbc8
md"""
## 字段含义
了解字段含义含义是简单的， 可以直接从文档中去了解， 我将其罗列如下：

| Field | Description |
| --- | --- |
| id | 为贷款清单分配的唯一信用证标识 |
| loanAmnt | 贷款金额 |
| term | 贷款期限（年） |
| interestRate | 贷款利率 |
| installment | 分期付款金额 |
| grade | 贷款等级 |
| subGrade | 贷款等级之子级 |
| employmentTitle | 就业职称 |
| employmentLength | 就业年限（年） |
| homeOwnership | 借款人在登记时提供的房屋所有权状况 |
| annualIncome | 年收入 |
| verificationStatus | 验证状态 |
| issueDate | 贷款发放的月份 |
| purpose | 借款人在贷款申请时的贷款用途类别 |
| postCode | 借款人在贷款申请中提供的邮政编码的前3位数字 |
| regionCode | 地区编码 |
| dti | 债务收入比 |
| delinquency_2years | 借款人过去2年信用档案中逾期30天以上的违约事件数 |
| ficoRangeLow | 借款人在贷款发放时的fico所属的下限范围 |
| ficoRangeHigh | 借款人在贷款发放时的fico所属的上限范围 |
| openAcc | 借款人信用档案中未结信用额度的数量 |
| pubRec | 贬损公共记录的数量 |
| pubRecBankruptcies | 公开记录清除的数量 |
| revolBal | 信贷周转余额合计 |
| revolUtil | 循环额度利用率，或借款人使用的相对于所有可用循环信贷的信贷金额 |
| totalAcc | 借款人信用档案中当前的信用额度总数 |
| initialListStatus | 贷款的初始列表状态 |
| applicationType | 表明贷款是个人申请还是与两个共同借款人的联合申请 |
| earliestCreditLine | 借款人最早报告的信用额度开立的月份 |
| title | 借款人提供的贷款名称 |
| policyCode | 公开可用的策略_代码=1新产品不公开可用的策略_代码=2 |
| n系列匿名特征 | 匿名特征n0-n14，为一些贷款人行为计数特征的处理 |


请注意，表格中的 "n系列匿名特征" 是竞赛给的匿名特征， 所有没有具体的含义。

"""

# ╔═╡ a14cb588-7f9d-492a-a5b6-32b4da879d38
md"""
## 数据类型

理解数据一个重要的操作是理解数据的存储情况， 即每一个字段是怎么存储的。 简单来说， 你可以将一个dataframe的每一个列看成是一个向量。 一个dataframe就是多个长度相同的向量组合而成的。 我们可以通过dataframe的`名字.字段`的形式去查看每一个字段。 有时候， 知道每一列是一个向量是不够的， 我们还希望了解， 向量中的每一个元素分别是什么类型的数据。 因为数据类型不同， 将决定其操作方式的差异。可以使用`eltype`函数， 获取一个向量中， 元素的数据类型。 以查看数据中，年龄字段的数据类型为例， 可以看到其元素类型是：$(eltype(train.loanAmnt)).


存储类型只是反应了数据是如何存储的， 但数据应该如何理解无法从存储类型中直接得出。 数据的理解涉及到对数据的每一列，分析其是定性属性，还是定量属性。对定性属性，还要看是标称属性。 这种从人的角度看数的类型，叫做数据的科学类型。 同样的存储类型， 可能意味着完全不同的含义， 比如，整数0和1， 既可以是通常意义下的数值， 也可能表示性别（这时候表示一个类别）。在这种情况下， 我们需要通过科学类型来区分数据表示的含义（本质上， 科学类型时是为了方便从人（建模）的角度区分属性的类型而设计的）。 

如果要使用科学类型， 需要用到ScientificTypes.jl包。下面是你可能会在本课程中几个科学类型。


```julia
Finite{N}
├─ Multiclass{N}
└─ OrderedFactor{N}

Infinite
├─ Continuous
└─ Count

ScientificTimeType
├─ ScientificDate
├─ ScientificTime
└─ ScientificDateTime

Textual

Missing

```
下面的表格给出了科学类型跟与类型的关系。注意， 区间属性和比率属性都是数值形式的， 虽然区分他们有意义， 但在建模过程中， 通常没有区分。

|类别|科学类型scitype|含义|举例|
| ---- | ---- | ---- | ----|
|有限型Finite{N}|有序因子OrderedFactor{N}**序数属性**|有N种可能的取值， 取值之间存在顺序关系（大小比较有意义）|成绩：不及格，及格，良好，优秀； |
||多类别因子Multiclass{N}**标称属性**|有N种类别， 类别之间无顺序关系|性别：男女；|中值、百分位、秩相关、游程检验、符号检验|
|无穷型Infinite|连续型（Continuous）|取值是某个区间中的所有值|身高， 体重|
||计数型Count|有无穷多取值， 但只能是正整数|家庭成员数量；班上学生人数|

我们可以方便的通过`elscitype`函数， 获取一个向量中， 元素的科学类型。 以查看数据中，贷款字段的科学类型为例， 可以看到其元素科学类型是：$(elscitype(train.loanAmnt)).
 
"""

# ╔═╡ 37ee6850-477d-4542-941d-72aaa8070a36
md"""
可以通过schema函数方便的获取数据的科学类型和存储类型
"""

# ╔═╡ a55a5d45-fd16-4979-8774-6edb86b538df
schema(train)

# ╔═╡ fe63b71b-114e-4abf-9b32-94b828941a92
md"""
当然， 将其转化为Dataframe可能显示会更好看。 请注意， **schema返回的第一列names是Symbol**。
"""

# ╔═╡ 879a29af-0515-47fd-804d-def795077cc9
DataFrame(schema(train))

# ╔═╡ 6c60453c-ecc0-4a2b-9a39-44807af45b1b
md"""
一般来说， 数据的存储类型和科学类型有如下的对应关系。

| 存储类型 | 科学类型 | 需要的包 |
|---------|-------------------|------------------------|
| Missing | Missing           |                        |
| Nothing | Nothing           |                        |
| AbstractFloat | Continuous       |                        |
| Integer | Count            |                        |
| String | Textual          |                        |
| CategoricalValue (unordered) | Multiclass{N} | CategoricalArrays.jl |
| CategoricalValue (ordered) | OrderedFactor{N} | CategoricalArrays.jl |
| Date | ScientificDate    | Dates                  |
| Time | ScientificTime    | Dates                  |
| DateTime | ScientificDateTime | Dates                  |

"""

# ╔═╡ 37190246-b809-4388-b2d9-8b7415894228
md"""
## 不同类型字段获取
有时候， 我们可能需要获取某种类型的所有字段， 这可以通过中括号的形式获取，使用到的关键函数是：`names`.
```julia
names(df::AbstractDataFrame, cols=:)
names(df, Type)
```
names 函数可以用于获取一个数据框中的字段名， 当然， 也可以用于获取一个数据框中所有Type类型的字段名。
下面的代码获取train中所有整型（Int）字段名。 获取了字段名之后， 我们就可以提取对应的字段了。
"""

# ╔═╡ 300eebf9-dc93-4132-aa16-ab53a701192e
names(train)

# ╔═╡ bfdc0184-b737-435c-b297-474459ee0a59
names(train, Int)

# ╔═╡ 5fc495b2-1124-4cbe-9f14-f6130355ded1
md"""
由于一般情况下， 数据要么是string， 要么是数值（包括整数和浮点数）， 所以有更快的办法获得字符串列或者是数值列。
"""

# ╔═╡ 434cd9e9-5aca-4344-b837-95548da86d19
@select(train, where(is_string)) |> names # 字符串列

# ╔═╡ 611572f7-84c3-4db1-a26f-04b8247a4f0e
@select(train, where(is_number)) |> names # 数值列

# ╔═╡ 574c25f6-4a8a-4c80-a9d7-d4b1f8c257fc
@select(train, where(x -> elscitype(x) == Textual)) |> names # 科学类型是Count的列

# ╔═╡ 78f76f55-7441-4581-ac90-0fce0dce6a66
md"""
# 类型修正
一般而言， 直接读取进来的数据， 其科学类型都是存疑的。 我们不能直接依赖上面的函数的返回结果去判断属性本身的类别。 因此， 我们需要细致的考虑变量的科学类型。 

一般而言， 字符类型会对应分类属性， 数值类型（整型或浮点型）对应数值属性。 因此， 我们需要关注如下的错误：1） 对数值类型的变量， 需要关注是否数值实际代表的是类别；（同时还要关注有序或无序情况）。
2） 对字符类型（Textual）， 一般应该是类别变量。 但也要注意是否存在数值被读取成字符的情况；

以上两种情况， 都可以从唯一值数量上看出一些端倪。 一般而言， 唯一值较少， 应该是分类属性， 唯一值较多， 则应该是数值属性。

因此， 唯一值较少的数值属性， 和唯一值较多的字符属性（Textual）都要重点关注。 
"""

# ╔═╡ 1d28bbc6-924d-4974-9bf1-a6b58b922aed
md"""
## 唯一值分析
"""

# ╔═╡ f9d60927-47b7-46ff-b6eb-3f571b6e1768
@chain train begin 
	@aside nms = names(train) # 先把列名存起来， 方便后面继续使用
	@summarise(across(everything(),(length ∘ unique ))) # 对每一类求一个函数值
	@pivot_longer(everything(), names_to = "names", values_to="nunique")
	@mutate(names = !!nms)
	@arrange(nunique)# 将结果排序
end

# ╔═╡ 36e7b107-316a-4b55-b669-03d978063638
md"""
下面的代码把科学类型和唯一值情况全部放到了一起。
"""

# ╔═╡ 72ddc0fa-547f-4830-ba65-ad5173d16f19

@chain train begin 
	@aside nms2 = Symbol.(names(train)) # 这里列名转化为Symbol是因为， 后面的schema中， 也是Symbol
	@summarise(across(everything(),(length ∘ unique )))
	@pivot_longer(everything(), names_to = "names", values_to="nunique")
	@mutate(names = !!nms2)
	@left_join(DataFrame(schema(train)) )
	@arrange(nunique)
end

# ╔═╡ 8425599e-88fb-4459-a5b8-f6a72499c065
md"""
从结果可以看到， policyCode只有一个唯一值， 这种字段对建模而言没用。 后面应该要删掉。

"""

# ╔═╡ bfae8a82-99e8-45fd-8c4f-d07c5292f660
md"""
## 唯一值较少
"""

# ╔═╡ 006b83f7-be91-4015-b39b-604d06dece71
md"""
### 标称属性修正
`initialListStatus`， 表示的是： 贷款的初始列表状态。 既然是一个状态， 那么应该是一个标称属性。 但其科学类型是：Count。 因为其存储的是整数。 下面的代码告诉我们， 这个字段有两种取值， 每种的样本数量分别为5763， 4237。
"""

# ╔═╡ 1892fff4-2e43-4586-abb7-f84c4047bdd7
countmap(train.initialListStatus)

# ╔═╡ d83e697d-4d08-4a7b-b227-b7c3e3146ee3
md"""
对于这种类型， 我们应该将其转化为类别变量， 可以使用categorical函数。 加载TidierCats.jl包（专门用于处理类别变量的）， 就可以了。
"""

# ╔═╡ ab263bcc-bfd0-4a39-87bc-3dc32ad63afd
@chain train begin 
@select(initialListStatus = categorical(initialListStatus))
end

# ╔═╡ 4c011faa-9a91-4b32-a141-b84a67ffdeb4
@chain train begin 
@select(initialListStatus = categorical(initialListStatus))
schema
end

# ╔═╡ eebc36fc-d634-4b58-a305-ba10aec37834
md"""
### 序数属性修正
grade属性，表示的是贷款的等级， 被解析成了Textual类型。 这是因为它存储类型是字符串。 既然是等级， 应该是一个序数属性。 下面的代码表明它有7种可能的取值， 分别为A,B,C,D,E,F,G.
"""

# ╔═╡ e3647ee7-023b-4436-99b7-55cf91ed03aa
countmap(train.grade)

# ╔═╡ 50ec515e-38fe-4931-b829-6d76615bb64e
md"""
这是一个序数属性， 我们需要知道其取值的大小关系。 题目没有告诉我们， 不过， 我们可以试着自己分析一下。下面看一下每种等级的贷款， 其违约的比率情况。
"""

# ╔═╡ de4e4a96-ff87-4c43-95ae-a1f5d87f6f67
@chain train begin 
@group_by(grade)
@summarise(ratio = sum(isDefault ==1)/length(isDefault))
@arrange()
end

# ╔═╡ ab98798e-bee3-4999-8a42-c4097013d3d5
md"""
可以看的出来， 贷款等级跟违约率之间确实存在很大关系。 而等级越靠近A， 违约率越低。 从贷款风险的角度看， 我们可以认为A<B<C<D<E<F<G。 因此， 我们应该这么修正这个字段。
"""

# ╔═╡ a15da6fa-4ef9-4091-aaf3-966120ec1c2a
@chain train begin 
@select(initialListStatus = categorical(grade, levels=["A", "B", "C", "D", "E", "F", "G"], ordered = true))
end

# ╔═╡ caa3da68-e91c-4872-920d-f114a53a725f
md"""
!!! warn "注意"
	请注意， 你需要同时指定levels和ordered两个参数。默认情况下， levels是全部的可能值， 但其排序会决定水平的排序， 这在有些情况下会出错。 ordered默认情况下为false，表示建立的是标称属性。
"""

# ╔═╡ be976a0f-174a-48f9-b54e-1774cbbe0435
md"""
我们再看一个属性，employmentLength， 这表示就业年限（年）， 按理说， 这个应该是数值型的数据， 但其取值不多， 而且是文本， 这意味着， 这可能要当做一个类别属性， 而且是序数属性。
"""

# ╔═╡ 255e6832-fe6a-4cc9-9dfe-a1887a50329b
countmap(train.employmentLength)

# ╔═╡ 8db2d648-4ffc-4d81-948b-e07704db6bcc
@chain train begin 
@select(employmentLength = categorical(case_when(	
	employmentLength=="< 1 year" => 0,
	employmentLength=="1 year" => 1,
	employmentLength=="2 years" => 2,
	employmentLength=="3 years" => 3,
	employmentLength=="4 years" => 4,
	employmentLength=="5 years" => 5,
	employmentLength=="6 years" => 6,
	employmentLength=="7 years" => 7,
	employmentLength=="8 years" => 8,
	employmentLength=="9 years" => 9,
	employmentLength=="10+ years" => 10,
	employmentLength=="NA" => missing,
),levels=[0,1,2,3,4,5,6,7,8,9,10], ordered=true))
end

# ╔═╡ cce08467-7ab0-4598-bb94-2e42b821f05e
@chain train begin 
@select(employmentLength = categorical(case_when(	
	employmentLength=="< 1 year" => 0,
	employmentLength=="1 year" => 1,
	employmentLength=="2 years" => 2,
	employmentLength=="3 years" => 3,
	employmentLength=="4 years" => 4,
	employmentLength=="5 years" => 5,
	employmentLength=="6 years" => 6,
	employmentLength=="7 years" => 7,
	employmentLength=="8 years" => 8,
	employmentLength=="9 years" => 9,
	employmentLength=="10+ years" => 10,
	employmentLength=="NA" => missing,
),levels=[0,1,2,3,4,5,6,7,8,9,10], ordered=true))
schema
end

# ╔═╡ 78d60c14-c032-44e7-895f-6aaf6fe11468
md"""
你发现其中的"NA"了吗？这不是一个年限， 应该是缺失值。
"""

# ╔═╡ b097000f-bdde-4e16-921c-63ec9a7f0278
@chain train begin 
@select(initialListStatus = categorical(grade, levels=["A", "B", "C", "D", "E", "F", "G"], ordered = true))
schema
end

# ╔═╡ 8feb6818-8827-44cb-bd46-0cf1828a2b70
md"""
## 唯一值较多
这种情况下，关注是否有文本形式存在的其他类型。 下面的代码选出， 唯一值的数量大于100， 但科学类型确实文本的字段。
"""

# ╔═╡ 58097000-4930-4115-a51e-6cf0a9101ee5
@select(train, where(x -> (length(unique(x))> 100) && (elscitype(x) == Textual)))

# ╔═╡ c4b82937-8c3a-420f-81e9-d2494fac58e0
md"""
### 日期数据
"""

# ╔═╡ 0b7d0757-a62f-4c45-b8a0-664ecd047821
md"""
earliesCreditLine，表示借款人最早报告的信用额度开立的月份， 他应该是一个日期型数据。我们可以使用TidierDates包去解析日期数据。不过数据中， 又缺少日， 需要将其转化为日期， 为此， 我们将每个月份转化为当月的第一天。 
"""

# ╔═╡ e3e88f5d-1e57-4bce-9c19-8ac52e397563
train.earliesCreditLine

# ╔═╡ b8e6ea94-5f1b-4aa9-bb1c-eb21980f2ee5
dmy("1-Oct-2007")

# ╔═╡ e0584c22-7394-431f-9905-ddf38019d4cd
dmy("1-Apr-2006")

# ╔═╡ f0127699-101b-44ae-af82-853028f9722c
@chain train begin 
@select earliesCreditLine = dmy("1-" * earliesCreditLine)
end

# ╔═╡ 07b38009-4e16-4939-a0fc-27e12b0823a1
@chain train begin 
@select earliesCreditLine = dmy("1-" * earliesCreditLine)
schema
end

# ╔═╡ 8122e11d-17a2-4272-91e1-c7b5c498dee4
md"""
### 文本形式的数值类型
"""

# ╔═╡ 8a76a81f-7774-4813-b619-73d31bc79bd5
md"""
revolUtil， 表示 循环额度利用率，或借款人使用的相对于所有可用循环信贷的信贷金额。 看名字就应该知道， 这应该是一个数值型属性， 但却是文本类型。 我们需要搞清楚， 为什么是这样的？
"""

# ╔═╡ 53586677-8e61-419b-b47b-8b1595db8979
train.revolUtil

# ╔═╡ e7bbba6f-a037-4371-b0ee-04d4ee237654
md"""
```julia
r"^-?\d+(\.\d+)?$" 
```
表示构建一个判断是否是数字的正则表达式, 这个正则表达式的组成部分解释如下：

- ^：表示字符串的开始。
- -?：表示负号，它是可选的。
- \d+：表示一个或多个数字（0-9）。\d 是数字字符的简写，+ 表示一个或多个。
- (\.\d+)?：表示小数点和小数部分，它是可选的。
- \.：表示小数点。在正则表达式中，. 是一个特殊字符，表示任何单个字符（除了换行符），所以需要用反斜杠 \ 进行转义。
- \d+：表示小数点后的一个或多个数字。
- ?：表示前面的小数部分是可选的。
- $：表示字符串的结束。

```julia
occursin.(r"^-?\d+(\.\d+)?$", train.revolUtil)
```
occursin用于判断模式是否在后面的字符串中存在， 也就是判断字符串是不是就是一个数字，如果是返回true， 否则返回false。  注意这里的点运算。

```julia
map(!, vec)
```
对向量vec中的每一个元素取反。

`findall`找到向量中所有为true的位置

""" |> hint |>aside

# ╔═╡ f69e071a-cc00-4121-a4bc-ef48a64dd9a3
idx = findall(map(!, occursin.(r"^-?\d+(\.\d+)?$", train.revolUtil)))

# ╔═╡ 2cf6990f-bbb0-4efb-952e-cf88e6615cb0
train.revolUtil[idx]

# ╔═╡ 7555c37e-d3f0-4eae-a69e-c16c79e59fba
md"""
显然， 这个变量是因为缺失值，被编码为NA， 从而导致数据数值变成了文本。只要转化一下就好了。 不过， 我们可以使用`as_float`函数， 他会把能编程数字的变为数字， 不能变为数字的，变为missing。
"""

# ╔═╡ 37658d89-64e9-4cd9-b98c-c5d46a08e01c
@chain train @select revolUtil = as_float(revolUtil)

# ╔═╡ fe5a1ffd-dfc9-459c-9f41-aceb2069be9e
countmap(cut(train.loanAmnt, 3))

# ╔═╡ 6ec9c6b8-6ab6-462b-83c1-230601555ab9
ntile

# ╔═╡ e58a3547-c60b-40b1-8fd9-522465e701f0
md"""
可以看到自动划分时， 函数在28和38岁两个年龄做出了划分。 如果你认为这种划分方式不够合理， 可以自己指定划分标准。 假设我们希望在30岁和50岁作为划分点。 这时候可以这么做：
"""

# ╔═╡ d86a0d90-863f-4188-9c3a-4f67cfb44104
md"""
注意， 上面的参数`[0,30,50,100]`设定的是数据取值的3个区间， 因此会有4个值。最左端不能大于最小值， 最右端不能小于最大值。

如果想自己给每个区间重新设置标签， 下面的例子把将三个区间分别设置为三个不同的字符串：
"""

# ╔═╡ efef2011-46fa-45c8-8ac7-52f6a9bcc424
md"""
请读者通过`countmap`函数自行查看两种划分下， 样本的分布情况。
"""

# ╔═╡ bff31ad5-1876-40b9-97a5-f054f05c5212
md"""
## 文本数据连续化
有时候， 一个文本类型的数据， 我们希望将其转换为数值类型进行处理。 这可以通过简单的将文本替换为数值(文本重新编码）实现。 `CategoricalArrays.jl`包中的函数是`recode`函数实现了这一功能。

其基本的用法是:
```julia
recode(a::AbstractArray, pairs::Pair...)
```
其中， a是一个待替换处理的数组， pairs是 `old => new`形式构成对。函数会将数组a中， 值为old的对象替换为new对象。 这里old可以是一个容器， 只要a中的元素在容器old中， 就会被new替换掉。

假设，我们要将上面离散化为3个年龄段的结果`age3`， 重新编码。分别用数值1,2,3来表示“青”、“中”、“老”。这可以通过如下方式实现：
```julia
julia> recode(age3, "青"=>1, "中"=>2, "老"=>3)
```

"""

# ╔═╡ 08ec3da6-7767-482b-b04a-9d9854dc4a75
md"""
又比如， 上面的上保险地区， 有三种可能得取值。 但源数据中是文本， 我们可以将其转化为一个数字。
"""

# ╔═╡ 1b3c1534-f21c-4597-9496-fcc752d6f253
md"""
## 缺失值填充
如果数据中存在缺失值， 在Julia中， 通常用missing来表示。 我们可以通过上述recode函数， 将缺失值重新编码为某一个值。 下面用一个构造的小例子演示如何将缺失值替换为均值。 
```julia
julia> vec = [1,2,3,missing,5];

julia > m = mean(skipmissing(vec)) 
2.75
julia> recode(vec, missing => m)
[1.0,2.0,3.0,2.75,5.0]
```
注意， 求向量的均值要求不能包含确实值， 如果数据中包含缺失值， 可以将其包裹在`skipmissing`函数的返回结果中， 这会自动过滤掉缺失值。
"""

# ╔═╡ cb556a74-7668-493a-9578-04567c3c97d7
md"""
## 数据泛化
数据的泛化在本质上还是用新的值代替旧的值， 因此， 还是可以用`recode`函数实现。 由于年龄字段是一个整数。我们可以将年龄按照如下方式泛化为不同的值：
```julia
julia> age4 = recode(train.age, 0:29=>"青", 30:49 => "中", 50:100 => "老");
```
这里泛化的结果，应该跟前面离散化的结果是一致的。注意：这里`recode`的参数中， pair的第一个值不一定是单个值， 可以是一个容器， 表示容器中的所有值都用pair的第二个值来代替。
```julia
julia> age3 = cut(ret.AGE, [0,30,50,100], labels=["青","中","老"]);

julia> all(age3 .== age4)
true
```

"""

# ╔═╡ 18754971-c945-41ce-a22d-aabed3cbe1d9
md"""
	- 前两个参数是位置单数， 所以只要给值就好；但后面的参数是关键字参数， 需要给出参数名字。
	- 第一种调用方式中breaks指定的范围需要涵盖所有可能的取值， breaks的数量会比区间多一个
	- 区间通常是以左开右闭的形式[left, right）表示， 最右边会有例外。
   
""" 

# ╔═╡ 7eb215ae-8f20-4b9b-9d7b-aa05051400b7
md"""
## 维度规约
维度规约是指通过使用数据变换， 得到原始数据的压缩表示。 如果原始数据可以由压缩表示重新构造， 则压缩是无损的。 不过通常情况下， 压缩会导致一定程度的精度损失。 那为什么还需要维度规约呢？ 一方面是维度规约可以减少特征的数量， 避免特征爆炸。 有时候， 太多的特征可能导致模型性能低下， 因为很多特征之间可能存在一定的相关性， 特征规约可以在尽可能保留信息的信息的情况下， 减少特征的数量， 并且通常是获得相互独立的特征。 另一方面， 更少的特征数量在建模中可以更方便的去理解和解释模型。 
"""

# ╔═╡ fab8836c-13a4-46ba-9562-92d6d9934f1f
md"""
### 主成分分析
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

# ╔═╡ 2ea15c1d-4f44-46bf-a5cf-bb5d4b428ba2
md"""
下面主要介绍在特征规约的过程中使用广泛的主成分分析（PCA）的实现。主要是基于多元统计分析包[MultivariateStats.jl]中的[PCA](https://multivariatestatsjl.readthedocs.io/en/latest/pca.html#principal-component-analysis)方法。

在[MultivariateStats.jl]， 用一个结构体表示一个主成分分析模型。设M为PCA的一个实例，d为观测（样本）的维数，p为输出维数(即主成分构成的子空间的维数)。也就是， 模型M实现的是将d维数据转化为p维。

使用PCA， 基本步骤入下：
1. 准备数据矩阵X， 满足(d, n) = size(X)。 注意数据要求是矩阵， 且每一列表示一个样本（跟通常的不同）
2. 通过函数`M = fit(PCA, X; ...)`拟合PCA模型。通常需要指定`maxoutdim=p`，即输出维度， 否则默认是输出维度跟输入维度相同。 
3. 最后使用`transform`函数实现对数据的变换， `reconstruct`函数实现逆变换。

到这里了解更多[PCA](https://juliastats.org/MultivariateStats.jl/dev/pca/#Principal-Component-Analysis)

"""

# ╔═╡ c6ffa379-0851-4e3b-8493-7d2d167f935a
trainint = train[:,names(train,Int)]

# ╔═╡ a2ff70a1-1565-4fb3-805d-d306a4126627
size(trainint)

# ╔═╡ d16a5e17-bbe7-4aa1-8665-fc2e4588e42c
Xtr = Matrix(trainint)'

# ╔═╡ c8eeabd7-89d5-40c3-80db-b67e3d3bf642
M = fit(PCA, Xtr; maxoutdim=4)

# ╔═╡ 6058779d-1471-4d20-afcc-41062cfeb50e
y =predict(M, Matrix(trainint)')

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
MultivariateStats = "6f286f6a-111f-5878-ab1e-185364afe411"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ScientificTypes = "321657f4-b219-11e9-178b-2701a2544e81"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
TidierCats = "79ddc9fe-4dbf-4a56-a832-df41fb326d23"
TidierData = "fe2206b3-d496-4ee9-a338-6a095c4ece80"
TidierDates = "20186a3f-b5d3-468e-823e-77aae96fe2d8"
TidierFiles = "8ae5e7a9-bdd3-4c93-9cc3-9df4d5d947db"

[compat]
MultivariateStats = "~0.10.3"
PlutoTeachingTools = "~0.3.0"
PlutoUI = "~0.7.60"
ScientificTypes = "~3.0.2"
StatsBase = "~0.34.3"
TidierCats = "~0.1.2"
TidierData = "~0.16.2"
TidierDates = "~0.2.6"
TidierFiles = "~0.1.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "5b960f6ea43365d44e609eecdbf6061bfe8427bd"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "InverseFunctions", "LinearAlgebra", "MacroTools", "Markdown"]
git-tree-sha1 = "b392ede862e506d451fc1616e79aa6f4c673dab8"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.38"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsDatesExt = "Dates"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"
    AccessorsTestExt = "Test"
    AccessorsUnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

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

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra"]
git-tree-sha1 = "0dd7edaff278e346eb0ca07a7e75c9438408a3ce"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.10.3"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Arrow]]
deps = ["ArrowTypes", "BitIntegers", "CodecLz4", "CodecZstd", "ConcurrentUtilities", "DataAPI", "Dates", "EnumX", "LoggingExtras", "Mmap", "PooledArrays", "SentinelArrays", "Tables", "TimeZones", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "4ece4573f169d64b1508b0c8dd38c7919ae7a907"
uuid = "69666777-d1a9-59fb-9406-91d4454c9d45"
version = "2.7.3"

[[deps.ArrowTypes]]
deps = ["Sockets", "UUIDs"]
git-tree-sha1 = "404265cd8128a2515a81d5eae16de90fdef05101"
uuid = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
version = "2.3.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BangBang]]
deps = ["Accessors", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires"]
git-tree-sha1 = "e2144b631226d9eeab2d746ca8880b7ccff504ae"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.4.3"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTablesExt = "Tables"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitIntegers]]
deps = ["Random"]
git-tree-sha1 = "6158239ac409f960abbc232a9b24c00f5cce3108"
uuid = "c3b6d118-76ef-56ca-8cc7-ebb389d030a1"
version = "0.3.2"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

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
git-tree-sha1 = "9ae9be75ad8ad9d26395bf625dea9beac6d519f1"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.6.0"

[[deps.Cleaner]]
deps = ["PrettyTables", "Tables", "Unicode"]
git-tree-sha1 = "664021fefeab755dccb11667cc96263ee6d7fdf6"
uuid = "caabdcdb-0ab6-47cf-9f62-08858e44f38f"
version = "1.1.1"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.CodecInflate64]]
deps = ["TranscodingStreams"]
git-tree-sha1 = "d981a6e8656b1e363a2731716f46851a2257deb7"
uuid = "6309b1aa-fc58-479c-8956-599a07234577"
version = "0.1.3"

[[deps.CodecLz4]]
deps = ["Lz4_jll", "TranscodingStreams"]
git-tree-sha1 = "0db0c70ca94c0a79cadad269497f25ca88b9fa91"
uuid = "5ba52731-8f18-5e0d-9241-30f10d1ec561"
version = "0.4.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[deps.CodecZstd]]
deps = ["TranscodingStreams", "Zstd_jll"]
git-tree-sha1 = "5e41a52bec3b0881a7eb54f5391b779994504186"
uuid = "6b39b394-51ab-5f42-8807-6242bab2b4c2"
version = "0.8.5"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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

[[deps.DecFP]]
deps = ["DecFP_jll", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "4a10cec664e26d9d63597daf9e62147e79d636e3"
uuid = "55939f99-70c6-5e9b-8bb0-5071ed7d61fd"
version = "1.3.2"

[[deps.DecFP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e9a8da19f847bbfed4076071f6fef8665a30d9e5"
uuid = "47200ebd-12ce-5be5-abb7-8e082af23329"
version = "2.0.3+1"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "e6c693a0e4394f8fda0e51a5bdf5aef26f8235e9"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.111"

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

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "380053d61bb9064d6aa4a9777413b40429c79901"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.2.0"

[[deps.FNVHash]]
git-tree-sha1 = "d6de2c735a8bffce9bc481942dfa453cc815357e"
uuid = "5207ad80-27db-4d23-8732-fa0bd339ea89"
version = "0.1.0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "7c4195be1649ae622304031ed46a2f4df989f1eb"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.24"

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
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"
weakdeps = ["ArrowTypes", "Parsers"]

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

[[deps.InputBuffers]]
git-tree-sha1 = "d5c278bee2efd4fda62725a4a794d7e5f55e14f1"
uuid = "0c81fc1b-5583-44fc-8770-48be1e1cca08"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
git-tree-sha1 = "2787db24f4e03daf859c6509ff87764e4182f7d1"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.16"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

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

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "eb3edce0ed4fa32f75a0a11217433c31d56bd48b"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.14.0"
weakdeps = ["ArrowTypes"]

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "2984284a8abcfcc4784d95a9e2ea4e352dd8ede7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.36"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "MatrixFactorizations", "SparseArrays"]
git-tree-sha1 = "35079a6a869eecace778bcda8641f9a54ca3a828"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "1.10.0"
weakdeps = ["StaticArrays"]

    [deps.LazyArrays.extensions]
    LazyArraysStaticArraysExt = "StaticArrays"

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

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.LightBSON]]
deps = ["DataStructures", "Dates", "DecFP", "FNVHash", "JSON3", "Sockets", "StructTypes", "Transducers", "UUIDs", "UnsafeArrays", "WeakRefStrings"]
git-tree-sha1 = "1c98cccebf21f97c5a0cc81ff8cebffd1e14fb0f"
uuid = "a4a7f996-b3a6-4de6-b9db-2fa5f350df41"
version = "0.2.20"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "c2b5e92eaf5101404a58ce9c6083d595472361d6"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.2"

[[deps.Lz4_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7f26c8fc5229e68484e0b3447312c98e16207d11"
uuid = "5ced341a-0733-55b8-9ab6-a4889d929147"
version = "1.10.0+0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MatrixFactorizations]]
deps = ["ArrayLayouts", "LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "6731e0574fa5ee21c02733e397beb133df90de35"
uuid = "a3b82374-2e81-5b9e-98ce-41277c0e4c87"
version = "2.2.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MicroCollections]]
deps = ["Accessors", "BangBang", "InitialValues"]
git-tree-sha1 = "44d32db644e84c75dab479f1bc15ee76a1a3618f"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.2.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "2c140d60d7cb82badf06d8783800d0bcd1a7daa2"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.8.1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.MultivariateStats]]
deps = ["Arpack", "Distributions", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "816620e3aac93e5b5359e4fdaf23ca4525b00ddf"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.3"

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

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a028ee3cb5641cccc4c24e90c36b0a4f7707bdf5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.14+0"

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

[[deps.Parquet2]]
deps = ["AbstractTrees", "BitIntegers", "CodecLz4", "CodecZlib", "CodecZstd", "DataAPI", "Dates", "DecFP", "FilePathsBase", "FillArrays", "JSON3", "LazyArrays", "LightBSON", "Mmap", "OrderedCollections", "PooledArrays", "PrecompileTools", "SentinelArrays", "Snappy", "StaticArrays", "TableOperations", "Tables", "Thrift2", "Transducers", "UUIDs", "WeakRefStrings"]
git-tree-sha1 = "58036936efa67e864e7fe640c6156add60f15e94"
uuid = "98572fba-bba0-415d-956f-fa77e587d26d"
version = "0.2.27"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoLinks", "PlutoUI"]
git-tree-sha1 = "e2593782a6b53dc5176058d27e20387a0576a59e"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.3.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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
git-tree-sha1 = "66b20dd35966a748321d3b2537c4584cf40387c7"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PtrArrays]]
git-tree-sha1 = "77a42d78b6a92df47ab37e177b2deac405e1c88f"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "cda3b045cf9ef07a08ad46731f5a3165e56cf3da"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.1"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.RData]]
deps = ["CategoricalArrays", "CodecZlib", "DataAPI", "DataFrames", "Dates", "FileIO", "Requires", "TimeZones", "Unicode"]
git-tree-sha1 = "9a6220c8f59c38ddf6217638042ae6788973f617"
uuid = "df47a6cb-8c03-5eed-afd8-b6050d6c41da"
version = "1.0.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.ReadStatTables]]
deps = ["CEnum", "DataAPI", "Dates", "InlineStrings", "MappedArrays", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "ReadStat_jll", "SentinelArrays", "StructArrays", "Tables"]
git-tree-sha1 = "97140dfb54eabb5e99d13d1e09554d7456bb184c"
uuid = "52522f7a-9570-4e34-8ac6-c005c74d4b84"
version = "0.3.1"

[[deps.ReadStat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "28e990e90ca643e99f3ec0188089c1816e8b46f4"
uuid = "a4dc8951-f1cc-5499-9034-9ec1c3e64557"
version = "1.1.9+0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "7b7850bb94f75762d567834d7e9802fc22d62f9c"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.18"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "852bd0f55565a9e973fcfee83a84413270224dc4"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.8.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

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

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ff11acffdb082493657550959d4feb4b6149e73a"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.5"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Snappy]]
deps = ["CEnum", "snappy_jll"]
git-tree-sha1 = "098adf970792fd9404788f4558e94958473f7d57"
uuid = "59d4ed8c-697a-5b28-a4c7-fe95c22820f9"
version = "0.4.3"

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
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "542d979f6e756f13f862aa00b224f04f9e445f11"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "3.4.0"

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
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "b423576adc27097764a90e163157bcfc9acf0f46"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.2"

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

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "159331b30e94d7b11379037feeb9b690950cace8"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.11.0"

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

[[deps.TZJData]]
deps = ["Artifacts"]
git-tree-sha1 = "36b40607bf2bf856828690e097e1c799623b0602"
uuid = "dc5dba14-91b3-4cab-a142-028a31da12f7"
version = "1.3.0+2024b"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Thrift2]]
deps = ["MacroTools", "OrderedCollections", "PrecompileTools"]
git-tree-sha1 = "9610f626cf80cf28468edb20ec2dc007f72aacfa"
uuid = "9be31aac-5446-47db-bfeb-416acd2e4415"
version = "0.2.1"

[[deps.TidierCats]]
deps = ["CategoricalArrays", "DataFrames", "Reexport", "Statistics"]
git-tree-sha1 = "bf7843c4477d1c3f9e430388f7ece546b9382bef"
uuid = "79ddc9fe-4dbf-4a56-a832-df41fb326d23"
version = "0.1.2"

[[deps.TidierData]]
deps = ["Chain", "Cleaner", "DataFrames", "MacroTools", "Reexport", "ShiftedArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "2649cad958374080016511376e647c15942825dc"
uuid = "fe2206b3-d496-4ee9-a338-6a095c4ece80"
version = "0.16.2"

[[deps.TidierDates]]
deps = ["Dates", "Reexport", "TimeZones"]
git-tree-sha1 = "680193b3912c5a337ec5e6b5c7a513e39418172d"
uuid = "20186a3f-b5d3-468e-823e-77aae96fe2d8"
version = "0.2.6"

[[deps.TidierFiles]]
deps = ["Arrow", "CSV", "DataFrames", "Dates", "HTTP", "Parquet2", "RData", "ReadStatTables", "Reexport", "XLSX"]
git-tree-sha1 = "aba95360310134ac54a3fc478457926d81f03927"
uuid = "8ae5e7a9-bdd3-4c93-9cc3-9df4d5d947db"
version = "0.1.5"

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "Mocking", "Printf", "Scratch", "TZJData", "Unicode", "p7zip_jll"]
git-tree-sha1 = "8323074bc977aa85cf5ad71099a83ac75b0ac107"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.18.1"

    [deps.TimeZones.extensions]
    TimeZonesRecipesBaseExt = "RecipesBase"

    [deps.TimeZones.weakdeps]
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.TranscodingStreams]]
git-tree-sha1 = "96612ac5365777520c3c5396314c8cf7408f436a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.1"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Transducers]]
deps = ["Accessors", "Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "SplittablesBase", "Tables"]
git-tree-sha1 = "5215a069867476fc8e3469602006b9670e68da23"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.82"

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
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnsafeArrays]]
git-tree-sha1 = "da0c9ca60d3371a4bc86b4e65c45db17086fb3ac"
uuid = "c4a57d5a-5b31-53a6-b365-19f8c011fbd6"
version = "1.0.6"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipArchives", "ZipFile"]
git-tree-sha1 = "1c36015573a833883f5a352af446bc461d8af2fa"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.10.3"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "1165b0443d0eca63ac1e32b8c0eb69ed2f4f8127"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.3+0"

[[deps.ZipArchives]]
deps = ["ArgCheck", "CodecInflate64", "CodecZlib", "InputBuffers", "PrecompileTools", "TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "c77707ebf7aad0caa57ad7b561b4f89b0caefc73"
uuid = "49080126-0e18-4c2a-b176-c102e4b3760c"
version = "2.3.0"

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "f492b7fe1698e623024e873244f10d89c95c340a"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.10.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.snappy_jll]]
deps = ["Artifacts", "JLLWrappers", "LZO_jll", "Libdl", "Lz4_jll", "Zlib_jll"]
git-tree-sha1 = "8bc7ddafc0a7339b82a06c1dde849cd5039324d6"
uuid = "fe1e1685-f7be-5f59-ac9f-4ca204017dfd"
version = "1.2.0+0"
"""

# ╔═╡ Cell order:
# ╠═54d48980-e50b-11ee-01ff-833f16130cde
# ╟─be3b73ca-f440-4273-a268-77f5a7780bae
# ╟─2aa3bad3-cf55-4b7d-b9ff-b9a3bc6813cb
# ╟─47212dab-e290-42a3-b3c5-2a5db45ff946
# ╟─ac7998a8-56e9-470e-ab9e-eaeb2e16f118
# ╟─7cc9cf55-393b-4c18-907b-115a8eda1958
# ╠═f67e2900-c720-44cb-8988-800f6b8e5389
# ╠═b024d006-8d14-4b83-9a4d-d7f1a5a50244
# ╟─023d6149-b031-498e-9985-e27f1dbefbc8
# ╟─a14cb588-7f9d-492a-a5b6-32b4da879d38
# ╟─37ee6850-477d-4542-941d-72aaa8070a36
# ╠═a55a5d45-fd16-4979-8774-6edb86b538df
# ╟─fe63b71b-114e-4abf-9b32-94b828941a92
# ╟─879a29af-0515-47fd-804d-def795077cc9
# ╟─6c60453c-ecc0-4a2b-9a39-44807af45b1b
# ╟─37190246-b809-4388-b2d9-8b7415894228
# ╠═300eebf9-dc93-4132-aa16-ab53a701192e
# ╠═bfdc0184-b737-435c-b297-474459ee0a59
# ╟─5fc495b2-1124-4cbe-9f14-f6130355ded1
# ╠═434cd9e9-5aca-4344-b837-95548da86d19
# ╠═611572f7-84c3-4db1-a26f-04b8247a4f0e
# ╠═574c25f6-4a8a-4c80-a9d7-d4b1f8c257fc
# ╟─78f76f55-7441-4581-ac90-0fce0dce6a66
# ╟─1d28bbc6-924d-4974-9bf1-a6b58b922aed
# ╠═f9d60927-47b7-46ff-b6eb-3f571b6e1768
# ╟─36e7b107-316a-4b55-b669-03d978063638
# ╠═72ddc0fa-547f-4830-ba65-ad5173d16f19
# ╟─8425599e-88fb-4459-a5b8-f6a72499c065
# ╟─bfae8a82-99e8-45fd-8c4f-d07c5292f660
# ╟─006b83f7-be91-4015-b39b-604d06dece71
# ╠═1892fff4-2e43-4586-abb7-f84c4047bdd7
# ╟─d83e697d-4d08-4a7b-b227-b7c3e3146ee3
# ╠═ab263bcc-bfd0-4a39-87bc-3dc32ad63afd
# ╠═4c011faa-9a91-4b32-a141-b84a67ffdeb4
# ╟─eebc36fc-d634-4b58-a305-ba10aec37834
# ╠═e3647ee7-023b-4436-99b7-55cf91ed03aa
# ╟─50ec515e-38fe-4931-b829-6d76615bb64e
# ╠═de4e4a96-ff87-4c43-95ae-a1f5d87f6f67
# ╟─ab98798e-bee3-4999-8a42-c4097013d3d5
# ╠═a15da6fa-4ef9-4091-aaf3-966120ec1c2a
# ╟─caa3da68-e91c-4872-920d-f114a53a725f
# ╟─be976a0f-174a-48f9-b54e-1774cbbe0435
# ╠═255e6832-fe6a-4cc9-9dfe-a1887a50329b
# ╠═8db2d648-4ffc-4d81-948b-e07704db6bcc
# ╠═cce08467-7ab0-4598-bb94-2e42b821f05e
# ╟─78d60c14-c032-44e7-895f-6aaf6fe11468
# ╠═b097000f-bdde-4e16-921c-63ec9a7f0278
# ╟─8feb6818-8827-44cb-bd46-0cf1828a2b70
# ╠═58097000-4930-4115-a51e-6cf0a9101ee5
# ╠═c4b82937-8c3a-420f-81e9-d2494fac58e0
# ╟─0b7d0757-a62f-4c45-b8a0-664ecd047821
# ╟─e3e88f5d-1e57-4bce-9c19-8ac52e397563
# ╠═b8e6ea94-5f1b-4aa9-bb1c-eb21980f2ee5
# ╠═e0584c22-7394-431f-9905-ddf38019d4cd
# ╠═f0127699-101b-44ae-af82-853028f9722c
# ╠═07b38009-4e16-4939-a0fc-27e12b0823a1
# ╟─8122e11d-17a2-4272-91e1-c7b5c498dee4
# ╟─8a76a81f-7774-4813-b619-73d31bc79bd5
# ╠═53586677-8e61-419b-b47b-8b1595db8979
# ╟─e7bbba6f-a037-4371-b0ee-04d4ee237654
# ╠═f69e071a-cc00-4121-a4bc-ef48a64dd9a3
# ╠═2cf6990f-bbb0-4efb-952e-cf88e6615cb0
# ╟─7555c37e-d3f0-4eae-a69e-c16c79e59fba
# ╠═37658d89-64e9-4cd9-b98c-c5d46a08e01c
# ╠═fe5a1ffd-dfc9-459c-9f41-aceb2069be9e
# ╠═6ec9c6b8-6ab6-462b-83c1-230601555ab9
# ╟─e58a3547-c60b-40b1-8fd9-522465e701f0
# ╟─d86a0d90-863f-4188-9c3a-4f67cfb44104
# ╟─efef2011-46fa-45c8-8ac7-52f6a9bcc424
# ╟─bff31ad5-1876-40b9-97a5-f054f05c5212
# ╟─08ec3da6-7767-482b-b04a-9d9854dc4a75
# ╟─1b3c1534-f21c-4597-9496-fcc752d6f253
# ╟─cb556a74-7668-493a-9578-04567c3c97d7
# ╟─18754971-c945-41ce-a22d-aabed3cbe1d9
# ╟─7eb215ae-8f20-4b9b-9d7b-aa05051400b7
# ╟─fab8836c-13a4-46ba-9562-92d6d9934f1f
# ╟─2ea15c1d-4f44-46bf-a5cf-bb5d4b428ba2
# ╠═aec56a53-fb02-4fd9-a30d-603fe4583a47
# ╠═c6ffa379-0851-4e3b-8493-7d2d167f935a
# ╠═a2ff70a1-1565-4fb3-805d-d306a4126627
# ╠═d16a5e17-bbe7-4aa1-8665-fc2e4588e42c
# ╠═c8eeabd7-89d5-40c3-80db-b67e3d3bf642
# ╠═6058779d-1471-4d20-afcc-41062cfeb50e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
