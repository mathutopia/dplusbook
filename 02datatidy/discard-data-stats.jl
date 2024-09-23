### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ 54d48980-e50b-11ee-01ff-833f16130cde
using CSV,DataFrames,PlutoUI,StatsBase,FreqTables

# ╔═╡ f67e2900-c720-44cb-8988-800f6b8e5389
TableOfContents(title="目录")

# ╔═╡ c20e8dd4-6199-40ba-a874-f5a0daadead9
md"""
# 数据统计分析

## 常见统计函数
数据探索分为统计分析和数据可视化两部分。 在Julia中， 统计相关的包有不少， 可参考[JuliaStats](https://juliastats.org/)了解统计有关的包。 本教程使用的基本统计工具主要来自于[StatsBase.jl](https://juliastats.org/StatsBase.jl/stable/)包。    


下表列出了常见的统计量名称、作用和相应的Julia函数。这里对统计量作用的描述并非严谨的数学定义， 只是为了方便理解和记忆而粗略的给出， 严谨的定义请参考有关书籍。

|统计量名称| 作用 | Julia函数 |
|----|---|---|
|计数 |统计给定的区间中（默认为：min~max）某个值出现的次数  | countmap|
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

# ╔═╡ 8544cf21-1943-4c78-824e-14f77358691f
md"""
## 数据读取

"""

# ╔═╡ 19cbc1c7-be09-4b6b-b620-4df8dd889f1a
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 3e403ca3-b7f8-455d-90d5-640e8470960c
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

# ╔═╡ 1dcae8f7-287c-4d11-9a7c-cbec4480897f
md"""
### 单个类别变量统计
"""

# ╔═╡ a1417f09-52e3-4228-8b1e-dca19a74079e
md"""
如果只是单纯统计某一个字段中，各个取值出现的次数， 使用`countmap`函数可能更方便。其返回结果是一个由`水平=>出现次数`构成的字典。

`countmap`不是只能针对类别变量， 其核心是统计一个向量中， 各个元素出现的次数。 用于类别变量自然是可以的。

比如，下面的代码可以查看样本中不同欺诈类型的数量。

"""

# ╔═╡ ecd322ab-6041-4133-9f89-1f1fa7401e51
countmap(train.fraud)

# ╔═╡ 744abff4-2541-47bc-880d-744e10cfcc00
md"""
下面的代码可以看到不同学历的样本的数量情况：
"""

# ╔═╡ 5141523d-9992-49d7-ab0f-00546460e907
countmap(train.insured_education_level	)

# ╔═╡ d4c6bf4a-5390-4197-b00f-0d7976719840
md"""
### 多个类别统计
通常的情况是， 我们需要对多个变量同时做统计分析。 这可以通过`FreqTables.jl`包中的`freqtable`函数得到。 [这里可以看到更多的细节](https://github.com/nalimilan/FreqTables.jl)

`freqtable`函数有两种使用方式: ：1）提供1个或多个（...）向量（AbstractVector）；2）提供一个表格型数据t（比如， DataFrame），然后可以提供一个或多个(...)以字符串（AbstractString）或符号（Symbol）形式给出的列名（cols）。
```julia
freqtable(x::AbstractVector...)

freqtable(t, cols::Union{Symbol, AbstractString}...)
```

	
"""

# ╔═╡ 0544e81c-4ed3-435d-b270-9b1c9f67da16
md"""
比如， 下面两种形式的代码给出的仍然是欺诈样本的数量分布情况。 其返回结果是一个命名向量。 命名向量还是一个向量， 只是向量中每一个元素都有一个名字，这个名字就是字段的各种取值。
"""

# ╔═╡ 8d490fd1-c479-4013-b350-fde8d0f5050d
freqtable(train.fraud)

# ╔═╡ a73c6ba0-7d40-4891-8cfa-e035c0e92d98
frd=freqtable(train, :fraud)

# ╔═╡ 1691fab6-6979-4de0-afd4-65b59241d946
names(frd)

# ╔═╡ 47001e60-48f6-4981-81a9-9475f84278bb
md"""
如果想知道某一个取值的对应的数量， 可以通过如下方式。 比如， 我们想知道fraud=1的样本数量。 首先需要通过Name构造一个名子，然后去获得相应的索引。
"""

# ╔═╡ 3e5a2ef4-e373-49b5-a8cc-1ddeebcad212
frd[Name(0)]

# ╔═╡ 18d763d4-e133-42d1-9d62-7e00d814818a
md"""
类似的， 我们也可以同时获取多个字段的列联表, 下面同时分析学历（insured\_education\_level）和欺诈（fraud）字段。
"""

# ╔═╡ 6d27358a-aa9d-4474-b7ce-16029bbb1db0
edu_frd = freqtable(train, :insured_education_level,  :fraud)

# ╔═╡ b03ad02b-fc18-4a50-969e-9d44710c7f59
md"""
对多个类别变量来说， 我们可能需要的是比例，这可以在结果上调用`prop`函数。 其使用方法如下：
```julia
prop(tbl::AbstractArray{<:Number}; margins = nothing)
```
其中， tbl是一个数组，`freqtable`函数返回的结果就是一个数组。 `margins`参数不指定时， 比例是全局去求的。如果要按行、按列求比例， 可以设定margins=1或2。 下面的代码演示的是对行求比例的结果。
"""

# ╔═╡ 61289494-5f42-46a1-913a-23a5a20e48cd
md"""
按学历(行)统计每种学历下， 欺诈的比例。 可以看到， 学历为MD的样本， 其欺诈的比例最高。
"""

# ╔═╡ fdb4ad62-e292-499b-b0da-426fcea49509
prop(edu_frd, margins=1)

# ╔═╡ e763dacd-aea5-45e0-a90a-8818ee0e64dc
md"""
统计每种欺诈类型在不同学历下的比例情况。可以看到， 欺诈样本中， 学历为JD的最高。                    
"""

# ╔═╡ 76080767-69e3-4aa4-af73-894b8d12c30e
prop(edu_frd, margins=2)

# ╔═╡ f773a1d1-d284-4464-9d49-941ff8041c7c
md"""
## 连续变量统计分析

数据集中， policy_annual_premium字段存储的是每年的保费， 是一个典型的连续变量。 可以简单的通过`变量名.属性名`或`变量名[:, :属性名]`的方式获取相应的属性列。 只要将获取的相应字段放入相应统计函数中，就可得得到统计量的值, 下面的代码是计算所有用户保费的最小值(`minimum`)、最大值（`maximum`）、均值（`mean`）、方差(`var`)、偏度(`skewness`)和峰度(`kurtosis`)。

```julia
julia> mean(train.policy_annual_premium)
3271.258

julia> var(ret.AMOUNT)
7.967843470906908e6

julia> skewness(ret[:,:AMOUNT])
1.946702018941925

julia> kurtosis(ret[:,:AMOUNT])
4.265163377213499
```
如果要计算其他统计量的值， 可以参考相应统计量的帮助文档。
"""

# ╔═╡ 40b40d75-2497-439c-a4c1-2a66d7eba5bf
minimum(train.policy_annual_premium)

# ╔═╡ f032ae63-7a12-4d24-ab39-8088258e34e1
maximum(train.policy_annual_premium)

# ╔═╡ 9ca2b221-ece1-4c13-8a4a-c0e2e2fdbce5
mean(train.policy_annual_premium)

# ╔═╡ 35e67b17-54f7-4274-99ea-d7c295687595
var(train.policy_annual_premium)

# ╔═╡ 8fc45d95-a1f6-4ccc-bad3-2490048b136f
skewness(train.policy_annual_premium)

# ╔═╡ 537b7fdf-4f29-46eb-8ce6-ac11b1965458
kurtosis(train.policy_annual_premium)

# ╔═╡ e24ae6e4-9c41-49ae-95eb-fabe8d68fe6d
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

# ╔═╡ da302a35-3825-4bbe-ba18-8e9b4e96d0e4
sample(1:10) # 在1:10随机抽取一个元素

# ╔═╡ d8ed4229-ce86-4f11-8077-4e2ec0135007
sample(1:10, 15) # 在1:10随机抽取3个元素, 默认是有放回抽样。

# ╔═╡ 2227f0d8-e56a-4c4f-a6a5-305cb4666f37
sample(1:10, 5, replace=false) # 无放回抽样

# ╔═╡ 5c30ee0e-154e-4f42-9ca8-af92420db30e
test = DataFrame(a = rand(10), b = sample(1:3, 10))

# ╔═╡ 06805e83-8bb2-4355-8077-c97413ba07d7
countmap(test[:, :b])

# ╔═╡ 46393867-3f27-469f-85c3-591c15a986ca
counts(test[:, :b])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FreqTables = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "629375c6c15af29975e98f992651eee21dbe2e0c"

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

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

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

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

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

[[deps.FreqTables]]
deps = ["CategoricalArrays", "Missings", "NamedArrays", "Tables"]
git-tree-sha1 = "4693424929b4ec7ad703d68912a6ad6eff103cfe"
uuid = "da1fdf0e-e0ff-5433-a45f-9bb5ff651cb1"
version = "0.4.6"

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

[[deps.NamedArrays]]
deps = ["Combinatorics", "DataStructures", "DelimitedFiles", "InvertedIndices", "LinearAlgebra", "Random", "Requires", "SparseArrays", "Statistics"]
git-tree-sha1 = "6d42eca6c3a27dc79172d6d947ead136d88751bb"
uuid = "86f7a689-2022-50b4-a561-43c23ac3c673"
version = "0.10.0"

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

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

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
# ╠═54d48980-e50b-11ee-01ff-833f16130cde
# ╠═f67e2900-c720-44cb-8988-800f6b8e5389
# ╠═c20e8dd4-6199-40ba-a874-f5a0daadead9
# ╟─8544cf21-1943-4c78-824e-14f77358691f
# ╠═19cbc1c7-be09-4b6b-b620-4df8dd889f1a
# ╟─3e403ca3-b7f8-455d-90d5-640e8470960c
# ╟─1dcae8f7-287c-4d11-9a7c-cbec4480897f
# ╟─a1417f09-52e3-4228-8b1e-dca19a74079e
# ╠═ecd322ab-6041-4133-9f89-1f1fa7401e51
# ╟─744abff4-2541-47bc-880d-744e10cfcc00
# ╠═5141523d-9992-49d7-ab0f-00546460e907
# ╟─d4c6bf4a-5390-4197-b00f-0d7976719840
# ╟─0544e81c-4ed3-435d-b270-9b1c9f67da16
# ╠═8d490fd1-c479-4013-b350-fde8d0f5050d
# ╠═a73c6ba0-7d40-4891-8cfa-e035c0e92d98
# ╠═1691fab6-6979-4de0-afd4-65b59241d946
# ╟─47001e60-48f6-4981-81a9-9475f84278bb
# ╠═3e5a2ef4-e373-49b5-a8cc-1ddeebcad212
# ╟─18d763d4-e133-42d1-9d62-7e00d814818a
# ╠═6d27358a-aa9d-4474-b7ce-16029bbb1db0
# ╟─b03ad02b-fc18-4a50-969e-9d44710c7f59
# ╟─61289494-5f42-46a1-913a-23a5a20e48cd
# ╠═fdb4ad62-e292-499b-b0da-426fcea49509
# ╟─e763dacd-aea5-45e0-a90a-8818ee0e64dc
# ╠═76080767-69e3-4aa4-af73-894b8d12c30e
# ╟─f773a1d1-d284-4464-9d49-941ff8041c7c
# ╠═40b40d75-2497-439c-a4c1-2a66d7eba5bf
# ╠═f032ae63-7a12-4d24-ab39-8088258e34e1
# ╠═9ca2b221-ece1-4c13-8a4a-c0e2e2fdbce5
# ╠═35e67b17-54f7-4274-99ea-d7c295687595
# ╠═8fc45d95-a1f6-4ccc-bad3-2490048b136f
# ╠═537b7fdf-4f29-46eb-8ce6-ac11b1965458
# ╟─e24ae6e4-9c41-49ae-95eb-fabe8d68fe6d
# ╠═da302a35-3825-4bbe-ba18-8e9b4e96d0e4
# ╠═d8ed4229-ce86-4f11-8077-4e2ec0135007
# ╠═2227f0d8-e56a-4c4f-a6a5-305cb4666f37
# ╠═5c30ee0e-154e-4f42-9ca8-af92420db30e
# ╠═06805e83-8bb2-4355-8077-c97413ba07d7
# ╠═46393867-3f27-469f-85c3-591c15a986ca
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
