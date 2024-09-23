### A Pluto.jl notebook ###
# v0.19.45

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
using PlutoUI, PlutoTeachingTools, Tidier, DMUtils
end;

# ╔═╡ 75298017-f882-4a31-8bd7-3d6883130923
using TidierData

# ╔═╡ c2a578b0-4ffd-4b63-bf42-43be74dc105a
using ScientificTypes

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

# ╔═╡ a3472672-57ec-44f3-9416-d3dc76804792
md"""
为了方便后面查询特征函数， 我将其构建为了一个字典。
"""

# ╔═╡ 5112b88f-2562-4d00-b74c-90c155e8b4a0
name_disc = Dict(
    "id" => "为贷款清单分配的唯一信用证标识",
    "loanAmnt" => "贷款金额",
    "term" => "贷款期限（年）",
    "interestRate" => "贷款利率",
    "installment" => "分期付款金额",
    "grade" => "贷款等级",
    "subGrade" => "贷款等级之子级",
    "employmentTitle" => "就业职称",
    "employmentLength" => "就业年限（年）",
    "homeOwnership" => "借款人在登记时提供的房屋所有权状况",
    "annualIncome" => "年收入",
    "verificationStatus" => "验证状态",
    "issueDate" => "贷款发放的月份",
    "purpose" => "借款人在贷款申请时的贷款用途类别",
    "postCode" => "借款人在贷款申请中提供的邮政编码的前3位数字",
    "regionCode" => "地区编码",
    "dti" => "债务收入比",
    "delinquency_2years" => "借款人过去2年信用档案中逾期30天以上的违约事件数",
    "ficoRangeLow" => "借款人在贷款发放时的fico所属的下限范围",
    "ficoRangeHigh" => "借款人在贷款发放时的fico所属的上限范围",
    "openAcc" => "借款人信用档案中未结信用额度的数量",
    "pubRec" => "贬损公共记录的数量",
    "pubRecBankruptcies" => "公开记录清除的数量",
    "revolBal" => "信贷周转余额合计",
    "revolUtil" => "循环额度利用率，或借款人使用的相对于所有可用循环信贷的信贷金额",
    "totalAcc" => "借款人信用档案中当前的信用额度总数",
    "initialListStatus" => "贷款的初始列表状态",
    "applicationType" => "表明贷款是个人申请还是与两个共同借款人的联合申请",
    "earliestCreditLine" => "借款人最早报告的信用额度开立的月份",
    "title" => "借款人提供的贷款名称",
    "policyCode" => "公开可用的策略代码=1新产品不公开可用的策略代码=2",
	"isDefault" => "是否欺诈",
	"n0" => "匿名特征n0",
	"n1" => "匿名特征n1",
	"n2" => "匿名特征n2",
	"n3" => "匿名特征n3",
	"n4" => "匿名特征n4",
	"n5" => "匿名特征n5",
	"n6" => "匿名特征n6",
	"n7" => "匿名特征n7",
	"n8" => "匿名特征n8",
	"n9" => "匿名特征n9",
	"n10" => "匿名特征n10",
	"n11" => "匿名特征n11",
	"n12" => "匿名特征n12",
	"n13" => "匿名特征n13",
	"n14" => "匿名特征n14",
	)

# ╔═╡ 7c963a6c-13ee-4b92-bf2a-d9abbbd5b412
name_disc_df = DataFrame(names=Symbol.(collect(keys(name_disc))), discription=collect(values(name_disc)))

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

# ╔═╡ 43aacf95-4834-48fc-ba1b-c91c2eb77e4b
@chain train begin 
	@summarise(across(everything(),(length ∘ unique )))
	@pivot_longer(everything(), names_to = "names", values_to="nunique")
	@arrange(nunique)
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
num_cont_feats = setdiff(Set(num_feats), Set(num_cate_feats))

# ╔═╡ 733e3e89-338c-4153-ba6d-fbda29d6fd72
md"""
### 文本特征
文本特征一般当成类别变量， 但也要看看类别的数量。
"""

# ╔═╡ bde3b6d2-710b-4923-b51d-5f175101ad78
str_feats = @select(train, where(is_string)) |> names 

# ╔═╡ 36d3c8a0-9c26-498a-b90e-c8f8c774f93c
md"""
有些文本很奇怪， 看上去是数字， 这个要检查一下， 是否真的应该处理成数字？
"""

# ╔═╡ 99a52e7a-b2e7-4adf-98db-64ee750c960f


# ╔═╡ 977f4da0-2360-4438-b17e-cc099d257c23
for fn in str_feats
	println(fn,"  " , length(unique(train[:,fn])))
end

# ╔═╡ 13ec0270-38bb-4403-944e-3f7f9efe6c7e
train[:, "subGrade"]

# ╔═╡ c41d16b2-9c91-4c14-a5a8-bb128128426e
function report_cat(vec)
    vec = categorical(vec)
    n = length(vec)
    nu = length(levels(vec))
    nur = nu / n
    return string(length(levels(vec))) * 
    " | " * string(nur) * 
    " | " * string(levels(vec)) * 
    " | " * string(countmap(vec))
end

# ╔═╡ eb33b63d-bad9-4522-b81c-0bd883929079
report_cat(train.pubRecBankruptcies)

# ╔═╡ 0728bb7a-19b3-4a2a-8714-0438b8321fbf
report_cat(train.n0)

# ╔═╡ ef0c9a89-b618-4d69-aaa6-0fce831e4fa9
report_cat(train.employmentLength)

# ╔═╡ 0fe1ce90-6a45-4a9e-ae2d-47c6981372c9
report_cat(train.n0)

# ╔═╡ 80bd4fa9-8cb1-496f-a183-c43f8acc3ace
report_cat(train.subGrade)

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

# ╔═╡ 615c7a5c-6235-4b92-a067-415c80c522a8


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

# ╔═╡ 94b4c681-a279-47e8-a001-003a3a158e07
num_cont_feats

# ╔═╡ 4a0a127e-5119-493b-a8dd-93501507cd02
md"""
因为数据是数值类型， 在画图前， 转化为字符串有利于避免一些画图问题。
""" |> aside

# ╔═╡ da135749-8fff-4687-8446-f113f4375c56
ggplot(train, @aes(x=loanAmnt)) + geom_density()

# ╔═╡ 75453e5e-87ff-4989-be5b-82a3b8e027d7
names(train)

# ╔═╡ cbbc48d4-5dea-42f6-a688-3e4b0a640950
md"""
# 整体整理
"""

# ╔═╡ b30a536c-3138-44b2-843f-f771e73d4d92
md"""
下面把每一列的名字，唯一值数量，科学类型，存储类型和含义放在一起， 方便从总体上判断， 字段是否可能存在不一致的情况。
"""

# ╔═╡ dcd068bc-e09a-49c3-9ab0-ffbd7304c0dc
df = @chain train begin 
	@aside nms = Symbol.(names(train)) # 先把列名存起来， 方便后面继续使用
	@summarise(across(everything(),(length ∘ unique )))
	@pivot_longer(everything(), names_to = "names", values_to="nunique")
	@mutate(names = !!nms)
	@left_join(DataFrame(schema(train)) )
	@left_join(name_disc_df)
	@arrange(nunique)
end

# ╔═╡ de1e569b-0b60-48a9-ace9-b8fc9f31921e
function report(vec, maxcnt = 30, freq=false)
    uvec = unique(vec)
    nu = length(uvec)
    if nu >maxcnt
        return "too many unique values"
    end

    level_counts = countmap(vec)
    n = length(vec)
    
    # 按照出现次数对水平进行排序
    sorted_levels = ifelse(freq, 
                    sort(collect(keys(level_counts)), by=x -> level_counts[x], rev=true),
                    sort(uvec)
    ) 
    nur = nu / n
    info = ["""$(level) => $(level_counts[level])""" for level in sorted_levels]
        
    code = ["""vec == $(level) => \"$(level)\"""" for level in sorted_levels]
   
   str = """  
    #=
    # 数据中有$nu 个唯一值， 占到总数的 $nur. 下面是每个唯一值出现次数的统计：
    $(join(info, "\n"))
    # 据此， 我写出了如下代码， 方便进行处理。默认情况是：将相关值转化为类别变量的水平，注意，这里增加true=>'r'表示
    # 如果有没有见过的值， 我们将其编码为"r"， 表示rest。
    =#   
    vec = categorical(case_when(
        $(join(code, "\n"))
        true => "r"
    ),levels=$(push!(["$(le)" for le in sorted_levels], "r")), ordered=true),
    """
    return println(str)
end

# ╔═╡ 17230f4f-6ae2-4b26-a22b-0684017acc90
@bind tmpf Select([key=>value for (key, value) in zip(df.names, df.discription)])

# ╔═╡ 7e86602c-abd5-4e03-a7db-0593bef864a0
TwoColumnWideLeft(
md"""
$(if length(unique(train[:, tmpf])) < 30
	ggplot(train, aes(y = tmpf)) + geom_bar()
elseif isnumeric(train[:, tmpf]) 
	ggplot(train, aes(y = tmpf)) + geom_density()
else 
	println("不好画图")
end)
""", 

	if length(unique(train[:, tmpf])) < 30	
		md"""
		name: $(string(tmpf))    
		
		type: $(eltype(train[:,tmpf]))  
		
		scitype: $(elscitype(train[:,tmpf]))  
		
		unique value: $(str_c(string.(unique(train[:,tmpf]), "  ")))
		
		num_unique: $(countmap(train[:,tmpf]))
		"""
	elseif isnumeric(train[:, tmpf]) 
		md"""
		name: $(string(tmpf))    
		
		type: $(eltype(train[:,tmpf]))  
		
		scitype: $(elscitype(train[:,tmpf]))  
		
		mean: $(means(train[:,tmpf]))
		
		var: $(var(train[:,tmpf]))
		"""
	else
		md"""这个没计算"""	
	end
)

# ╔═╡ 6dd92738-1369-41e0-b79f-95707070b2f2
report(train[:, tmpf])

# ╔═╡ 71fbd95e-a27b-49bc-a540-6e184d718923
@select(train, 
delinquency_2years = categorical(as_integer(delinquency_2years), levels=0:15,ordered=true),

)

# ╔═╡ 3e41f841-f1b7-4314-afc7-c30a7296ff01
as_integer

# ╔═╡ 3fa4351a-16c8-49af-899f-b2224c1ac7cf
md"""
```julia
@mutate(train, 
term = categorical(term, levels = [3,5], ordered = true),
applicationType = categorical(applicationType, levels = [0,1]),
initialListStatus = categorical(initialListStatus, levels = [0,1]),
verificationStatus = categorical(verificationStatus, levels = [0,1,2]),
n11 = categorical(missing_if(n11, "NA"), levels=["0.0","1.0"]),
n12 = categorical(missing_if(n12, "NA"), levels=["0.0","1.0","2.0"]),
homeOwnership = categorical(case_when(
	homeOwnership == 0 => "0",
	homeOwnership == 1 => "1",
	homeOwnership == 2 => "2",
	true => "a"
),levels=["0","1","2","a"], ordered=true),
grade = categorical(grade, levels=["A","B","C","D","E","F","G"],ordered=true),
pubRecBankruptcies = categorical(case_when(
	pubRecBankruptcies == "0.0" => "0",
	pubRecBankruptcies == "1.0" => "1",
	pubRecBankruptcies == "2.0" => "2",
	true => "a"
),levels=["0","1","2","a"], ordered=true),
pubRec = categorical(case_when(
	pubRec == "0.0" => "0",
	pubRec == "1.0" => "1",
	pubRec == "2.0" => "2",
	pubRec == "3.0" => "3",
	pubRec == "4.0" => "4",
	true => "a"
),levels=["0","1","2","3","4","a"], ordered=true),

n13 = categorical(case_when(
	n13 == "0.0" => "0",
	n13 == "1.0" => "1",
	n13 == "2.0" => "2",
	n13 == "NA" => missing, 
	true => "a"
),levels=["0","1","2","a"], ordered=true),
employmentLength = categorical(case_when(	
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
),levels=[0,1,2,3,4,5,6,7,8,9,10], ordered=true),

delinquency_2years = categorical(case_when(
	delinquency_2years == "0.0" => "0",
	delinquency_2years == "1.0" => "1",
	delinquency_2years == "2.0" => "2",
	delinquency_2years == "3.0" => "3",
	delinquency_2years == "4.0" => "4",
	delinquency_2years == "5.0" => "5",
	delinquency_2years == "6.0" => "6",
	delinquency_2years == "7.0" => "7",
	delinquency_2years == "8.0" => "8",
	true => "a"
),levels=["0","1","2","3","4","5","6","7","8","a"], ordered=true),



)
```
"""

# ╔═╡ 908c9c63-7428-441d-b7b4-b2173425b70a
del_feats = ["id","policyCode", "isDefault"]

# ╔═╡ 0f889626-f415-4a1b-b6ef-c14271310722
md"""
这里写对特征要做的处理的相关代码：
$(@bind code TextField((80, 20), default = "@mutate(train,
")))
"""

# ╔═╡ cc67bc7c-5f00-402c-a47f-0e2b72a05750
@select(train, 
applicationType = categorical(applicationType), 
initialListStatus = categorical(initialListStatus),
verificationStatus = categorical(verificationStatus),
n11 = missing_if(n11, "NA"),
)

# ╔═╡ 0fd6f69e-524c-4b2d-9718-da4816b174f3
md"""
这里写对特征要做的处理的相关代码：
$(@bind testcode TextField((80, 20)))
"""

# ╔═╡ c597dca4-766c-4ee1-97f6-8cb880d3b2e7
Meta.parse(testcode)

# ╔═╡ 0dea5f1a-a14f-4989-ad4e-2fa27c1be459
a = quote
	a=b
	c=d
end

# ╔═╡ 6066b045-69da-4f32-babf-bb3b713f14ec
Meta.parse(code)

# ╔═╡ d5f6b8f5-34ec-4923-8fb9-7e86db729c2e
md"""
这里写要删掉的特征:
$(@bind del TextField((80, 5)))
"""

# ╔═╡ 227c9bfe-f941-41f1-8988-b3bef382175b
ggplot(train, @aes(y = term,color=isDefault)) + geom_bar(position="dodge")

# ╔═╡ 6bd41c0f-573e-4770-a941-c83a67eea4b1


# ╔═╡ d90f6502-eea6-4e9a-a242-11c9d300d67d


# ╔═╡ 52edd3c2-6541-4549-8512-c81bd682539d
md"""
字段有问题的地方可能是：1）文本特征应该当成类别变量，但如果类别太多就有问题了。2）数值特征，应该是文本类型的才对。 既不是数值， 也不是文本的特征。
"""

# ╔═╡ 12284118-dc02-484c-9411-fd0e8e05637a


# ╔═╡ 300ef793-02e1-49f0-8f5f-b55b9e54d940
begin
	Temp = @ingredients "../chinese.jl" # provided by PlutoLinks.jl
	PlutoTeachingTools.register_language!("chinese", Temp.PTTChinese.China())
	set_language!( PlutoTeachingTools.get_language("chinese") )
end;

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ScientificTypes = "321657f4-b219-11e9-178b-2701a2544e81"
Tidier = "f0413319-3358-4bb0-8e7c-0c83523a93bd"
TidierData = "fe2206b3-d496-4ee9-a338-6a095c4ece80"

[compat]
PlutoTeachingTools = "~0.2.15"
PlutoUI = "~0.7.60"
ScientificTypes = "~3.0.2"
Tidier = "~1.3.0"
TidierData = "~0.15.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "20fae007804b7e3c3eb77cce42a2865a119766f8"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

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

[[deps.AdaptivePredicates]]
git-tree-sha1 = "7e651ea8d262d2d74ce75fdf47c4d63c07dba7a6"
uuid = "35492f91-a3bd-45ad-95db-fcad7dcfedb7"
version = "1.2.0"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

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
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "014bc22d6c400a7703c0f5dc1fdc302440cf88be"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.4"

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

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

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

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "7b6ad8c35f4bc3bca8eb78127c8b99719506a5fb"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.1.0"

[[deps.CairoMakie]]
deps = ["CRC32c", "Cairo", "Colors", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools"]
git-tree-sha1 = "d69c7593fe9d7d617973adcbe4762028c6899b2c"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.11.11"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[deps.Cascadia]]
deps = ["AbstractTrees", "Gumbo"]
git-tree-sha1 = "c0769cbd930aea932c0912c4d2749c619a263fc1"
uuid = "54eefc05-d75b-58de-a785-1a3403f0919f"
version = "1.0.2"

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

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "3e4b134270b372f2ed4d4d0e936aabaefc1802bc"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

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

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

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
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"
weakdeps = ["IntervalSets", "LinearAlgebra", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
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

[[deps.DelaunayTriangulation]]
deps = ["AdaptivePredicates", "EnumX", "ExactPredicates", "Random"]
git-tree-sha1 = "94eb20e6621600f4315813b1d1fc9b8a5a6a34db"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "1.4.0"

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

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.Extents]]
git-tree-sha1 = "81023caa0021a41712685887db1fc03db26f41f5"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.4"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "8cc47f299902e13f90405ddb5bf87e5d474c0d38"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "6.1.2+0"

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

[[deps.FilePaths]]
deps = ["FilePathsBase", "MacroTools", "Reexport", "Requires"]
git-tree-sha1 = "919d9412dbf53a2e6fe74af62a73ceed0bce0629"
uuid = "8fc22ac5-c921-52a6-82fd-178b2807b824"
version = "0.8.3"

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

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "2493cdfd0740015955a8e46de4ef28f49460d8bc"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.3"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "273bd1cd30768a2fddfa3fd63bbc746ed7249e5f"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.9.0"

[[deps.GeoFormatTypes]]
git-tree-sha1 = "59107c179a586f0fe667024c5eb7033e81333271"
uuid = "68eda718-8dee-11e9-39e7-89f7f65f511f"
version = "0.4.2"

[[deps.GeoInterface]]
deps = ["Extents", "GeoFormatTypes"]
git-tree-sha1 = "5921fc0704e40c024571eca551800c699f86ceb4"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.6"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "b62f2b2d76cee0d61a2ef2b3118cd2a3215d3134"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.11"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "7c82e6a6cd34e9d935e9aa4051b66c6ff3af59ba"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.2+0"

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
git-tree-sha1 = "6f93a83ca11346771a93bbde2bdad2f65b61498f"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.10.2"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Gumbo]]
deps = ["AbstractTrees", "Gumbo_jll", "Libdl"]
git-tree-sha1 = "a1a138dfbf9df5bace489c7a9d5196d6afdfa140"
uuid = "708ec375-b3d6-5a57-a7ce-8257bf98657a"
version = "0.8.2"

[[deps.Gumbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "29070dee9df18d9565276d68a596854b1764aa38"
uuid = "528830af-5a63-567c-a44a-034ed33b8444"
version = "0.10.2+0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "401e4f3f30f43af2c8478fc008da50096ea5240f"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.3.1+0"

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
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "10bd689145d2c3b2a9844005d01087cc1194e79e"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.1+0"

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
git-tree-sha1 = "fe30dec78e68f27fc416901629c6e24e9d5f057b"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.22.16"

    [deps.IntervalArithmetic.extensions]
    IntervalArithmeticDiffRulesExt = "DiffRules"
    IntervalArithmeticForwardDiffExt = "ForwardDiff"
    IntervalArithmeticIntervalSetsExt = "IntervalSets"
    IntervalArithmeticLinearAlgebraExt = "LinearAlgebra"
    IntervalArithmeticRecipesBaseExt = "RecipesBase"

    [deps.IntervalArithmetic.weakdeps]
    DiffRules = "b552c78f-8df3-52c6-915a-8e097449b14b"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

    [deps.IntervalSets.weakdeps]
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "2984284a8abcfcc4784d95a9e2ea4e352dd8ede7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.36"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "7d703202e65efa1369de1279c162b915e245eed1"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.9"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Languages]]
deps = ["InteractiveUtils", "JSON", "RelocatableFolders"]
git-tree-sha1 = "0cf92ba8402f94c9f4db0ec156888ee8d299fcb8"
uuid = "8ef0a80b-9436-5d2c-a485-80b904378c43"
version = "0.4.6"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "f749e7351f120b3566e5923fefdf8e52ba5ec7f9"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.6.4"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FilePaths", "FixedPointNumbers", "Format", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Scratch", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "4d49c9ee830eec99d3e8de2425ff433ece7cc1bc"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.20.10"

[[deps.MakieCore]]
deps = ["Observables", "REPL"]
git-tree-sha1 = "248b7a4be0f92b497f7a331aed02c1e9a878f46b"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.7.3"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

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

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "2c140d60d7cb82badf06d8783800d0bcd1a7daa2"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.8.1"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

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
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"
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
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

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

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

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
git-tree-sha1 = "e127b609fb9ecba6f201ba7ab753d5a605d53801"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.54.1+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

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
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "5d9ab1a4faf25a62bb9d07ef0003396ac258ef1c"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.15"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

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

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.PtrArrays]]
git-tree-sha1 = "77a42d78b6a92df47ab37e177b2deac405e1c88f"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.1"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "cda3b045cf9ef07a08ad46731f5a3165e56cf3da"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.1"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

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

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "98ca7c29edd6fc79cd74c61accb7010a4e7aee33"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.6.0"

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

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

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
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

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

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsAPI", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "9022bcaa2fc1d484f1326eaa4db8db543ca8c66d"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.7.4"

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "b765e46ba27ecf6b44faf70df40c57aa3a547dcb"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.7"

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

[[deps.TZJData]]
deps = ["Artifacts"]
git-tree-sha1 = "36b40607bf2bf856828690e097e1c799623b0602"
uuid = "dc5dba14-91b3-4cab-a142-028a31da12f7"
version = "1.3.0+2024b"

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

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tidier]]
deps = ["Reexport", "TidierCats", "TidierData", "TidierDates", "TidierPlots", "TidierStrings", "TidierText", "TidierVest"]
git-tree-sha1 = "5502e1d0c8bf26524f5d3b14670e2f0ac35e7a47"
uuid = "f0413319-3358-4bb0-8e7c-0c83523a93bd"
version = "1.3.0"

[[deps.TidierCats]]
deps = ["CategoricalArrays", "DataFrames", "Reexport", "Statistics"]
git-tree-sha1 = "bf7843c4477d1c3f9e430388f7ece546b9382bef"
uuid = "79ddc9fe-4dbf-4a56-a832-df41fb326d23"
version = "0.1.2"

[[deps.TidierData]]
deps = ["Chain", "Cleaner", "DataFrames", "MacroTools", "Reexport", "ShiftedArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "c8707f31337e168d0bb63f126315ad52694793c8"
uuid = "fe2206b3-d496-4ee9-a338-6a095c4ece80"
version = "0.15.2"

[[deps.TidierDates]]
deps = ["Dates", "Reexport", "TimeZones"]
git-tree-sha1 = "680193b3912c5a337ec5e6b5c7a513e39418172d"
uuid = "20186a3f-b5d3-468e-823e-77aae96fe2d8"
version = "0.2.6"

[[deps.TidierPlots]]
deps = ["CairoMakie", "CategoricalArrays", "Colors", "DataFrames", "GLM", "KernelDensity", "Loess", "Makie", "Reexport", "TidierData"]
git-tree-sha1 = "0733f44cb2f2445a2fcab9563e18b94b32f5bc47"
uuid = "337ecbd1-5042-4e2a-ae6f-ca776f97570a"
version = "0.6.6"

[[deps.TidierStrings]]
deps = ["StringEncodings"]
git-tree-sha1 = "04163119cd5d6897b70c187062d24cb32dcbce84"
uuid = "248e6834-d0f8-40ef-8fbb-8e711d883e9c"
version = "0.2.4"

[[deps.TidierText]]
deps = ["DataFrames", "Languages", "MacroTools", "Reexport", "StatsBase"]
git-tree-sha1 = "e2d33da7cb5c836dec5cdf1c1f6fb9d793c9184d"
uuid = "8f0b679f-44a1-4a38-8011-253e3a78fd39"
version = "0.1.1"

[[deps.TidierVest]]
deps = ["Cascadia", "DataFrames", "Gumbo", "HTTP"]
git-tree-sha1 = "4a3ccf757ea5884c725c6a77db93715910bb1d8f"
uuid = "969b988e-7aed-4820-b60d-bdec252047c4"
version = "0.4.4"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "bc7fd5c91041f44636b2c134041f7e5263ce58ae"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.0"

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

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "1165b0443d0eca63ac1e32b8c0eb69ed2f4f8127"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "a54ee957f4c86b526460a720dbc882fa5edcbefc"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.41+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "bcd466676fef0878338c61e655629fa7bbc69d8e"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

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
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "35976a1216d6c066ea32cba2150c4fa682b276fc"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.0+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dcc541bb19ed5b0ede95581fb2e41ecf179527d2"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.6.0+0"
"""

# ╔═╡ Cell order:
# ╠═a6682dc0-501e-4a1a-aa26-2f4ff59cc8cb
# ╠═75298017-f882-4a31-8bd7-3d6883130923
# ╠═2a640a85-5c23-438d-b262-4287ab372d7c
# ╟─74ece9db-0a67-4b5c-9693-482c1bca0ba0
# ╟─245a7c5f-fd01-4386-93c9-e39a4b6c26ab
# ╠═b93c8356-1125-4c78-96d6-d65d008824cf
# ╠═c2a578b0-4ffd-4b63-bf42-43be74dc105a
# ╟─b4b21281-2ee7-4b91-b33d-1e1138215f66
# ╟─a3472672-57ec-44f3-9416-d3dc76804792
# ╟─5112b88f-2562-4d00-b74c-90c155e8b4a0
# ╠═7c963a6c-13ee-4b92-bf2a-d9abbbd5b412
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
# ╠═43aacf95-4834-48fc-ba1b-c91c2eb77e4b
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
# ╟─36d3c8a0-9c26-498a-b90e-c8f8c774f93c
# ╠═99a52e7a-b2e7-4adf-98db-64ee750c960f
# ╠═977f4da0-2360-4438-b17e-cc099d257c23
# ╠═13ec0270-38bb-4403-944e-3f7f9efe6c7e
# ╠═eb33b63d-bad9-4522-b81c-0bd883929079
# ╠═0728bb7a-19b3-4a2a-8714-0438b8321fbf
# ╠═c41d16b2-9c91-4c14-a5a8-bb128128426e
# ╠═ef0c9a89-b618-4d69-aaa6-0fce831e4fa9
# ╠═0fe1ce90-6a45-4a9e-ae2d-47c6981372c9
# ╠═80bd4fa9-8cb1-496f-a183-c43f8acc3ace
# ╟─462f22ac-dd09-4f90-87c3-00c151b4d5f7
# ╠═3e1db291-c953-4c9c-bc4c-4e75fd666bf8
# ╟─10118f78-9de4-4380-b676-5a391bfa4678
# ╠═efddd6f7-b827-4386-94f7-a15300b1aac2
# ╠═615c7a5c-6235-4b92-a067-415c80c522a8
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
# ╠═1e7c3d5b-ace7-484c-8f1e-f118498aac3a
# ╠═27f2447c-72ff-4753-9cd6-29b346b0e3e2
# ╠═0e6ac6fb-79c4-4516-8978-a420e85ed56e
# ╟─359f830b-c0c4-4371-a71f-797177826820
# ╠═94b4c681-a279-47e8-a001-003a3a158e07
# ╟─4a0a127e-5119-493b-a8dd-93501507cd02
# ╠═da135749-8fff-4687-8446-f113f4375c56
# ╠═75453e5e-87ff-4989-be5b-82a3b8e027d7
# ╟─cbbc48d4-5dea-42f6-a688-3e4b0a640950
# ╟─b30a536c-3138-44b2-843f-f771e73d4d92
# ╠═dcd068bc-e09a-49c3-9ab0-ffbd7304c0dc
# ╟─de1e569b-0b60-48a9-ace9-b8fc9f31921e
# ╟─7e86602c-abd5-4e03-a7db-0593bef864a0
# ╟─17230f4f-6ae2-4b26-a22b-0684017acc90
# ╠═6dd92738-1369-41e0-b79f-95707070b2f2
# ╠═71fbd95e-a27b-49bc-a540-6e184d718923
# ╠═3e41f841-f1b7-4314-afc7-c30a7296ff01
# ╠═3fa4351a-16c8-49af-899f-b2224c1ac7cf
# ╠═908c9c63-7428-441d-b7b4-b2173425b70a
# ╟─0f889626-f415-4a1b-b6ef-c14271310722
# ╠═cc67bc7c-5f00-402c-a47f-0e2b72a05750
# ╠═0fd6f69e-524c-4b2d-9718-da4816b174f3
# ╠═c597dca4-766c-4ee1-97f6-8cb880d3b2e7
# ╠═0dea5f1a-a14f-4989-ad4e-2fa27c1be459
# ╠═6066b045-69da-4f32-babf-bb3b713f14ec
# ╟─d5f6b8f5-34ec-4923-8fb9-7e86db729c2e
# ╠═227c9bfe-f941-41f1-8988-b3bef382175b
# ╠═6bd41c0f-573e-4770-a941-c83a67eea4b1
# ╠═d90f6502-eea6-4e9a-a242-11c9d300d67d
# ╟─52edd3c2-6541-4549-8512-c81bd682539d
# ╠═12284118-dc02-484c-9411-fd0e8e05637a
# ╠═300ef793-02e1-49f0-8f5f-b55b9e54d940
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
