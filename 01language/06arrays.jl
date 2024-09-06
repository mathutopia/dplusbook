### A Pluto.jl notebook ###
# v0.19.46

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

# ╔═╡ acecbf4d-fca6-409b-8290-bf65ced442fb
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ e8cabcc9-87f9-4e99-9aa4-7090cc78f23c
# ╠═╡ show_logs = false
using Images

# ╔═╡ 5ab39790-f7df-4f80-a80a-c636365258d0
TableOfContents(title="目录")

# ╔═╡ 5bc8d907-cc0a-4579-9623-b40864cb2dbc
present_button()

# ╔═╡ de644d2b-127f-40f5-93de-0bee608712ae
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Julia简短教程——数组
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 3160ac8d-0aae-43ea-a3ac-fa66991f1533
md"""
# 数组Array
为了实现高效的科学计算， 在Julia中， 实现了数组类型。 数组类型具有维度的概念(可以用`ndims`获取一个数组的维度)。 一维数组是向量，二维数据是矩阵。由于向量和矩阵有很多的操作都是跟数组通用的，下面简单介绍一下向量和矩阵的手动构造然后再转入通用的数组的介绍。

## 向量与矩阵
### 向量
向量数据分析中是非常常见的。 跟元组类似，向量也是一列数据。只不过， 向量中的元素是同一种类型。

手动构造向量非常简单， 只要用中括号(元组用的是小括号）和逗号(分号)即可。

```julia
julia> x = [1, 2, 3]
[1,2,3]

julia> x = [1;2;3]
[1,2,3]
```

"""

# ╔═╡ 6485e303-3be0-4683-95c3-68fa4cf8ef0d
[1, 2, 3]

# ╔═╡ 2d5a100b-64d9-4ee1-8ce9-edf4c431d865
[1;2;3]

# ╔═╡ be6e92bc-7cd6-494b-a5d3-2a1ed49c91b9
md"""
向量的数据类型是`Vector{元素类型}`。表示由**元素类型**构成的向量。
"""

# ╔═╡ 3c0c4a27-7ec7-4c9a-9c93-b47d1d298ccb
typeof([1, 2, 3])

# ╔═╡ b766b11c-39af-4b08-af2b-e01569bb2170
md"""
使用**collect函数**可以方便的把一个范围（range）里的所有元素提取到向量中
"""

# ╔═╡ 45d5ab62-2483-4650-9e68-2cf9e779345a
collect(1:10)

# ╔═╡ 3264b2ae-8e0c-411c-9503-b3416b4a951e
collect(range(1,10, 5))

# ╔═╡ d2c94917-6289-4938-bcf8-c4fe5d74ce37
collect(range(1,10,2))

# ╔═╡ 146c3abe-ddfb-4a59-b75e-19fdc91fa1aa
md"""
### 矩阵
矩阵也是一种常见的数据类型。 与向量相比， 矩阵是二维的， 即有行、列两个维度。还是可以使用中括号构造矩阵。 这时候， 空格分隔的元素会按行排列。
"""

# ╔═╡ 075fef83-e55b-426a-9966-0244fd64b38e
# 空格分隔的元素被排成了一行， 请注意返回结果是一个一行的矩阵， Julia中没有行向量。
[1 2 3]

# ╔═╡ 43c28d52-a352-46a3-9907-57c2e09d5333
[1 2 3; 4 5 6]

# ╔═╡ fa5f4c1f-84fb-44e0-a368-19a7886b0c2c
md"""
!!! info "数组的维度"
	维度是数组特有的一个性质。 在Julia中， 天然的支持多维度的数组。那么，怎么理解维度呢？ 尤其是怎么理解一个多维数组呢？以下，提供一个直观的关于维度的理解--奇怪的图书馆。
	
	想象一个奇怪的图书馆， 其中的书中的文字是按列先从上之下， 再从左至右排列的（这就是奇怪之处）。每一本书就是一个三维数组（对于书来说， 数组中的元素是文字，不是数字）。其中的每一页是一个矩阵。
	
	于是， 第一个维度代表列方向（向下）， 第二个维度代表行方向， 第三个维度是厚度的方向（页数增加的方向）。第四个维度是书架上的最底层，从左到右的方向。第五个维度是书架从低到高增加的方向。 当然还可以继续增加维度， 但实际中用到第五个维度已经很难想象了。
	
	许多数组操作函数都包含一个维度dim参数， 需要结合具体场景理解。
"""

# ╔═╡ 4842c9ff-4571-4c4d-928b-9ec544d584a4
md"""
## 数据类型与构造
`AbstractArray{T,N}`是所有数组类类型的父类型。其中T表示数组的元素类型， N表示数组的维度。通常的数组类型是`Array{T,N} <: AbstractArray{T,N}`. 如果`N=1`, 表示一维数组。其类型是也可以表示为`Vector{T}`, 类似的如果`N=2`表示矩阵，其类型也可以表示为`Matrix{T}`。

有了数据类型可以非常方便的构造相应类型的数据容器。比如我们要构造包含100个元素的向量。可以用如下的方式：

```julia
x = Vector{Int32}(undef, 100);
y = Array{Int32,1}(undef, 100);
```
以上两种构造方式是等价的。大括号中的类型是一个具体类型。比如在这里是32位的整数。我们当然可以改成抽象的类型， 比如`Number`。但一般我们不用抽象类型。因为具体类型的运行效率会更高一点。这里的`undef`是一个特殊的常量, 表示未初始化。

对于向量来说， 还可以用  **类型[]**的方式构造某种类型的向量, 但不能同时指定长度（这时候可以使用push!, append!添加元素）。比如下面构造的是一个32位整数构成的向量。但向量的长度不知道。

```julia
x = Int32[];
``` 
构造矩阵也是类似的方式，可以使用`Matrix{T}(undef, m, n)`，或者`Array{T,2}(undef, m, n)`构造元素类型为t的m行n列的矩阵。

""" 

# ╔═╡ 8c0becc4-dae6-4aca-b232-e0482376903d
md"""
## 特殊数组构造
上面用未初始化的类型去构造的数组，需要在后续编程过程当中去填充所有的元素。有时候我们希望数组是已经初始化为某种类型的元素。下面是一些特殊的构造方法。

我们可以通过`zeros`和`ones`函数构造元素全是0或1的数组。元素类型可以指定，如果没有指定的话，默认为Float64。 dims用于指定数组的维度及其每个维度的元素个数。它可以是一个元组, 也可以是多个数字。
```julia
zeros([T=Float64,] dims::Tuple)
zeros([T=Float64,] dims...)
ones([T=Float64,] dims::Tuple)
ones([T=Float64,] dims...)
```
下面是一些例子。
```julia
julia> zeros(1)
1-element Vector{Float64}:
 0.0

julia> zeros(Int8, 2, 3)
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> ones(1,2)
1×2 Matrix{Float64}:
 1.0  1.0

julia> ones(ComplexF64, 2, 3)
2×3 Matrix{ComplexF64}:
 1.0+0.0im  1.0+0.0im  1.0+0.0im
 1.0+0.0im  1.0+0.0im  1.0+0.0im
```
"""

# ╔═╡ 4b33c26f-222a-4477-a85e-8363727d6636
md"""
如果是想初始化为不同于0、1的值，这时候需要使用fill函数。这个函数的作用是将数组元素填充为给定的值。类似的指定维度也可以使用两种不同的方式。
```julia
fill(value, dims::Tuple)
fill(value, dims...)
```
下面是1个例子:

```julia
julia> fill(1.0, (2,3))
2×3 Matrix{Float64}:
 1.0  1.0  1.0
 1.0  1.0  1.0
```
"""

# ╔═╡ 8e9daf50-296f-492e-991f-44c1a002e5e4
md"""
此外， 有时候， 我们常常需要构造随机数组， 这可以通过下列方法实现：

- rand: 可以通过给定维度长度构造（0,1）间的随机数数组， 例如：rand(m, n)构造m*n的随机矩阵。-
- randn: 可以通过给定维度长度构造符合正态分布的随机数数组
"""

# ╔═╡ 926084f6-8810-41fe-94f3-e2d05e907e9e
md"""
!!! warn "注意"
    需要注意的是这里填充进去的是同一个值。如果这个值是一个可变结构,比如数组, 意味着所有的值都是这个可变结构.因此改变其中的一个也会改变其他的值。通过下面的例子就明白。
    ```julia
    julia> A = fill(zeros(2), 2) # sets both elements to the same [0.0, 0.0] vector
    2-element Vector{Vector{Float64}}:
    [0.0, 0.0]
    [0.0, 0.0]

    julia> A[1][1] = 42; # modifies the filled value to be [42.0, 0.0]

    julia> A # both A[1] and A[2] are the very same vector
    2-element Vector{Vector{Float64}}:
    [42.0, 0.0]
    [42.0, 0.0]
    ```
""" 

# ╔═╡ 7ccf7108-175a-43f1-b8ac-75f46c766d40
md"""
有时候我们可能会需要构造一个跟给定数组具有相同维度或者相同元素类型的数组这时候可以使用similar函数。
```julia
similar(array, [element_type=eltype(array)], [dims=size(array)])
```
注意，上面的函数中元素类型和维度都是可选的参数。如果都没有给定，那就是一个跟array具有相同内存结构的未初始化的数组.
"""

# ╔═╡ 18dfa55b-3a4c-45c3-9e49-c3d42663b522
md"""
## 数组的索引
除了维度数组的另外一个重要特性是：数组元素具有索引（index）。简单来说就是数组的元素都具有一个编号或者下标（位置）。可以通过这个编号或者下标直接获得数组中的某一个具体的元素。数组有两种形式的索引： 线性索引`IndexLinear`和笛卡尔索引`IndexCartesian`. 

Julia给数组的每一个元素位置按照先低维后高维的顺序(按列存储)都赋予了一个从1开始到数组元素个数(length)的编号。这个编号就是线性索引。

线性索引用一个整数表示一个元素的位置。而笛卡尔索引则是用多个整数表示一个元素的位置。通常情况下每一个维度需要一个数字。比如(m,n)表示数组的第m行n列所在的位置。也可以说第一维的下标取值是m， 第二维的下标取值是n。

对一个数组来说，线性索引跟笛卡尔索引之间可以相互转换。但从笛卡尔索引转换为线性索引要容易（涉及加法和乘法）。从线性索引转化为笛卡尔索引要复杂一些（涉及除法）。Julia中的数组同时实现了上面两种索引方式。

索引的重要作用是可以通过索引去操作数组的对应索引位置的元素。强奸的操作是读取和写入。这两种操作都可以用中括号放入索引的方式实现。 其中`A[index]`用于获取元素， `A[index]=...`用于修改元素。`index`是一个合法的索引值（一个整数，或逗号分隔的多个整数）。

```julia

getindex(A, inds...)

setindex!(A, X, inds...)
A[inds...] = X

```

```julia
julia> A = [10 20; 30 40];

julia> A[1,2]
20

julia> A[3]

```
如果我们要遍历数组去处理他的每一个元素，可以使用`eachindex`函数获得一个数组的所有元素的索引构成的容器， 通过遍历这个容器去处理数组中的元素。这个函数会根据数组的类型返回它最优的索引方式。

```julia
julia> A = [10 20; 30 40];

julia> for i in eachindex(A) # linear indexing
           println("A[", i, "] == ", A[i])
       end
A[1] == 10
A[2] == 30
A[3] == 20
A[4] == 40

```
"""

# ╔═╡ 77f4c1b7-e90b-4bd3-bc64-140d0370146b
md"""
### 数组读取
读取一个数据中某一个或者某一批未知的元素的通用语法是：
```julia
X = A[I_1, I_2, ..., I_n]
```
这里的`I_k`可以是整数、向量、数组、冒号(:)、范围（a:b:c或者a:c)以及任何其他合法的索引。

如果所有的索引`I_k`都是标量， X就是对应位置的元素。 标量的存在会消除对应维度。

如果所有索引`I_k`都是向量，那么X的形状将是`（length(I_1），length(I_2),...，length（I_n）`，位置`(i_1,i_2,...,i_n)`的值包含`A[I_1[i_1],I_2[i_2],...,I_n[i_n]]`。

### 数组改写
修改一个数组某些位置的元素的通用语法是：
```julia
A[I_1, I_2, ..., I_n] = X
```
这里下标的写法和上面是类似的。 赋值能够成功， 要求左边得到的尺寸，跟右边X提供的尺寸或元素个数（向量情形）相同。 如果是一个元素赋值给多个位置， 则需要用到广播运算：
```julia
A[I_1, I_2, ..., I_n] .= X
```
"""

# ╔═╡ 9807c778-e540-4f68-8f13-ca8d1a3ed5f2
md"""

!!! hint "关于笛卡尔索引"

    [ref](https://julialang.org/blog/2016/02/iteration/)
    首先， 可以方便的通过整数或整数元组构建笛卡尔索引（CartesianIndex）。注意， 这构建的是单个索引。
    ```julia
    CartesianIndex(i, j, k...)   -> I
    CartesianIndex((i, j, k...)) -> I
    ```
    如果想构建一片区域， 可以通过一个维度对象（整数元组）, 或一个范围元组，放入CartesianIndices中（注意，这是复数）。
    ```julia
    CartesianIndices(sz::Dims) -> R
    CartesianIndices((istart:[istep:]istop, jstart:[jstep:]jstop, ...)) -> R
    ```
    当然， 也可以直接通过`CartesianIndices`获取一个数组的所有笛卡尔坐标。
    ```julia
    CartesianIndices(A::AbstractArray) -> R
    ```
    以上只是关于如何构建迪卡尔索引。有趣的是笛卡尔索引还支持简单运算。

    简单加减远算会在对应的每个维度上做相应的运算。
    ```julia
    julia> CIs = CartesianIndices((2:3, 5:6))
    CartesianIndices((2:3, 5:6))

    julia> CI = CartesianIndex(3, 4)
    CartesianIndex(3, 4)

    julia> CIs .+ CI
    CartesianIndices((5:6, 9:10))
    ```
    另一个值得注意的是对两个笛卡尔索引求最大值max和最小值min。他们并不是直接比较两个笛卡尔索引的大小， 而是求得两个索引的对应维度上的最大值和最小值。
    ```julia
    julia> max(CartesianIndex(3,4,5), CartesianIndex(2,5,3))
    CartesianIndex(3, 5, 5)

    julia> min(CartesianIndex(3,4,5), CartesianIndex(2,5,3))
    CartesianIndex(2, 4, 3)

    julia> CartesianIndex(3,4,5) > CartesianIndex(2,5,3)
    true

    ```

    下面这个函数， 将A的某个维度求和，放入B中。注意`min(Bmax,I)`， 因为在求和的维度上， Bmax会等于1， 其他维度上则是可取到的最大值。 因此， 这里min返回的永远是，求和为都上为1， 其他则是I所对应的位置。
    ```julia
    julia> function sumalongdims!(B, A)
        # It's assumed that B has size 1 along any dimension that we're summing,
        # and otherwise matches A
        fill!(B, 0)
        Bmax = last(CartesianIndices(B))
        for I in CartesianIndices(A)
            B[min(Bmax,I)] += A[I]
        end
        B
    end
    ```

""" 

# ╔═╡ 5537f878-4e61-43a3-8d27-af4c9b243e21
md"""
## 基本函数

- ndims(A::AbstractArray) -> Integer： 给出数组有多少个维度？
- size(A::AbstractArray, [dim])： 返回数组的每一个维度的长度构成的元组。也可以用于获取指定维度的长度。

- axes(A) : 以元组的形式返回数组的每一个维度的索引范围。
```julia
julia> A = fill(1, (5,6,7));

julia> axes(A)
(Base.OneTo(5), Base.OneTo(6), Base.OneTo(7))
```
- axes(A, d): 返回数组的指定维度的索引范围。
```julia
julia> A = fill(1, (5,6,7));

julia> axes(A, 2)
Base.OneTo(6)

julia> axes(A,3) == 1:7
true
```
- length(A::AbstractArray):返回数组的元素个数。

- **变形**
reshape可以将一个数组变形为另一个给定维度的数组。 前提是变形前后， 元素个数是相同的。
```julia
reshape(A, dims...) -> AbstractArray
reshape(A, dims) -> AbstractArray
```
- **搜索**
|函数名|	搜索的起始点|	搜索方向	|结果值|
|---|---|---|---|
|findfirst|	第一个元素位置|	线性索引顺序|	首个满足条件的元素值的索引号或nothing|
|findlast|	最后一个元素位置|	线性索引逆序|	首个满足条件的元素值的索引号或nothing|
|findnext|	与指定索引号对应的元素位置|	线性索引顺序|	首个满足条件的元素值的索引号或nothing|
|findprev|	与指定索引号对应的元素位置|	线性索引逆序|	首个满足条件的元素值的索引号或nothing|
|findall|	第一个元素位置|	线性索引顺序|	包含了所有满足条件元素值的索引号的向量|
|findmax|	第一个元素位置|	线性索引顺序|	最大的元素值及其索引号组成的元组或NaN|
|findmin|	第一个元素位置|	线性索引顺序|	最小的元素值及其索引号组成的元组或NaN|
"""

# ╔═╡ 1aacc018-59c3-4ca3-9934-266afbcfaa0d
md"""
## 数组的迭代
数据迭代有两种方式：
```julia
for a in A
    # 直接对元素a做操作
end

for i in eachindex(A)
    # 对元素下标 i 或元素 A[i] 同时操作
end
```
"""

# ╔═╡ 9aaa8953-42be-4d00-9105-c40c8f0bfb39
md"""
## 广播与向量化
### 广播
广播是将一个操作同时施加到多个对象上。 使用函数broadcast, 可以方便的将函数f广播到数组，元组，集合，引用或标量上。 如果后面的元素（As...）都是单个元素， 则返回结果是单个元素。如果其中有一个是元组， 返回结果是元组， 其他情况下， 返回结果是数组。
```julia
broadcast(f, As...)
```
下面是是一个简单的例子：
```julia
julia> A = [1, 2, 3, 4, 5]
5-element Vector{Int64}:
 1
 2
 3
 4
 5

julia> B = [1 2; 3 4; 5 6; 7 8; 9 10]
5×2 Matrix{Int64}:
 1   2
 3   4
 5   6
 7   8
 9  10

julia> broadcast(+, A, B)
5×2 Matrix{Int64}:
  2   3
  5   6
  8   9
 11  12
 14  15
```
"""

# ╔═╡ 32c81b82-f8b1-44dd-b1b3-251c62eb592c
md"""
### 向量化

在Python、R等语言中， 为了写出更高效的代码， 一般都尽量使得代码是向量化的。一个函数``f(x)``施加到向量``v``上时，默认会施加到向量中的每一个元素上``f(v[i])``。在Julia中， 也支持向量化。只需要在函数调用的括号前面加一个点即可。例如
```julia
x = rand(10)
sin.(x)
```
可以实现对10个元素同时求正弦sin。 因为运算符也是函数， 所以运算符也可以是向量化的， 可以通过在运算符前加一个点让运算符变成向量化运算符。比如，下面的 **.^**可以实现对向量中的每一个元素求平方。

```julia
x = rand(10)
x.^2
```

多个函数同时向量化也是允许的， 而且在Julia中会比较快。 比如， 我们对一个向量中每一个元素平方之后，求正弦， 再求余弦， 那么可以这么写：

```julia
x = rand(10)
cos.(sin.(x.^2))
```
上面的代码中有三个点， 表明三个相关函数（^这个也是函数）都是向量化的。不过，如果有太多点运算， 可能代码看起来比较繁琐， 这时候可以使用宏`@.`。 宏有点像函数， 但不需要写括号。宏`@.`是告诉Julia， 这个宏后面的代码是向量化的， 只是不需要写点了。因此，上面的代码也可以写成：
```julia
x = rand(10)
@. cos(sin(x^2))
```
这时候， 如果你要告诉Julia， 其中的某个函数不是向量化的， 那么你需要在该函数名前加上美元\$符号。

例如`@. sqrt(abs($sort(v)))`表示对向量排序（sort）之后，再每个元素求绝对值（abs），然后再开方（sqrt）。

在julia中， 你直接写循环会比向量化代码更快， 所以不需要担心自己的代码不是向量化的。 我们还是会写向量化的代码是因为非常方便，仅此而已。
"""

# ╔═╡ ce95d0e9-6d1c-4546-90a9-b2655bf1fd61
md"""
!!! info "点运算"
	在Julia中， 点运算本质上就是调用了广播函数。比如， `f.(args...)` 本质上调用的是` broadcast(f, args...)`.

"""

# ╔═╡ 39a09e5b-cb30-4631-b479-495388655d94
md"""
##  数组推导
数组推导是构建数组的一个常见形式。与python类似，Julia也提供了数组推导式, 通用的格式如下：
- [f(e) for e in colletion if condition]。 这是遍历collection里面的元素， 当满足条件condition时就进行某种操作f， 最后形成一个数组。 e in colletion 也可以写成 e = colletion， if condition可以省略, 下同。
- [f(x,y) for x in c1, y in c2 if condition]。 这种情况下， x,y分别从两个集合c1,c2取值，如果没有if条件，结果是一个矩阵， 矩阵第i,j位置上的元素是f(x[i],y[j])， 由于Julia中矩阵按列存储， 所以会先计算出第1列，再第二列，依次类推； 如果有if条件， 结果是向量， 相当于先计算一个矩阵，再过滤掉不满足条件的元素。  
**注意：**如果外侧不是用[ ]包裹， 那就不是数组推导。 比如， 用（）包裹得到的可不是python里面的元组， 而是生成器了。
"""

# ╔═╡ 295464e9-4ada-46ae-80f2-5f09fa0ed635
[x for x in 1:100 if iseven(x)]

# ╔═╡ f9efe456-7c51-41de-a80f-4ae26d9c5c35
[(x,y) for x in 1:3,  y in 1:4]

# ╔═╡ 46c6ac52-d33d-45f5-9fbd-05221940a159
md"""
### 向量的拼接cat
如果有多个向量需要拼接为一个向量， 可以使用cat函数。
```julia
cat(A...; dims)
```
该函数有一个关键字参数， dims， 用于给定拼接的维度。 也就是把数据放在哪个维度上（单个维度）。 注意， 这里的参数名是复数， 意味着可以同时给多个维度， 这时候拼接的结果是多个维度同时增加。比如， 构造分块矩阵。

在第一个维度拼接也可以用vcat， 在第二个维度拼接可以用hcat。看[**这里**](https://docs.julialang.org/en/v1/base/arrays/#Base.cat)了解更多。
"""

# ╔═╡ 9b679c06-4c2c-4fac-b531-0f595e01d5ce
md"""
push!函数可以在向量后面增加一个元素， 而pop!函数弹出向量的最后一个元素， 注意， 这两个函数名后面有惊叹号， 表明这种函数会修改参数值。 在这里其实是会修改，输入的数组xv。
"""

# ╔═╡ 1bfa8a99-7fa1-4254-b871-0ad0c6f908aa
md"""
### 向量堆叠stack
矩阵是由列向量按行排列而成的。因此， 如果我们有一系列等长的向量， 可以将其简单拼接起来就好。
"""

# ╔═╡ 7375a318-67e6-4755-9380-11d1b73a69e3
vecs = (1:2, [30, 40], Float32[500, 600]);

# ╔═╡ fe36499e-7dca-47a1-ba28-7d9602a3dd1e
stack(vecs)

# ╔═╡ bce35124-6542-44a9-bf0c-2aaf5c17a4cb
cat([1,2],[3,4], dims=1)# 按第一个维度（行）方向拼接

# ╔═╡ 4ac9bd22-dc28-4a08-be79-a57ef9bb9e39
cat([1,2],[3,4], dims=2)# 按第二个维度（列）方向拼接

# ╔═╡ f11fd7d7-2e36-4cb4-be86-37b22a1f0496

md"""
## 数组操作演示
"""

# ╔═╡ 14a0c913-7502-439a-b45a-d2f98891a498
function invert(color)
	return RGB(1-color.r, 1-color.g, 1-color.b)
end

# ╔═╡ ac3ae604-b8c7-4562-a758-8ccd5ac04461
md"""
在Julia中， 图片就是一种典型的数组（矩阵），只是其元素是具有特殊含义的值。下面我们用Julia中的Images.jl包提供的图片功能演示一下数组的操纵， 更多的操作请自行探索。（注意，加载Images包）。 

我们随便找了一张图片， 通过download函数将其下载下来， 然后再用load函数（来源于Images.jl包）将其读取到数组中
"""

# ╔═╡ a51dfbf8-781b-496c-bc39-26960109edcb
trees = load(download("https://news.gdufs.edu.cn/images/xwb1.jpg"))

# ╔═╡ c8866f00-d03f-48f0-8ad4-1a403f36e56f
md"""
### 元素提取
"""

# ╔═╡ d23c2a7d-a0c3-4bf5-a25c-ec51556fa7af
typeof(trees)

# ╔═╡ 85766506-c963-4a06-9706-905e490c38e1
md"""
一个颜色值（RGB对象）可以简单的看成包含了三个域， 分别为r,g,b。我们可以通过这三个域名获取对应通道的颜色的值。
"""

# ╔═╡ df9fac42-38b5-4b6d-b525-cd27b3f7606f
md"""
可以用typeof看一下图片的数据类型， 发现是Matrix， 其元素类型是：RGB{N0f8}， 如果不理解没有关系。你只要知道这代表的是一个颜色值就行。 因为加载了Images包， 后面所有的颜色值都会被显示为图片， 而不是数值。
"""

# ╔═╡ bd7751d0-8efc-4a49-9d15-f4aef504a853
trees[1,1] # 第一个像素

# ╔═╡ a10e7c0b-7c80-4856-849a-12e1ad447f12
smtree = trees[1:380, 1:380]

# ╔═╡ b25ebfce-175b-4e8b-9c58-30b13c731760
[smtree smtree; smtree smtree]

# ╔═╡ c145832a-06e4-410b-967d-a3bb3e6c7096
invert.(smtree)

# ╔═╡ f8baf1d1-0cd3-4b00-9c42-bb66075436fa
[smtree;smtree]

# ╔═╡ ced313d0-3aa5-40d3-9de2-146b02e8dac8
size(trees)

# ╔═╡ 3071c1ac-e035-4f26-bbdc-731e96fffe21
md"""
下面是用编写的函数将图片反转， 注意函数调用时在括号前面的点， 这个实现的是点运算， 即将函数的作用施加到参数的每一个元素上。
"""

# ╔═╡ 428576d5-c92a-43c5-a6f0-4a6f1c676d1f
md"""
#### 👉 练习1
编写一个函数， 实现将给定的颜色反转。即将颜色（r,g,b），变为（1-r, 1-b, 1-c）
""" 

# ╔═╡ 3d483e9f-ec3c-4120-ad7d-0e12f5321eac
md"""
r= $(@bind r Scrubbable(0:0.1:1; default=0.1)), g= $(@bind g Scrubbable(0:0.1:1; default=0.1)), b= $(@bind b Scrubbable(0:0.1:1; default=0.1)) 对应的颜色是：
"""

# ╔═╡ 804fa0cf-37e3-4df3-bb05-672bb7bbf216
tmp = RGB(r,g,b)

# ╔═╡ ed6bd5cf-5315-434b-83fc-994d0ba2a564
tmp.r, tmp.g, tmp.b

# ╔═╡ 5501d7bb-7633-46f1-b316-5dcf7587a2f6
trees[1:50,:]

# ╔═╡ e49a1ed6-565f-4a95-8d37-9691dd307de2
md"""
接下来可以用提取的这颗小树实现数组的拼接等操作。
"""

# ╔═╡ 8201d666-52c7-4fe6-8828-3b4fbb1503ce
md"""
接下来可以用size看一下这张图片的尺寸， 发现有$(size(trees)[1])行， $(size(trees)[2])列。 我们可以用中括号提取其中的某个元素， 或某些元素。
"""

# ╔═╡ f471ee78-e17f-4b91-8dd2-3a2d272ff828
[smtree smtree]

# ╔═╡ 56cc8673-416e-4ac6-a248-3e53d026f9a2
md"""
下面把左边的整棵树提取出来， 并另外保存起来。
"""

# ╔═╡ ab48e2d7-6136-4721-9f88-fb7911ef3baf
md"""
### 数组元素修改
如果我们要修改数组某些元素， 可以简单的用赋值语句实现。 不过要注意的是， 如果要修改的是多个位置， 那么对应应该有多个值。 如果想要用同一个值去修改多个位置的值， 需要用点运算.=

由于上面的数组是图片数组， 中间的元素表示的是颜色， 要去修改对应的颜色， 我们需要能够构造新的颜色。简单来说， 一个颜色是一个 **RGB（r,g,b）** 元组(0<=r,g,b<=1)。 我们只要构造一个这样的元组就可以得到一个颜色值。

下面构造一个红色像素。
"""

# ╔═╡ 7190b949-09c9-4e38-98ce-81d6e546bf1b
RGB(1.0, 0.0, 0.0)

# ╔═╡ d428a955-844a-4f1f-a941-ecdd513854a6
begin
	Temp = @ingredients "../chinese.jl" # provided by PlutoLinks.jl
	PlutoTeachingTools.register_language!("chinese", Temp.PTTChinese.China())
	set_language!( PlutoTeachingTools.get_language("chinese") )
end;

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Images = "~0.26.0"
PlutoTeachingTools = "~0.2.15"
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "c37c6ad000c4a224dd80d77029a9a85a54fbcc8e"

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

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "133a240faec6e074e07c31ee75619c90544179cf"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.10.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

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

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "585a387a490f1c4bd88be67eea15b93da5e85db7"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.5"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "4b270d6465eb21ae89b732182c20dc165f8bf9f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.25.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

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

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

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

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43ba3d3c82c18d88471cfd2924931658838c9d8f"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "4f2b57488ac7ee16124396de4f2bbdd51b2602ad"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.11.0"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "f5356e7203c4a9954962e3757c08033f2efe578a"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.0"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "3447781d4c80dbe6d71d239f7cfb1f8049d4c84f"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.6"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "OpenJpeg_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d65554bad8b16d9562050c67e7223abf91eaba2f"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.13+0"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "6f0a801136cb9c229aebea0df296cdcd471dbcd1"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.5"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "44664eea5408828c03e5addb84fa4f916132fc26"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.1"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e0884bdf01bbbb111aea77c348368a86fb4b5ab6"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.1"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "12fdd617c7fe25dc4a6cc804d657cc4b2230302b"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.1"

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
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be50fe8df3acbffa0274a744f1a99d29c45a57f4"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.1.0+0"

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

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Reexport", "Requires", "TranscodingStreams", "UUIDs", "Unicode"]
git-tree-sha1 = "bdbe8222d2f5703ad6a7019277d149ec6d78c301"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.48"

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
git-tree-sha1 = "4b415b6cccb9ab61fec78a621572c82ac7fa5776"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.35"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

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

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "62edfee3211981241b57ff1cedf4d74d79519277"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.15"

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

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "6355fb9a4d22d867318db186fd09b09b35bd2ed7"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.6.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LittleCMS_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll"]
git-tree-sha1 = "fa7fd067dca76cadd880f1ca937b4f387975a9f5"
uuid = "d3a379c0-f9a3-5b72-a4c0-6bf4d2e8af0f"
version = "2.16.0+0"

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

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8f6786d8b2b3248d79db3ad359ce95382d5a6df8"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.170"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "1ce1834f9644a8f7c011eb0592b7fd6c42c90653"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.1"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "80b2833b56d466b3858d565adcd16a4a05f2089b"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.1.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

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

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded64ff6d4fdd1cb68dfcbb818c69e144a5b2e4c"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.16"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "e64b4f5ea6b7389f6f046d13d4896a8f9c1ba71e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

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

[[deps.OpenJpeg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libtiff_jll", "LittleCMS_jll", "libpng_jll"]
git-tree-sha1 = "f4cb457ffac5f5cf695699f82c537073958a6a6c"
uuid = "643b3616-a352-519d-856d-80112ee9badc"
version = "2.5.2+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

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

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

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
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

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

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "763a8ceb07833dd51bb9e3bbca372de32c0605ad"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "994cc27cdacca10e68feb291673ec3a76aa2fae9"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.6"

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

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

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

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "5680a9276685d392c87407df00d57c9924d9f11e"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.7.1"
weakdeps = ["RecipesBase"]

    [deps.Rotations.extensions]
    RotationsRecipesBaseExt = "RecipesBase"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "2803cab51702db743f3fda07dd1745aadfbf43bd"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.5.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "3aac6d68c5e57449f5b9b865c9ba50ac2970c4cf"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.42"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

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

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "d2fdac9ff3906e27f7a618d47b676941baa6c80c"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.10"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "5d66818a39bb04bf328e92bc933ec5b4ee88e436"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.5.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "9ae599cd7529cfce7fea36cf00a62cfc56f0f37c"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.4"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

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

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "bc7fd5c91041f44636b2c134041f7e5263ce58ae"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.0"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "5d54d076465da49d6746c647022f3b3674e64156"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.8"
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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "6129a4faf6242e7c3581116fbe3270f3ab17c90d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.67"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

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
version = "5.8.0+1"

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
"""

# ╔═╡ Cell order:
# ╠═acecbf4d-fca6-409b-8290-bf65ced442fb
# ╠═5ab39790-f7df-4f80-a80a-c636365258d0
# ╠═5bc8d907-cc0a-4579-9623-b40864cb2dbc
# ╟─de644d2b-127f-40f5-93de-0bee608712ae
# ╟─3160ac8d-0aae-43ea-a3ac-fa66991f1533
# ╠═6485e303-3be0-4683-95c3-68fa4cf8ef0d
# ╠═2d5a100b-64d9-4ee1-8ce9-edf4c431d865
# ╟─be6e92bc-7cd6-494b-a5d3-2a1ed49c91b9
# ╠═3c0c4a27-7ec7-4c9a-9c93-b47d1d298ccb
# ╟─b766b11c-39af-4b08-af2b-e01569bb2170
# ╠═45d5ab62-2483-4650-9e68-2cf9e779345a
# ╠═3264b2ae-8e0c-411c-9503-b3416b4a951e
# ╠═d2c94917-6289-4938-bcf8-c4fe5d74ce37
# ╟─146c3abe-ddfb-4a59-b75e-19fdc91fa1aa
# ╠═075fef83-e55b-426a-9966-0244fd64b38e
# ╠═43c28d52-a352-46a3-9907-57c2e09d5333
# ╟─fa5f4c1f-84fb-44e0-a368-19a7886b0c2c
# ╟─4842c9ff-4571-4c4d-928b-9ec544d584a4
# ╟─8c0becc4-dae6-4aca-b232-e0482376903d
# ╟─4b33c26f-222a-4477-a85e-8363727d6636
# ╟─8e9daf50-296f-492e-991f-44c1a002e5e4
# ╟─926084f6-8810-41fe-94f3-e2d05e907e9e
# ╟─7ccf7108-175a-43f1-b8ac-75f46c766d40
# ╟─18dfa55b-3a4c-45c3-9e49-c3d42663b522
# ╟─77f4c1b7-e90b-4bd3-bc64-140d0370146b
# ╟─9807c778-e540-4f68-8f13-ca8d1a3ed5f2
# ╟─5537f878-4e61-43a3-8d27-af4c9b243e21
# ╟─1aacc018-59c3-4ca3-9934-266afbcfaa0d
# ╟─9aaa8953-42be-4d00-9105-c40c8f0bfb39
# ╟─32c81b82-f8b1-44dd-b1b3-251c62eb592c
# ╟─ce95d0e9-6d1c-4546-90a9-b2655bf1fd61
# ╟─39a09e5b-cb30-4631-b479-495388655d94
# ╠═295464e9-4ada-46ae-80f2-5f09fa0ed635
# ╠═f9efe456-7c51-41de-a80f-4ae26d9c5c35
# ╟─46c6ac52-d33d-45f5-9fbd-05221940a159
# ╟─9b679c06-4c2c-4fac-b531-0f595e01d5ce
# ╟─1bfa8a99-7fa1-4254-b871-0ad0c6f908aa
# ╠═7375a318-67e6-4755-9380-11d1b73a69e3
# ╠═fe36499e-7dca-47a1-ba28-7d9602a3dd1e
# ╠═bce35124-6542-44a9-bf0c-2aaf5c17a4cb
# ╠═4ac9bd22-dc28-4a08-be79-a57ef9bb9e39
# ╟─f11fd7d7-2e36-4cb4-be86-37b22a1f0496
# ╠═14a0c913-7502-439a-b45a-d2f98891a498
# ╟─ac3ae604-b8c7-4562-a758-8ccd5ac04461
# ╠═e8cabcc9-87f9-4e99-9aa4-7090cc78f23c
# ╠═a51dfbf8-781b-496c-bc39-26960109edcb
# ╠═ed6bd5cf-5315-434b-83fc-994d0ba2a564
# ╠═b25ebfce-175b-4e8b-9c58-30b13c731760
# ╟─c8866f00-d03f-48f0-8ad4-1a403f36e56f
# ╠═d23c2a7d-a0c3-4bf5-a25c-ec51556fa7af
# ╟─85766506-c963-4a06-9706-905e490c38e1
# ╟─df9fac42-38b5-4b6d-b525-cd27b3f7606f
# ╠═bd7751d0-8efc-4a49-9d15-f4aef504a853
# ╠═a10e7c0b-7c80-4856-849a-12e1ad447f12
# ╠═c145832a-06e4-410b-967d-a3bb3e6c7096
# ╠═f8baf1d1-0cd3-4b00-9c42-bb66075436fa
# ╠═ced313d0-3aa5-40d3-9de2-146b02e8dac8
# ╠═804fa0cf-37e3-4df3-bb05-672bb7bbf216
# ╟─3071c1ac-e035-4f26-bbdc-731e96fffe21
# ╟─428576d5-c92a-43c5-a6f0-4a6f1c676d1f
# ╟─3d483e9f-ec3c-4120-ad7d-0e12f5321eac
# ╠═5501d7bb-7633-46f1-b316-5dcf7587a2f6
# ╠═e49a1ed6-565f-4a95-8d37-9691dd307de2
# ╠═8201d666-52c7-4fe6-8828-3b4fbb1503ce
# ╠═f471ee78-e17f-4b91-8dd2-3a2d272ff828
# ╟─56cc8673-416e-4ac6-a248-3e53d026f9a2
# ╟─ab48e2d7-6136-4721-9f88-fb7911ef3baf
# ╠═7190b949-09c9-4e38-98ce-81d6e546bf1b
# ╠═d428a955-844a-4f1f-a941-ecdd513854a6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
