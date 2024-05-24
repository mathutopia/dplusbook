### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 3f847b82-2175-498a-9ef7-f85a50432733
begin
using PlutoUI, Distances,Clustering, CSV, DataFrames, Distances, DataFramesMeta,StatsBase
end

# ╔═╡ d716ead9-6987-4d6c-a83b-93ffc70f10ea
PlutoUI.TableOfContents(title = "目录", indent = true, depth = 4, aside = true)

# ╔═╡ 7d874820-7e3f-11ec-1087-dd819d253f23
md"""

# 距离计算
做聚类分析以及各种数据挖掘， 距离都是很重要的一个概念， 这里总结一下距离有关的计算， 以及相关的julia包[**Distances.jl**](https://github.com/JuliaStats/Distances.jl)。 

"""

# ╔═╡ 4b3cdac5-e1dc-4f39-b6db-b3c6ef7ada4b
PlutoUI.TableOfContents(title = "目录", aside = true)

# ╔═╡ 45be63a0-5e3a-404b-835e-f8dfd3d43a8e
md"""
## 距离函数
对一个距离函数`d(.,.)`来说， 通常要求其满足一定的性质：
1. 非负性：$d(x,y)\geq 0$
2. 同一性：$d(x,y)=0 当且仅当x=y$;
3. 对称性：$d(x,y) = d(y,x)$; 
4. 直递性：$d(x,y)\leq d(x,z)+d(z,y)$.

直递性通常也称为三角不等式。 上述的性质是在数学上对距离函数的要求。 不过， 在Distances.jl包中， 通常的距离可以不满足上述性质。 
"""

# ╔═╡ 319acc7d-b5ac-421a-b3ea-98d6cd3701de
md"""
## 距离类型与函数
每个距离对应一个距离类型， 有一个相应的方便调用的函数。 下表列出了距离的类型名、相应函数及对应的距离计算数学表达式。 当然，这里的数学表达式只是说明距离是如何被计算的，并不意味着系统是这么实现的。事实上， 包中实现的距离计算效率要比这里的函数实现高。下面表格中的x,y应该被理解为两个相同长度的数值向量。

| type name            |  convenient syntax                | math definition     |
| -------------------- | --------------------------------- | --------------------|
|  Euclidean           |  `euclidean(x, y)`                | `sqrt(sum((x - y) .^ 2))` |
|  SqEuclidean         |  `sqeuclidean(x, y)`              | `sum((x - y).^2)` |
|  PeriodicEuclidean   |  `peuclidean(x, y, w)`            | `sqrt(sum(min(mod(abs(x - y), w), w - mod(abs(x - y), w)).^2))`  |
|  Cityblock           |  `cityblock(x, y)`                | `sum(abs(x - y))` |
|  TotalVariation      |  `totalvariation(x, y)`           | `sum(abs(x - y)) / 2` |
|  Chebyshev           |  `chebyshev(x, y)`                | `max(abs(x - y))` |
|  Minkowski           |  `minkowski(x, y, p)`             | `sum(abs(x - y).^p) ^ (1/p)` |
|  Hamming             |  `hamming(k, l)`                  | `sum(k .!= l)` |
|  RogersTanimoto      |  `rogerstanimoto(a, b)`           | `2(sum(a&!b) + sum(!a&b)) / (2(sum(a&!b) + sum(!a&b)) + sum(a&b) + sum(!a&!b))` |
|  Jaccard             |  `jaccard(x, y)`                  | `1 - sum(min(x, y)) / sum(max(x, y))` |
|  BrayCurtis          |  `braycurtis(x, y)`               | `sum(abs(x - y)) / sum(abs(x + y))`  |
|  CosineDist          |  `cosine_dist(x, y)`              | `1 - dot(x, y) / (norm(x) * norm(y))` |
|  CorrDist            |  `corr_dist(x, y)`                | `cosine_dist(x - mean(x), y - mean(y))` |
|  ChiSqDist           |  `chisq_dist(x, y)`               | `sum((x - y).^2 / (x + y))` |
|  KLDivergence        |  `kl_divergence(p, q)`            | `sum(p .* log(p ./ q))` |
|  GenKLDivergence     |  `gkl_divergence(x, y)`           | `sum(p .* log(p ./ q) - p + q)` |
|  RenyiDivergence     |  `renyi_divergence(p, q, k)`      | `log(sum( p .* (p ./ q) .^ (k - 1))) / (k - 1)` |
|  JSDivergence        |  `js_divergence(p, q)`            | `KL(p, m) / 2 + KL(q, m) / 2 with m = (p + q) / 2` |
|  SpanNormDist        |  `spannorm_dist(x, y)`            | `max(x - y) - min(x - y)` |
|  BhattacharyyaDist   |  `bhattacharyya(x, y)`            | `-log(sum(sqrt(x .* y) / sqrt(sum(x) * sum(y)))` |
|  HellingerDist       |  `hellinger(x, y)`                | `sqrt(1 - sum(sqrt(x .* y) / sqrt(sum(x) * sum(y))))` |
|  Haversine           |  `haversine(x, y, r = 6_371_000)` | [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) |
|  SphericalAngle      |  `spherical_angle(x, y)`          | [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula) |
|  Mahalanobis         |  `mahalanobis(x, y, Q)`           | `sqrt((x - y)' * Q * (x - y))` |
|  SqMahalanobis       |  `sqmahalanobis(x, y, Q)`         | `(x - y)' * Q * (x - y)` |
|  MeanAbsDeviation    |  `meanad(x, y)`                   | `mean(abs.(x - y))` |
|  MeanSqDeviation     |  `msd(x, y)`                      | `mean(abs2.(x - y))` |
|  RMSDeviation        |  `rmsd(x, y)`                     | `sqrt(msd(x, y))` |
|  NormRMSDeviation    |  `nrmsd(x, y)`                    | `rmsd(x, y) / (maximum(x) - minimum(x))` |
|  WeightedEuclidean   |  `weuclidean(x, y, w)`            | `sqrt(sum((x - y).^2 .* w))`  |
|  WeightedSqEuclidean |  `wsqeuclidean(x, y, w)`          | `sum((x - y).^2 .* w)`  |
|  WeightedCityblock   |  `wcityblock(x, y, w)`            | `sum(abs(x - y) .* w)`  |
|  WeightedMinkowski   |  `wminkowski(x, y, w, p)`         | `sum(abs(x - y).^p .* w) ^ (1/p)` |
|  WeightedHamming     |  `whamming(x, y, w)`              | `sum((x .!= y) .* w)`  |
|  Bregman             |  `bregman(F, ∇, x, y; inner=dot)` | `F(x) - F(y) - inner(∇(y), x - y)` |
"""

# ╔═╡ 41eb25f8-8a10-4f78-9373-dd79f95c87f2
md"""
## 计算方式
"""

# ╔═╡ fcf4a764-fb69-4a75-b59a-b1d0f646adf2
md"""
## 距离计算

在distances.jl包中， 距离的计算有几种形式：
```julia
r = evaluate(dist, x, y)
r = dist(x, y)
```
上面的代码中， **x， y是等长的向量**， 的dist是一种距离的实例，比如欧式聚类的类型为 Euclidean， 那么 Euclidean（）就可以构造一个欧式距离的实例，用于计算欧式距离。

如果要对具有相同size的**矩阵按列计算距离**， 需要使用 colwise函数。
```julia
r = colwise(dist, X, Y)
```
上面的r是一个向量， 第i个元素是X的第i列和y的第i列计算距离的结果。

如果两个矩阵的**列数不同**， 这时候可能要计算的是**配对距离**。使用pariwise函数。
```julia
R = pairwise(dist, X, Y, dims=2)
```
上面函数返回结果R为矩阵， R[i,j] 是 X[:,i] 和 Y[:,j]之间的距离。
"""

# ╔═╡ d79fd59e-ef0b-4b12-b4cf-6526020b8167
md"""
## 典型距离计算
下面几个距离是常见的

| type name            |  convenient syntax                | math definition     |
| -------------------- | --------------------------------- | --------------------|
|  Euclidean           |  `euclidean(x, y)`                | `sqrt(sum((x - y) .^ 2))` |
|  SqEuclidean         |  `sqeuclidean(x, y)`              | `sum((x - y).^2)` |
|  Cityblock           |  `cityblock(x, y)`                | `sum(abs(x - y))` |
|  TotalVariation      |  `totalvariation(x, y)`           | `sum(abs(x - y)) / 2` |
|  Chebyshev           |  `chebyshev(x, y)`                | `max(abs(x - y))` |
|  Minkowski           |  `minkowski(x, y, p)`             | `sum(abs(x - y).^p) ^ (1/p)` |
|  Jaccard             |  `jaccard(x, y)`                  | `1 - sum(min(x, y)) / sum(max(x, y))` |
|  CosineDist          |  `cosine_dist(x, y)`              | `1 - dot(x, y)` / (norm(x) * norm(y))` |
|  CorrDist            |  `corr_dist(x, y)`                | `cosine_dist(x - mean(x), y - mean(y))` |
|  ChiSqDist           |  `chisq_dist(x, y)`               | `sum((x - y).^2 / (x + y))` |
|  KLDivergence        |  `kl_divergence(p, q)`            | `sum(p .* log(p ./ q))` |



"""

# ╔═╡ 21a3c9cb-1744-41a0-baaa-38beb0becec0
path = joinpath(@__DIR__, "..", "..")

# ╔═╡ 24666eab-ac52-4bb2-816a-d204619bfe16
readdir(path)

# ╔═╡ 05665ec6-2f44-49ec-8df9-d3af3363e180
begin
tip(text) = Markdown.MD(Markdown.Admonition("tip", "🍡 建 议", [text])) # 绿色
hint(text) = Markdown.MD(Markdown.Admonition("hint", "💡 提 示", [text]))
attention(text) = Markdown.MD(Markdown.Admonition("warning", "⚡ 注 意", [text])) # 黄色
danger(text) = Markdown.MD(Markdown.Admonition("danger", "💣 危 险", [text])) # 红色
note(text) = Markdown.MD(Markdown.Admonition("hint", "📘 笔 记", [text])) # 蓝色
end;

# ╔═╡ c11d30f4-b739-428a-948a-039c128716f4
md"""
## 算例
下面以西瓜书-《机器学习》的西瓜数据集4.0为例， 演示距离的计算。 下面的数据中， 第一列表示西瓜的密度， 第二列表示西瓜的含糖率。
"""

# ╔═╡ a1431c8e-22af-4b6a-b924-fee19224b35a
xig4 = [0.697 0.460
0.403 0.237
0.245 0.057
0.593 0.042
0.748 0.232
0.751 0.489
0.774 0.376
0.481 0.149
0.343 0.099
0.719 0.103
0.714 0.346
0.532 0.472
0.634 0.264
0.437 0.211
0.639 0.161
0.359 0.188
0.483 0.312
0.473 0.376
0.608 0.318
0.666 0.091
0.657 0.198
0.339 0.241
0.478 0.437
0.725 0.445
0.556 0.215
0.243 0.267
0.360 0.370
0.282 0.257
0.525 0.369
0.446 0.459]

# ╔═╡ d85a855d-ac48-4e74-8b91-13be6df11d3b
md"""
比如， 下面的代码计算第一个样本和第二个样本的欧式距离。
"""

# ╔═╡ df70271b-3b62-4b1f-ab46-aaad23b4d431
euclidean(xig4[1,:], xig4[2,:])

# ╔═╡ e679f86b-42d0-41ee-9a33-2cd09bcdfb9a
md"""
更常见的距离计算方式是： 计算样本两两之间的某种距离， 这可以通过`pairwise`函数实现。其基本用法是：
```julia
pairwise(metric::PreMetric, a::AbstractMatrix, b::AbstractMatrix=a; dims)
```
通过指定一种距离metric， 计算矩阵a和b中，第dims个维度的配对距离。dims=1表示按行计算， dims=2表示按列计算。

下面的代码计算每两个西瓜之间的欧式距离。
"""

# ╔═╡ 81799b81-43f6-44a3-88ef-415f068d350c
pairwise(euclidean, xig4,dims=1)

# ╔═╡ 0a1a6b51-9f7d-479c-8d91-4999d5b15d3d
train = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 934185c2-7e18-48de-80b2-28ee749550b5
data = @chain train begin
@transform :autoage = 2023 .- :auto_year # 车辆年限在原始数据中不存在，需要计算出来
@select :age :premium = :policy_annual_premium :claim = :vehicle_claim :autoage :fraud

end

# ╔═╡ 55450379-d648-423a-8d08-048fbbbe6f04
X = Matrix(data[:, 1:4])' 

# ╔═╡ 03d405ef-9f3b-44ed-ab90-5b2b365cd423
md"""
下面的代码演示计算第1、2号样本的欧式距离的计算。
"""

# ╔═╡ 89946952-fb31-47c3-8915-3408d49d9eb3
euclidean(data[1,:], data[2,:])

# ╔═╡ 5e026b39-65f3-4f3b-a8b1-2b2779ca5d5f
md"""
如果想要一次性多计算几个样本， 需要首先将样本的特征表示为矩阵形式。这可以通过将样本对应的数据框放入矩阵类型（Matrix）的构造函数去构造。 此外， 计算距离时，通常将矩阵的列视为样本。 因此， 转换后的特征矩阵，需要做一个转置操作。

下面计算1~10号样本与11~20号样本的欧式距离。
"""

# ╔═╡ 94e6f2b7-7745-491a-9e78-31155fc87e0a
colwise(euclidean, Matrix(data[1:10,:])',Matrix(data[11:20,:])')

# ╔═╡ be29c6d4-8d37-439b-9111-9adcbda40582
md"""
注意区分距离和相似度。比如， 我们有余弦相似度， 余弦距离是`1-余弦相似度`。类似的， 我们有相关系数（用于表示线性相关性），其值通常在[-1,1]中，而相关性距离CorrDist， 则只能为正数，因此范围是[0,2]
""" |> attention

# ╔═╡ e53dd289-d4ee-44cf-89a7-2414e353fa92
md"""
## 信息量
由于信息量等相关概念也常用于计算变量之间的距离。下面就信息量的计算做简要介绍。

一个随机事件`A`包含的信息量I(A)应该跟这个事件出现的概率P(A)成反比， 即越是小概率事件，越是信息量大。 此外， 两个独立的随机事件A\B同时发生的信息量I(AB)应该是两个事件信息量的和(I(A) + I(B))。 由于这些朴素的要求， 我们可以使用对数函数来量化信息量。 即：
```math
I(A) = log(\frac{1}{P(A)})
```
注意， 在Julia中， log函数用于计算以e为底的对数（自然对数）， 在计算机领域， 有时候， 我们希望计算以2为底，或以10为底的对数， 这时候， 可以使用`log2`或`log10`两个函数。

一个随机变量X的信息量，被称为这个随机变量的“熵”(entropy)， 是这个随机变量所有可能出现的事件的信息量的和。
```math
H(X) = \sum P(x_i)log(\frac{1}{P(x_i)}) = - \sum P(x_i)log(P(x_i))
```

在Julia中， 熵的计算使用函数`entropy`
```julia
entropy(p, [b])
```
其中， p是一个概率分布， b是可选的计算对数时的底数， 如果省略则表示计算自然对数。
"""

# ╔═╡ 71e17edc-c97d-4dfe-b4c9-dda731854792
xp = [1/3, 1/3,1/3]

# ╔═╡ 1bbc3b4a-0e63-4ce7-9ecb-eea1ed7e2ffb
entropy(xp)

# ╔═╡ 6f59e3c8-7c45-4ca9-8703-3a2544e601b8
md"""
如果从信息量的视角来看熵， 一个随机变量的熵就是这个随机变量对应所有可能发生的随机事件的信息量的加权平均， 权重是随机事件对应的概率。 这时候， 可能会在一些场景中出现概率和信息量的计算用的是不同的值的情况。 例如， 我们认为数据应该服从某种分布`P(X)`, 但实际数据可能服从另一种分布`P(Y)`，这时候， 我们计算的熵就是两个随机变量的交叉熵`crossentropy`。交叉熵经常用于衡量理想（X）跟现实（Y）之间的差异（距离）。 在机器学习中， 我们常用交叉熵来度量我们的模型预测的结果Y（现实， 预测概率分布）与数据的真实概率X（理想）之间的差异性（也叫做交叉熵损失函数）。
```math
H(X,Y) = - \sum P(x_i)log(P(y_i))
```
"""

# ╔═╡ c915d365-4fe5-4dc2-9a37-36728f8fff25
yp = [1/2,1/4,1/4]

# ╔═╡ dd2de6a0-80d4-4446-8820-8cea8eafc073
crossentropy(xp, yp)

# ╔═╡ 7fc65334-79eb-4f48-a513-52faf2018e48
md"""
## 其他 
有时候，你要计算距离的数据可能在一个矩阵中，你希望对矩阵的每一列（或行）配对计算距离。或者你的数据在两个矩阵中， 你希望对应的列（行）分别计算距离。 甚至， 两个矩阵中的任意两列（行）计算一个距离。这时候， 用上面计算两个向量的距离的方法时， 你需要写循环了。 好在Distance.jl中已经实现的几个辅助函数， 可以避免自己去手写循环。 这些使用方法可以自己去[阅读文档](https://github.com/JuliaStats/Distances.jl)。下面我copy了一部分过来。
"""




# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
Clustering = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.14"
Clustering = "~0.15.7"
DataFrames = "~1.6.1"
DataFramesMeta = "~0.15.2"
Distances = "~0.10.11"
PlutoUI = "~0.7.58"
StatsBase = "~0.34.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "73f62f432a4885ad8f56437e0996030564e8616b"

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
# ╠═3f847b82-2175-498a-9ef7-f85a50432733
# ╠═d716ead9-6987-4d6c-a83b-93ffc70f10ea
# ╟─7d874820-7e3f-11ec-1087-dd819d253f23
# ╠═4b3cdac5-e1dc-4f39-b6db-b3c6ef7ada4b
# ╟─45be63a0-5e3a-404b-835e-f8dfd3d43a8e
# ╟─319acc7d-b5ac-421a-b3ea-98d6cd3701de
# ╟─41eb25f8-8a10-4f78-9373-dd79f95c87f2
# ╟─fcf4a764-fb69-4a75-b59a-b1d0f646adf2
# ╟─d79fd59e-ef0b-4b12-b4cf-6526020b8167
# ╠═21a3c9cb-1744-41a0-baaa-38beb0becec0
# ╠═24666eab-ac52-4bb2-816a-d204619bfe16
# ╟─05665ec6-2f44-49ec-8df9-d3af3363e180
# ╠═c11d30f4-b739-428a-948a-039c128716f4
# ╟─a1431c8e-22af-4b6a-b924-fee19224b35a
# ╟─d85a855d-ac48-4e74-8b91-13be6df11d3b
# ╠═df70271b-3b62-4b1f-ab46-aaad23b4d431
# ╟─e679f86b-42d0-41ee-9a33-2cd09bcdfb9a
# ╠═81799b81-43f6-44a3-88ef-415f068d350c
# ╠═0a1a6b51-9f7d-479c-8d91-4999d5b15d3d
# ╠═934185c2-7e18-48de-80b2-28ee749550b5
# ╠═55450379-d648-423a-8d08-048fbbbe6f04
# ╟─03d405ef-9f3b-44ed-ab90-5b2b365cd423
# ╠═89946952-fb31-47c3-8915-3408d49d9eb3
# ╟─5e026b39-65f3-4f3b-a8b1-2b2779ca5d5f
# ╠═94e6f2b7-7745-491a-9e78-31155fc87e0a
# ╟─be29c6d4-8d37-439b-9111-9adcbda40582
# ╟─e53dd289-d4ee-44cf-89a7-2414e353fa92
# ╠═71e17edc-c97d-4dfe-b4c9-dda731854792
# ╠═1bbc3b4a-0e63-4ce7-9ecb-eea1ed7e2ffb
# ╟─6f59e3c8-7c45-4ca9-8703-3a2544e601b8
# ╠═c915d365-4fe5-4dc2-9a37-36728f8fff25
# ╠═dd2de6a0-80d4-4446-8820-8cea8eafc073
# ╟─7fc65334-79eb-4f48-a513-52faf2018e48
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
