### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 2bd50632-8cd0-11ec-1f8b-fd812996df39
using CSV,DataFrames,PlutoUI

# ╔═╡ d81022aa-1c73-4a5c-b312-3b3979bbbd7d
PlutoUI.TableOfContents(title = "目录")

# ╔═╡ 5b83c3a5-4dc8-4d41-ba5e-7036f51925f0
begin
tip(text) = Markdown.MD(Markdown.Admonition("tip", "🍡 建 议", [text])) # 绿色
hint(text) = Markdown.MD(Markdown.Admonition("hint", "💡 提 示", [text]))
attention(text) = Markdown.MD(Markdown.Admonition("warning", "⚡ 注 意", [text])) # 黄色
danger(text) = Markdown.MD(Markdown.Admonition("danger", "💣 危 险", [text])) # 红色
note(text) = Markdown.MD(Markdown.Admonition("hint", "📘 笔 记", [text])) # 蓝色
end;

# ╔═╡ f8cbff52-6731-482f-86bf-cd8238154bb4
md"""
# 数据与数据集 
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
# 数据读取
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
train = CSV.read("data\\trainbx.csv", DataFrame)

# ╔═╡ c0d6a811-210f-4733-b4a6-429dc5899616
typeof(train)

# ╔═╡ 1d170b7c-1d7a-4afd-91f4-8f77808d8f82
md"""
# 数据写入CSV
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

# ╔═╡ 776268ac-d191-4228-9ff2-9e84e60afc68
md"""
# 作业
1. 请将比赛的提交示例数据下载， 读取， 然后对所有的样本随机生成一个预测值，并将结果保存，提交系统。
2. 新建一个cell， 定义一个变量score, 用于存储最终的成绩。 此外，需要将成绩截图， 额外保存提交。

$(hint(md"为了生成随机值， 你可能需要`rand`函数； 你需要写入、保存CSV"))

3. 阅读Julia中数据处理有名的一个包[DataFrame.jl](https://dataframes.juliadata.org/stable/)的文档，了解其跟Python中Pandas包的异同。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.10.9"
DataFrames = "~1.5.0"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "b9ecb36555f622903138d30d6fbb20c7ca52f1cd"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "SnoopPrecompile", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "c700cce799b51c9045473de751e9319bdd1c6e94"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.9"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "61fdd77467a5c3ad071ef8277ac6bd6af7dd4c04"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.6.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

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

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "82aec7a3dd64f4d9584659dc0b62ef7db2ef3e19"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.2.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

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
version = "2.28.2+0"

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

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "96f6db03ab535bdb901300f88335257b0018689d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
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
git-tree-sha1 = "77d3c4726515dca71f6d80fbb5e251088defe305"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.18"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

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
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

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
# ╠═2bd50632-8cd0-11ec-1f8b-fd812996df39
# ╠═d81022aa-1c73-4a5c-b312-3b3979bbbd7d
# ╟─5b83c3a5-4dc8-4d41-ba5e-7036f51925f0
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
# ╟─776268ac-d191-4228-9ff2-9e84e60afc68
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
