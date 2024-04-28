### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ da6e322b-cf26-4803-9b34-19bf4c6f00bc
begin
using PlutoUI,Box
TableOfContents(title="目录")
end


# ╔═╡ 6c6e3068-406c-4c8a-b28c-ef1fa33cfe72
md"""
# 常见复合数据类型
数值和字符（串）是基本的数据类型。 Julia中实现了多种复合类型的数据。复合数据类型可以看成是基本类型组合到一起之后形成的数据类型。 不同的复合类型组合方式不一样，支持的操作也会不一样。下面介绍几种常用的复合数据类型。

## 元组(tuple)
**元组(tuple)**是由括号和逗号构建的不可变对象，其中元素可以是任意类型：
```julia
(e1,e2,e3,...)
```
元组的类型是：`Tuple{e1的类型, e2的类型， ...}`。 

一个元组可以看成是一列“火车”。元组元素个数（相当于火车的车厢数目）在定义时就确定了，后续也不能再修改。 元组的元素可以具有不同的数据类型(相当于“火车”车厢可能具有不同的功能和尺寸）。

元组类型常见于函数定义场景。函数的输入数据时典型的元组。 在需要函数返回多个值时， 我们通常将值用逗号分隔， 返回的结果就是一个多个值构成的元组。 

由于元组是由固定数量元素构成的， 因此也可是使用下标索引。

```julia

julia> (1, 1+1)
(1, 2)

julia> (1,)
(1,)

julia> x = (0.0, "hello", 6*7)
(0.0, "hello", 42)

julia> x[2]
"hello"

julia> typeof(x)
Tuple{Float64, String, Int64}

julia> y = (0, "hello", 6*7);

julia> typeof(y)
Tuple{Int64, String, Int64}
```

注： 对于单个元素构成的元组， 只有一个括号是不行的， 通常需要在元组后加一个逗号， 以表明这是一个元组。 
"""

# ╔═╡ 4e6d9031-873e-49c1-9de5-79c88d186ecb
md"""
注意上面复合数据类型的表示形式。 一个重要的特征就是存在一对大括号。比如，`Tuple{Float64, String, Int64}`， 其中Tuple可以看成是主要类型的名字， 大括号中间的类型显示的是元素的类型。从这个类型表示可以看出很多东西， 比如由于大括号中间只有三个元素， 所以元组是由3个元素构成， 同时每一个元素类型也是给定的。  

类型名字和大括号是一个整体, 所以变量x和y是不同的元组类型。 

事实上， 类型后面的大括号表明这是一个**参数类型**。 所谓参数类型是指一个类型包含一些类型参数， 这些类型参数主要用于限定复合的元素的类型。  

"""  |> box

# ╔═╡ 406811f6-0c24-4d75-b222-d581fe829d92
md"""
**命名元组(NamedTuple)**
元组中的元素只可以通过下标取索引。 命名元组中是给元组中的每一个元素值都赋予一个名字。有了命名元组， 可以通过元组名字和元素名字获取元素值。

```julia
julia> student1 = (name="Robert", reg_year=2020, 性别='男');
julia> student1.name
"Robert"

julia> typeof(student1)
NamedTuple{(:name, :reg_year, :性别), Tuple{String, Int64, Char}}

julia> student1[:name]
"Robert"
```
"""

# ╔═╡ c0ab05eb-dcbb-42e9-8bca-32bcfb3c05ac
md"""
注意，上面命名元组的类型参数中有两个元组，一个是名字构成的元组， 其元素都是Symbol；另一个才是真正的元组Tuple。 
"""  |> box

# ╔═╡ c95c7bef-f2bc-42fd-81d0-706c95b75eff
md"""
NTuple补充

### NTuple元组
NTuple是具有n个元素的元组的一种紧凑表示。其类型是`NTuple{N, T}`。 可以通过函数`ntuple(f::Function, n::Integer)`构建一个n元组。这个函数构建的n个元素分别是`f(i)`。 

为什么需要n元组呢？主要是为了编写类型稳定的函数。 比如下面的函数， 用于计算数组沿某个维度的求和。下面的size(A)返回的是数组A的维度的普通元组， 进而，当我们构建数组B时， 其维度sz是一个向量。但向量的类型并不包含长度信息， 所以B的维度是无法在编译时确定。因此，编译器无法编译出高效的代码。

```julia
julia> function sumalongdims(A, dims)
    sz = [size(A)...]
    sz[[dims...]] .= 1
    B = Array{eltype(A)}(undef, sz...)
    sumalongdims!(B, A)
end
```
一个补救的办法是：构建一个n元组。因为n元组带有长度（n)信息， 这样方便构建[类型稳定的函数](https://docs.julialang.org/en/v1/manual/faq/#man-type-stability)。
```julia
function sumalongdims(A, dims)
    sz = ntuple(i->i ∈ dims ? 1 : size(A, i), Val(ndims(A)))
    B = Array{eltype(A)}(undef, sz...)
    sumalongdims!(B, A)
end
```
""" |> fbox

# ╔═╡ 1ed8d6b2-47e2-4920-918e-da5124e6140e
md"""
### 元组创建

在构建命名元组时， 经常在括号的前面加上一个分号；， 这是为了避免元组只有一个元素时产生错误。没有分号， 一个元素放进括号还是这个元素， 并不会变成元组。

构建元组时， 最后一个元素后面加一个逗号，不会影响最终的结果。但如果整个元组只有一个元素， 这个逗号就必须要添加了。

```julia
julia> (; xt=3)
(xt = 3)

julia> (xt = 3)
xt = 3

julia> (xt,)
(3)

julia> (xt)
3
```
换句话说，括号前面的分号或者括号后面的逗号。用于表示元组，尤其是当元素只有一个时。
""" 

# ╔═╡ 84fb76fd-7f94-4b81-9b36-210df016a2c8
(x = 1)

# ╔═╡ e2c49ef4-191b-423c-9342-5c254278d032
md"""
### 解构赋值
有时候， 将一个容器赋值给多个变量构成的元组是， 容器会发生解构（deconstruct)。结构出来的元素会按顺序赋值给元组中相应的元素， 形成一次给多个变量赋值的效果。 

```julia
julia> (a,b,c) = 1:3 # 这里的括号不是必须的
1:3

julia> b
2

```
另一个有趣的小技巧就是， 交换变量的值
```julia
julia> x,y = 2,3;
julia> x
2

julia> x,y = y,x;
julia> x
3
```

在解构赋值时， 一个常见的问题是： 右边的容器包含多于左边元素个数的值。这时候发生的情况如下：

1. 如果左边的元组元素都是变量， 赋值还是按顺序依次进行，多出来的值都会被抛弃。
2. 如果元组中某个变量后有一个吸收(slurping)操作符`...`, 那么这个变量会贪婪的吸收掉所有的值，不会造成“浪费”。 当然， 如果这个操作符之后还有变量， 后面的变量还是会有值。
3. 吸收操作放中间变量后面需要Julia1.9以上， 在函数参数情形下， 这个操作还是只能放最后参数上。

```julia
julia> a, b... = "hello"
"hello"

julia> a
'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)

julia> b
"ello"

julia> a, b..., c = 1:5
1:5

julia> a
1

julia> b
3-element Vector{Int64}:
 2
 3
 4

julia> c
5

```
对于命名元组， 其解构时， 可以直接把元素的名字变成变量名。这时候顺序不是关键。请注意这时候左边圆柱的前面有一个分号。
```julia
julia> (; b, a) = (a=1, b=2, c=3)
(a = 1, b = 2, c = 3)

julia> a
1

julia> b
2
```
"""

# ╔═╡ 6dbfaa98-7bae-4b59-b4e9-f61248e5aa30
md"""
## Pair对象

用推出符号 => 可以构建pair对象。 当然， 也可以用Pair构造： 
```julia
Pair(x, y)
x => y
```
一个pair对象包含一个first元素， 和second元素。 看上去有点像命名元组,或者像一个字典。但在迭代时， 一个pair对象是一个整体。
"""

# ╔═╡ 87af3a4e-2c03-48ac-9263-ed2d2cf00cc4
p1 = "name"=>7

# ╔═╡ 8d0b07f1-d1c6-4645-988d-3ab502bc1a1c
p1.first

# ╔═╡ ea895254-2d2d-4d40-bf79-a1dafe5bc000
p1.second

# ╔═╡ 11198d9c-f7cf-4e7b-8926-c4254c721a03
md"""
## 字典Dict
字典也是常用的数据结构。字典中有键-值对， 通过键可以方便的获得值。可以用键值对元组向量构建字典， 也可以用键值对Pair构建字典。

```julia
Dict([(key1, value1), (key2, value2),...])
Dict(key1=>value1, key2=>value2,...)
```
对于字典， 可以使用keys，values函数分别获取由key和value构成的可迭代集。

### 字典相关操作
- haskey(collection, key) -> Bool 判断是否存在某个key
- get(collection, key, default) 获取某个key的值， 如果不存在这个key，返回default。对于字典， 可以直接使用中括号给定的key的方式获取key对应的值，即 **D[key]**, 但如果key不存在， 这种操作方法会出错。
- get!(collection, key, default) 获取某个key的值， 如果不存在这个key， 增加key=>default对，返回default
- delete!(collection, key) 删掉给定的key， 如果存在的话，并返回collectio。
- pop!(collection, key[, default]) 删掉给定的Key， 返回对应的值， 如果key不存在，返回默认值default， 这时候不指定默认值会出错。
- merge(d::AbstractDict, others::AbstractDict...)合并两个字典， 如果字典中具有相同的key，最后的字典中的对应值会被保留。
"""

# ╔═╡ b18bd2c2-56ad-4cf1-aaa8-b2b4936eebb1
D = Dict('a'=>2, 'b'=>3)

# ╔═╡ b0c34d32-1490-4070-a90e-cc76cf8f0019
keys(D), values(D)

# ╔═╡ 66e5e71c-85ac-45dd-9962-adb345907e45
haskey(D, 'a'), haskey(D, 'c')

# ╔═╡ 463d85eb-ca9b-4285-8756-d57f1e125560
D['a']

# ╔═╡ 4f9433bc-f6d2-4717-acfa-91a149e59ef6
get(D, 'a', 1), get(D, 'c', 1)

# ╔═╡ 0ad902f4-dd65-4929-b533-db3532b0ae25
md"""
## 集合set
Julia中实现了数学上集合的概念， 即集合包含的元素具有：互异性、无序性、确定性。集合常见的操作是：
- 判断元素是否在集合中（确定性） in
- 结合求并 union
- 求交 intersect
- 求差 setdiff
- 对称差 symdiff
具体请参考[集合相关文档](https://docs.julialang.org/en/v1/base/collections/#Set-Like-Collections)
"""

# ╔═╡ c92c9533-ad4d-4678-a8a5-22202200ca3d
5 in Set([1,2,3])

# ╔═╡ 21b613ce-fa2b-4fd4-b1df-973e81d47c4a
md"""
## 范围Range
简单来说，范围是指由一定范围内的具有某种特性的数据构成的一组元素。最常见的是一个等差数列。下面介绍一下怎么表示一个等差数列。 最常见的表示方法是用一个冒号运算符表示。
```julia
start:step:stop
```
上面的式子表示从Start开始， 公差是step， 到stop结束的等差数列的所有的项构成的范围。Stop可能是其中的项，也可能不是。如果step＝1， 那么step可以省略。

上面构造方法的一个缺陷是我们不知道这个等差数列包含了多少项?因此用range函数可以指定项数(length)。Range函数有四种用法。
```julia
range(start, stop, length)
range(start, stop; length, step)
range(start; length, stop, step)
range(;start, length, stop, step)
```

由于范围类型描述的是具有某种特性的值构成的一个集合，所以范围并不会把所有的元素都列出来。因此通常情况下，如果想了解范围中包括了哪些数据需要使用collect函数。

```julia
julia> 1:1.2:10
1.0:1.2:9.4

julia> collect(1:1.2:10)
[1.0, 2.2, 3.4, 4.6, 5.8, 7.0, 8.2, 9.4]
```
Collect函数可以实现将一个范围内的所有数据都**收集**到一个向量中。
"""

# ╔═╡ 10bb3dd2-9301-4717-8c6d-88d5673bf6ee
md"""
**函数调用：**上面给出的range函数有四种调用方式，我们应该怎么去调用呢？或者Julia是怎么实现一个名字（range）可以实现多种不同功能的呢？

在编程语言中， 一个名字（函数）在不同语境中可以表示不同含义（不同的调用方式，实现不同的功能），被称为多态。在C++、Python等语言中， 是通过对象实现多态的，即不同的对象调用相同的函数可能得到不同的结果。

在Julia中， 通过**多重分派**实现多态。一个函数名只是给出了一个通用的功能(generic function)。然后对这个功能的不同实现表示该函数的方法（method）。上面就给出的range函数的四个方法。可以通过`methods`函数查看一个函数有多少个方法。

Julia是怎么根据用户输入的参数去判断要调用哪个方法的呢？答案隐藏在Julia的多重分派（multiple dispatch）里。简单来说， 多重分派的意思是：一个函数在寻找匹配的方法时， 根据其多个参数的类型去确定要调用的方法。当然， 并非所有的参数都会用于多重分派。只有参数列表里，分号；前面的参数（称为**位置参数**）会起作用（也就是给出的位置参数类型及顺序不同， 调用的方法就不同）。这些参数在调用的时候， 不需要给出参数名， 直接按顺序给出参数值即可。分号后的参数通常被称为**关键字参数**， 关键字参数在赋值时， 需要给出关键字的名字。在函数调用时， 位置参数和关键字参数不需要用分号隔开。 所以， 你知道下面的代码的含义吗？
```julia
range(1,10, 2)
range(1,10, length=2 )
range(1,10, step=2 )
```
""" |> box

# ╔═╡ 6501554b-2576-42b4-a8cf-d572231486ca
md"""
## 容器类型
[容器类型Collections](https://docs.julialang.org/en/v1/base/collections/)并非一种特定的数据类型， 而是多种数据类型的一种抽象。 直观上来说， 只要能够从中不断读取出元素的类型都是容器类型。

为什么要单独提容器类型呢？因为Julia中， 很多的操作对容器类型都是有效的。具体可以参考其[文档](https://docs.julialang.org/en/v1/base/collections/)。 在Julia中， 上述所有的数据类型，包括后续讲到的数组类型等都是容器类型。因此， 有很多的函数（操作）同时适用于上述所有类型。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Box = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Box = "~1.0.14"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "72a9292ad3d0000381c02f99b5b280918f284dc2"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "297b6b41b66ac7cbbebb4a740844310db9fd7b8c"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Box]]
deps = ["HypertextLiteral", "Markdown"]
git-tree-sha1 = "bee6dbf5fa690f991d4c3b018cbfbb206e59dc18"
uuid = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
version = "1.0.14"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

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
# ╠═da6e322b-cf26-4803-9b34-19bf4c6f00bc
# ╟─6c6e3068-406c-4c8a-b28c-ef1fa33cfe72
# ╟─4e6d9031-873e-49c1-9de5-79c88d186ecb
# ╟─406811f6-0c24-4d75-b222-d581fe829d92
# ╟─c0ab05eb-dcbb-42e9-8bca-32bcfb3c05ac
# ╟─c95c7bef-f2bc-42fd-81d0-706c95b75eff
# ╟─1ed8d6b2-47e2-4920-918e-da5124e6140e
# ╠═84fb76fd-7f94-4b81-9b36-210df016a2c8
# ╟─e2c49ef4-191b-423c-9342-5c254278d032
# ╟─6dbfaa98-7bae-4b59-b4e9-f61248e5aa30
# ╠═87af3a4e-2c03-48ac-9263-ed2d2cf00cc4
# ╠═8d0b07f1-d1c6-4645-988d-3ab502bc1a1c
# ╠═ea895254-2d2d-4d40-bf79-a1dafe5bc000
# ╟─11198d9c-f7cf-4e7b-8926-c4254c721a03
# ╠═b18bd2c2-56ad-4cf1-aaa8-b2b4936eebb1
# ╠═b0c34d32-1490-4070-a90e-cc76cf8f0019
# ╠═66e5e71c-85ac-45dd-9962-adb345907e45
# ╠═463d85eb-ca9b-4285-8756-d57f1e125560
# ╠═4f9433bc-f6d2-4717-acfa-91a149e59ef6
# ╟─0ad902f4-dd65-4929-b533-db3532b0ae25
# ╠═c92c9533-ad4d-4678-a8a5-22202200ca3d
# ╟─21b613ce-fa2b-4fd4-b1df-973e81d47c4a
# ╟─10bb3dd2-9301-4717-8c6d-88d5673bf6ee
# ╟─6501554b-2576-42b4-a8cf-d572231486ca
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
