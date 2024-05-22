### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 54b70d8d-ec5c-4e7c-a4be-82fe98660d89
begin
using PlutoUI,MLJ, MLJMultivariateStatsInterface,MLJDecisionTreeInterface
end

# ╔═╡ 9980a076-9225-4ef4-8805-635d52001ba9
TableOfContents(title="目录")

# ╔═╡ 5c840389-4d21-466c-948c-bb74ce189645
import MLJModelInterface as MMI

# ╔═╡ a5f158d6-e672-4b6d-b3b6-9aab2e317a23
md"""
# 前言
这里主要介绍模型和机器涉及的一些基本概念， 以及如何定义自己的模型。
"""

# ╔═╡ dd368673-da9a-498d-8d5a-ba0f8c775c64
md"""
# 基本概念

## 超参数
超参数是一个模型不能从数据中学习的参数， 是需要在学习之前指定的参数。比如kmeans算法的k。
"""

# ╔═╡ d4ec5210-d252-4062-9603-6d86848c5475
md"""
## 模型
模型（model）是一个算法的超参数构成的可变结构体。 模型的抽象类型是Model。通常模型有两种类型， 有监督（supervised）和无监督（Unsupervised）。 两类不同的模型通常可以执行不同的操作。
"""

# ╔═╡ 5930cda1-911a-49cf-bebc-3fa4ba421840
md"""
## 机器(machine)
一个机器（machine）本质上来说，也是换一个可变的结构体。记录了这个机器的模型（model）和数据（通过args）。
```julia
mutable struct Machine{M<Model}

    model::M
    fitresult
    cache
    args::Tuple    # e.g., (X, y) for supervised models
    report
    previous_rows # remember the last rows used
end
```


"""

# ╔═╡ e44aa442-71d8-427d-a3c9-8368f6b2f772
md"""
### 机器初始化
机器初始化的时候， 只需要提供模型实例和对应的数据就行。 机器在最开始的时候，是没有定义拟合结果（fitresult）,previous\_rows等字段的。这些字段需要在训练后才有。
```julia
    function Machine{M}(model::M, args...) where M<:Model
        machine = new{M}(model)
        machine.args = args
        machine.report = Dict{Symbol,Any}()
        return machine
    end
```

"""

# ╔═╡ 9c8882b2-d53d-4e53-b849-69e2ccbb763f
md"""
### 拟合机器fit!
拟合机器在本质上会根据模型调用对应的模型拟合函数。下面只是给出了拟合机器的一般框架。
```julia
function fit!(mach::Machine; rows=nothing, force=false, verbosity=1)

    if rows === nothing
        rows = (:)   # 如果没有指定训练集，那么默认所有样本构成训练集
    end
	# 前面没有定义：previous_rows字段（表明模型没有被训练过）或者新指定的rows跟训练过的rows不同（表明，训练集换了， 需要重新训练）
    rows_have_changed  = (!isdefined(mach, :previous_rows) ||
	    rows != mach.previous_rows)
	# 按照rows选定训练数据；
    args = [MLJ.selectrows(arg, rows) for arg in mach.args]
	# 在没有定义：fitresult字段或训练集变了或强制重新训练的情况下，训练模型， 否则就是更新模型就好。
    if !isdefined(mach, :fitresult) || rows_have_changed || force
        mach.fitresult, mach.cache, report =
            fit(mach.model, verbosity, args...)# 调用模型的拟合函数。
    else # call `update`:
        mach.fitresult, mach.cache, report =
            update(mach.model, verbosity, mach.fitresult, mach.cache, args...)
    end
	# 记录这次训练用到的训练样本编号
    if rows_have_changed
        mach.previous_rows = deepcopy(rows)
    end
	# 记录训练报告
    if report !== nothing
        merge!(mach.report, report)
    end

    return mach

end

```
"""

# ╔═╡ ecabba3d-3898-49eb-bc79-0cd686cbc2af
md"""
### 拟合结果
从上面的代码可以看出来，机器拟合本质上是模型在拟合（fit函数的第一个参数）。机器拟合的过程， 只是把模型拟合的结果存储到机器的对应字段。 

模型拟合返回三个结果： fitresult, cache, report。

其中**fitresult**是一个模型通过数据学习到或拟合的参数。比如， 线性模型的系数、主成分分析的投影矩阵等。这个字段可以通过函数fitted_params获取。模型创建者可以重定义该方法， 更好的展示模型的返回结果。

**report**是一个命名元组（NamedTuple）（可能是空的）， 用于记录模型拟合得到的一些中间参数。比如算法拟合中得到的距离、损失、特征重要性等等。这些信息对于模型的诊断是有价值的。 

**cache**没有限定类型，可能是nothing。 主要用于模型更新update时，提供必要的信息。 比如，这里可以包含对数据的预处理结果。


"""

# ╔═╡ 415fe16f-d96c-4628-936f-02e4829cc851
md"""
当机器用于预测时， 跟拟合类似， 也是根据模型和拟合结果做分派，调用对应的预测函数。 预测只有在监督学习时才做。
```julia
function predict(machine::Machine{<:Supervised}, Xnew)
    if isdefined(machine, :fitresult)
        return predict(machine.model, machine.fitresult, Xnew))
    else
        throw(error("$machine is not trained and so cannot predict."))
    end
end
```
"""

# ╔═╡ 54c93d2b-9f92-4800-8b93-10cc221aa7c3
md"""
如果是无监督学习， 一般是用transform函数。
```julia
function transform(machine::Machine{<:Unsupervised}, Xnew)
    if isdefined(machine, :fitresult)
        return transform(machine.model, machine.fitresult, Xnew))
    else
        throw(error("$machine is not trained and so cannot transform."))
    end
end
```
"""

# ╔═╡ be30817a-061e-45a5-86df-12da2739989a
md"""
## 操作（operation）
操作是一种数据变换。 它可能是基于模型的拟合结果。比如对监督学习，可以有Predict、Predict\_Mean、Predict\_median或Predict\_mode方法实现对输入数据（X）变换为预测数据（y）；对于无监督学习， 可使用Transformation或Against_transform方法实现对输入数据（X）的直接变换或逆变换。

操作也可以指不依赖于拟合结果的普通数据处理方法，比如一个函数广播到所有数据上。 为清楚起见， 这类方法被称为静态操作。非静态的操作则是动态的。
"""

# ╔═╡ 92a91528-8825-4bc3-a266-c3a8a6dd39a5
md"""
# 定义模型
MLJ生态提供两种模型定义的方式。 一种是通过模型接口MLJModelInterface去定义（参考[这里](https://alan-turing-institute.github.io/MLJ.jl/dev/adding_models_for_general_use/)）。这种方式适合需要定义一个供整个生态使用的模型。比如， 通过models搜索到的很多模型都是通过这个方式定义的。 这种定义方式需要实现很多在MLJModelInterface定义的接口， 相对而言稍显复杂。 另一种定义模型的方式是通过实现机器（machine）提供的接口实现构建新的模型。这种方式适合定义暂时供自己使用的模型。 下面主要介绍这种方式。


定义一个模型很简单，只需要做三件事：
- 定义一个mutable struct, 用于记录模型的超参数。这个结构体是Probabilistic、Deterministic 或Unsupervised的子类型， 用于表明模型可以用于得到概率（向量）、常规的向量作为预测结果，还是只能做变换。其中，前两种模型Probabilistic、Deterministic是Supervised的子类型。这三种类型都是抽象类型。
- 定义一个fit！方法， 用于拟合模型时，返回拟合结果fitresult.
- 定义一个predict方法， 用模型和拟合结果做分派， 实现对新数据的预测。或者对无监督机器， 定义一个transform方法，实现对新数据的变换。 对监督学习，predict返回的结果要么是一个跟y具有相同元素数据类型的向量， 要么就是一个概率分布向量（对分类问题）。

一个模型可能定义一个clean！方法， 判断模型的参数是否合法， 不合法时可以抛出警告。对一个合法的模型， 该方法不会更改任何信息。
"""

# ╔═╡ e86c79ec-0d3e-4032-9cf4-642e77faaa23
md"""
# 学习网络（Learning network）
学习网络是指通过将数据和数据的处理视为节点（node）， 数据在节点之间的流动视为边，形成的有向无环图。学习网络的核心是延迟计算（delayed computation； lazy computation）。 下面用具体的例子介绍学习网络。
"""

# ╔═╡ 0b9992c7-20e2-4e13-a197-62a020c5b3ac
md"""
## 延迟计算
通常计算都是实时的，即给定了代计算和数据和计算方法（函数、操作符）， 计算结果会立即得到。比如，下面的计算过程, 在给定了x和y的值之后， z的值是3。
"""

# ╔═╡ a5ebbc58-b0a8-4d1f-aa38-827d126ea422
x=1;y=2;  w = 3*y; z = x+w;

# ╔═╡ 5f177518-db25-4f2c-a484-d556a42ab112
md"""
但如果我们将x，y分别定义为数据节点，则z的计算就不是实时的了。为了避免冲突，我们用新的变量名
"""

# ╔═╡ 2a76d0fc-6a8e-4de2-995d-843ce56d05a8
x1=source(1);y1= source(2); w1 = 3*y1; z1= x1+w1;

# ╔═╡ 62876545-369d-4844-a647-700268da5adc
z1

# ╔═╡ 44fe4275-8393-453a-b807-f64174073ba4
md"""
可以看到， z1现在不再是一个计算得到的数据， 而是一个节点， 这个节点是我通过+连接两个参数。当我们需要z1的值的时候， 可以将z1写成一个函数调用。
"""

# ╔═╡ e97ed498-1de6-4f5c-a57e-844f671bd046
z1()

# ╔═╡ 68ccb425-0453-4ad4-acef-d46ced524889
md"""
上面的例子其实是给出了一个从源节点（x1,y1）到最终节点z1的计算过程。 这就是一个计算网络。 我们可以通过rebind!函数更改源节点绑定的数据， 这样就可以通过计算网络得到新的计算结果。
"""

# ╔═╡ a4a962b7-b72b-4f99-b3b4-7e7fe487b447
rebind!(x1,10)

# ╔═╡ c34bc842-7b10-4a41-8068-b036763d3b41
z1()

# ╔═╡ 6dbb364a-ce69-4457-bf34-1b111afcf33e
md"""
这种修改数据的方法比较不直观。因为对z1节点来说，它可能不知道它的源节点已经修改。如果一个节点的源节点只有一个， 那么可以方便的通过节点本身去修改其源节点。
"""

# ╔═╡ 20cfa343-a791-4f2d-9ca0-e46186547354
md"""
我们可以通过origins函数获得一个节点的源节点（source）。
"""

# ╔═╡ bfcc0777-d1c5-4068-b645-37cdb551b5c9
origins(z1)

# ╔═╡ 72397617-ba70-48d4-813f-8cd6dea2d9fb
origins(w1)

# ╔═╡ 569db7ef-345f-4077-b004-a1d350b16775
md"""
可以看到w1只有一个源节点， 注意观察下面两种计算方式的结果。
"""

# ╔═╡ a8c89725-3d14-44d6-90bc-98a54036484d
w1()

# ╔═╡ 46afd362-5305-4e36-ab7c-5a2e37c70a64
w1(3)

# ╔═╡ 9f9adbe0-b437-41e1-b95b-53597b9e772d
md"""
这种单一源节点表现的就像一个函数， 我们可以像通过参数赋值一样给源节点赋予不同的值实现计算。
"""

# ╔═╡ 69dc1e2b-28a7-44b9-93f6-fbd0fcb1ab13
md"""
## 函数计算
通过上面的例子我们看到， x1,y1,w1，z1等都是节点（node）。 节点之间通过运算实现连接（运算的参数和结果之间形成有向边）。 上面给出的运算是简单的*和+， 在MLJ中， 下面这些函数都能够直接作用到节点上MLJBase.matrix, MLJBase.table, vcat, hcat, mean, median, mode, first, last, as well as broadcasted versions of log, exp, mean, mode and median.
"""

# ╔═╡ 935d6db3-3fff-475d-90b4-8925766feb73
md"""
除了上面提到的函数外， 一个普通函数可能不能直接作用到节点上. 
"""

# ╔═╡ 3874cac7-5f81-4782-a2a8-cd7e00ae175a
z2 = sin(x1)

# ╔═╡ 44d864ec-8b2a-4b56-95df-b2def849049d
md"""
这时候， 我们需要通过node函数定义实现普通函数计算的节点。node函数的调用方式如下：`
N = node(f::Function, args...)`。 它可以将函数f作用到给出的节点（args）上，得到一个新的节点N。
"""

# ╔═╡ 3567e9c0-61c3-4764-b040-6391b5af81fd
z3 = node(sin, x1)

# ╔═╡ a6510f06-5d4b-464d-9364-901e556ad168
z3()

# ╔═╡ 8dd3c993-b6d9-44ca-a4b9-4946d2944bfa
md"""
## 会学习的网络
上面构建的网络能够实现延迟计算， 但不能学习。 为了让一个网络能够学习， MLJ允许机器:1)允许节点绑定“机器”； 2）在数据节点和机器上调用predict或transform创建操作节点。下面演示这些节点的构建。

### 准备数据
下面的函数`X, y = make_blobs(n=100, p=2; kwargs...)`用于生成n个样本，每个样本p个特征。默认情况下， centers=3表示样本分成3类。
"""

# ╔═╡ e510e9e8-4141-470c-a8e7-96f8d01fef09
Xb,yb = make_blobs(100,rng=123)

# ╔═╡ 5408cd03-a639-4ab4-8318-5984681f72aa
Xnew, _ = make_blobs(3)

# ╔═╡ d14e767d-1e6a-4527-b359-b626dec10e88
md"""
### 准备两个模型实例
"""

# ╔═╡ c550be42-e907-40e8-be63-71bf64fdd304
begin
pca = (@load PCA pkg=MultivariateStats verbosity=0)()
tree = (@load DecisionTreeClassifier pkg=DecisionTree verbosity=0)()
end

# ╔═╡ 3e80f552-01e5-41bf-9b38-4912aab1380a
md"""
### 构建数据节点
"""

# ╔═╡ b1d07971-d4ae-4a0d-97f3-08218149bcf8
begin
Xs = source(Xb)
ys = source(yb)
end

# ╔═╡ 87c36a43-320a-413a-bb5e-e290aafc6b23
md"""
### 构建学习节点
"""

# ╔═╡ 9e8ef0f1-56e7-4e03-9eb6-2e9155ad1ea3
md"""
把模型和数据绑定在一起，只是为了说明，我们要从数据中学得一个机器。这个学得的机器在数据上的操作（transform）才是构成的新的节点（操作节点）。 所以，机器本身不是节点。机器只是指向了它要学习的数据源和给定学习的目标（模型）， 机器本身需要成为构建新节点的输入。

简单来说， 构建学习节点分两步：
- 1）构建机器（指定要学什么？（模型）和从哪里学？（数据））
- 2）在数据（或节点）上施加学到的操作。

**学习节点是数据节点上施加带机器的操作形成的节点。**
"""

# ╔═╡ c2bafeed-f0cb-4ce6-a6a5-b7866678ee26
begin
mach1 = machine(pca, Xs)
xx = transform(mach1, Xs)
end

# ╔═╡ b5f32075-2fdb-43ff-9e4c-3e7d21c4f6e2
begin
mach2 = machine(tree, xx, ys)
yhat = predict(mach2, xx)
end

# ╔═╡ 9ab4bca6-4307-40e5-99b6-e6c925d67618
md"""
注意， 这里yhat节点只有一个源节点。 虽然看上去，yhat除了Xs作为源节点外，还有一个ys（通过mach2）, 但mach2本身不是节点。因此， yhat跟ys之间不存在直接边。事实上， 这个看似间接边也会在节点学习之后消失。简单总结就是：**通过机器连接的节点，不存在连边。**
"""

# ╔═╡ 3cefcc02-6628-404c-88a4-ec198e03375d
origins(yhat)

# ╔═╡ e49f8a96-3845-4436-a3ba-8c07c18345ad
md"""
### 学习节点的学习
"""

# ╔═╡ 83f7f986-e9ba-4528-a18e-01f92f1e45bb
md"""
以上构建的xx和yhat都是可学习的节点，它们在调用之前，需要先学习。 但yhat这个节点是以xx节点为输入的。因此， 当yhat学习时， 会导致其依赖的xx节点也进行学习。
"""

# ╔═╡ 8e62dc47-061d-4c4b-9508-5dd097ee1676
fit!(yhat)

# ╔═╡ 8099c70d-63a3-459c-976a-46414bcb2c0e
md"""
学习节点完成学习后，就可以调用了。注意，这个时候的学习节点是单源节点。我们可以直接修改源节点值实现利用学习网络做预测。
"""

# ╔═╡ 75ef369c-3605-4d16-a199-a1b866838ea3
yhat()[1:2]

# ╔═╡ d99ffd5a-b964-46c6-af11-9a618e0d1bcc
yhat(Xnew)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
MLJ = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
MLJDecisionTreeInterface = "c6f25543-311c-4c74-83dc-3ea6d1015661"
MLJModelInterface = "e80e1ace-859a-464e-9ed9-23947d8ae3ea"
MLJMultivariateStatsInterface = "1b6a4a23-ba22-4f51-9698-8599985d3728"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
MLJ = "~0.20.2"
MLJDecisionTreeInterface = "~0.4.0"
MLJModelInterface = "~1.9.4"
MLJMultivariateStatsInterface = "~0.5.3"
PlutoUI = "~0.7.54"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "990ec17578dccd6e9e54bf0a57548442df8ef0fd"

[[deps.ARFFFiles]]
deps = ["CategoricalArrays", "Dates", "Parsers", "Tables"]
git-tree-sha1 = "e8c8e0a2be6eb4f56b1672e46004463033daa409"
uuid = "da404889-ca92-49ff-9e8b-0aa6b4d38dc8"
version = "1.4.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "faa260e4cb5aba097a73fab382dd4b5819d8ec8c"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

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

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables"]
git-tree-sha1 = "e28912ce94077686443433c2800104b061a827ed"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.39"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

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

[[deps.CategoricalDistributions]]
deps = ["CategoricalArrays", "Distributions", "Missings", "OrderedCollections", "Random", "ScientificTypes"]
git-tree-sha1 = "3124343a1b0c9a2f5fdc1d9bcc633ba11735a4c4"
uuid = "af321ab8-2d2e-40a6-b165-3d674595d28e"
version = "0.1.13"

    [deps.CategoricalDistributions.extensions]
    UnivariateFiniteDisplayExt = "UnicodePlots"

    [deps.CategoricalDistributions.weakdeps]
    UnicodePlots = "b8865327-cd53-5732-bb35-84acbb429228"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "2118cb2765f8197b08e5958cdd17c165427425ee"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.19.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

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
deps = ["UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"
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

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

    [deps.CompositionsBase.weakdeps]
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.ContextVariablesX]]
deps = ["Compat", "Logging", "UUIDs"]
git-tree-sha1 = "25cc3803f1030ab855e383129dcd3dc294e322cc"
uuid = "6add18c4-b38d-439d-96f6-d6bc489c04c5"
version = "0.1.3"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DecisionTree]]
deps = ["AbstractTrees", "DelimitedFiles", "LinearAlgebra", "Random", "ScikitLearnBase", "Statistics"]
git-tree-sha1 = "526ca14aaaf2d5a0e242f3a8a7966eb9065d7d78"
uuid = "7806a523-6efd-50cb-b5f6-3fa6f1930dbb"
version = "0.12.4"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

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
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "9242eec9b7e2e14f9952e8ea1c7e31a50501d587"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.104"

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

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarlyStopping]]
deps = ["Dates", "Statistics"]
git-tree-sha1 = "98fdf08b707aaf69f524a6cd0a67858cefe0cfb6"
uuid = "792122b4-ca99-40de-a6bc-6742525f08b6"
version = "0.3.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.FLoops]]
deps = ["BangBang", "Compat", "FLoopsBase", "InitialValues", "JuliaVariables", "MLStyle", "Serialization", "Setfield", "Transducers"]
git-tree-sha1 = "ffb97765602e3cbe59a0589d237bf07f245a8576"
uuid = "cc61a311-1640-44b5-9fba-1b764f453329"
version = "0.2.1"

[[deps.FLoopsBase]]
deps = ["ContextVariablesX"]
git-tree-sha1 = "656f7a6859be8673bf1f35da5670246b923964f7"
uuid = "b9860ae5-e623-471e-878b-f6a53c775ea6"
version = "0.1.1"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

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

[[deps.IterationControl]]
deps = ["EarlyStopping", "InteractiveUtils"]
git-tree-sha1 = "d7df9a6fdd82a8cfdfe93a94fcce35515be634da"
uuid = "b3c1a2ee-3fec-4384-bf48-272ea71de57c"
version = "0.5.3"

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

[[deps.JuliaVariables]]
deps = ["MLStyle", "NameResolution"]
git-tree-sha1 = "49fb3cb53362ddadb4415e9b73926d6b40709e70"
uuid = "b14d175d-62b4-44ba-8fb7-3064adc8c3ec"
version = "0.2.4"

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "PrecompileTools", "Requires", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "653e0824fc9ab55b3beec67a6dbbe514a65fb954"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.9.15"

    [deps.KernelAbstractions.extensions]
    EnzymeExt = "EnzymeCore"

    [deps.KernelAbstractions.weakdeps]
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Requires", "Unicode"]
git-tree-sha1 = "0678579657515e88b6632a3a482d39adcbb80445"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "6.4.1"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "98eaee04d96d973e79c25d49167668c5c8fb50e2"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.27+1"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LatinHypercubeSampling]]
deps = ["Random", "StableRNGs", "StatsBase", "Test"]
git-tree-sha1 = "825289d43c753c7f1bf9bed334c253e9913997f8"
uuid = "a5e1c1ea-c99a-51d3-a14d-a9a37257b02d"
version = "1.9.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LearnAPI]]
deps = ["InteractiveUtils", "Statistics"]
git-tree-sha1 = "ec695822c1faaaa64cee32d0b21505e1977b4809"
uuid = "92ad9a40-7767-427a-9ee6-6e577f1266cb"
version = "0.1.0"

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
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MLFlowClient]]
deps = ["Dates", "FilePathsBase", "HTTP", "JSON", "ShowCases", "URIs", "UUIDs"]
git-tree-sha1 = "32cee10a6527476bef0c6484ff4c60c2cead5d3e"
uuid = "64a0f543-368b-4a9a-827a-e71edb2a0b83"
version = "0.4.4"

[[deps.MLJ]]
deps = ["CategoricalArrays", "ComputationalResources", "Distributed", "Distributions", "LinearAlgebra", "MLJBalancing", "MLJBase", "MLJEnsembles", "MLJFlow", "MLJIteration", "MLJModels", "MLJTuning", "OpenML", "Pkg", "ProgressMeter", "Random", "Reexport", "ScientificTypes", "StatisticalMeasures", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "981196c41a23cbc1befbad190558b1f0ebb97910"
uuid = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
version = "0.20.2"

[[deps.MLJBalancing]]
deps = ["MLJBase", "MLJModelInterface", "MLUtils", "OrderedCollections", "Random", "StatsBase"]
git-tree-sha1 = "e4be85602f010291f49b6a6464ccde1708ce5d62"
uuid = "45f359ea-796d-4f51-95a5-deb1a414c586"
version = "0.1.3"

[[deps.MLJBase]]
deps = ["CategoricalArrays", "CategoricalDistributions", "ComputationalResources", "Dates", "DelimitedFiles", "Distributed", "Distributions", "InteractiveUtils", "InvertedIndices", "LearnAPI", "LinearAlgebra", "MLJModelInterface", "Missings", "OrderedCollections", "Parameters", "PrettyTables", "ProgressMeter", "Random", "Reexport", "ScientificTypes", "Serialization", "StatisticalMeasuresBase", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "6d433d34a1764324cf37a1ddc47dcc42ec05340f"
uuid = "a7f614a8-145f-11e9-1d2a-a57a1082229d"
version = "1.0.1"
weakdeps = ["StatisticalMeasures"]

    [deps.MLJBase.extensions]
    DefaultMeasuresExt = "StatisticalMeasures"

[[deps.MLJDecisionTreeInterface]]
deps = ["CategoricalArrays", "DecisionTree", "MLJModelInterface", "Random", "Tables"]
git-tree-sha1 = "8059d088428cbe215ea0eb2199a58da2d806d446"
uuid = "c6f25543-311c-4c74-83dc-3ea6d1015661"
version = "0.4.0"

[[deps.MLJEnsembles]]
deps = ["CategoricalArrays", "CategoricalDistributions", "ComputationalResources", "Distributed", "Distributions", "MLJModelInterface", "ProgressMeter", "Random", "ScientificTypesBase", "StatisticalMeasuresBase", "StatsBase"]
git-tree-sha1 = "94403b2c8f692011df6731913376e0e37f6c0fe9"
uuid = "50ed68f4-41fd-4504-931a-ed422449fee0"
version = "0.4.0"

[[deps.MLJFlow]]
deps = ["MLFlowClient", "MLJBase", "MLJModelInterface"]
git-tree-sha1 = "89d0e7a7e08359476482f20b2d8ff12080d171ee"
uuid = "7b7b8358-b45c-48ea-a8ef-7ca328ad328f"
version = "0.3.0"

[[deps.MLJIteration]]
deps = ["IterationControl", "MLJBase", "Random", "Serialization"]
git-tree-sha1 = "991e10d4c8da49d534e312e8a4fbe56b7ac6f70c"
uuid = "614be32b-d00c-4edb-bd02-1eb411ab5e55"
version = "0.6.0"

[[deps.MLJModelInterface]]
deps = ["Random", "ScientificTypesBase", "StatisticalTraits"]
git-tree-sha1 = "0cd3514d865b928e6a36f03497f65b5b1dee38c1"
uuid = "e80e1ace-859a-464e-9ed9-23947d8ae3ea"
version = "1.9.4"

[[deps.MLJModels]]
deps = ["CategoricalArrays", "CategoricalDistributions", "Combinatorics", "Dates", "Distances", "Distributions", "InteractiveUtils", "LinearAlgebra", "MLJModelInterface", "Markdown", "OrderedCollections", "Parameters", "Pkg", "PrettyPrinting", "REPL", "Random", "RelocatableFolders", "ScientificTypes", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "10d221910fc3f3eedad567178ddbca3cc0f776a3"
uuid = "d491faf4-2d78-11e9-2867-c94bc002c0b7"
version = "0.16.12"

[[deps.MLJMultivariateStatsInterface]]
deps = ["CategoricalDistributions", "Distances", "LinearAlgebra", "MLJModelInterface", "MultivariateStats", "StatsBase"]
git-tree-sha1 = "0d76e36bf83926235dcd3eaeafa7f47d3e7f32ea"
uuid = "1b6a4a23-ba22-4f51-9698-8599985d3728"
version = "0.5.3"

[[deps.MLJTuning]]
deps = ["ComputationalResources", "Distributed", "Distributions", "LatinHypercubeSampling", "MLJBase", "ProgressMeter", "Random", "RecipesBase", "StatisticalMeasuresBase"]
git-tree-sha1 = "44dc126646a15018d7829f020d121b85b4def9bc"
uuid = "03970b2e-30c4-11ea-3135-d1576263f10f"
version = "0.8.0"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MLUtils]]
deps = ["ChainRulesCore", "Compat", "DataAPI", "DelimitedFiles", "FLoops", "NNlib", "Random", "ShowCases", "SimpleTraits", "Statistics", "StatsBase", "Tables", "Transducers"]
git-tree-sha1 = "3504cdb8c2bc05bde4d4b09a81b01df88fcbbba0"
uuid = "f1d291b0-491e-4a28-83b9-f70985020b54"
version = "0.4.3"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "b211c553c199c111d998ecdaf7623d1b89b69f93"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.12"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

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
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "629afd7d10dbc6935ec59b32daeb33bc4460a42e"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.4"

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

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "68bf5103e002c44adfd71fea6bd770b3f0586843"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.2"

[[deps.NNlib]]
deps = ["Adapt", "Atomix", "ChainRulesCore", "GPUArraysCore", "KernelAbstractions", "LinearAlgebra", "Pkg", "Random", "Requires", "Statistics"]
git-tree-sha1 = "7c221293228506db2fe883251407581e0846688e"
uuid = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"
version = "0.9.9"

    [deps.NNlib.extensions]
    NNlibAMDGPUExt = "AMDGPU"
    NNlibCUDACUDNNExt = ["CUDA", "cuDNN"]
    NNlibCUDAExt = "CUDA"
    NNlibEnzymeCoreExt = "EnzymeCore"

    [deps.NNlib.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    cuDNN = "02a925ec-e4fe-4b08-9a7e-0d78e3d38ccd"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NameResolution]]
deps = ["PrettyPrint"]
git-tree-sha1 = "1a0fa0e9613f46c9b8c11eee38ebb4f590013c5e"
uuid = "71a1bf82-56d0-4bbc-8a3c-48b961074391"
version = "0.1.5"

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

[[deps.OpenML]]
deps = ["ARFFFiles", "HTTP", "JSON", "Markdown", "Pkg", "Scratch"]
git-tree-sha1 = "6efb039ae888699d5a74fb593f6f3e10c7193e33"
uuid = "8b6db2d4-7670-4922-a472-f9537c81ab66"
version = "0.3.1"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

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

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

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

[[deps.PrettyPrint]]
git-tree-sha1 = "632eb4abab3449ab30c5e1afaa874f0b98b586e4"
uuid = "8162dcfd-2161-5ef2-ae6c-7681170c5f98"
version = "0.2.0"

[[deps.PrettyPrinting]]
git-tree-sha1 = "22a601b04a154ca38867b991d5017469dc75f2db"
uuid = "54e16d92-306c-5ea0-a30b-337be88ac337"
version = "0.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

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

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

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

[[deps.ScikitLearnBase]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "7877e55c1523a4b336b433da39c8e8c08d2f221f"
uuid = "6e75b9c4-186b-50bd-896f-2d2496a4843e"
version = "0.5.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShowCases]]
git-tree-sha1 = "7f534ad62ab2bd48591bdeac81994ea8c445e4a5"
uuid = "605ecd9f-84a6-4c9e-81e2-4798472b76a3"
version = "0.1.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StableRNGs]]
deps = ["Random", "Test"]
git-tree-sha1 = "ddc1a7b85e760b5285b50b882fa91e40c603be47"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "fba11dbe2562eecdfcac49a05246af09ee64d055"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.8.1"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.StatisticalMeasures]]
deps = ["CategoricalArrays", "CategoricalDistributions", "Distributions", "LearnAPI", "LinearAlgebra", "MacroTools", "OrderedCollections", "PrecompileTools", "ScientificTypesBase", "StatisticalMeasuresBase", "Statistics", "StatsBase"]
git-tree-sha1 = "b58c7cc3d7de6c0d75d8437b81481af924970123"
uuid = "a19d573c-0a75-4610-95b3-7071388c7541"
version = "0.1.3"

    [deps.StatisticalMeasures.extensions]
    LossFunctionsExt = "LossFunctions"
    ScientificTypesExt = "ScientificTypes"

    [deps.StatisticalMeasures.weakdeps]
    LossFunctions = "30fc2ffe-d236-52d8-8643-a9d8f7c094a7"
    ScientificTypes = "321657f4-b219-11e9-178b-2701a2544e81"

[[deps.StatisticalMeasuresBase]]
deps = ["CategoricalArrays", "InteractiveUtils", "MLUtils", "MacroTools", "OrderedCollections", "PrecompileTools", "ScientificTypesBase", "Statistics"]
git-tree-sha1 = "17dfb22e2e4ccc9cd59b487dce52883e0151b4d3"
uuid = "c062fc1d-0d66-479b-b6ac-8b44719de4cc"
version = "0.1.1"

[[deps.StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "30b9236691858e13f167ce829490a68e1a597782"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "3.2.0"

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

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

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
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "e579d3c991938fecbb225699e8f611fa3fbf2141"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.79"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "323e3d0acf5e78a56dfae7bd8928c989b4f3083e"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.3"

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
# ╠═54b70d8d-ec5c-4e7c-a4be-82fe98660d89
# ╠═9980a076-9225-4ef4-8805-635d52001ba9
# ╠═5c840389-4d21-466c-948c-bb74ce189645
# ╠═a5f158d6-e672-4b6d-b3b6-9aab2e317a23
# ╟─dd368673-da9a-498d-8d5a-ba0f8c775c64
# ╟─d4ec5210-d252-4062-9603-6d86848c5475
# ╟─5930cda1-911a-49cf-bebc-3fa4ba421840
# ╟─e44aa442-71d8-427d-a3c9-8368f6b2f772
# ╟─9c8882b2-d53d-4e53-b849-69e2ccbb763f
# ╟─ecabba3d-3898-49eb-bc79-0cd686cbc2af
# ╟─415fe16f-d96c-4628-936f-02e4829cc851
# ╟─54c93d2b-9f92-4800-8b93-10cc221aa7c3
# ╟─be30817a-061e-45a5-86df-12da2739989a
# ╟─92a91528-8825-4bc3-a266-c3a8a6dd39a5
# ╟─e86c79ec-0d3e-4032-9cf4-642e77faaa23
# ╟─0b9992c7-20e2-4e13-a197-62a020c5b3ac
# ╠═a5ebbc58-b0a8-4d1f-aa38-827d126ea422
# ╟─5f177518-db25-4f2c-a484-d556a42ab112
# ╠═2a76d0fc-6a8e-4de2-995d-843ce56d05a8
# ╠═62876545-369d-4844-a647-700268da5adc
# ╟─44fe4275-8393-453a-b807-f64174073ba4
# ╠═e97ed498-1de6-4f5c-a57e-844f671bd046
# ╟─68ccb425-0453-4ad4-acef-d46ced524889
# ╠═a4a962b7-b72b-4f99-b3b4-7e7fe487b447
# ╠═c34bc842-7b10-4a41-8068-b036763d3b41
# ╟─6dbb364a-ce69-4457-bf34-1b111afcf33e
# ╟─20cfa343-a791-4f2d-9ca0-e46186547354
# ╠═bfcc0777-d1c5-4068-b645-37cdb551b5c9
# ╠═72397617-ba70-48d4-813f-8cd6dea2d9fb
# ╟─569db7ef-345f-4077-b004-a1d350b16775
# ╠═a8c89725-3d14-44d6-90bc-98a54036484d
# ╠═46afd362-5305-4e36-ab7c-5a2e37c70a64
# ╟─9f9adbe0-b437-41e1-b95b-53597b9e772d
# ╟─69dc1e2b-28a7-44b9-93f6-fbd0fcb1ab13
# ╟─935d6db3-3fff-475d-90b4-8925766feb73
# ╟─3874cac7-5f81-4782-a2a8-cd7e00ae175a
# ╟─44d864ec-8b2a-4b56-95df-b2def849049d
# ╠═3567e9c0-61c3-4764-b040-6391b5af81fd
# ╠═a6510f06-5d4b-464d-9364-901e556ad168
# ╟─8dd3c993-b6d9-44ca-a4b9-4946d2944bfa
# ╠═e510e9e8-4141-470c-a8e7-96f8d01fef09
# ╠═5408cd03-a639-4ab4-8318-5984681f72aa
# ╟─d14e767d-1e6a-4527-b359-b626dec10e88
# ╠═c550be42-e907-40e8-be63-71bf64fdd304
# ╟─3e80f552-01e5-41bf-9b38-4912aab1380a
# ╠═b1d07971-d4ae-4a0d-97f3-08218149bcf8
# ╟─87c36a43-320a-413a-bb5e-e290aafc6b23
# ╟─9e8ef0f1-56e7-4e03-9eb6-2e9155ad1ea3
# ╠═c2bafeed-f0cb-4ce6-a6a5-b7866678ee26
# ╠═b5f32075-2fdb-43ff-9e4c-3e7d21c4f6e2
# ╟─9ab4bca6-4307-40e5-99b6-e6c925d67618
# ╠═3cefcc02-6628-404c-88a4-ec198e03375d
# ╟─e49f8a96-3845-4436-a3ba-8c07c18345ad
# ╟─83f7f986-e9ba-4528-a18e-01f92f1e45bb
# ╠═8e62dc47-061d-4c4b-9508-5dd097ee1676
# ╟─8099c70d-63a3-459c-976a-46414bcb2c0e
# ╠═75ef369c-3605-4d16-a199-a1b866838ea3
# ╠═d99ffd5a-b964-46c6-af11-9a618e0d1bcc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
