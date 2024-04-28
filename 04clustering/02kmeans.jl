### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ c587a5d0-d34c-11ed-39e2-cbac5becd555
using Clustering, CSV, DataFrames, Distances, DataFramesMeta,StatsBase,PlutoUI

# ╔═╡ fbed6daa-d1f0-4c44-b7c9-285f4c202f37
using MLBase

# ╔═╡ 1768d5f5-1bff-4577-b635-731e9e05382b
TableOfContents(title = "目录")

# ╔═╡ 4baf0251-866c-4883-93e2-871371e844e3
md"""
# Kmeans聚类分析
聚类分析的目标是把数据集D中的样本聚成k个簇， 使得每个样本指派给距离最近的簇， 每个样本与簇之间的距离和（总损失）最小。用数学公式表示是优化如下的目标函数（损失函数）：

$$\text{minimize} \ \sum_{i=1}^n \| \mathbf{x}_i - \boldsymbol{\mu}_{z_i} \|^2 \ \text{w.r.t.} \ (\boldsymbol{\mu}, z)$$
其中$\boldsymbol{\mu}_k$是第k个簇的中心，$Z_i$表示其是第$Z_i$个样本。

kmeans算法的思想很简单： 
```
1. 从D中任选k个样本作为初始簇中心
2. repeat
3. 	计算每个样本跟各中心的距离，并将其分配给最近的簇
4. 	更新簇中心
5. until 目标函数变化很小（tol）

```

"""

# ╔═╡ 4c4fa049-5cac-4768-bf8d-fc610a1484f0
md"""
## 1 kmeans聚类函数
kmeans的函数签名如下（[这里有官方文档](https://juliastats.org/Clustering.jl/stable/kmeans.html)）：
```
kmeans(X::AbstractMatrix{<:Real},               
       k::Integer;                              
       weights::Union{Nothing, AbstractVector{<:Real}}=nothing, 
       init::Union{Symbol, SeedingAlgorithm, AbstractVector{<:Integer}}             
       maxiter::Integer=_kmeans_default_maxiter, 
       tol::Real=_kmeans_default_tol,            
       display::Symbol=_kmeans_default_display,  
       distance::SemiMetric=SqEuclidean()) 
```
其中， 
- X是d×n的特征矩阵， d是特征的维度，n是样本的个数。
- k是类的个数。
以上两个参数是位置参数， 必须给定，后面的参数是关键字参数， 都有默认值。

- init:初始类中心， 可以是Symbol,用于指定随机选取中心的方法; 或者长度为k的向量， 用于指定k个中心对应X中的下标。
- weights: n维向量， 用于指定每个元素的权重。
- maxiter: 整数， 用于指定最大的迭代次数
- tol:: 目标值变化的容忍程度， 目标变化小于这个值， 则认为算法收敛了。
- display: Symbol: 计算过程展示的信息量， 可取如下值： 
		- :none: nothing is shown
		- :final: only shows a brief summary when the algorithm ends
		- :iter: shows the progress at each iteration
- distance: 计算点之间距离的函数， 默认是平方欧式距离， 表示节点位置差的平方和。
"""

# ╔═╡ 6407b2a8-450e-4c2b-b213-c635280d26e1
md"""
!!! warn "注意"
	- 上面的参数中，X是d×n的特征矩， 与数据挖掘的数据通常行为样本， 列为特征刚好相反， 需要对原始数据做一个转置变换

	- 距离对于聚类来说是一个重要参数， 如果想选择更多的距离计算方法， 可以参考Distances.jl包中的函数。 请参考[**这里**](https://juliapackages.com/p/distances)获取更多信息。
"""

# ╔═╡ c75bd0f0-f0e4-4191-b0c9-a2db71a4bfc5
md"""
## 2 计算案例
下面以竞赛数据为对象， 演示如何对样本做聚类分析。 由于kmeans聚类只能针对连续性特征， 假定我们想按照客户年龄、保费、车辆索赔、以及车辆年限去对所有样本做一个Kmeans聚类， 下面演示计算过程。
"""

# ╔═╡ b069a337-7d55-488a-9aef-0c8a3cb62e55
md"""
### 2.1 读取数据
"""

# ╔═╡ d7db3f96-1f16-4205-96f2-144f3216d24e
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 0dbfab26-2b99-4e48-84eb-26c2ab97bf56
md"""
### 2.2 构造特征
数挖的对象可能包含多个数据字段， 为了适配某种方法， 我们需要先构造出模型需要的字段。我们这里主要使用数值型特征。 下面选择几个相关特征演示kmeas函数的使用。主要选择的特征是：用户的年龄， 保费， 索赔额， 和车辆本身的“年龄”。
"""

# ╔═╡ 1709e0a6-0bc3-4e43-b87b-b35c7fe9935d
data1 = @chain train begin
@transform :autoage = 2023 .- :auto_year # 车辆年限在原始数据中不存在，需要计算出来
@select :age :premium = :policy_annual_premium :claim = :vehicle_claim :autoage :fraud

end

# ╔═╡ af6fa93b-1d33-4a47-8768-18bc927c760c
X = Matrix(data1[:, 1:4])' # 注意这里的转换为矩阵并转置

# ╔═╡ 3ec7eeea-df4f-494e-a03b-801b24ce2c00
md"""
!!! info "提示"
	1. 上面构造聚类的数据时， 用到了Matrix类型构造函数去构造矩阵。 

	2. 此外， 请注意构造的矩阵上面有一个**转置运算** ', 因为算法的要求是输入数据的行表示特征。
	
"""

# ╔═╡ cc81ee09-50be-4857-b1e1-0cf3ca1dc93e
md"""
### 2.3 结果计算
由于我们的样本主要是两类：欺诈和非欺诈。我们尝试对其聚类为2类。
"""

# ╔═╡ 75b2403c-35eb-454e-acb1-4af40f5c371c
c1 = kmeans(X, 2)

# ╔═╡ 79ad22b0-796e-4748-81c0-a12428009288
md"""
### 2.4 结果提取与分析
上面kmeans的结果保存在变量c1中。有几个重要的结果是需要关注的。
 - 中心(centers)
 - 簇结果计数（counts）
 - 样本分派的类别（assignments）

这些结果可以通过 **聚类结果.名字**的方式获取相应的字段。 其中计数和分派还可以counts、assignments两个函数在聚类结果上调用实现。
"""

# ╔═╡ 594e2e44-a957-4edd-938c-192a1dac7007
md"""
下面的结果说明， 聚类为两个簇后， 第一簇有 $((counts(c1)[1])) 个样本， 第二簇有 $((counts(c1)[2])) 个样本。
"""

# ╔═╡ eb940ff4-e3cd-402d-958b-dac4cb3403c5
counts(c1)

# ╔═╡ ce7e409c-b721-42d1-b271-016d91264046
md"""
下面的向量表示每个样本被分派到哪一个簇中。
"""

# ╔═╡ fa16216e-3008-4971-915a-8243e9275779
assignments(c1)

# ╔═╡ c79f66c7-b322-48cb-9acf-4aee80905728
md"""
下面给出的是每个簇的中心， 因为我们只使用了4个特征， 所以每个簇的中心是4维的向量。
"""

# ╔═╡ d5fc71d9-6332-4fbe-8c5c-eafa09a405bf
c1.centers

# ╔═╡ b37b94a9-1461-40ec-8353-c0e4f0f9b83d
data2 = hcat(data1, c1.assignments)

# ╔═╡ 87c7529c-fb1c-426b-b9fe-b6d4d06b663a
md"""
### 2.5 切换距离计算
在kmeans函数中， 默认的距离函数是平方欧式距离（distance::SemiMetric=SqEuclidean()）。如果想采用不同的距离函数， 可以指定不同的距离类型实例。 可以在[这里](https://juliapackages.com/p/distances)找到所有的距离类型（type）。 比如， 我们用城市块距离重新做聚类， 看一下效果是否会不一样。
"""

# ╔═╡ 96bdb845-4baf-49b8-aa85-b534434691f3
c2 = kmeans(X, 2, distance = Cityblock())

# ╔═╡ ea69910f-04a6-4497-a219-f558485dd624
data3 = hcat(data1,  c2.assignments)

# ╔═╡ f164abba-989b-4266-b739-f6079c3999ce
md"""
## 3 效果评价
聚类本身没有标签信息， 我们可以通过计算簇的一些统计特征去评价聚类的效果。下面的counts函数简单比较两种不同的聚类结果。

简单来说， counts函数统计两个聚类结果将同一个样本分别划分到不同的簇的数量。 即结果res[i,j]表示第一个聚类结果将样本划分到第i个簇，而第二个聚类结果将样本划分到第j个簇的数量。其基本使用方法是：

```julia
counts(a::ClusteringResult, b::ClusteringResult) -> Matrix{Int}
counts(a::ClusteringResult, b::AbstractVector{<:Integer}) -> Matrix{Int}
counts(a::AbstractVector{<:Integer}, b::ClusteringResult) -> Matrix{Int}
```

"""

# ╔═╡ 61df67e5-942b-48bb-93c8-a6917c65d47c
res = counts(c1, data1.fraud.+1) # 注意为什么要将fraud+1

# ╔═╡ 9226ba11-d465-47d5-ba8c-0db282478081
md"""
由于在我们的数据集中， 有一个标签信息。 要评价聚类效果的好坏， 我们可以结合这个标签信息。

其基本思想是： 将聚类的2个簇分别赋予不同的类别标签， 然后去比较聚类得到的标签信息和原始标签信息是否重合。 可以通过[MLBase.jl](https://mlbasejl.readthedocs.io/en/latest/perfeval.html)去计算一些指标。
"""

# ╔═╡ ea01216d-4997-4a7b-a86d-a19f9ae00762
md"""
### 3.1 簇编号转类别标签
为了计算方便， 我们需要明确不同的簇（1,2）应该被视为哪一个类别。即， 要给簇预测一个类别。 这可以通过将簇编号（1或2）转换为类别标签（0,1）实现。 这可以通过replace函数实现。 
"""

# ╔═╡ 3b050523-24bc-4043-864b-68d64540c84f
pred = replace(c1.assignments, 1 => 1, 2 => 0)

# ╔═╡ c6dc796a-ed8b-4591-b37c-f44802c7b34b
md"""
### 3.2 计算预测值与真实值的混淆矩阵。
计算预测效果的一些统计数据。 可以使用MLBase.jl包中的roc函数计算预测结果的一些统计数字。 roc函数的基本使用方法是：`roc(gt, pred)`， 其第一个参数是真实标签（ground truth），第二个参数是预测标签(predition)。 然后， 通过遍历真实标签和预测标签计算如下字段值：
```julia
immutable ROCNums{T<:Real}
    p::T    # positive in ground-truth
    n::T    # negative in ground-truth
    tp::T   # correct positive prediction
    tn::T   # correct negative prediction
    fp::T   # (incorrect) positive prediction when ground-truth is negative
    fn::T   # (incorrect) negative prediction when ground-truth is positive
end
```
其中， positive表示正例， negative表示负例。 默认情况下， 函数会将标签值大于0的样本视为正例。因此， 在我们的问题中， fraud==1是正例； fraud==0是负例。
"""

# ╔═╡ 9190077b-a778-48c7-9319-d7280efa9f2d
md"""
!!! warn "注意"
	如果要使用roc函数， 默认是二分类问题， 只要值大于0就当成正例， 否则就是负例。 
"""

# ╔═╡ ebe87c34-5a24-4068-9a05-f03f7a37ee98
r = MLBase.roc(train.fraud, pred)

# ╔═╡ 37e4c83e-5098-43e8-a31c-a549fd0a0103
MLBase.precision(r)

# ╔═╡ da207e7a-9b3b-4688-8509-632ca5215f11
MLBase.recall(r)

# ╔═╡ a13d4961-e0b0-420e-b55b-6856e2c6ab59
md"""
很明显，这个模型效果不理想。 是不是因为对簇编码的问题导致的呢？接下来， 调整一下簇编码， 看效果是否发生变化。
"""

# ╔═╡ 7a55a7d0-0f0a-4395-b664-0a4e91b956f8
pred2 = replace(c1.assignments, 1 => 1, 2 => 0)

# ╔═╡ abb5eec0-42cd-4961-b3f8-274c3c7bfe90
r2 = MLBase.roc(train.fraud, pred2)

# ╔═╡ b706e84e-0252-4e9c-b510-c042e4dba2e2
 MLBase.precision(r2)

# ╔═╡ ea661732-1d03-4ac1-be69-383730435d83
 MLBase.recall(r2)

# ╔═╡ eba70a4c-87b0-48a5-80cf-628db18f9a13
md"""
从上面的结果看， 我们将第一个聚类簇视为欺诈， 第二个簇视为非欺诈用户效果相对上一种要好一点， 尽管这个效果还是不理想。 但如果单纯只看查全率， 已经达到90%。
"""

# ╔═╡ 516f3508-c10b-46b2-9b73-287d9d9b97e2
md"""
假定我们关注precision和recall指标， 为了后面使用方便， 我们将其写成一个函数， 根据预测值和真实值，一次性返回我们要的结果。
"""

# ╔═╡ bc7e1902-ef6e-4d3f-8d2f-b2dc796da76c
md"""
### 3.3 效果计算函数
"""

# ╔═╡ 82672a8a-f881-43fe-afc5-9372819d4156
function pinggu(gt, pred)
 r =  MLBase.roc(gt, pred)
 return (pre =  MLBase.precision(r), rec =  MLBase.recall(r), f1 =  MLBase.f1score(r))
end

# ╔═╡ a44bcedf-52f9-4f61-911c-0d6f36b8d683
pinggu(train.fraud, pred2)

# ╔═╡ dfe10929-decc-4642-a773-3547b70fd7c3
pinggu(train.fraud, pred)

# ╔═╡ 53d036a6-32fa-4173-8ffb-8c6a70506971
md"""
接下来， 我们看一下， 上面切换不同的距离对效果有没有影响
"""

# ╔═╡ 18ed70ea-dd2b-4d19-9edd-8e723a7157e9
pred3 = replace(c2.assignments, 1 => 0, 2 => 1)

# ╔═╡ 61c5c9e9-2de6-463c-91ef-ae69faf40f02
pinggu(train.fraud, pred3)

# ╔═╡ 5563dd5b-fa39-482a-8542-c34468440e8e
scale(x) = (x .- minimum(x)) ./ (maximum(x) .- minimum(x))

# ╔═╡ e47c59f2-4051-4a52-b95b-829c9e33797e
Y = similar(X)

# ╔═╡ 723e5488-e3fe-4e88-8185-3e6a87ac33e5
tmp = map(scale, eachrow(X))

# ╔═╡ 4cd8bbf7-5413-41c4-a609-f17e974ae16e
for i in 1:size(X)[1]
  Y[i,:] .= scale(X[i,:])
end

# ╔═╡ e2ebb4c3-86da-4b75-b339-9805de3ac382
Y

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
Clustering = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
MLBase = "f0e99cf1-93fa-52ec-9ecc-5026115318e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.14"
Clustering = "~0.15.7"
DataFrames = "~1.6.1"
DataFramesMeta = "~0.15.2"
Distances = "~0.10.11"
MLBase = "~0.9.2"
PlutoUI = "~0.7.58"
StatsBase = "~0.34.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "49240691410f8f774adc3d4111bff3da0b521c7b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.Chain]]
git-tree-sha1 = "9ae9be75ad8ad9d26395bf625dea9beac6d519f1"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.6.0"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

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
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport", "TableMetadataTools"]
git-tree-sha1 = "f912a2126c99ff9783273efa38b0181bfbf9d322"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.15.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "97d79461925cdb635ee32116978fc735b9463a39"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.19"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

    [deps.Distances.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

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

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

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

[[deps.MLBase]]
deps = ["IterTools", "Random", "Reexport", "StatsBase"]
git-tree-sha1 = "ac79beff4257e6e80004d5aee25ffeee79d91263"
uuid = "f0e99cf1-93fa-52ec-9ecc-5026115318e0"
version = "0.9.2"

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
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded64ff6d4fdd1cb68dfcbb818c69e144a5b2e4c"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.16"

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

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

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

[[deps.TableMetadataTools]]
deps = ["DataAPI", "Dates", "TOML", "Tables", "Unitful"]
git-tree-sha1 = "c0405d3f8189bb9a9755e429c6ea2138fca7e31f"
uuid = "9ce81f87-eacc-4366-bf80-b621a3098ee2"
version = "0.1.0"

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
git-tree-sha1 = "71509f04d045ec714c4748c785a59045c3736349"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.7"
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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

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
# ╠═c587a5d0-d34c-11ed-39e2-cbac5becd555
# ╠═1768d5f5-1bff-4577-b635-731e9e05382b
# ╟─4baf0251-866c-4883-93e2-871371e844e3
# ╟─4c4fa049-5cac-4768-bf8d-fc610a1484f0
# ╟─6407b2a8-450e-4c2b-b213-c635280d26e1
# ╟─c75bd0f0-f0e4-4191-b0c9-a2db71a4bfc5
# ╟─b069a337-7d55-488a-9aef-0c8a3cb62e55
# ╠═d7db3f96-1f16-4205-96f2-144f3216d24e
# ╟─0dbfab26-2b99-4e48-84eb-26c2ab97bf56
# ╠═1709e0a6-0bc3-4e43-b87b-b35c7fe9935d
# ╠═af6fa93b-1d33-4a47-8768-18bc927c760c
# ╟─3ec7eeea-df4f-494e-a03b-801b24ce2c00
# ╟─cc81ee09-50be-4857-b1e1-0cf3ca1dc93e
# ╠═75b2403c-35eb-454e-acb1-4af40f5c371c
# ╟─79ad22b0-796e-4748-81c0-a12428009288
# ╟─594e2e44-a957-4edd-938c-192a1dac7007
# ╠═eb940ff4-e3cd-402d-958b-dac4cb3403c5
# ╟─ce7e409c-b721-42d1-b271-016d91264046
# ╠═fa16216e-3008-4971-915a-8243e9275779
# ╟─c79f66c7-b322-48cb-9acf-4aee80905728
# ╠═d5fc71d9-6332-4fbe-8c5c-eafa09a405bf
# ╠═b37b94a9-1461-40ec-8353-c0e4f0f9b83d
# ╟─87c7529c-fb1c-426b-b9fe-b6d4d06b663a
# ╠═96bdb845-4baf-49b8-aa85-b534434691f3
# ╠═ea69910f-04a6-4497-a219-f558485dd624
# ╟─f164abba-989b-4266-b739-f6079c3999ce
# ╠═61df67e5-942b-48bb-93c8-a6917c65d47c
# ╟─9226ba11-d465-47d5-ba8c-0db282478081
# ╟─ea01216d-4997-4a7b-a86d-a19f9ae00762
# ╠═3b050523-24bc-4043-864b-68d64540c84f
# ╟─c6dc796a-ed8b-4591-b37c-f44802c7b34b
# ╟─9190077b-a778-48c7-9319-d7280efa9f2d
# ╠═fbed6daa-d1f0-4c44-b7c9-285f4c202f37
# ╠═ebe87c34-5a24-4068-9a05-f03f7a37ee98
# ╠═37e4c83e-5098-43e8-a31c-a549fd0a0103
# ╠═da207e7a-9b3b-4688-8509-632ca5215f11
# ╟─a13d4961-e0b0-420e-b55b-6856e2c6ab59
# ╠═7a55a7d0-0f0a-4395-b664-0a4e91b956f8
# ╠═abb5eec0-42cd-4961-b3f8-274c3c7bfe90
# ╠═b706e84e-0252-4e9c-b510-c042e4dba2e2
# ╠═ea661732-1d03-4ac1-be69-383730435d83
# ╟─eba70a4c-87b0-48a5-80cf-628db18f9a13
# ╟─516f3508-c10b-46b2-9b73-287d9d9b97e2
# ╟─bc7e1902-ef6e-4d3f-8d2f-b2dc796da76c
# ╠═82672a8a-f881-43fe-afc5-9372819d4156
# ╠═a44bcedf-52f9-4f61-911c-0d6f36b8d683
# ╠═dfe10929-decc-4642-a773-3547b70fd7c3
# ╟─53d036a6-32fa-4173-8ffb-8c6a70506971
# ╠═18ed70ea-dd2b-4d19-9edd-8e723a7157e9
# ╠═61c5c9e9-2de6-463c-91ef-ae69faf40f02
# ╠═5563dd5b-fa39-482a-8542-c34468440e8e
# ╠═e47c59f2-4051-4a52-b95b-829c9e33797e
# ╠═723e5488-e3fe-4e88-8185-3e6a87ac33e5
# ╠═4cd8bbf7-5413-41c4-a609-f17e974ae16e
# ╠═e2ebb4c3-86da-4b75-b339-9805de3ac382
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
