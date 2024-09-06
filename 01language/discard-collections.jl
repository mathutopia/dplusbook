### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 547d1aad-ede7-4584-b150-3cfbecbf90ec
begin
using PlutoUI
TableOfContents(title="目录")
end


# ╔═╡ d7f70e39-ca2e-41c6-b8ad-9c0fbe29e9a1
md"""
# 容器类型（Collections）
[容器类型Collections](https://docs.julialang.org/en/v1/base/collections/)
容器类型并非一种特定的数据类型， 而是多种数据类型的一种抽象。 直观上来说， 只要能够从中不断读取出元素的类型都是容器类型。

为什么要单独提容器类型呢？因为Julia中， 很多的操作对容器类型都是有效的。上面给出的向量的统计里的函数， 很多都对容器适用。 具体可以参考每一个函数的文档。 容器类型定义了多种函数， 具体可以参考其[文档](https://docs.julialang.org/en/v1/base/collections/)

容器类型只是说容器找中存在很多数据， 至于这些数据是如何存储的， 又是怎么取出来的并没有规定。 因此， 存在多种不同特性的容器类型。

一个简单的分类就是： 1）可迭代类型； 2)可索引类型； 3）其他类型。 可迭代类型是是可以按顺序不断的提取出元素。按顺序的意思是，不能跳跃着提取元素； 而可索引类型则是给定了一种索引， 可以通过索引去直接提取对应元素。 


"""

# ╔═╡ 111ce5cd-0535-41c0-96d8-ef85b409245a
md"""
!!! info "集合还是容器？"
    在计算机资料中， 集合（set）和容器（collection）都被翻译为集合。 但在这两者在Julia里是不一样的。 首先，Julia中存在集合（set)类型， 它有明确的定义。 另一方面， Julia更符合数学规范， collection的性质明显是不符合集合的定义的。在数学上，集合的元素满足确定性、无序性、互异性等三个性质， 而这里的容器则定义的宽泛的多。
""" 

# ╔═╡ aaa10bac-2268-4229-915b-6ddeb0bd9912
md"""
## 可迭代类型（Iteration）
容器的要求是能从中读取不断读取出元素。 其中， 能够按某种顺序读取出全部元素的容器是一种非常常见的容器， 称为可迭代容器。  

要让一个容器变成可迭代很简单。 只需要定义清楚， 如何从容器中按顺序取出元素即可。 

常见的for循环中， 循环变量取值的集合（下面的iter）展示了一个迭代类型应该满足的基本条件， 即能够按顺序的取出容器中的元素。
```julia
for i in iter   # or  "for i = iter"
    # body
end
```
在每一次迭代时， for循环需要知道当前的值是多少， 这个值会被绑定给i进行处理。 从逻辑上来说， for循环实现的功能应该与如下的while循环一致。
```julia
next = iterate(iter) # 从容器中取出一个元素
while next !== nothing  # 取出的是实实在在的元素
    (i, state) = next # 将这个元素解构成待处理的值和状态
    # 处理值
    next = iterate(iter, state) # 读取下一个元素
end
```
上面的while循环中， 最重要的就是iterate函数。这个函数用于从容器中获取一个值和当前的状态。 这个函数就是实现迭代容器的核心函数。


正式的说， 一个可迭代容器是指这样一个容器， 在该类对象上， 定义了一个iterate函数：

`iterate(iter [, state]) -> Union{Nothing, Tuple{Any, Any}}`

该函数实现在容器中（iter）， 根据当前的状态（state）， 获取容器中的下一个值和下一个状态。 一般， 值和状态构成一个元组。 如果聚合中的元素全部取出， 那么再次迭代获取的值将是nothing。 上面的返回值类型`Union{Nothing, Tuple{Any, Any}}`表明这个函数的返回值可是是Nothing类型， 也可以是两个元素的元组类型， 因此， 返回类型是这两种类型的联合类型（Uninon）。


一个可迭代类型可能还实现了IteratorSize和IteratorEltype等特性（这些特性统称为可迭代特性）， 可以用于求迭代器中的元素数量和元素类型。 当然， 只要定义了上面的iterator函数， 一个类型就自动实现了很多迭代操作。 这里可以看到可迭代类型的[通用接口函数](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration)。

下面这些类型都定义了可迭代类型接口， 因此都是可迭代类型。

```
AbstractRange
UnitRange
Tuple
Number
AbstractArray
BitSet
IdDict
Dict
WeakKeyDict
EachLine
AbstractString
Set
Pair
NamedTuple
```
"""

# ╔═╡ a8d97066-76cb-4730-a7e5-a4157d1caab8
md"""
### 平方序列
下面， 我们用迭代类型实现一个由自然数1...n的平方构成的迭代类型。 （你当然可以用向量等实现， 但这显然需要将每一个元素都存起来， 用迭代器，我们根本不需要存储那么多数据）。

简单来说， 一个迭代类型是一个自定义类型， 在该类型上， 我们定义了一个iterator函数。
"""

# ╔═╡ 0138ab4b-06f6-4b87-a6b7-ef00c9b2d65c
struct Squares
    count::Int 
end

# ╔═╡ 4339f403-7c3d-47b6-95c9-d080db44ea30
md"""
上面定义的结构只有一个字段，这个字段用于表示频繁序列包含了多少个元素。注意，这里我们并不需要将我所有元素都存起来，而只有一个元素数量的变量。接下来需要在这个自定义类型上定义一个函数`iterate`,这个函数需要在给定自定义的对象和状态之后， 计算出下一个状态。默认情况下状态取值为一。每一次调用状态都会增加1。当状态达到这个类型的最大数量的时候， 状态会变成nothing，表示数据都取完了。
"""

# ╔═╡ 89a4b054-7338-4f1c-9bcf-203b0063bcdc
 Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)

# ╔═╡ 8e8af379-66c1-4098-8120-493961aee4e7
md"""
!!! warn "定义iterate函数"
	注意， 定义iterate函数时， 前面的Base.是必须的， 这表示， 我们要给Base包中的iterate函数增加一个方法， 即增加一个能够处理（迭代）我们自定的类型的方法。 通常我们要给某个包的函数增加方法时， 需要首先import 这个包， 然后再定义包含包名的函数。 不过， 因为Base包是Julia自动加载的， 我们不需要import。
""" 

# ╔═╡ 943ca96b-a6b2-40a0-b912-edc0a51a4326
md"""
上面的平方序列迭代对象已经很厉害了， 比如， 你可以对这种类型的对象进行常见的for循环迭代
"""

# ╔═╡ 9ff591fa-8ceb-4271-9086-73112e8e884a
for item in Squares(7)
    println(item)
end

# ╔═╡ a4828633-46f6-4165-bd23-9fa84d83d959
md"""
你可以判断一个元素是否在该容器中， 对该容器求和、求最大值等。
"""

# ╔═╡ ca84e43c-9415-47ff-a8ff-60c5af00478b
25 in Squares(7)

# ╔═╡ eb8a4c8d-82fb-4b4b-b9f9-c18e705e4ec3
sum(Squares(7))

# ╔═╡ 39a91c72-1c1c-427d-9275-b48d2b0a9101
maximum(Squares(7))

# ╔═╡ a5d6e91b-0f64-4f63-9c18-b140cbd72cc6
s = Squares(7)

# ╔═╡ de464200-a66c-417a-8036-9099e4ac8ae9
isempty(s)

# ╔═╡ ef346dac-3f1a-4a2a-8138-b110c2074fd5
md"""
一个这样的迭代类型还是非常强大的， 因为我们只需要存储一点数据和编写一个简单函数就可以实现对大量（甚至无穷）元素的迭代。如果用数组， 需要很大的存储空间。

当然， 有时候， 我们可能希望将这种迭代类型转换为用数组（向量）来存储。 这时候， 我们需要使用`collect`函数。`collect`函数的作用是把容器中的所有元素都收集起来形成一个向量。

当然， 为了能够自动处理， 系统需要知道这个迭代类型的元素是什么类型， 以及它的元素数量是多少。 只有这样， 才能预分配数组， 用于存储各个元素。 这只需要定义两个简单函数就可以了。
"""

# ╔═╡ 23d699fd-e814-4883-9b96-e061827dff54
 Base.eltype(::Type{Squares}) = Int # 我们知道， 平方序列肯定都是整数

# ╔═╡ 040f040f-9be7-4a1e-8035-6cb33a000ba2
Base.length(S::Squares) = S.count # 序列长度就是记录在结构的count域中

# ╔═╡ 4d4a27f1-5271-41cf-a494-5eea51e0b23f
collect(s)

# ╔═╡ c0c8fe7f-2956-4519-aa55-a3ecdbc2e922
md"""

### 斐波拉契序列
斐波拉契序列是一个非常有名的序列。该序列满足如下条件：


```math
x_1=1, x_2=1, x_{n} = x_{n-1} + x_{n-2}\ for\ n \geq 3      
```

下面用上面的思路可以实现一个斐波拉契序列。类似的我们也不需要存储序列的每一个值。而是存储序列总共有多少个值就行了。


"""

# ╔═╡ 364512eb-8cdf-4a31-a19b-7f98c83ff9bd
struct Fib
    n::Int
end

# ╔═╡ 78af836f-754f-44ee-bd3e-687b29725459
Base.iterate(fib::Fib, state=(1,1,1)) = 
	state[1] > fib.n ? nothing : state[1] == 1 ? (1, (2,1,1)) : state[1] == 2 ? (1, (3, 1,1)) :	(state[2]+state[3], (state[1]+1, state[2] + state[3], state[2]))

# ╔═╡ 0c05d426-42db-4601-aa19-39724b824397
for item in Fib(50)
	@show item
end

# ╔═╡ 981d0195-6610-43b0-a0b9-8bdf8d825df3
for (i,item) in enumerate(Fib(50))
	println("x_$i = " * string(item))
end

# ╔═╡ ac51a2e4-fa61-4d9c-a1a8-b41708d1ef95
md"""
## 特殊容器－范围的类型与构造

容器并没有规定其中的元素要具有某种特征。 因此， 容器的构造可能有多种方式。 在实际应用中， 范围类型是一种常见的容器。 这种容器中的元素都在某一个范围内， 而且元素之间存在固定的间隔等特性。 

 一个范围类型就是规定了由某个范围内的值构成的容器。 Julia有各种范围， 下面简单介绍一下。 

### 类型结构

- AbstractRange
	AbstractRange {T}
	包含T类型元素的范围类型的超类型。

- OrdinalRange
	OrdinalRange{T, S} <: abstracrange {T}
	具有T类型元素且间距为s类型的有序范围的超类型。步长应该始终是一个单位的精确倍数，并且T应该是一个“离散”类型，其值不能小于一个单位。例如，Integer或Date类型可以满足条件，而Float64则不行(因为该类型可以表示小于一个单位的值(Float64))。 UnitRange、StepRange和其他类型都是它的子类型。

- AbstractUnitRange
	AbstractUnitRange{T} <: OrdinalRange{T, T}
	步长为一个单位(T)且元素类型为T的范围的超类型。UnitRange和其他类型是它的子类型。

- StepRange
	StepRange{T, S} <: OrdinalRange{T, S}
	每个元素之间的步长是常数，范围用类型为T的开始和停止以及类型为S的步长来定义。T和S都不能是浮点类型。语法a:b:c与b != 0和a, b和c都是整数创建一个StepRange。

- UnitRange
	UnitRange {T<:Real}
	由类型为T的开始和停止参数化的范围，由从开始到超过停止间隔为1的元素填充。语法a:b与a和b都是整数创建一个UnitRange。

- LinRange
	LinRange {T、L}
	在它的开始和结束之间有len个线性间隔元素的范围。空格的大小由len控制，它必须是一个整数。



"""

# ╔═╡ ece031b0-c900-4469-877b-caad15e7fdf4
plantuml"""
@startmindmap
<style>
mindmapDiagram {
  .specific {
    BackgroundColor lightgreen
}
  .abstract {
    BackgroundColor #FFBBCC
  }
  .path {
    BackgroundColor lightblue
  }
}
</style>
* AbstractRange{T} <<abstract>>
** OrdinalRange{T, S}  <<abstract>>
*** StepRange{T, S}   <<specific>>
*** AbstractUnitRange{T}  <<abstract>>
**** UnitRange{T<:Real}  <<specific>>
** LinRange{T,L}  <<specific>>
** StepRangeLen  <<specific>>
@endmindmap
"""

# ╔═╡ 9bbffd47-f4c1-414f-8c95-d1b5cccf5f7f
md"""
### 范围构造
上图是自带范围类型的层次结构图。 为了图形显示方便的，`AbstractRange{T}`的父类型`AbstractVector`以及祖先类型Any没有显示出来。

从上图可以看出， StepRange、UnitRange， StepRangeLen和LinRange是四个具体的类型。因此， 一般而言， 我们了解这四种范围类型就行。 首先，可以通过这个类型名构造相应的类型， 不过这写起来可能有点多。 

简单来说， 这几个Range表达的都是类似于`a:b:c`的含义，因此可以直接用**冒号操作符构造范围**。StepRange就是用a，b,c都是整数。UnitRange是StepRange中b取1时的情形。 StepRangeLen可以用于浮点数形式的a,b,c。这三种范围是间隔大小已知， 但元素数量未知。 LinRange是已知数量，但间隔大小未知的范围。上面的冒号运算符无法构造这种形式的范围。

Base中有一个range函数， 可以实现常见范围的构建。 range函数不能构造出LinRange类型的范围， 虽然从效果上没有本质的区别。
```julia
range(start, stop, length)
range(start, stop; length, step)
range(start; length, stop, step)
range(;start, length, stop, step)
```
"""

# ╔═╡ ab4d934d-6e22-4a64-af43-9b0b436084dd
md"""
在容器迭代的过程中，很多时候我们可能只需要容器中的元素就行了。那么下面的for循环就够了。我们不需要关注这个背后是如何实现的。
```julia
for item in collection
# 处理item
end
```
但有时候我们不仅需要知道元素是什么，我们还需要知道这个元素对应的是第几个元素，或者更进一步这个元素的索引是什么？

"""

# ╔═╡ 892f2276-779a-47b6-b7de-36a931021cf6
md"""
## 通用操作
只要是容器类型， 下面的操作基本都实现了。 具体来说， 除了EachLine、和Pair, 实现了可迭代特性的所有类型都实现了下列容器的通用操作。 具体来说， 下面的类型都实现了。
	
```
AbstractRange
UnitRange
Tuple
Number
AbstractArray
BitSet
IdDict
Dict
WeakKeyDict
EachLine
AbstractString
Set
Pair
NamedTuple
```
具体来说，包括：
- 判断容器是否为空
```julia
isempty(collection) -> Bool
```
求容器的元素数量
```julia
length(collection) -> Integer
```



"""

# ╔═╡ 470272e2-9830-4fa1-a58b-dd3750ebc01f
md"""
## 可迭代容器
### 判断元素存在性
```julia
in(item, collection) -> Bool
∈(item, collection) -> Bool
```

与之相反， 判断不存在的话需要使用

```julia
∉(item, collection) -> Bool
∌(collection, item) -> Bool
```
值得注意的是， 如果item和collection都是多个元素， 如果我们要一次判断多个元素是否在一个容器中， 我们需要使用广播方式， 而且， 需要将collection构造成一个元组形式，或者用Ref包裹。 否则就会变成判断两个集合对应位置是否相等或不等了。

### 判断元素数据类型
```julia
eltype(type)
```
### 索引查询
查询一个元素或多个元素， 在一个容器中的位置（索引）， 存在多个则返回第一个的位置；不存在则返回nothing
```julia
indexin(a, b) # 判断a中的元素在b中首次出现的位置（索引）
```
"""

# ╔═╡ 3d5334a7-84ca-4158-9d18-596d2f526e24
let a = ['a', 'b', 'c', 'b', 'd', 'a'], b = ['a', 'b', 'c']
	indexin(a, b)
end

# ╔═╡ 32677c19-2845-4fa9-a5e2-c3505bece4a2
md"""
### 去重
有时候， 我们要去除一个容器中的重复元素。
```julia
unique(itr) # 直接去重
unique(f, itr) # 元素通过f的计算后重复再去重；
```
相关函数， 判断元素是否存在重复， 都相等？
```julia
allunique(itr) -> Bool
allequal(itr) -> Bool
```
"""

# ╔═╡ 9d44a723-fb87-442d-84af-d52ad9997f0a
md"""
例： 假如我们要找到一个向量中元素每个元素首次出现的位置索引， 可以如下操作
"""

# ╔═╡ 9df26f0e-21e1-4b03-9aaf-4ec697d0c2c7
au = [3.1, 4.2, 5.3, 3.1, 3.1, 3.1, 4.2, 1.7];

# ╔═╡ c7f89afc-b021-489d-9b54-8e09c1f47ed8
unique(au)

# ╔═╡ 2299cdc2-c819-4435-9d6b-fe875724bd75
indexin(unique(au), au)

# ╔═╡ 22c4cf8b-2b3c-4853-a03a-c89c4140fb9e
unique(i -> au[i], eachindex(au))

# ╔═╡ a9701741-afc1-4127-90d9-07becf1dc3bd
md"""
### 压缩操作(Reduce)
压缩操作的意思是将容器中的元素， 按照某种方式压缩为少量，甚至一个值。其基本用法如下：
```julia
reduce(op, itr; [init])
```
"""

# ╔═╡ 6e49836f-9ee5-4e41-909f-90475a3e2d81
md"""
下面是一个关于可迭代容器的简单总结。具体的函数极其应用案例可参考官方文档。

一：跟元素整体有关：
  1.   某个元素是否在容器中？in(intem, collection); 某些元素是否在某个容器中, collection要放进元组或者Ref()中
  2.   元素在容器中的首个索引  indexin(a,b)；如果a的元素不在b中， 则返回nothing。
  3.   所有元素都相同？allequal(itr)->bool，都不同allunique(itr)->bool
  4.   去除重复元素：重复可以体现在， 元素本身重复unique(itr)?元素在某个函数映射下重复？unique(f, itr)。对于数组， 还可以只在某个维度上操作unique(A::AbstractArray; dims::Int)。对于向量， 还可以直接修改容器：unique!(f, A::AbstractVector)， unique!(A::AbstractVector)，如果不考虑顺序，sort!(A); unique!(A)比unique!(A::AbstractVector)更有效率。

二、值压缩操作Reduce reduce(op, itr; [init])

  1.   压缩操作(Reduce): 压缩操作的意思是，将整个容器的元素变成数量更少的值。这通常会涉及到几个方面的问题：1）压缩的手段， 也就是值是怎么变成一个值的？这个压缩手段既可以是一个操作符op， 也可能是一个摘要函数, 比如max，min等等(如果是函数， 一般需要时数组容器)。摘要函数是用于获取一组数组的摘要信息的函数。2）通常可能需要一个初始值， 用于作为空容器的默认返回值。这个初始值需要一个中性值， 也就是不能影响最终结果。 比如，压缩手段是乘法，中性值为1， 加法对应中性值为0；求最大值，默认值应该是容器的最小值；求最小值，默认值是集合的最大值。当然， 对＋＊max，min, &,| 操作来说，这个是可选的。3）需要考虑运算符跟元素的结合性。如果结合顺序有影响， 需要使用foldl或foldr函数。比如，减法操作，左结合和右结合就完全不同。

reduce(op, itr; [init])
reduce(f, A::AbstractArray; dims=:, [init])

  2.   几个常见的压缩操作：: maximum(itr), minimum(itr),extrema(itr), sum(itr), prod(itr), any(itr), all(itr). 比通用的Reduce效率会更好。所以，在可以的情况下， 应该选择常用的方式。下面以maximum为例， 看看怎么一般有哪些接口：
  •  直接对元素求最大值，maximum(itr; [init])；
  •  元素经过函数计算后，再求最大值,maximum(f, itr; [init])
  •  对数组来说，总是可以指定维度：maximum(A::AbstractArray; dims)、maximum(f, A::AbstractArray; dims)
  •  总是可以预先构造一个结果向量，写入结果maximum!(r, A)，不能经过函数计算
  •  对求最大值来说，NaN是除missing以外的最大值；对求最小值来说，NaN是除missing以外的最小值。
其他函数简要介绍：
   ▪   extrema：求极值，同时最大值和最小值；
   ▪   sum: 求和。注，sum(A)和reduce(+, A)的区别是reducde不会扩充数据的位数， 因此，有可能出现数据越界。
   ▪   prod:求连乘和
   ▪   any:判断有元素为true？
   ▪   all：判断所有元素都为true？
   ▪   count：统计为true的元素个数；

三：索引操作
这类操作针对的是容器的索引。对数组来说，就是下标；对字典来说，可能是key等等。
  1.   求元素最大值对应的索引：argmax(r::AbstractRange)，
  2.   或者元素经过计算之后的最大值对应的索引：argmax(f, domain)
  3.   对数组来说， 总是可以指定维度， 返回指定维度上的值。argmax(A; dims) -> indices

四：同时需要值和索引
有时候， 我们同时需要值和索引， 这时候， 可以用findmax函数，对应还有findmin函数。
findmax(itr) -> (x, index)，
findmax(A; dims) -> (maxval, index)
findmax(f, domain) -> (f(x), index)
findmax!(rval, rind, A) -> (maxval, index)

五：对值做变换
对每个值都做同一个操作
  1.   不需要返回值 foreach(f, c...) -> Nothing；这里可以有多个可迭代对象， 当其中一个迭代完时，操作结束；
  2.   如果需要返回值，或者本质上是对集合做变换： map(f, c...) -> collection或者是map!(function, destination, collection...)
  3.   如果是对字典的值做变换， 那么可以map!(f, values(dict::AbstractDict))

六：值变换与值压缩同时进行
mapreduce(f, op, itrs...; [init]), 对应的， 如果压缩操作可以是有结合性要求的话，用下面两个操作：
mapfoldl(f, op, itr; [init])
mapfoldr(f, op, itr; [init])

七： 部分值提取
first(coll)/last(coll)：提取第一个/最后一个元素
first(itr, n::Integer)/last(itr, n::Integer)：提取前n个/后n个元素； 
Base.front(x::Tuple)::Tuple：提取前端， 只留最后一个元素； 
Base.tail(x::Tuple)::Tuple: 提取后端， 只留第一个元素；
step：提取一个范围的步长
collect: 收集所有的元素：

八：过滤
过滤相当于部分值提取，单不是简单的通过位置，而是通过判断元素是否满足某种条件。
filter(f, a): 提取容器a中f为true的元素，返回结果是容器的复制品数组,f是一个单参数函数；如果采用Iterators.filter(flt, itr)， 则返回值是一个可迭代对象。这个函数的时间是O(1)空间也是O(1)的。因为，函数是Lazy的。
filter可以创建一个过滤函数，filter(f)
对于字典， 函数可以处理key＝>value对。filter(f, d::AbstractDict)
对于数组：有时候， 我们需要越过对缺失值的判断：filter(f, skipmissing(arr)).
filter!(f, a):可以直接更新容器。

九：替换replace
  •  replace(A, old_new::Pair...; [count::Integer])：直接将旧的值替换为新的值， 旧和新是用pair给出。可以给出替换的数量count，满足数量之后就不会再换了。
  •  replace(new::Union{Function, Type}, A; [count::Integer])：不仅可以替换值，还可以将值替换为不同的类型（Type）或值的某个函数值。
  •  还有就地修改版本：replace!(A, old_new::Pair...; [count::Integer])/replace!(new::Union{Function, Type}, A; [count::Integer])


十：索引与值同时获得
对数组而言：
pairs(IndexLinear(), A) pairs(IndexCartesian(), A) pairs(IndexStyle(A), A)
可以指定索引类型和值；
对一般的容器：
pairs(collection)；可以获得key=>value形式的可迭代对象；


"""

# ╔═╡ 72ddae71-fe1b-4cfb-904a-48d0708517aa
md"""
## 运算
对集合中的所有元素做聚合运算[Reduce](https://docs.julialang.org/en/v1/base/collections/#Base.reduce-Tuple{Any,%20Any})。
```julia
reduce(op, itr; [init])
foldl(op, itr; [init]) # 当运算符不满足结合律时， 左结合；
foldl(op, itr; [init]) # 当运算符不满足结合律时， 右结合；
```
"""

# ╔═╡ 76396ef0-bfde-499b-8685-c0bad8d420bf
md"""
Collection
- 存在性问题
	***    ∉(item, collection) -> Bool
	*** in(item, collection) -> Bool
	***    indexin(a, b)

** 重复性问题
*** unique(itr)
*** allunique(itr) -> Bool
*** allequal(itr) -> Bool

** 计算问题
***    reduce(op, itr; [init])
*** foldl(op, itr; [init])
*** foldr(op, itr; [init])
*** maximum(f, itr; [init])
*** minimum(f, itr; [init])
*** extrema(itr; [init]) -> (mn, mx)
*** argmax(f, domain)
*** argmin(r::AbstractRange)
*** findmax(f, domain) -> (f(x), index)
*** findmin(f, domain) -> (f(x), index)
*** sum(itr; [init])
*** prod(itr; [init])
*** any(itr) -> Bool
*** all(itr) -> Bool
*** count([f=identity,] itr; init=0) -> Integer

** 迭代问题
*** foreach(f, c...) -> Nothing
*** map(f, c...) -> collection
***    mapreduce(f, op, itrs...; [init])
***    zip(iters...)
    *** enumerate(iter)

** 提取元素
***    first(itr, n::Integer)
***    last(itr, n::Integer)
***    front(x::Tuple)::Tuple
***    tail(x::Tuple)::Tuple
*** Base.Iterators.peel
***    collect(collection)

** 过滤
***    filter(f, a)
***    replace(A, old_new::Pair...; [count::Integer])


"""

# ╔═╡ ff559581-ea9a-47cf-a028-a8ec54345c8e
md"""
## Iterators子模块
在Base模块中，还有一个子模块Iterators,专门用于处理可迭代的对象。 相对于Base模块， 这个模块里面的函数， 很多都是返回可迭代对象。 也就是这个模块里的函数， 可能是对应的Base模块中的函数的“懒惰(Lazy)”版本。

具体的相关内容可以参考[文档](https://docs.julialang.org/en/v1/base/iterators/#Iteration-utilities)。下面给出一些常用的函数。很多函数可能需要加上Iterators前缀， 比如Iterators.Stateful。

- zip(iters...):同时在多个可迭代对象上进行迭代。直到其中某一个被迭代完。它的返回元素是一个由各个可迭代对象里取出来的元素构成的元组。

- enumerate(iter):这个用于枚举一个迭代器里的元素，同时还要返回这个元素的序号， (i,x)。注意这里的序号不见得是一个合理的索引， 因为序号永远是从1开始， 只反应元素的顺序。如果想要枚举的过程当中获得一个合理的索引， 那么可以用这个函数pairs(IndexLinear(), iter)。

- Iterators.flatten(iter): 把多个可迭代对象前后按顺序拼接在一起。

- Iterators.repeated(x[, n::Int]):生成一个不断生产x的可迭代序列。如果指定n的话，那就是生成n个x的可迭的序列。

- Iterators.product(iters...):把多个可迭代器中的做笛卡尔积。越左边的可迭代对象变化越快。

- Iterators.partition(collection, n): 每n个元素做成一组去迭代，而不是每次只取一个元素。注意这里返回的n个元素仍然是可迭代对象而不是一个有n个元素构成的数组。

- Iterators.map(f, iterators...):懒惰版本的map函数。

- Iterators.filter(flt, itr):懒惰版本的过滤函数。

- Iterators.accumulate(f, itr; [init]):懒惰版本的积累函数Base.accumulate。

- Iterators.reverse(itr):继续叠单一个可迭代容器。

-  (item, rest) = Iterators.peel(iter)：从一个可叠在容器中，取出一个元素，同时返回一个后续元素构成的可迭代容器。

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "6e7bcec4be6e95d1f85627422d78f10c0391f199"

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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

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
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

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
# ╠═547d1aad-ede7-4584-b150-3cfbecbf90ec
# ╟─d7f70e39-ca2e-41c6-b8ad-9c0fbe29e9a1
# ╟─111ce5cd-0535-41c0-96d8-ef85b409245a
# ╟─aaa10bac-2268-4229-915b-6ddeb0bd9912
# ╟─a8d97066-76cb-4730-a7e5-a4157d1caab8
# ╠═0138ab4b-06f6-4b87-a6b7-ef00c9b2d65c
# ╟─4339f403-7c3d-47b6-95c9-d080db44ea30
# ╠═89a4b054-7338-4f1c-9bcf-203b0063bcdc
# ╟─8e8af379-66c1-4098-8120-493961aee4e7
# ╟─943ca96b-a6b2-40a0-b912-edc0a51a4326
# ╠═9ff591fa-8ceb-4271-9086-73112e8e884a
# ╟─a4828633-46f6-4165-bd23-9fa84d83d959
# ╠═ca84e43c-9415-47ff-a8ff-60c5af00478b
# ╠═eb8a4c8d-82fb-4b4b-b9f9-c18e705e4ec3
# ╠═39a91c72-1c1c-427d-9275-b48d2b0a9101
# ╠═a5d6e91b-0f64-4f63-9c18-b140cbd72cc6
# ╠═de464200-a66c-417a-8036-9099e4ac8ae9
# ╟─ef346dac-3f1a-4a2a-8138-b110c2074fd5
# ╠═23d699fd-e814-4883-9b96-e061827dff54
# ╠═040f040f-9be7-4a1e-8035-6cb33a000ba2
# ╠═4d4a27f1-5271-41cf-a494-5eea51e0b23f
# ╟─c0c8fe7f-2956-4519-aa55-a3ecdbc2e922
# ╠═364512eb-8cdf-4a31-a19b-7f98c83ff9bd
# ╠═78af836f-754f-44ee-bd3e-687b29725459
# ╠═0c05d426-42db-4601-aa19-39724b824397
# ╠═981d0195-6610-43b0-a0b9-8bdf8d825df3
# ╟─ac51a2e4-fa61-4d9c-a1a8-b41708d1ef95
# ╟─ece031b0-c900-4469-877b-caad15e7fdf4
# ╟─9bbffd47-f4c1-414f-8c95-d1b5cccf5f7f
# ╟─ab4d934d-6e22-4a64-af43-9b0b436084dd
# ╟─892f2276-779a-47b6-b7de-36a931021cf6
# ╟─470272e2-9830-4fa1-a58b-dd3750ebc01f
# ╠═3d5334a7-84ca-4158-9d18-596d2f526e24
# ╟─32677c19-2845-4fa9-a5e2-c3505bece4a2
# ╟─9d44a723-fb87-442d-84af-d52ad9997f0a
# ╠═9df26f0e-21e1-4b03-9aaf-4ec697d0c2c7
# ╠═c7f89afc-b021-489d-9b54-8e09c1f47ed8
# ╠═2299cdc2-c819-4435-9d6b-fe875724bd75
# ╠═22c4cf8b-2b3c-4853-a03a-c89c4140fb9e
# ╟─a9701741-afc1-4127-90d9-07becf1dc3bd
# ╟─6e49836f-9ee5-4e41-909f-90475a3e2d81
# ╟─72ddae71-fe1b-4cfb-904a-48d0708517aa
# ╟─76396ef0-bfde-499b-8685-c0bad8d420bf
# ╟─ff559581-ea9a-47cf-a028-a8ec54345c8e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
