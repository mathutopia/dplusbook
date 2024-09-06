### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 79eab523-738c-4469-81ab-cc0530733ac0
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ d91a9d5f-8050-4754-9bc0-f379621fe1bf
TableOfContents(title="目录")

# ╔═╡ 5905fc1b-3281-41b1-9ffc-10e173bc0759
present_button()

# ╔═╡ ced691c0-298e-4f44-8f16-661f95ff760c
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Julia简短教程
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 6c6e3068-406c-4c8a-b28c-ef1fa33cfe72
md"""
## 元组(Tuple)
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


"""

# ╔═╡ 4e6d9031-873e-49c1-9de5-79c88d186ecb
md"""
!!! info "复合数据类型的类型"
	注意上面复合数据类型的表示形式。 一个重要的特征就是存在一对大括号。比如，`Tuple{Float64, String, Int64}`， 其中Tuple可以看成是主要类型的名字， 大括号中间的类型显示的是元素的类型。从这个类型表示可以看出很多东西， 比如由于大括号中间只有三个元素， 所以元组是由3个元素构成， 同时每一个元素类型也是给定的。  
	
	类型名字和大括号是一个整体, 所以变量x和y是不同的元组类型。 
	
	事实上， 类型后面的大括号表明这是一个**参数类型**。 所谓参数类型是指一个类型包含一些类型参数， 这些类型参数主要用于限定复合的元素的类型。  

""" 

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
!!! warn "注意"
	上面命名元组的类型参数中有两个元组，一个是名字构成的元组， 其元素都是Symbol；另一个才是真正的元组Tuple。 
""" 

# ╔═╡ c95c7bef-f2bc-42fd-81d0-706c95b75eff
md"""
!!! info "NTuple补充" 
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
""" 

# ╔═╡ 8a07fd51-e1d1-4cc4-bee8-ebde1026d073
md"""
在Julia语言中，元组（Tuple）和命名元组（Named Tuple）是两种有用的数据结构，它们在函数参数传递、返回值以及数据存储等方面发挥着重要作用。

### 元组（Tuple）

元组是Julia中一种基本的复合数据类型，用于存储不同数据类型的有序集合。元组一旦创建，其内容就是不可变的，即不能修改元组中的元素。

**特点：**
- 有序集合
- 内容不可变
- 可以包含不同类型的元素

**创建元组：**
```julia
julia> t = (1, "hello", 3.0)
(1, "hello", 3.0)
```

**访问元组元素：**
```julia
julia> t[1]
1

julia> t[2]
"hello"
```

**使用场景：**
- 作为函数的返回值，一次性返回多个值。
- 作为不可变数据的存储，保证数据的安全性。

### 命名元组（Named Tuple）

命名元组是元组的一种扩展，其中的元素可以通过名称来访问，而不仅仅是通过索引。

**特点：**
- 有序集合
- 内容不可变
- 元素可以通过名称访问

**创建命名元组：**
```julia
julia> nt = (a=1, b="hello", c=3.0)
(a = 1, b = "hello", c = 3.0)
```

**访问命名元组元素：**
```julia
julia> nt.a
1

julia> nt.b
"hello"
```

**使用场景：**
- 需要明确标识符来访问元素的场景，比如函数参数的配置选项。
- 作为字典的轻量级替代，当只需要少量键值对时。
"""

# ╔═╡ 830d93fe-e238-40ee-a477-348e1576db36
md"""
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
""" |> danger

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

# ╔═╡ cd4a41d8-22c8-4d0e-b8d2-065cd73ae268
md"""
## 向量Vector
在Julia语言中，向量（Vector）是最基本的一维数组类型，用于存储同类型数据的有序集合。向量是可变的，这意味着可以修改向量中的元素。

**特点：**
- 有序集合
- 内容可变
- 通常包含相同类型的元素，但也可以包含不同类型的元素（称为异质向量）
### 向量的创建
在 Julia 中，创建向量（Vector）有多种方法，以下是一些常见的创建向量的方式，每种方式都有其特定的应用场景：
当然，我们可以将 Julia 中创建向量的方法归类为以下几种主要类别：

#### 1. 直接定义
- **列表初始化**：直接在方括号中列出元素。
  ```julia
  v = [1, 2, 3, 4, 5]
  ```

#### 2. 函数构造
- **`zeros`**：创建元素全为 0 的向量。
  ```julia
  v = zeros(5)
  ```
- **`ones`**：创建元素全为 1 的向量。
  ```julia
  v = ones(4)
  ```
- **`fill`**：创建元素全为指定值的向量。
  ```julia
  v = fill(7, 6)
  ```

#### 3. 范围和序列
- **范围表示**：使用 `:` 运算符创建连续整数的向量。
  ```julia
  v = 1:10
  ```
- **生成器表达式**：通过表达式生成元素。
  ```julia
  v = [x^2 for x in 1:5]
  ```

#### 4. 集合转换
- **`collect`**：将任何可迭代对象转换为向量。
  ```julia
  v = collect(1:2:11)
  ```

#### 5. 动态修改
- **`push!`**：向向量末尾添加一个或多个元素。
  ```julia
  push!(v, 4)
  ```
- **`append!`**：向向量末尾添加另一个向量的元素。
  ```julia
  append!(v, [4, 5])
  ```

#### 6. 重塑和变换
- **`reshape`**：将一维向量或数组重新排列成新的维度。
  ```julia
  v = reshape(1:6, 2, 3)
  ```

这些方法提供了灵活的方式来创建向量，以满足不同的需求和场景。


与元组和命名元组相比，向量的主要区别在于它们的可变性和元素类型的一致性。元组和命名元组通常用于存储不应改变的数据，而向量则更适用于需要动态修改的场景。此外，向量在数学和科学计算中非常常用，因为它们提供了丰富的数组操作和广播功能。
"""

# ╔═╡ a0fff9a7-b61e-443c-bc22-5e99595d8627
md"""
### 向量的访问
在 Julia 中，向量（Vector）和元组（Tuple）是两种常用的有序集合类型，它们都支持通过索引访问其中的元素。**Julia 的索引是从 1 开始的**，这与其他一些编程语言（如 C、Python 等，它们的索引从 0 开始）不同。此外，Julia 提供了 `begin` 和 `end` 这两个关键字，用于在索引操作中表示序列的开始和结束。

#### 1. 索引访问

在 Julia 中，你可以通过在方括号 `[]` 中提供索引来访问向量或元组中的元素。

**向量示例**：
```julia
v = [10, 20, 30, 40, 50]
println(v[1])  # 输出第一个元素，结果为 10
println(v[end])  # 输出最后一个元素，结果为 50
```

**元组示例**：
```julia
t = ('a', 'b', 'c', 'd')
println(t[2])  # 输出第二个元素，结果为 'b'
println(t[end])  # 输出最后一个元素，结果为 'd'
```

#### 2. 使用 `begin` 和 `end` 访问

`begin` 和 `end` 在 Julia 中用作表示序列开始和结束的特殊关键字。它们经常用于切片操作，即获取序列的一部分。

- `begin`：表示序列的第一个元素。
- `end`：表示序列的最后一个元素。

**向量切片示例**：
```julia
v = [10, 20, 30, 40, 50]
# 获取从第一个元素到第三个元素的切片
println(v[begin:3])  # 输出: [10, 20, 30]
# 获取从第三个元素到最后一个元素的切片
println(v[3:end])  # 输出: [30, 40, 50]
```

**元组切片示例**：
```julia
t = ('a', 'b', 'c', 'd')
# 获取从第一个元素到第二个元素的切片
println(t[begin:2])  # 输出: ('a', 'b')
# 获取从第二个元素到最后一个元素的切片
println(t[2:end])  # 输出: ('b', 'c', 'd')
```

在这些例子中，使用 `begin` 和 `end` 可以方便地表示序列的一部分，而不需要明确指出切片的起始和结束索引。这种用法在处理不确定长度的序列或者在需要动态确定切片范围时特别有用。

"""

# ╔═╡ 4f99e34a-01cb-457e-8e0c-246da1f3919d
md"""

## Pair类型


Pair类型在编程中是一种常见的数据结构，用于将两个相关的值组合成一个单一的对象。在Julia语言中，Pair是一个内置的类型，它存储了两个元素，通常称为“键”和“值”。

### 什么是Pair类型？
Pair类型是一个用于表示键值对的数据结构，它允许将两个相关的值组合成一个对象。这种结构在很多场景下都非常有用，比如在字典中存储数据或者在迭代过程中生成键值对。

### 如何构建Pair？
用推出符号 => 或者Pair类型构造函数可以构建Pair对象： 
```julia
Pair(key， value)
key => value
```
这里，`key`是Pair的第一个元素，通常用于标识或查找值，而`value`是第二个元素，是与键相关联的数据。


Pair类型在多种场景中发挥作用，主要包括：
1. **字典存储**：在字典中，每个键值对都是一个Pair对象，其中键用于唯一标识一个值。
2. **数据关联**：在迭代或数据处理过程中，Pair可以用来关联数据，比如在迭代过程中生成索引和值的对应关系。
3. **简便的数据打包**：Pair可以简洁地打包两个相关的数据项，使得数据的传递和操作更加方便。

"""

# ╔═╡ e077f43f-dc44-4594-ad3a-2bd225f78709
md"""
### 访问Pair元素
在Julia中，`Pair`对象的两个元素构成了一个整体，它们被存储在`Pair`的两个字段中：`first`和`second`。这两个字段分别对应于`Pair`的键（key）和值（value）。尽管它们是作为一个整体存储的，但可以分别使用`.first`和`.second`属性来访问。

```julia
# 创建一个Pair对象
p = "key" => 123

# 访问Pair的键和值
key = p.first
value = p.second

println("Key: $key, Value: $value")
```

输出将会是：
```
Key: key, Value: 123
```

除了直接访问`.first`和`.second`属性，还可以使用解构（destructuring）来同时获取键和值：

```julia
# 创建一个Pair对象
p = "key" => 123

# 使用解构获取键和值
key, value = p

println("Key: $key, Value: $value")
```

这也是一种非常简洁和常用的访问`Pair`元素的方法，输出同样会是：
```
Key: key, Value: 123
```
通过这些方式，可以方便地访问和操作`Pair`对象中的元素，无论是单独处理键或值，还是同时处理两者。
"""

# ╔═╡ 35ea0a67-7ce8-4dad-a7b9-c326f265712d
md"""
## 字典类型（Dict）
字典（Dict）是 Julia 语言中的一种数据结构，用于存储键值对（key-value pairs），其中每个键（key）映射到一个特定的值（value）。字典在编程中非常有用，因为它们允许你快速检索、更新和删除具有特定键的数据项。

### 什么是字典（Dict）？

- 字典是一种关联数组，其中的元素是键值对。
- 键和值可以是任何类型的对象，但键必须是可哈希的，以便字典能够高效地检索它们。
- 字典是无序的，这意味着元素的顺序并不是固定的。

### 字典的用途

- 快速查找：通过键快速访问值。
- 动态数据存储：在运行时动态添加、删除或修改数据项。
- 唯一性保证：每个键在字典中是唯一的，不会出现重复的键。

### 如何构造字典

1. **直接构造**：使用字面量语法或 `Dict` 函数直接创建字典。
   ```julia
   d = Dict("a" => 1, "b" => 2)  # 使用字面量语法
   d = Dict([("a", 1), ("b", 2)])  # 使用元组列表
   ```

2. **通过迭代器构造**：从一个键值对的迭代器创建字典。
   ```julia
   keys = ["a", "b"]
   vals = [1, 2]
   d = Dict(zip(keys, vals))  # 使用 zip 函数将键和值的列表组合起来
   ```

3. **空字典**：创建一个空字典，然后添加键值对。
   ```julia
   d = Dict{String, Int}()
   d["a"] = 1  # 添加键值对
   ```

### 如何访问字典

1. **通过键访问**：使用键来检索对应的值。
   ```julia
   val = d["a"]  # 获取键 "a" 对应的值
   ```

2. **使用 `get` 函数**：安全地访问字典，如果键不存在，则返回默认值。
   ```julia
   val = get(d, "a", 0)  # 如果 "a" 不存在，则返回 0
   ```

3. **使用 `get!` 函数**：如果键不存在，则插入默认值并返回该值。
   ```julia
   val = get!(d, "c", 3)  # 如果 "c" 不存在，则插入 "c" => 3 并返回 3
   ```

4. **遍历字典**：通过迭代键值对来处理字典中的每个元素。
   ```julia
   for (key, value) in d
       println("Key: $key, Value: $value")
   end
   ```

5. **查询操作**：检查键是否存在于字典中。
   ```julia
   haskey(d, "a")  # 检查键 "a" 是否存在
   ```

### 字典的方法和操作

- **更新值**：通过键来更新字典中的值。
  ```julia
  d["a"] = 10  # 更新键 "a" 对应的值为 10
  ```

- **删除键值对**：使用 `delete!` 函数删除字典中的键值对。
  ```julia
  delete!(d, "b")  # 删除键 "b" 及其对应的值
  ```

- **合并字典**：使用 `merge` 或 `merge!` 函数合并两个或多个字典。
  ```julia
  d1 = Dict("a" => 1, "b" => 2)
  d2 = Dict("b" => 3, "c" => 4)
  merged_d = merge(d1, d2)  # 合并 d1 和 d2
  ```

- **字典视图**：使用 `keys`、`values` 和 `pairs` 函数获取字典的键、值和键值对视图。
  ```julia
  keys(d)  # 获取所有键
  values(d)  # 获取所有值
  pairs(d)  # 获取所有键值对, 每一个键值对就是一个Pair对象。
  ```

字典是 Julia 中非常灵活和强大的数据结构，适用于各种需要快速查找和存储键值对的场景。
"""

# ╔═╡ e7dcaaa8-a66f-4a0a-8e19-f57190d19228
md"""
## 集合类型（Set）

在计算机科学和数学中，集合是一个无序的、不重复的元素序列。集合内的元素是唯一的，即不允许有重复的元素。集合的概念在许多编程语言和数据结构中都有广泛的应用，用于表示一组唯一的项。

### 集合的构造

在Julia语言中，可以使用`Set`类型来创建集合。 使用`Set()`可以创建一个空的集合，而`Set{T}()`可以创建一个特定类型的空集合。也可以直接传入一个可迭代对象来创建集合， 例如：
   ```julia
   s1 = Set()  # 创建一个空集合
   s2 = Set{Int}()  # 创建一个空的整数集合
   s3 = Set([1, 2, 3])  # 创建一个包含1, 2, 3的集合
   ```

2. **使用字面量语法**：
   Julia 允许使用大括号来创建集合，例如：
   ```julia
   s = Set([1, 2, 3])  # 等同于 Set(1, 2, 3)
   ```

### 集合的应用

集合在编程中有着广泛的应用，以下是一些主要的应用场景：

1. **成员资格测试**：
   集合提供了快速的成员资格测试功能，可以快速检查一个元素是否存在于集合中：
   ```julia
   s = Set([1, 2, 3])
   println(2 in s)  # 输出 true
   println(4 in s)  # 输出 false
   ```

2. **集合操作**：
   集合支持多种数学上的集合操作，如并集、交集、差集等：
   - **并集**：合并两个或多个集合中的所有元素，重复元素只保留一次。
     ```julia
     s1 = Set([1, 2, 3])
     s2 = Set([3, 4, 5])
     union_s = union(s1, s2)  # 输出 Set([1, 2, 3, 4, 5])
     ```
   - **交集**：返回两个或多个集合中共有的元素。
     ```julia
     intersect_s = intersect(s1, s2)  # 输出 Set([3])
     ```
   - **差集**：返回存在于第一个集合但不在第二个集合中的元素。
     ```julia
     setdiff_s = setdiff(s1, s2)  # 输出 Set([1, 2])
     ```

3. **去重**：
   集合天生具有去重的特性，可以用于去除数据中的重复项：
   ```julia
   data = [1, 2, 2, 3, 4, 4, 5]
   unique_data = Set(data)  # 输出 Set([1, 2, 3, 4, 5])
   ```

4. **集合的转换和迭代**：
   可以将集合转换为数组或其他数据结构，也可以迭代集合中的元素：
   ```julia
   s = Set([1, 2, 3])
   for element in s
       println(element)
   end
   ```
集合（Set）是Julia中一种基本的数据结构，它提供了一种有效的方式来存储不重复的元素集合，并支持快速的成员资格测试和各种集合操作。集合的构造简单，应用广泛，是处理数据去重和集合运算时的理想选择。
"""

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
!!! info "函数调用"
	上面给出的range函数有四种调用方式，我们应该怎么去调用呢？或者Julia是怎么实现一个名字（range）可以实现多种不同功能的呢？
	
	在编程语言中， 一个名字（函数）在不同语境中可以表示不同含义（不同的调用方式，实现不同的功能），被称为多态。在C++、Python等语言中， 是通过对象实现多态的，即不同的对象调用相同的函数可能得到不同的结果。
	
	在Julia中， 通过**多重分派**实现多态。一个函数名只是给出了一个通用的功能(generic function)。然后对这个功能的不同实现表示该函数的方法（method）。上面就给出的range函数的四个方法。可以通过`methods`函数查看一个函数有多少个方法。
	
	Julia是怎么根据用户输入的参数去判断要调用哪个方法的呢？答案隐藏在Julia的多重分派（multiple dispatch）里。简单来说， 多重分派的意思是：一个函数在寻找匹配的方法时， 根据其多个参数的类型去确定要调用的方法。当然， 并非所有的参数都会用于多重分派。只有参数列表里，分号；前面的参数（称为**位置参数**）会起作用（也就是给出的位置参数类型及顺序不同， 调用的方法就不同）。这些参数在调用的时候， 不需要给出参数名， 直接按顺序给出参数值即可。分号后的参数通常被称为**关键字参数**， 关键字参数在赋值时， 需要给出关键字的名字。在函数调用时， 位置参数和关键字参数不需要用分号隔开。 所以， 你知道下面的代码的含义吗？
	```julia
	range(1,10, 2)
	range(1,10, length=2 )
	range(1,10, step=2 )
	```
""" 

# ╔═╡ 2916c389-7af4-4336-9d8a-09aeb70c0b53
md"""
## 数组（Array）类型

数组在Julia中用于存储同类型数据的有序集合。它们可以是一维（向量）、二维（矩阵）或更高维度的。数组的每个元素都有一个唯一的索引，用于访问和操作数据。

### 数组的属性

数组在Julia中是多维的，每个数组都有一系列的属性，这些属性定义了数组的结构和存储的数据类型。

- **维度(N)**：数组的维度表示其在空间中扩展的方向数量。例如，向量是一维数组，矩阵是二维数组。高维数组可以被视为矩阵在多个方向上的扩展。

  - **相关函数**：`ndims(A)` 返回数组 `A` 的维度数。
  - **例子**：
    ```julia
    A = [1, 2, 3]  # 一维数组
    B = [1 2 3; 4 5 6]  # 二维数组
    C = rand(3, 3, 3)  # 三维数组
    ndims(A)  # 输出：1
    ndims(B)  # 输出：2
    ndims(C)  # 输出：3
    ```

- **大小(dims)**：每个维度的长度，通常表示为一个整数元组。数组的大小定义了其在每个维度上的扩展程度。用 `size` 函数可以返回一个表示各个维度长度的元组。

  - **相关函数**：
    - `size(A)` 返回数组 `A` 的尺寸。
    - `size(A, d)` 返回数组 `A` 在维度 `d` 的大小。
  - **例子**：
    ```julia
    A = [1, 2, 3, 4, 5]
    B = [1 2 3; 4 5 6; 7 8 9]
    size(A)  # 输出：(5,)
    size(B)  # 输出：(3, 3)
    size(B, 1)  # 输出：3 (第一维的大小)
    size(B, 2)  # 输出：3 (第二维的大小)
    ```

- **元素类型(T)**：数组中所有元素的共同数据类型，如 `Int`、`Float64` 等。这决定了数组可以存储的数据类型和执行的运算。

  - **相关函数**：
    - `eltype(A)` 返回数组 `A` 中元素的类型。
  - **例子**：
    ```julia
    A = [1, 2, 3]
    B = [1.0, 2.0, 3.0]
    eltype(A)  # 输出：Int64
    eltype(B)  # 输出：Float64
    ```

- **总元素数**：数组中所有元素的总数，可以通过将所有维度的大小相乘得到，或者使用 `length` 函数直接获取。

  - **相关函数**：
    - `length(A)` 返回数组 `A` 中元素的总数。
  - **例子**：
    ```julia
    A = [1, 2, 3, 4, 5]
    B = [1 2 3; 4 5 6]
    length(A)  # 输出：5
    length(B)  # 输出：6
    ```

- **内存布局**：数组的元素在内存中是如何存储的。Julia中的数组是按列存储的（列主序）。

  - **相关函数**：
    - `strides(A)` 返回数组 `A` 的步长，即在内存中移动到下一个元素需要跳过的字节数。
    - `pointer(A)` 返回数组 `A` 在内存中的起始地址。
  - **例子**：
    ```julia
    A = [1, 2, 3, 4, 5]
    strides(A)  # 输出：(1,)
    B = [1 2 3; 4 5 6]
    strides(B)  # 输出：(3, 1) (在内存中，先跳过3个元素到达下一行的开始，再跳过1个元素到达下一个元素)
    ```

- **可变性**：数组是可变的还是不可变的。Julia中的数组是可变的，这意味着可以修改数组中存储的数据。

  - **相关函数**：
    - `ismutable(A)` 检查数组 `A` 是否可变。
  - **例子**：
    ```julia
    A = [1, 2, 3]
    ismutable(A)  # 输出：true
    ```

"""

# ╔═╡ a156d361-e7d9-4a1d-a666-754471c2597e
md"""
### 构造数组

在Julia中，构造数组的方法多样，可以根据需要创建不同类型和形状的数组：

1. **直接列表**：通过将值放入方括号中来创建数组。这是最直观的数组创建方式。
   ```julia
   A = [1, 2, 3]  # 一维数组（向量）
   B = [1 2 3; 4 5 6]  # 二维数组（矩阵）
   ```

2. **使用构造函数**：`Array`构造函数允许用户指定数组的类型和大小，创建未初始化的数组。
   ```julia
   C = Array{Float64}(undef, 3, 3)  # 创建一个3x3的未初始化浮点数组
   ```

3. **使用特定函数**：Julia提供了多个函数来创建具有特定值的数组，如`zeros`、`ones`、`fill`等。
   ```julia
   D = zeros(3, 3)  # 创建一个3x3的全零矩阵
   E = ones(5)  # 创建一个包含5个1的向量
   F = fill(7, 3, 3)  # 创建一个3x3的矩阵，所有元素都是7
   ```

4. **使用范围和序列**：通过`range`函数或类似表达式创建数组。
   ```julia
   G = 1:5  # 创建一个1到5的整数范围
   H = 0.0:0.1:1.0  # 创建一个从0.0到1.0的浮点数序列
   ```

5. **使用随机数**：Julia的`rand`和`randn`函数可以用来生成随机数数组。
   ```julia
   I = rand(3, 3)  # 创建一个3x3的矩阵，元素为[0,1)区间的随机浮点数
   J = randn(4, 4)  # 创建一个4x4的矩阵，元素为标准正态分布的随机数
   ```

6. **复制和重复**：使用`copy`和`repeat`函数来复制数组或重复数组元素。
   ```julia
   K = copy(A)  # 复制数组A
   L = repeat([1, 2], 1, 3)  # 将向量[1, 2]重复3次，创建一个3x2的矩阵
   ```

7. **使用`reshape`**：改变数组的维度而不改变其数据。
   ```julia
   M = reshape(1:6, 2, 3)  # 将1到6的向量重塑为2x3的矩阵
   ```

8. **使用`cat`和`hcat`/`vcat`**：沿指定维度连接数组。
   ```julia
   N = cat(A, [4, 5, 6], dims=1)  # 垂直堆叠（沿第一维）
   O = hcat(B, [7 8 9; 10 11 12])  # 水平连接（沿第二维）
   ```

9. **使用`collect`**：将迭代器或其他对象转换为数组。
   ```julia
   P = collect(1:2:7)  # 将范围1:2:7转换为数组
   Q = collect("Hello")  # 将字符串"Hello"转换为字符数组
   ```
"""

# ╔═╡ 06938d7c-c0d8-40d1-a203-670571a5673e

md"""
### 向量化实现（点运算）

Julia语言的向量化实现，即点运算（dot syntax），允许用户对数组或任何可迭代对象中的每个元素应用函数，而无需显式循环。

- **基本点运算**：通过在函数名后加点（`.`）并传入数组，可以对数组的每个元素应用该函数。
  ```julia
  A = [1.0, 2.0, 3.0]
  squared = sin.(A)  # 对数组A中的每个元素应用sin函数
  ```

- **点运算与广播**：点运算实际上是广播（broadcasting）的一种语法糖，允许对多个数组或数组与标量的组合进行操作。
  ```julia
  B = [1, 2, 3]
  C = [4, 5, 6]
  added = B .+ C  # 逐元素相加
  scaled = 2 .* A  # 将数组A中的每个元素乘以2
  ```

- **点运算与函数组合**：可以结合点运算和函数组合，对数组进行链式操作。
  ```julia
  D = [0.5, 1.5, 2.5]
  result = sqrt.(cos.(D))  # 先对D中的每个元素应用cos函数，然后对结果应用sqrt函数
  ```

- **点运算与预分配**：为了提高性能，通常建议预先分配结果数组，并使用点运算进行就地更新。
  ```julia
  E = [1.0, 2.0, 3.0]
  F = similar(E)  # 创建一个与E相同类型的空数组
  F .= sin.(E)  # 在F中存储sin(E)的结果
  ```

- **点运算与宏**：Julia提供了`@.`宏，用于将表达式中的所有函数调用自动转换为点运算形式。
  ```julia
  @. F = sin(cos(E))  # 等价于F .= sin.(cos.(E))
  ```

- **点运算与条件**：点运算可以与条件表达式结合，进行基于条件的元素级操作。
  ```julia
  G = [10, 20, 30, 40, 50]
  positive = G .> 20  # 创建一个逻辑数组，其中满足条件的元素为true
  filtered = G[positive]  # 基于逻辑数组选择元素
  ```

- **点运算与自定义函数**：用户可以定义自己的函数，并使用点运算对数组的每个元素应用这些函数。
  ```julia
  function custom_func(x)
      return x^2 + 3x + 2
  end
  H = [1, 2, 3]
  custom_result = custom_func.(H)  # 对H中的每个元素应用custom_func函数
  ```

点运算是Julia语言中一种强大且灵活的机制，它使得数组操作简洁而高效。通过合理使用点运算，可以写出既简洁又高效的代码。


"""

# ╔═╡ aaa0ddcf-d00b-4009-bcfd-e14378783dac
md"""




### 向量化运算与传播

Julia中的向量化运算允许直接在数组上执行数学运算，而无需显式循环：

- **向量化操作**：如加法、乘法等，可以直接应用于数组。
  ```julia
  v = [1, 2, 3]
  w = [4, 5, 6]
  z = v + w  # 元素逐一相加
  ```

- **传播**：使用点操作符（`.`），将函数应用于数组的每个元素。
  ```julia
  v = [1, 2, 3]
  w = [4, 5, 6]
  z = v .* w  # 元素逐一相乘
  ```

### 常用的数组函数

Julia提供了许多用于操作数组的函数，以下是一些常用的：

- **`sum(A)`**：计算数组`A`的元素总和。
- **`mean(A)`**：计算数组`A`的元素平均值。
- **`maximum(A)`** 和 **`minimum(A)`**：分别找到数组`A`中的最大值和最小值。
- **`sort(A)`**：将数组`A`的元素进行排序。
- **`push!(A, item)`** 和 **`pop!(A)`**：向数组`A`添加元素和从数组`A`中移除元素。
- **`append!(A, B)`**：将数组`B`的元素添加到数组`A`的末尾。

### 数组的拼接

Julia提供了多种数组拼接的方法：

- **`vcat(A...)`**：垂直拼接数组。
- **`hcat(A...)`**：水平拼接数组。
- **`cat(A...; dims)`**：沿指定维度拼接数组。

### 数组的视图和切片

- **`view(A, inds...)`**：返回数组`A`的视图，而不是数据的副本。视图是轻量级的，并且修改视图会影响原始数组。
- **`@view A[inds...]`**：宏，用于创建数组`A`的视图。

### 数组的转换和重塑

- **`reshape(A, dims...)`**：返回具有新维度的数组，其数据与原始数组`A`相同。
- **`permutedims(A, perm)`**：根据给定的排列`perm`重新排列数组`A`的维度。

### 数组的搜索和排序

- **`findall(A)`**：返回数组`A`中所有`true`值的索引。
- **`findfirst(A)`**：返回数组`A`中第一个`true`值的索引。
- **`sort(A)`**：对数组`A`的元素进行排序。

### 结论

Julia的数组是进行数值和科学计算的核心工具。它们支持丰富的操作，包括索引、切片、向量化运算、传播、数组的拼接、视图和切片、转换和重塑、搜索和排序等。这些功能使得Julia在处理数据集合时既高效又方便，特别适合于数据密集型的应用场景。

"""

# ╔═╡ af71810b-02c2-4d39-affd-3cbc75d0507f
md"""
### 索引

Julia中的数组索引从1开始，支持多种索引方式，包括单个元素访问、切片、以及多维数组的索引。

- **单个元素访问**：通过指定单个索引访问数组中的元素。
  ```julia
  A = [1, 2, 3]
  first_element = A[1]  # 访问第一个元素
  last_element = A[end]  # 访问最后一个元素
  ```

- **切片**：通过指定索引范围或多个索引访问数组的子集。
  ```julia
  B = [1, 2, 3, 4, 5]
  slice = B[2:4]  # 访问第二个到第四个元素
  full_end_slice = B[1:end]  # 访问从第一个到最后一个元素
  empty_slice = B[6:6]  # 访问空切片
  ```

- **多维数组索引**：二维数组（矩阵）可以通过提供多个索引来访问，每个索引对应一个维度。
  ```julia
  C = [1 2 3; 4 5 6; 7 8 9]
  element = C[2, 3]  # 访问第二行第三列的元素
  row = C[1, :]  # 访问第一行的所有元素
  column = C[:, 2]  # 访问第二列的所有元素
  submatrix = C[1:2, 1:2]  # 访问子矩阵
  ```

- **使用冒号**：可以使用冒号（`:`）来表示一个维度的所有元素。
  ```julia
  D = [1 2 3; 4 5 6; 7 8 9]
  all_rows_second_column = D[:, 2]  # 访问第二列的所有行元素
  all_columns_second_row = D[2, :]  # 访问第二行的所有列元素
  ```

- **基于条件的索引**：可以使用逻辑数组进行条件索引。
  ```julia
  E = [10, 20, 30, 40, 50]
  even_indices = E[E .> 20]  # 访问大于20的所有元素
  ```

- **索引的高级用法**：可以使用复杂的表达式进行索引，包括使用其他数组或函数作为索引。
  ```julia
  F = [10, 20, 30, 40, 50]
  indices = [1, 3, 5]  # 指定索引数组
  selected_elements = F[indices]  # 根据索引数组访问元素
  
  function custom_index(x)
      return x > 20
  end
  filtered_elements = F[custom_index(F)]  # 使用函数作为索引条件
  ```


"""

# ╔═╡ 299a77d5-fde1-4704-8fd5-1b5e558bb6ba
begin
v = [1, 2, 3]
w = [4, 5, 6]
end

# ╔═╡ 5f29db9a-3236-443f-9543-c2a337e93745
v - w

# ╔═╡ 6501554b-2576-42b4-a8cf-d572231486ca
md"""
## 容器类型
[容器类型Collections](https://docs.julialang.org/en/v1/base/collections/)并非一种特定的数据类型， 而是多种数据类型的一种抽象。 直观上来说， 只要能够从中不断读取出元素的类型都是容器类型。

为什么要单独提容器类型呢？因为Julia中， 很多的操作对容器类型都是有效的。具体可以参考其[文档](https://docs.julialang.org/en/v1/base/collections/)。 在Julia中， 上述所有的数据类型，包括后续讲到的数组类型等都是容器类型。因此， 有很多的函数（操作）同时适用于上述所有类型。
"""

# ╔═╡ 5b197c18-c8e1-4084-9731-316f7ca047ed
md"""
在 Julia 语言中，可迭代类型（Iterable Types）是那些能够被迭代器迭代的对象。迭代器是一个遵循迭代协议的对象，它能够逐个返回集合中的元素。了解可迭代类型对于编写高效且灵活的代码非常重要，因为它们允许你使用简洁的循环结构来处理集合中的数据。

### 什么是可迭代类型？

可迭代类型是指那些可以被 `iterate` 函数遍历的对象类型。在 Julia 中，迭代是实现集合遍历的一种机制，它通过 `iterate` 函数来实现。`iterate` 函数接收一个可迭代对象（iterable）和一个可选的初始状态（state），并返回一个包含元素和新状态的元组，或者在没有更多元素时返回 `nothing`。

### 为什么需要可迭代类型？

可迭代类型使得对集合的遍历变得简单和统一。它们允许开发者使用 `for` 循环来遍历集合，而无需关心集合内部的数据结构。此外，可迭代类型也使得编写泛型代码成为可能，因为许多 Julia 标准库函数都依赖于迭代来处理数据。

### 有哪些类型是可迭代的？

在 Julia 中，许多内置的集合类型都是可迭代的，包括：

- 数组（Arrays）
- 元组（Tuples）
- 范围（Ranges）如 `1:10`
- 字典的键（Keys）和值（Values）
- 集合（Sets）
- 字符串（Strings）

### 可迭代类型有哪些同样的迭代方法？

所有可迭代类型都遵循相同的迭代协议，主要通过 `iterate` 函数实现。以下是一些通用的迭代方法：

- `iterate(iter)`：从可迭代对象 `iter` 中获取第一个元素和状态。
- `iterate(iter, state)`：使用给定的状态从可迭代对象 `iter` 中获取下一个元素和状态。

### 代码示例

以下是一些使用可迭代类型的例子：

```julia
# 数组是可迭代的
array = [1, 2, 3, 4, 5]
for element in array
    println(element)
end

# 元组也是可迭代的
tuple = ("a", "b", "c")
for item in tuple
    println(item)
end

# 范围同样可迭代
range = 1:3
for num in range
    println(num)
end

# 字典的键和值可以通过迭代获取
dict = Dict("one" => 1, "two" => 2, "three" => 3)
for key in keys(dict)
    println("Key: ", key)
end

for value in values(dict)
    println("Value: ", value)
end
```

### 总结

可迭代类型在 Julia 中扮演着重要的角色，它们提供了一种统一的方式来处理集合数据。通过实现 `iterate` 函数，任何类型都可以变得可迭代，这使得编写泛型代码和处理数据集合变得非常灵活和强大。无论是内置的集合类型还是自定义类型，只要它们遵循迭代协议，就可以使用 `for` 循环和其他依赖于迭代的函数进行处理。

"""

# ╔═╡ a6e61f23-0399-45ab-8759-54bb5febb689
begin
	Temp = @ingredients "../chinese.jl" # provided by PlutoLinks.jl
	PlutoTeachingTools.register_language!("chinese", Temp.PTTChinese.China())
	set_language!( PlutoTeachingTools.get_language("chinese") )
end;

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.15"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "f1c3cad4185de8dfdbe7a2e313cedba3766fbc3f"

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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

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

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "4b415b6cccb9ab61fec78a621572c82ac7fa5776"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.35"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "1ce1834f9644a8f7c011eb0592b7fd6c42c90653"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.1"

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
# ╠═79eab523-738c-4469-81ab-cc0530733ac0
# ╠═d91a9d5f-8050-4754-9bc0-f379621fe1bf
# ╠═5905fc1b-3281-41b1-9ffc-10e173bc0759
# ╟─ced691c0-298e-4f44-8f16-661f95ff760c
# ╟─6c6e3068-406c-4c8a-b28c-ef1fa33cfe72
# ╟─4e6d9031-873e-49c1-9de5-79c88d186ecb
# ╟─406811f6-0c24-4d75-b222-d581fe829d92
# ╟─c0ab05eb-dcbb-42e9-8bca-32bcfb3c05ac
# ╟─c95c7bef-f2bc-42fd-81d0-706c95b75eff
# ╟─8a07fd51-e1d1-4cc4-bee8-ebde1026d073
# ╟─830d93fe-e238-40ee-a477-348e1576db36
# ╟─e2c49ef4-191b-423c-9342-5c254278d032
# ╟─cd4a41d8-22c8-4d0e-b8d2-065cd73ae268
# ╟─a0fff9a7-b61e-443c-bc22-5e99595d8627
# ╟─4f99e34a-01cb-457e-8e0c-246da1f3919d
# ╟─e077f43f-dc44-4594-ad3a-2bd225f78709
# ╟─35ea0a67-7ce8-4dad-a7b9-c326f265712d
# ╟─e7dcaaa8-a66f-4a0a-8e19-f57190d19228
# ╟─21b613ce-fa2b-4fd4-b1df-973e81d47c4a
# ╟─10bb3dd2-9301-4717-8c6d-88d5673bf6ee
# ╟─2916c389-7af4-4336-9d8a-09aeb70c0b53
# ╟─a156d361-e7d9-4a1d-a666-754471c2597e
# ╟─06938d7c-c0d8-40d1-a203-670571a5673e
# ╠═aaa0ddcf-d00b-4009-bcfd-e14378783dac
# ╠═af71810b-02c2-4d39-affd-3cbc75d0507f
# ╠═299a77d5-fde1-4704-8fd5-1b5e558bb6ba
# ╠═5f29db9a-3236-443f-9543-c2a337e93745
# ╟─6501554b-2576-42b4-a8cf-d572231486ca
# ╟─5b197c18-c8e1-4084-9731-316f7ca047ed
# ╠═a6e61f23-0399-45ab-8759-54bb5febb689
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
