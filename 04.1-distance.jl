### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 3f847b82-2175-498a-9ef7-f85a50432733
using PlutoUI, Distances

# ╔═╡ 4ccd867c-ddb9-4a13-a589-e5f1304ef7e7
using StatsBase

# ╔═╡ 7d874820-7e3f-11ec-1087-dd819d253f23
md"""
# 距离计算
做聚类分析以及各种数据挖掘， 距离都是很重要的一个概念， 这里总结一下距离有关的计算， 以及相关的julia包[**Distances.jl**](https://github.com/JuliaStats/Distances.jl)。 

"""

# ╔═╡ 4b3cdac5-e1dc-4f39-b6db-b3c6ef7ada4b
PlutoUI.TableOfContents(title = "目录", aside = true)

# ╔═╡ 41eb25f8-8a10-4f78-9373-dd79f95c87f2
md"""
## 计算方式
"""

# ╔═╡ 3012af0f-f52d-4212-a5a7-c8f97485ea5c
md"""
最常见的计算距离的方式是： 用某种距离函数， 去计算两个向量的距离。 假定`x,y`是两个需要计算距离的向量， 距离计算的基本方法是：
```julia
r = distfun(x,y)
```
其中， `distfun`表示某种距离计算函数，是Distances.jl提供的一种简便调用方式， 比如欧式距离函数是：`euclidean`。 因此， 可以这样计算两个向量的距离：
```julia
r = euclidean(x,y)
```

更通用的距离计算方式是：
```
r = evaluate(dist, x, y)
r = dist(x, y)
```
其中`dist`是某种距离类型的实例， 比如欧式距离对应的类型是`Euclidean.`, 欧式距离可计算如下：
```julia
r = evaluate(Euclidean(), x, y)
r = Euclidean()(x, y)
```



"""

# ╔═╡ 319acc7d-b5ac-421a-b3ea-98d6cd3701de
md"""
## 距离类型与函数
每个距离对应一个距离类型， 有一个相应的方便调用的函数。 下表列出了距离的类型名、相应函数及对应的距离计算数学表达式。 当然，这里的数学表达式只是说明距离是如何被计算的，并不意味着系统是这么实现的。事实上， 包中实现的距离计算效率要比这里的函数实现高。

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

# ╔═╡ a30a5e85-9862-4dc4-ba0f-323dc96a1ad5
x = 1:10; y = sin.(x)

# ╔═╡ 12df2775-2621-4d0e-9975-27b07c922f9d
corr_dist(x,y)

# ╔═╡ 95007a2f-27dd-414e-b802-f2193e09bb1c
1- cosine_dist(x .- mean(x), y .- mean(y))

# ╔═╡ 05665ec6-2f44-49ec-8df9-d3af3363e180
begin
tip(text) = Markdown.MD(Markdown.Admonition("tip", "🍡 建 议", [text])) # 绿色
hint(text) = Markdown.MD(Markdown.Admonition("hint", "💡 提 示", [text]))
attention(text) = Markdown.MD(Markdown.Admonition("warning", "⚡ 注 意", [text])) # 黄色
danger(text) = Markdown.MD(Markdown.Admonition("danger", "💣 危 险", [text])) # 红色
note(text) = Markdown.MD(Markdown.Admonition("hint", "📘 笔 记", [text])) # 蓝色
end;

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

# ╔═╡ d14c7917-bc4c-4b1a-8c49-435d21d6b4dc
md"""

### 计算匹配对象间的距离("column-wise")

假定有两个 `m-by-n` 矩阵 `X` 和 `Y`, 然后你可以一次性（批处理模式）计算`X` 和 `Y`所有的的对应列之间的距离如下

```julia
r = colwise(dist, X, Y)
```

The output `r` is a vector of length `n`. In particular, `r[i]` is the distance
between `X[:,i]` and `Y[:,i]`. The batch computation typically runs considerably
faster than calling `evaluate` column-by-column.

Note that either of `X` and `Y` can be just a single vector -- then the `colwise`
function computes the distance between this vector and each column of the other
argument.

### 配对距离

Let `X` and `Y` have `m` and `n` columns, respectively, and the same number of rows.
Then the `pairwise` function with the `dims=2` argument computes distances between
each pair of columns in `X` and `Y`:

```julia
R = pairwise(dist, X, Y, dims=2)
```

In the output, `R` is a matrix of size `(m, n)`, such that `R[i,j]` is the
distance between `X[:,i]` and `Y[:,j]`. Computing distances for all pairs using
`pairwise` function is often remarkably faster than evaluting for each pair
individually.

If you just want to just compute distances between all columns of a matrix `X`,
you can write

```julia
R = pairwise(dist, X, dims=2)
```

This statement will result in an `m-by-m` matrix, where `R[i,j]` is the distance
between `X[:,i]` and `X[:,j]`. `pairwise(dist, X)` is typically more efficient
than `pairwise(dist, X, X)`, as the former will take advantage of the symmetry
when `dist` is a semi-metric (including metric).

To compute pairwise distances for matrices with observations stored in rows use
the argument `dims=1`.

### 就地按列、配对距离计算

If the vector/matrix to store the results are pre-allocated, you may use the
storage (without creating a new array) using the following syntax
(`i` being either `1` or `2`):

```julia
colwise!(r, dist, X, Y)
pairwise!(R, dist, X, Y, dims=i)
pairwise!(R, dist, X, dims=i)
```

Please pay attention to the difference, the functions for inplace computation are
`colwise!` and `pairwise!` (instead of `colwise` and `pairwise`).


"""

# ╔═╡ f36c8fd9-b995-4634-a963-c31579a89a38
md"""
## 距离类型层次树

原始距离（仅定义非负） => 半距离（增加对称性） => 距离（增加三角不等式）。

The distances are organized into a type hierarchy.

At the top of this hierarchy is an abstract class **PreMetric**, which is defined to be a function `d` that satisfies

    d(x, x) == 0  for all x
    d(x, y) >= 0  for all x, y

**SemiMetric** is a abstract type that refines **PreMetric**. Formally, a *semi-metric* is a *pre-metric* that is also symmetric, as

    d(x, y) == d(y, x)  for all x, y

**Metric** is an abstract type that further refines **SemiMetric**. Formally, a *metric* is a *semi-metric* that also satisfies the triangle inequality, as

    d(x, z) <= d(x, y) + d(y, z)  for all x, y, z

该类型系统具有一定的现实意义。例如， 当计算一组向量之间的配对距离时， 可以只对其中的一半进行计算， 通过利用*semi-metrics*的对称性立即获得其余一半的值。 

请注意，“SemiMetric”和“Metric”类型并不完全遵循数学中的定义，因为它们不需要“距离”来区分点: 对这些类型， `x != y` 并不意味着 `d(x, y) != 0`， 因为这个属性不改变实际中的计算。 


### Precision for Euclidean and SqEuclidean

For efficiency (see the benchmarks below), `Euclidean` and
`SqEuclidean` make use of BLAS3 matrix-matrix multiplication to
calculate distances.  This corresponds to the following expansion:

```julia
(x-y)^2 == x^2 - 2xy + y^2
```

However, equality is not precise in the presence of roundoff error,
and particularly when `x` and `y` are nearby points this may not be
accurate.  Consequently, `Euclidean` and `SqEuclidean` allow you to
supply a relative tolerance to force recalculation:

```julia
julia> x = reshape([0.1, 0.3, -0.1], 3, 1);

julia> pairwise(Euclidean(), x, x)
1×1 Array{Float64,2}:
 7.45058e-9

julia> pairwise(Euclidean(1e-12), x, x)
1×1 Array{Float64,2}:
 0.0
```

## Benchmarks

The implementation has been carefully optimized based on benchmarks. The script in
`benchmark/benchmarks.jl` defines a benchmark suite for a variety of distances,
under column-wise and pairwise settings.

Here are benchmarks obtained running Julia 1.5 on a computer with a quad-core Intel
Core i5-2300K processor @ 3.2 GHz. Extended versions of the tables below can be
replicated using the script in `benchmark/print_table.jl`.

### Column-wise benchmark

Generically, column-wise distances are computed using a straightforward loop
implementation. For `[Sq]Mahalanobis`, however, specialized methods are
provided in *Distances.jl*, and the table below compares the performance
(measured in terms of average elapsed time of each iteration) of the generic
to the specialized implementation. The task in each iteration is to compute a
specific distance between corresponding columns in two `200-by-10000` matrices.

|  distance     | loop      |  colwise   |  gain       |
|---------------|-----------|------------|-------------|
| SqMahalanobis | 0.089470s |  0.014424s |  **6.2027** |
| Mahalanobis   | 0.090882s |  0.014096s |  **6.4475** |

### Pairwise benchmark

Generically, pairwise distances are computed using a straightforward loop
implementation. For distances of which a major part of the computation is a
quadratic form, however, the performance can be drastically improved by restructuring
the computation and delegating the core part to `GEMM` in *BLAS*. The table below
compares the performance (measured in terms of average elapsed time of each
iteration) of generic to the specialized implementations provided in *Distances.jl*.
The task in each iteration is to compute a specific distance in a pairwise manner
between columns in a `100-by-200` and `100-by-250` matrices, which will result in
a `200-by-250` distance matrix.

|  distance             |  loop     |  pairwise  |  gain  |
|---------------------- | --------- | -----------| -------|
| SqEuclidean           | 0.001273s |  0.000124s | **10.2290** |
| Euclidean             | 0.001445s |  0.000194s |  **7.4529** |
| CosineDist            | 0.001928s |  0.000149s | **12.9543** |
| CorrDist              | 0.016837s |  0.000187s | **90.1854** |
| WeightedSqEuclidean   | 0.001603s |  0.000143s | **11.2119** |
| WeightedEuclidean     | 0.001811s |  0.000238s |  **7.6032** |
| SqMahalanobis         | 0.308990s |  0.000248s | **1248.1892** |
| Mahalanobis           | 0.313415s |  0.000346s | **906.1836** |

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Distances = "~0.10.7"
PlutoUI = "~0.7.30"
StatsBase = "~0.34.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "92f91ba9e5941fc781fecf5494ac1da87bdac775"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5c0eb9099596090bb3215260ceca687b888a1575"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.30"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[StatsAPI]]
git-tree-sha1 = "d88665adc9bcf45903013af0982e2fd05ae3d0a6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─7d874820-7e3f-11ec-1087-dd819d253f23
# ╠═3f847b82-2175-498a-9ef7-f85a50432733
# ╠═4b3cdac5-e1dc-4f39-b6db-b3c6ef7ada4b
# ╟─41eb25f8-8a10-4f78-9373-dd79f95c87f2
# ╟─3012af0f-f52d-4212-a5a7-c8f97485ea5c
# ╟─319acc7d-b5ac-421a-b3ea-98d6cd3701de
# ╟─d79fd59e-ef0b-4b12-b4cf-6526020b8167
# ╠═a30a5e85-9862-4dc4-ba0f-323dc96a1ad5
# ╠═12df2775-2621-4d0e-9975-27b07c922f9d
# ╠═4ccd867c-ddb9-4a13-a589-e5f1304ef7e7
# ╠═95007a2f-27dd-414e-b802-f2193e09bb1c
# ╟─05665ec6-2f44-49ec-8df9-d3af3363e180
# ╟─be29c6d4-8d37-439b-9111-9adcbda40582
# ╟─e53dd289-d4ee-44cf-89a7-2414e353fa92
# ╠═71e17edc-c97d-4dfe-b4c9-dda731854792
# ╠═1bbc3b4a-0e63-4ce7-9ecb-eea1ed7e2ffb
# ╟─6f59e3c8-7c45-4ca9-8703-3a2544e601b8
# ╠═c915d365-4fe5-4dc2-9a37-36728f8fff25
# ╠═dd2de6a0-80d4-4446-8820-8cea8eafc073
# ╟─7fc65334-79eb-4f48-a513-52faf2018e48
# ╟─d14c7917-bc4c-4b1a-8c49-435d21d6b4dc
# ╟─f36c8fd9-b995-4634-a963-c31579a89a38
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
