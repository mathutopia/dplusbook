### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ a6682dc0-501e-4a1a-aa26-2f4ff59cc8cb
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ f504eb73-cab0-4e2b-92ce-16a292df974f
using StatsPlots

# ╔═╡ 71a16c11-c1e4-45f2-9e39-35632757f443
using Tidier

# ╔═╡ 6007bd79-5584-4f17-8530-c56997042d7a
using DMUtils

# ╔═╡ 2a640a85-5c23-438d-b262-4287ab372d7c
TableOfContents(title="目录")

# ╔═╡ 74ece9db-0a67-4b5c-9693-482c1bca0ba0
present_button()

# ╔═╡ 245a7c5f-fd01-4386-93c9-e39a4b6c26ab
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据分析与挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			数据分析案例
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ b93c8356-1125-4c78-96d6-d65d008824cf
train = read_csv("../data/train1w.csv")

# ╔═╡ b4b21281-2ee7-4b91-b33d-1e1138215f66
md"""
## 字段含义
了解字段含义含义是简单的， 可以直接从文档中去了解， 我将其罗列如下：

以下是您提供的内容转化为Markdown表格的格式：

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


请注意，表格中的 "n系列匿名特征" 描述可能需要进一步明确化，因为它提到了 "n0-n14" 但并未详细说明每个特征。如果需要为每个特征提供单独的行，请提供更多具体信息。

"""

# ╔═╡ 9e29a561-bda1-46c2-a66f-4bde0b91731a
md"""
# 总结了解数据
## 查看数据的行列数
"""

# ╔═╡ 0e783777-c3bd-41c2-b130-48eba04c2758
size(train)

# ╔═╡ 6fd78a3a-63ea-4832-800f-dfc4a718fade
md"""
## 查看列名
"""

# ╔═╡ 3e6e4a80-4931-4efa-9a2d-cb070b708ae7
names(train)

# ╔═╡ 13678a02-3664-4a52-83b3-7bf93b2f34bd
md"""
## 偷瞄数据
"""

# ╔═╡ 8fa82962-7e00-4551-be97-9c7e883cd420
@glimpse(train)

# ╔═╡ a89e1f03-b9bf-468e-ba42-2983405dd5f7
md"""
在across环境中，所有的函数都不会被向量化。 所以， 在上面的匿名函数中， `ismissing`后面有一个`点号`， 以确保缺失值判断施加到向量的每一个元素上， 最后统计一下为`true`的数量。
""" |> danger |> aside

# ╔═╡ bd89c6b8-6af6-4660-bbdb-a48aef9191f6
md"""
## 谁有缺失值？
下面的代码统计了一下每一列的缺失值数量， 你可以转化为比例。
"""

# ╔═╡ d67ee67a-ebc1-4a49-9bb0-59b59c210428
@chain train begin
	@summarise(across(everything(), x->count(ismissing.(x))))
	@pivot_longer(everything())
	@arrange(desc(value))
	@filter(value>0) #只要有缺失值的
end

# ╔═╡ e7e24ee0-cd32-46cf-a8b9-cade27de9d8c
md"""
## 唯一值情况
下面是每一列的唯一值情况
"""

# ╔═╡ cdb4e909-5f17-42a7-91f0-f10fc05d36a2
md"""
通常， 一个字段如何唯一值太多（大多数样本都不一样），或者唯一值太少（大部分样本都相同）都是不理想的。 请计算每一个数字和字符列中有多少唯一值?将结果按升序排列。
""" |> question_box

# ╔═╡ dcd068bc-e09a-49c3-9ab0-ffbd7304c0dc
@chain train begin 
	@summarise(across(everything(),(length ∘ unique )))
	@pivot_longer(everything())
	@arrange(value)
	@filter(value <10) 
end

# ╔═╡ 2142e85a-8a0d-49c3-ac20-6fb92fb99026
md"""
## 找出唯一值较少的列名
"""

# ╔═╡ 8b6e2a66-358d-4903-a3cc-a627cf76c421
@select(train, where(x -> is_number(x) && length(unique(x)) < 10)) |> names

# ╔═╡ 71872557-459a-4f17-8865-ed5b22a0715c
md"""
# 数据的属性
数据的属性通常指的是数据所具有的特征和性质，它们定义了数据的类型、格式以及如何被处理和分析。 数据可以按具体的特征和性质分为如下4类。

1. **名义属性（Nominal Attributes）**：
   - 描述：没有固定顺序的定性属性。
   - 例子：性别（男、女），国家（中国、美国、加拿大）。

2. **序数属性（Ordinal Attributes）**：
   - 描述：定性属性值之间存在逻辑顺序或等级。
   - 例子：教育水平（高中、学士、硕士、博士），满意度评分（不满意、一般、满意、非常满意）。

3. **区间属性（Interval Attributes）**：
   - 描述：定量属性，其中值之间的差异是重要的，但没有真正的零点。
   - 例子：年份（2021、2022、2023），温度（摄氏或华氏）。

4. **比率属性（Ratio Attributes）**：
   - 描述：定量属性，存在真正的零点，可以进行比率和百分比计算。
   - 例子：身高（160厘米），体重（50公斤）。

了解数据的属性对于选择合适的数据分析方法和数据预处理技术至关重要。例如，连续属性可能需要归一化处理， 区间属性通常需要被分割成不同的区间或桶（binning），以便进行分类或分组分析。而序数和名义属性可能需要编码转换才能被机器学习算法有效处理。


从存储的角度看： 名义属性和序数属性是类别变量， 可能以整数或字符串的形式存在，但在建模中，一般要转化为整数。 区间属性和比率属性一般以数值形式存在（可能是整数也可能是浮点数）。


"""

# ╔═╡ a63ad11b-d2d5-4dba-8856-532130b6eeb7
md"""
分析上面数据的类型？
""" |> question_box

# ╔═╡ a9a8705e-de36-4175-af86-4c064a108b69
md"""
以下是一个参考分类。 

| 字段              | 描述                               | 类别       | 理由                                                         |
|-------------------|-----------------------------------|------------|--------------------------------------------------------------|
| id                | 唯一信用证标识                     | 名义属性   | 标识符通常作为分类标签使用                                   |
| loanAmnt          | 贷款金额                           | 比率属性   | 具体的金额数值，存在绝对的零点                              |
| term              | 贷款期限（年）                     | 序数属性   | 表示时间跨度的顺序，但每个单位并非等距                       |
| interestRate       | 贷款利率                           | 区间属性   | 利率之间的差异有意义，但没有绝对的零点                       |
| installment        | 分期付款金额                       | 比率属性   | 具体的付款金额，存在绝对的零点                              |
| grade             | 贷款等级                           | 名义属性   | 贷款等级作为分类标识                                        |
| subGrade          | 贷款等级之子级                     | 名义属性   | 子等级作为进一步的分类标识                                  |
| employmentTitle   | 就业职称                            | 名义属性   | 职称作为职业的分类标识                                      |
| employmentLength  | 就业年限（年）                     | 序数属性   | 表示就业经验的顺序，但年数不等距                              |
| homeOwnership      | 房屋所有权状况                     | 名义属性   | 表示所有权的分类                                             |
| annualIncome      | 年收入                             | 比率属性   | 具体的收入数值，存在绝对的零点                              |
| verificationStatus | 验证状态                         | 名义属性   | 表示验证的分类                                               |
| issueDate         | 贷款发放的月份                     | 名义属性   | 发放月份作为时间标识                                        |
| purpose           | 贷款用途类别                     | 名义属性   | 用途类别作为分类标识                                        |
| postCode          | 邮政编码的前3位数字               | 名义属性   | 编码作为地区分类标识                                        |
| regionCode        | 地区编码                           | 名义属性   | 编码作为地区分类标识                                        |
| dti               | 债务收入比                         | 比率属性   | 比率，存在绝对的零点                                        |
| delinquency_2years| 逾期30天以上的违约事件数           | 比率属性   | 表示违约频率，存在绝对的零点                              |
| ficoRangeLow      | FICO得分下限范围                 | 区间属性   | 得分范围，没有绝对的零点                                   |
| ficoRangeHigh     | FICO得分上限范围                 | 区间属性   | 得分范围，没有绝对的零点                                   |
| openAcc           | 未结信用额度的数量                | 比率属性   | 具体的信用额度数量，存在绝对的零点                         |
| pubRec            | 贬损公共记录的数量                | 比率属性   | 记录的数量，存在绝对的零点                                |
| pubRecBankruptcies | 公开记录清除的数量              | 比率属性   | 清除记录的数量，存在绝对的零点                            |
| revolBal          | 信贷周转余额合计                  | 比率属性   | 具体的余额数值，存在绝对的零点                            |
| revolUtil         | 循环额度利用率                     | 比率属性   | 利用率，存在绝对的零点                                    |
| totalAcc          | 信用档案中当前的信用额度总数      | 比率属性   | 具体的信用额度数量，存在绝对的零点                         |
| initialListStatus  | 贷款的初始列表状态                | 名义属性   | 状态作为分类标识                                          |
| applicationType    | 贷款申请类型                       | 名义属性   | 申请类型作为分类标识                                      |
| earliestCreditLine | 信用额度开立的月份            | 名义属性   | 开立月份作为时间标识                                      |
| title             | 贷款名称                           | 名义属性   | 名称用作标识                                               |
| policyCode        | 策略代码                           | 名义属性   | 代码用作策略的分类标识                                      |
| n系列匿名特征     | 贷款人行为计数特征                | 比率属性   | 通常为数值特征，存在绝对的零点                            |


这个表格提供了每个字段的分类和理由，帮助理解为什么每个字段被归入特定的数据类型类别。

""" |> answer_box

# ╔═╡ 824eca64-ff9a-48af-99dc-a832196313e0
md"""
## 存储结构分析
一般字段会存储为数值（number）或字符串（string）， 可以通过函数`is_number`， `is_string`找到所有的相应的列。

比如下面的代码找到了所有的文本列
"""

# ╔═╡ 3b9e3dc1-bf16-49b8-bf94-a9af8d808993
@select(train, where(is_string)) |> names

# ╔═╡ 45e168f6-1b2b-4560-b33d-c66999456a41
@select(train, where(is_number)) |> names

# ╔═╡ 2c4dbc16-4b22-4ae7-9ba0-26ffba47c9cb
md"""
那么， 除了数字和文本外， 数据集中还有其他类型的字段吗？ 下面的代码告诉我们，还有一列日期数据。
"""

# ╔═╡ ab80de21-15c0-48a6-b286-e2dbf1b9ead3
md"""
## 特征分类
"""

# ╔═╡ 84a645f6-8c85-45b9-8e03-3b381e26511e
md"""
### 数值特征
被存储为数据的特征， 其中，如果唯一值比10个都少， 那么将当成是被存储为数字的类别特征。10并非强制规定， 你可以自己设定。
"""

# ╔═╡ ba548abf-44f3-41ad-a2a2-28286a3efeb2
num_feats = @select(train, where(is_number)) |> names # 数值特征

# ╔═╡ 677003c9-7911-4ba2-8f3d-baabf2bf7341
num_cate_feats = @select(train, where(x-> is_number(x) && length(unique(x)) <= 10)) |> names 

# ╔═╡ dfc21c69-5fba-4f28-91fe-fa445be7abd8
num_cont_feats = @select(train, where(x-> is_number(x) && length(unique(x)) > 10)) |> names 

# ╔═╡ 733e3e89-338c-4153-ba6d-fbda29d6fd72
md"""
### 文本特征
文本特征一般当成类别变量， 但也要看看类别的数量。
"""

# ╔═╡ bde3b6d2-710b-4923-b51d-5f175101ad78
str_feats = @select(train, where(is_string)) |> names 

# ╔═╡ 1143968f-f555-475d-ba84-fbd8dc1cb86b
@chain train begin
@select(!!str_feats)
end

# ╔═╡ 462f22ac-dd09-4f90-87c3-00c151b4d5f7
md"""
`earliesCreditLine`被识别为字符串，但本质上应该是时间。
"""

# ╔═╡ 3e1db291-c953-4c9c-bc4c-4e75fd666bf8
## 其他特征
oth_feats = @select(train, where(x -> !is_string(x) && !is_number(x))) |> names 

# ╔═╡ 10118f78-9de4-4380-b676-5a391bfa4678
md"""
确认一下， 没有遗漏特征了吧。
"""

# ╔═╡ efddd6f7-b827-4386-94f7-a15300b1aac2
length(num_feats) + length(str_feats) + length(oth_feats) == size(train)[2]

# ╔═╡ 540000a0-ac62-4167-96ab-cad3e91b7ee2
md"""
# 特征分析
## 文本特征分析
主要看看文本特征有哪些取值， 分布情况怎么样
"""

# ╔═╡ dbe477c4-e13b-4799-9d20-2d4159e9ba77
@count(train, employmentLength)

# ╔═╡ 897afd4b-6b8b-4f31-ae6a-2381333f3027
@chain train begin 
	@drop_missing
	@mutate(isDefault = as_string(isDefault))
	ggplot(_, @aes(y = employmentLength, color=isDefault)) + geom_bar(position="dodge")
end

# ╔═╡ c02c487c-c519-4146-a859-c73313f9f863
md"""
这里，因为isDefault是整数，默认会在画图时当成数值型变量， 转化为字符串，从而可以作为分类变量。
""" |> aside

# ╔═╡ d93ad6f5-8b34-4964-9864-616bfa8b2573
@chain train begin 
	@drop_missing
	@mutate(isDefault = as_string(isDefault))
ggplot(_, @aes(y = grade,color=isDefault)) + geom_bar(position="dodge")
end

# ╔═╡ 9e31d3c4-7973-4332-b8e4-916c5cfd2a4a
@chain train begin 
	@aside n = nrow(_)
	@select(id,term)
end

# ╔═╡ 17a241f7-6601-4530-bdaf-3a50dbc22edb
n

# ╔═╡ b08ca6ed-0ff9-40ea-89f6-2d68b3d379b5
names(train)

# ╔═╡ b155e99a-4666-49bc-98dc-59c07d926df5
md"""
如果数据中包含缺失值， 画图会出现问题。因为图形不知道如何处理缺失值， 所以这里采用`drop_missing`。 不过， 也可以在进行了缺失值处理之后，再来画图（ 比如，把缺失值设置为某个值）。
""" |> aside

# ╔═╡ c0ee1401-8658-4aed-a474-492aa014222d
md"""
这两个文本特征， 很明显应该属于有序特征， 但因为其保存为文本，所以无法体现顺序。 不过， 再转化为顺序之前， 我们可以先看看， 顺序是否跟目标存在关系。 
"""

# ╔═╡ dd09ae38-5d2e-4e7e-a814-9bc306baac70
md"""
统计不同grade的欺诈比率
""" |> question_box

# ╔═╡ 37a32896-b5b9-47a2-ad6f-3364d7361c86
md"""
$(@chain train begin
	@group_by(grade)
	@summarise(ratio = mean(isDefault))
	@arrange(ratio)
end )
""" |> answer_box

# ╔═╡ 953f5f18-c84a-4998-bd65-0d2408490848
md"""
## 数值特征分析
"""

# ╔═╡ 9dbcdbc6-419f-428e-9c33-8cf2f2d3cecb
md"""
### 数值特征中的类别特征
"""

# ╔═╡ 1e7c3d5b-ace7-484c-8f1e-f118498aac3a
num_cate_feats

# ╔═╡ 27f2447c-72ff-4753-9cd6-29b346b0e3e2
@count(train, term)

# ╔═╡ 0e6ac6fb-79c4-4516-8978-a420e85ed56e
@chain train begin 
	@drop_missing
	@mutate(isDefault = as_string(isDefault), term = as_string(term))
ggplot(_, @aes(y = term,color=isDefault)) + geom_bar(position="dodge")
end

# ╔═╡ 359f830b-c0c4-4371-a71f-797177826820
md"""
### 数值特征中的连续变量

"""

# ╔═╡ 386888a4-7bfd-48b3-b2ef-05a0ebb6cca1
df = @chain train begin 
@drop_missing
@select(!!num_cont_feats)
@pivot_longer(-id)
#@group_by(variable)
#@summarise(cv = std(value)/mean(value), max = maximum(value))
end

# ╔═╡ a5195522-8348-4b72-b2f1-a6550ae23333
@chain train begin 

end

# ╔═╡ 94b4c681-a279-47e8-a001-003a3a158e07
num_cont_feats

# ╔═╡ 73e42df3-6a8f-40b7-a21b-6e35336407e3
function classify(df, num = nrow(df))
	@chain df begin
	@aside nu = @summarise(_, across(everything(), (length ∘ unique)))
	@aside nur = @summarise(_, across(everything(), (x -> length(unique(x))/!!num)))
end
	# return @bind_rows(nu, nur)
	nu,nur
end
	

# ╔═╡ 58b8f0cc-dcec-49c2-9036-9a6d41536fb5
x,y = classify(train)

# ╔═╡ 4d3e79fa-a8a8-464f-9a9b-fda62384685e
@bind_rows(x,y)

# ╔═╡ 67fd66e2-6ac2-43b8-af99-18fd2928edfb
function cat_report(sv)
us = unique(sv)
	count(us, )
end

# ╔═╡ f07af232-47cf-4c82-b34d-752eb5d29ddb
begin
us = unique(train.term)
countmap(us, train.term)
end

# ╔═╡ 9640e860-7ce8-4f41-bef7-0aa231e242de
count()

# ╔═╡ 8d988a06-0b8f-43f6-980d-5a84ca4cdd52
@df df violin( :variable, :value)

# ╔═╡ d465f7e9-a0b9-4e42-9aaf-72cea43bce52


# ╔═╡ 4a597e85-5842-4897-a6c8-cde8828d786c
ggplot(df, @aes(x=value)) + geom_density()

# ╔═╡ a7a97950-0334-49f7-95d9-e0441707539e
df.variable

# ╔═╡ 5b844a24-e2a5-48e9-b8a1-4901e1d4c587
function test( a,b; c,d)
 return (a,b,c,d)
end	 

# ╔═╡ 02f8a464-3663-4d78-9a96-92700110f788
test(c=3,2, d=4, 1)

# ╔═╡ ba89cd1a-f309-484c-a135-6cd25f1a600e
df_wide = DataFrame(id = [1, 2], A = [1, 3], B = [2, 4])

# ╔═╡ afa6f38a-6e16-49b9-afd3-956f33e786ce
@pivot_longer(df_wide, A:B, names_to = "letter", values_to = "number")

# ╔═╡ a6370b72-fc88-4a0a-9e26-13b259a4fee2
d = Dict(:sdf => "ok")

# ╔═╡ 18fb0ab9-5822-470b-aa20-cebc671a8fdf
@pivot_longer(df_wide, A:B, names_to = letter, values_to = number)

# ╔═╡ 908031d1-2ca0-4438-8917-2f283d5130e6
@pivot_longer(df_wide, A:B, names_to = "letter")

# ╔═╡ 4a0a127e-5119-493b-a8dd-93501507cd02
md"""
因为数据是数值类型， 在画图前， 转化为字符串有利于避免一些画图问题。
""" |> aside

# ╔═╡ 3e9a242c-cc83-4413-9d0c-ce4b53b85ee4
dt = DataFrame(x = rand(1:5, 20), y = rand(20))

# ╔═╡ dd3e5521-04d4-4f88-a1f2-2ea756a1784e
mm = @chain dt begin
@aside nms = names(_)
@summarise(across(everything(), length ∘ unique))
#@rename_with(nms .= names(_))

end

# ╔═╡ b30510e8-1cc0-4428-8cb3-fecd764024d2
names(mm)

# ╔═╡ b1619c32-8bd8-4db5-b8f9-f412b408c974
function str_extract_group(string, pattern::Union{String, Regex}, i=1)
	m = match(pattern, string)
	if isnothing(m)
		return nothing
	end

	if(i > length(m.captures))
		return nothing
	else
		return m.captures[i]
	end
end

# ╔═╡ 4c1a9d1e-bbc8-449c-b2ac-dc689c2d9fe6
@chain train begin
	@summarise(_, across(everything(), (length ∘ unique)))
	str_extract_group.(names(_), r"^(.*?)_")
	
end

# ╔═╡ 42ddc8fb-1a09-4eb9-bc95-3d7a613f7427
str_extract_group.(names(mm), r"^(.*?)_")

# ╔═╡ 12284118-dc02-484c-9411-fd0e8e05637a


# ╔═╡ 93a43557-6519-4063-b998-563f248cda34
isnothing(mmt)

# ╔═╡ 33b58f0f-0a0c-4eb6-8b2e-0d898c0d652b
mt.captures

# ╔═╡ 3d474c37-d715-40aa-979f-4422e616abda
m[1].captures[1]

# ╔═╡ 300ef793-02e1-49f0-8f5f-b55b9e54d940
begin
	Temp = @ingredients "../chinese.jl" # provided by PlutoLinks.jl
	PlutoTeachingTools.register_language!("chinese", Temp.PTTChinese.China())
	set_language!( PlutoTeachingTools.get_language("chinese") )
end;

# ╔═╡ 71c36e05-cb12-48a3-a92a-bab9d244ab01
m = match.(r"^(.*?)_", names(mm))

# ╔═╡ c0648716-a2fb-4cd6-827a-00fb86fe1617
m = str_extract("a_b",r"\d")

# ╔═╡ Cell order:
# ╠═a6682dc0-501e-4a1a-aa26-2f4ff59cc8cb
# ╠═f504eb73-cab0-4e2b-92ce-16a292df974f
# ╠═71a16c11-c1e4-45f2-9e39-35632757f443
# ╠═6007bd79-5584-4f17-8530-c56997042d7a
# ╠═2a640a85-5c23-438d-b262-4287ab372d7c
# ╟─74ece9db-0a67-4b5c-9693-482c1bca0ba0
# ╟─245a7c5f-fd01-4386-93c9-e39a4b6c26ab
# ╠═b93c8356-1125-4c78-96d6-d65d008824cf
# ╟─b4b21281-2ee7-4b91-b33d-1e1138215f66
# ╟─9e29a561-bda1-46c2-a66f-4bde0b91731a
# ╠═0e783777-c3bd-41c2-b130-48eba04c2758
# ╟─6fd78a3a-63ea-4832-800f-dfc4a718fade
# ╠═3e6e4a80-4931-4efa-9a2d-cb070b708ae7
# ╟─13678a02-3664-4a52-83b3-7bf93b2f34bd
# ╠═8fa82962-7e00-4551-be97-9c7e883cd420
# ╟─a89e1f03-b9bf-468e-ba42-2983405dd5f7
# ╟─bd89c6b8-6af6-4660-bbdb-a48aef9191f6
# ╠═d67ee67a-ebc1-4a49-9bb0-59b59c210428
# ╟─e7e24ee0-cd32-46cf-a8b9-cade27de9d8c
# ╟─cdb4e909-5f17-42a7-91f0-f10fc05d36a2
# ╠═dcd068bc-e09a-49c3-9ab0-ffbd7304c0dc
# ╟─2142e85a-8a0d-49c3-ac20-6fb92fb99026
# ╠═8b6e2a66-358d-4903-a3cc-a627cf76c421
# ╟─71872557-459a-4f17-8865-ed5b22a0715c
# ╟─a63ad11b-d2d5-4dba-8856-532130b6eeb7
# ╟─a9a8705e-de36-4175-af86-4c064a108b69
# ╟─824eca64-ff9a-48af-99dc-a832196313e0
# ╠═3b9e3dc1-bf16-49b8-bf94-a9af8d808993
# ╠═45e168f6-1b2b-4560-b33d-c66999456a41
# ╟─2c4dbc16-4b22-4ae7-9ba0-26ffba47c9cb
# ╟─ab80de21-15c0-48a6-b286-e2dbf1b9ead3
# ╟─84a645f6-8c85-45b9-8e03-3b381e26511e
# ╠═ba548abf-44f3-41ad-a2a2-28286a3efeb2
# ╠═677003c9-7911-4ba2-8f3d-baabf2bf7341
# ╠═dfc21c69-5fba-4f28-91fe-fa445be7abd8
# ╟─733e3e89-338c-4153-ba6d-fbda29d6fd72
# ╠═bde3b6d2-710b-4923-b51d-5f175101ad78
# ╠═1143968f-f555-475d-ba84-fbd8dc1cb86b
# ╟─462f22ac-dd09-4f90-87c3-00c151b4d5f7
# ╠═3e1db291-c953-4c9c-bc4c-4e75fd666bf8
# ╟─10118f78-9de4-4380-b676-5a391bfa4678
# ╠═efddd6f7-b827-4386-94f7-a15300b1aac2
# ╟─540000a0-ac62-4167-96ab-cad3e91b7ee2
# ╠═dbe477c4-e13b-4799-9d20-2d4159e9ba77
# ╠═897afd4b-6b8b-4f31-ae6a-2381333f3027
# ╟─c02c487c-c519-4146-a859-c73313f9f863
# ╠═d93ad6f5-8b34-4964-9864-616bfa8b2573
# ╠═9e31d3c4-7973-4332-b8e4-916c5cfd2a4a
# ╠═17a241f7-6601-4530-bdaf-3a50dbc22edb
# ╠═b08ca6ed-0ff9-40ea-89f6-2d68b3d379b5
# ╟─b155e99a-4666-49bc-98dc-59c07d926df5
# ╟─c0ee1401-8658-4aed-a474-492aa014222d
# ╟─dd09ae38-5d2e-4e7e-a814-9bc306baac70
# ╟─37a32896-b5b9-47a2-ad6f-3364d7361c86
# ╟─953f5f18-c84a-4998-bd65-0d2408490848
# ╟─9dbcdbc6-419f-428e-9c33-8cf2f2d3cecb
# ╟─1e7c3d5b-ace7-484c-8f1e-f118498aac3a
# ╠═27f2447c-72ff-4753-9cd6-29b346b0e3e2
# ╠═0e6ac6fb-79c4-4516-8978-a420e85ed56e
# ╟─359f830b-c0c4-4371-a71f-797177826820
# ╠═386888a4-7bfd-48b3-b2ef-05a0ebb6cca1
# ╠═a5195522-8348-4b72-b2f1-a6550ae23333
# ╠═94b4c681-a279-47e8-a001-003a3a158e07
# ╠═73e42df3-6a8f-40b7-a21b-6e35336407e3
# ╠═58b8f0cc-dcec-49c2-9036-9a6d41536fb5
# ╠═4d3e79fa-a8a8-464f-9a9b-fda62384685e
# ╠═4c1a9d1e-bbc8-449c-b2ac-dc689c2d9fe6
# ╠═67fd66e2-6ac2-43b8-af99-18fd2928edfb
# ╠═f07af232-47cf-4c82-b34d-752eb5d29ddb
# ╠═9640e860-7ce8-4f41-bef7-0aa231e242de
# ╠═8d988a06-0b8f-43f6-980d-5a84ca4cdd52
# ╠═d465f7e9-a0b9-4e42-9aaf-72cea43bce52
# ╠═4a597e85-5842-4897-a6c8-cde8828d786c
# ╠═a7a97950-0334-49f7-95d9-e0441707539e
# ╠═5b844a24-e2a5-48e9-b8a1-4901e1d4c587
# ╠═02f8a464-3663-4d78-9a96-92700110f788
# ╠═ba89cd1a-f309-484c-a135-6cd25f1a600e
# ╠═afa6f38a-6e16-49b9-afd3-956f33e786ce
# ╠═a6370b72-fc88-4a0a-9e26-13b259a4fee2
# ╠═18fb0ab9-5822-470b-aa20-cebc671a8fdf
# ╠═908031d1-2ca0-4438-8917-2f283d5130e6
# ╟─4a0a127e-5119-493b-a8dd-93501507cd02
# ╠═3e9a242c-cc83-4413-9d0c-ce4b53b85ee4
# ╠═dd3e5521-04d4-4f88-a1f2-2ea756a1784e
# ╠═b30510e8-1cc0-4428-8cb3-fecd764024d2
# ╠═71c36e05-cb12-48a3-a92a-bab9d244ab01
# ╠═3d474c37-d715-40aa-979f-4422e616abda
# ╠═b1619c32-8bd8-4db5-b8f9-f412b408c974
# ╠═42ddc8fb-1a09-4eb9-bc95-3d7a613f7427
# ╠═12284118-dc02-484c-9411-fd0e8e05637a
# ╠═93a43557-6519-4063-b998-563f248cda34
# ╠═33b58f0f-0a0c-4eb6-8b2e-0d898c0d652b
# ╠═c0648716-a2fb-4cd6-827a-00fb86fe1617
# ╠═300ef793-02e1-49f0-8f5f-b55b9e54d940
