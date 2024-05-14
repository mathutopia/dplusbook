### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ d4fadc14-b0cd-4f98-9562-c57f03dffcff
using DataFrames, StatsBase, PlutoUI

# ╔═╡ aa8def3f-4265-40fb-8320-981e5222c5b9
md"""
## 准备数据集
下面的数据是从网上复制过来的， 先简单处理，将其转化为一个dataframe。
"""

# ╔═╡ 6b0d04ee-11c1-11ef-17f4-577b0e329a25
begin
wd = "编号,色泽,根蒂,敲声,纹理,脐部,触感,好瓜
1,青绿,蜷缩,浊响,清晰,凹陷,硬滑,是
2,乌黑,蜷缩,沉闷,清晰,凹陷,硬滑,是
3,乌黑,蜷缩,浊响,清晰,凹陷,硬滑,是
4,青绿,蜷缩,沉闷,清晰,凹陷,硬滑,是
5,浅白,蜷缩,浊响,清晰,凹陷,硬滑,是
6,青绿,稍蜷,浊响,清晰,稍凹,软粘,是
7,乌黑,稍蜷,浊响,稍糊,稍凹,软粘,是
8,乌黑,稍蜷,浊响,清晰,稍凹,硬滑,是
9,乌黑,稍蜷,沉闷,稍糊,稍凹,硬滑,否
10,青绿,硬挺,清脆,清晰,平坦,软粘,否
11,浅白,硬挺,清脆,模糊,平坦,硬滑,否
12,浅白,蜷缩,浊响,模糊,平坦,软粘,否
13,青绿,稍蜷,浊响,稍糊,凹陷,硬滑,否
14,浅白,稍蜷,沉闷,稍糊,凹陷,硬滑,否
15,乌黑,稍蜷,浊响,清晰,稍凹,软粘,否
16,浅白,蜷缩,浊响,模糊,平坦,硬滑,否
17,青绿,蜷缩,沉闷,稍糊,稍凹,硬滑,否"

items = split.(split(wd, "\n"),",")
xigua = [[row[i] for row in items[2:end] ] for i in 1:8]
xg2 = DataFrame(items[1] .=> xigua )
end;

# ╔═╡ b9b8a560-3faf-429a-a6d8-988c0bc90b4d
md"""
下面可以看到数据集已经处理成dataframe的格式。
"""

# ╔═╡ 884f7cad-632f-4c12-8265-f10faefb76fa
xg2

# ╔═╡ ad1f6012-adae-4a5c-be70-f2c171060f71
md"""
## 计算信息熵
假定一个离散随机变量$X$的分布为$p_1, p_2, \cdots, p_k$， 则其信息熵定义为：
$Ent(X) = -\sum_{t=1}^k p_t log_2(p_t)$。

StatsBase.jl包中定义了一个函数`entropy`, 可以用于计算一个分布的信息熵。其调用方法是：
```julia
entropy(p, [b])
```
其中p是概率分布， b是计算对数时的底数。 默认情况下，其底数是自然底数`e`。
"""

# ╔═╡ d3a83b1c-bd9e-4ce2-8776-778bf1fdcb80
count(row->row."好瓜"=="是", eachrow(xg2))

# ╔═╡ be39eea0-4abb-4745-873c-8d781a14fa7a
log

# ╔═╡ 84fffbd6-5541-485b-9f1e-b32f15d46289
count(row->row."好瓜"=="否", eachrow(xg2))

# ╔═╡ 116c38cb-ab8d-4f99-9eb6-109116b80fd0
-(log2(8/17)*8/17+log2(9/17)*9/17)

# ╔═╡ 58ed8dd5-36d4-4202-b6fe-f51addce6089
entropy([8,9]./17, 2)

# ╔═╡ 034c4d43-2c06-475f-a780-96a6fa7d4e4b
d=countmap(xg2[:,"好瓜"])

# ╔═╡ c24f5bf0-17fc-457c-8ead-ace7dc12d4a6
values(d)

# ╔═╡ b7453971-5c05-453f-8a7b-291e33b8e2f9
values(d)./sum(values(d))

# ╔═╡ 94ac0935-730b-4ef6-bebd-9c71436c45dc
md"""
## 写成一个函数
写一个函数用于计算一个dataframe的信息熵。 假定最后一列就是目标属性。
"""

# ╔═╡ b093702d-0904-45c6-bded-cbb70c37964a
function Ent(df)
	d = countmap(df[:, end])
	entropy(values(d) ./ sum(values(d)), 2)
end

# ╔═╡ 26a7c2d4-d9e4-4158-b39d-fe85fd22fbc5
Ent(xg2)

# ╔═╡ 05b8d255-132b-4b9f-b3ba-1faf57663c86
xg2[xg2.色泽 .== "青绿",:]

# ╔═╡ 5ffd6f7c-1082-44aa-8537-76f9cf930425
Ent(xg2[xg2.色泽 .== "青绿",:])

# ╔═╡ 4ba584bf-b176-4c48-af62-b3c0c6a582a9
Ent(xg2[xg2.色泽 .== "乌黑",:])

# ╔═╡ 2d6a58ce-e91d-4577-af94-0205908a3c5e
Ent(xg2[xg2.色泽 .== "浅白",:])

# ╔═╡ fe8173cb-a509-4aff-86ef-595dd6b80121
md"""
## 信息增益
下面写一个用于计算信息增益的函数。`Gain`
这个函数的原型定义如下：
```julia
Grain(D, f) -> float
```
这个函数输入一个数据集（dataframe）和这个数据集中的一个字段名。计算以该字段划分数据集可以获得的信息增益。
"""

# ╔═╡ 2e8fc21d-efe3-4402-9cdf-a87b68ea80ba
function Grain(D, f)
	# 计算特征f的每一个取值分别有多少样本
	fn = countmap(D[:, f])
	es = [Ent(D[D[:, f] .== v, : ]) for v in keys(fn)]
	Ent(D) - sum(values(fn) ./ sum(values(fn)) .* es )
end

# ╔═╡ 663df657-bf5f-4399-aa0b-5dd0bbf422e8
Grain(xg2, :色泽)

# ╔═╡ 0282da08-ca35-408e-97dc-d83d344667da
Grain(xg2, :色泽), Grain(xg2, :根蒂), Grain(xg2, :敲声)

# ╔═╡ 9ab93744-3420-4a49-a927-cc26a9b54da4
md"""
## 计算固有值
某个属性的固有值本质上是将该属性视为随机变量对应的信息熵。所以可以简单定义一个函数用于计算一个属性的固有值。
"""

# ╔═╡ b8bcb6da-a02b-40e3-8c4f-72a9cd55170e
function SplitE(D, f)
	# 计算该属性每一个取值及其对应的样本数量
	fn = countmap(D[:, f])
	entropy(values(fn)./sum(values(fn)), 2)
end

# ╔═╡ 489dc08c-ec0a-4181-95c1-d9ec8be909cb
begin
wt = "outlook temperature humidity wind playball
sunny hot high weak no
sunny hot high strong no
overcast hot high weak yes
rain mild high weak yes
rain cool normal weak yes
rain cool normal strong no
overcast cool normal strong yes
sunny mild high weak no
sunny cool normal weak yes
rain mild normal weak yes 
sunny mild normal strong yes
overcast mild high strong yes
overcast hot normal weak yes
rain mild high strong no"
tq = split.(split(wt, "\n"), " ")
wt2 = [[row[i] for row in tq[2:end] ] for i in 1:length(tq[1])]
weather = DataFrame(tq[1] .=> wt2)
end;


# ╔═╡ b39df657-7db4-4677-a804-2969f991a0d7
md"""
## 计算信息增益率
"""

# ╔═╡ 056c8c3e-89db-4ac4-9cc9-527369bb818f
md"""
考虑weather数据集, 求该数据集关于outlook属性的信息增益率。
"""

# ╔═╡ c9c70a49-63ad-4341-a8a0-b8ce47d8f76b
weather

# ╔═╡ 7fef1c00-e596-4533-9db5-4328e252137b
md"""
信息增益率就是信息增益除以属性的固有值，定义一个简单函数。
"""

# ╔═╡ 28273569-6338-43b9-bd03-e3fe8cb745a2
GainRatio(D, f) = Grain(D, f)/SplitE(D, f)

# ╔═╡ 9d2427a1-5be1-49aa-9966-64eca24e5088
Ent(weather)

# ╔═╡ 0934e387-2970-44e9-8a98-16551e119634
Grain(weather, :outlook), Grain(weather, :temperature), Grain(weather, :humidity), Grain(weather, :wind)

# ╔═╡ b5d2feb7-3761-4e9a-8b90-f8b6a1f65089
Grain(weather, :outlook) / SplitE(weather, :outlook)

# ╔═╡ 3e3ff1a8-59af-42ed-8d7a-fe2101a6d5bc
SplitE(weather, :outlook)

# ╔═╡ 8e859609-adb4-41ba-8271-6e063276fddd
GainRatio(weather, :outlook), GainRatio(weather, :temperature), GainRatio(weather, :humidity), GainRatio(weather, :wind)

# ╔═╡ 1f265171-33ff-497e-8650-4ce5e54e8d83
md"""
## 减枝问题
"""

# ╔═╡ 16466e76-03f1-4621-9145-8374373076c9
trainid = [1,2,3,6,7,10,14,15,16,17]

# ╔═╡ 3f60b98c-6504-479f-a0e4-72815a9852d0
testid = [4,5,8,9,11,12,13]

# ╔═╡ 5e0d8ade-ae92-432b-a4c3-b57810ad62f8
md"""
## 节点1要划分吗？
结点1：若不划分，则将其标记为叶结点，类别标记为训练样例中最多的类别(好瓜)。
"""

# ╔═╡ 1f75aa51-584c-48c3-a20f-764172296407
md"""
在预测为好瓜的情况下， 测试集中，【4，5，8】是对的。 验证精度为 3/7 = $(round(3/7*100, digits=1))%。
"""

# ╔═╡ 2bed2ba6-378d-4a72-ae54-8a79b686ad04
xg2[testid,:]

# ╔═╡ 50b21d64-199f-4668-9fff-c57192ac716c
md"""
如果划分， 脐部凹陷训练集中有3个好瓜， 因而脐部凹陷预测为好瓜。
"""

# ╔═╡ a274fe36-8c3c-4506-b0b0-ea95520699bb
node21 = subset(xg2[trainid,:], :脐部 => x->x.=="凹陷")

# ╔═╡ 53e0d9cb-e46d-462d-b33f-4bae4a299fc3
md"""
这样应用到验证集上， 有一个错误。
"""

# ╔═╡ 83987c59-b3a4-4784-b35f-9605bb7b38c4
node22 = subset(xg2[testid,:], :脐部 => x->x.=="凹陷")

# ╔═╡ 3fc9e303-c5a8-4db7-8fb1-1c39033213a2
md"""
如果划分， 脐部稍凹训练集是对半开的， 随机预测为好瓜。 
"""

# ╔═╡ 526a9f54-0cf9-4416-9e61-c3e5b01370c9
node31 = subset(xg2[trainid,:], :脐部 => x->x.=="稍凹")

# ╔═╡ 619d050d-5a5a-4d84-b211-bf856cb4110a
md"""
在脐部稍凹预测为好瓜的情况下， 验证集有一个错。
"""

# ╔═╡ 666481a7-5f9d-40d9-bd6c-c5c8cb028212
node32 = subset(xg2[testid,:], :脐部 => x->x.=="稍凹")

# ╔═╡ edeb8637-78e7-4856-9959-b009d5711be4
md"""
如果划分， 脐部平坦预测为坏瓜。
"""

# ╔═╡ 47cb9933-6841-457c-ad02-638977331051
node41 = subset(xg2[trainid,:], :脐部 => x->x.=="平坦")

# ╔═╡ 15d47c05-17c6-4819-98ad-6cae90504b2e
md"""
脐部平坦预测为坏瓜运用到验证集上， 没有错误。
"""

# ╔═╡ 3ce9f09f-7648-491a-b107-ff79b6dbc27e
node42 = subset(xg2[testid,:], :脐部 => x->x.=="平坦")

# ╔═╡ 894d5e4e-85b7-4c19-bbf6-c7aa79c43581
md"""
这样， 上述预测的精度变为： 5/7= $(round(5/7*100, digits=1))%
"""

# ╔═╡ 4e20044f-8837-4f90-b638-03c2e09f7ef4
md"""
预测精度上升， 应该划分
"""

# ╔═╡ bbe04ba7-36c8-47af-95a6-d7d9a4becee1
md"""
## 节点2要划分吗？
节点2是在节点1划分的基础上划分的,满足条件的验证集只有$(nrow(node22))个样本。 如果不划分， 其精度为：2/3 = 66.7%。 如果划分， 色泽== "青绿" 有一个错， :色泽.== "浅白"有一个错。 验证精度只有 1/3 = 33.33%。 所以不应该再划分。
"""

# ╔═╡ 1c0b6ed5-a919-4d0f-9882-45eed6e4b0e3
node22

# ╔═╡ 33c30264-000f-46b8-996e-1a3075de2f44
subset(node21, :色泽=> x-> x .== "青绿")

# ╔═╡ 6d02d24a-b943-43a8-873f-9ecc414b66e8
subset(node22, :色泽=> x-> x .== "青绿")

# ╔═╡ 9eed3182-484b-4975-b472-e976c338f151
subset(node21, :色泽=> x-> x .== "乌黑")

# ╔═╡ d8c55831-a26b-4a62-abb7-26a8d98a28f8
subset(node22, :色泽=> x-> x .== "乌黑")

# ╔═╡ f9dbc18f-7642-462d-a3ee-04c75b58af62
subset(node21, :色泽=> x-> x .== "浅白")

# ╔═╡ 6406860e-0664-4841-b52b-28c84bc170f2
subset(node22, :色泽=> x-> x .== "浅白")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
DataFrames = "~1.6.1"
PlutoUI = "~0.7.59"
StatsBase = "~0.34.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "47af7cb9938b6d0be75e84740d785c678fcea08f"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"
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

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

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
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

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
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

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
git-tree-sha1 = "363c4e82b66be7b9f7c7c7da7478fdae07de44b9"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.2"

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
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

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
# ╠═d4fadc14-b0cd-4f98-9562-c57f03dffcff
# ╟─aa8def3f-4265-40fb-8320-981e5222c5b9
# ╠═6b0d04ee-11c1-11ef-17f4-577b0e329a25
# ╟─b9b8a560-3faf-429a-a6d8-988c0bc90b4d
# ╠═884f7cad-632f-4c12-8265-f10faefb76fa
# ╟─ad1f6012-adae-4a5c-be70-f2c171060f71
# ╠═d3a83b1c-bd9e-4ce2-8776-778bf1fdcb80
# ╠═be39eea0-4abb-4745-873c-8d781a14fa7a
# ╠═84fffbd6-5541-485b-9f1e-b32f15d46289
# ╠═116c38cb-ab8d-4f99-9eb6-109116b80fd0
# ╠═58ed8dd5-36d4-4202-b6fe-f51addce6089
# ╠═034c4d43-2c06-475f-a780-96a6fa7d4e4b
# ╠═c24f5bf0-17fc-457c-8ead-ace7dc12d4a6
# ╠═b7453971-5c05-453f-8a7b-291e33b8e2f9
# ╟─94ac0935-730b-4ef6-bebd-9c71436c45dc
# ╠═b093702d-0904-45c6-bded-cbb70c37964a
# ╠═26a7c2d4-d9e4-4158-b39d-fe85fd22fbc5
# ╠═05b8d255-132b-4b9f-b3ba-1faf57663c86
# ╠═5ffd6f7c-1082-44aa-8537-76f9cf930425
# ╠═4ba584bf-b176-4c48-af62-b3c0c6a582a9
# ╠═2d6a58ce-e91d-4577-af94-0205908a3c5e
# ╟─fe8173cb-a509-4aff-86ef-595dd6b80121
# ╠═2e8fc21d-efe3-4402-9cdf-a87b68ea80ba
# ╠═663df657-bf5f-4399-aa0b-5dd0bbf422e8
# ╠═0282da08-ca35-408e-97dc-d83d344667da
# ╟─9ab93744-3420-4a49-a927-cc26a9b54da4
# ╠═b8bcb6da-a02b-40e3-8c4f-72a9cd55170e
# ╟─489dc08c-ec0a-4181-95c1-d9ec8be909cb
# ╟─b39df657-7db4-4677-a804-2969f991a0d7
# ╟─056c8c3e-89db-4ac4-9cc9-527369bb818f
# ╠═c9c70a49-63ad-4341-a8a0-b8ce47d8f76b
# ╟─7fef1c00-e596-4533-9db5-4328e252137b
# ╠═28273569-6338-43b9-bd03-e3fe8cb745a2
# ╠═9d2427a1-5be1-49aa-9966-64eca24e5088
# ╠═0934e387-2970-44e9-8a98-16551e119634
# ╠═b5d2feb7-3761-4e9a-8b90-f8b6a1f65089
# ╠═3e3ff1a8-59af-42ed-8d7a-fe2101a6d5bc
# ╠═8e859609-adb4-41ba-8271-6e063276fddd
# ╠═1f265171-33ff-497e-8650-4ce5e54e8d83
# ╠═16466e76-03f1-4621-9145-8374373076c9
# ╠═3f60b98c-6504-479f-a0e4-72815a9852d0
# ╟─5e0d8ade-ae92-432b-a4c3-b57810ad62f8
# ╟─1f75aa51-584c-48c3-a20f-764172296407
# ╠═2bed2ba6-378d-4a72-ae54-8a79b686ad04
# ╠═50b21d64-199f-4668-9fff-c57192ac716c
# ╠═a274fe36-8c3c-4506-b0b0-ea95520699bb
# ╟─53e0d9cb-e46d-462d-b33f-4bae4a299fc3
# ╠═83987c59-b3a4-4784-b35f-9605bb7b38c4
# ╟─3fc9e303-c5a8-4db7-8fb1-1c39033213a2
# ╠═526a9f54-0cf9-4416-9e61-c3e5b01370c9
# ╟─619d050d-5a5a-4d84-b211-bf856cb4110a
# ╠═666481a7-5f9d-40d9-bd6c-c5c8cb028212
# ╠═edeb8637-78e7-4856-9959-b009d5711be4
# ╠═47cb9933-6841-457c-ad02-638977331051
# ╟─15d47c05-17c6-4819-98ad-6cae90504b2e
# ╠═3ce9f09f-7648-491a-b107-ff79b6dbc27e
# ╟─894d5e4e-85b7-4c19-bbf6-c7aa79c43581
# ╟─4e20044f-8837-4f90-b638-03c2e09f7ef4
# ╟─bbe04ba7-36c8-47af-95a6-d7d9a4becee1
# ╠═1c0b6ed5-a919-4d0f-9882-45eed6e4b0e3
# ╠═33c30264-000f-46b8-996e-1a3075de2f44
# ╠═6d02d24a-b943-43a8-873f-9ecc414b66e8
# ╠═9eed3182-484b-4975-b472-e976c338f151
# ╠═d8c55831-a26b-4a62-abb7-26a8d98a28f8
# ╠═f9dbc18f-7642-462d-a3ee-04c75b58af62
# ╠═6406860e-0664-4841-b52b-28c84bc170f2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
