### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 341380c9-3b93-4f4f-adcd-01fc89c021d0
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ 37f847ca-9101-46eb-8114-fcc0de261556
TableOfContents(title="目录")

# ╔═╡ 70a57d28-9efa-44ce-821c-5c340078f49f
present_button()

# ╔═╡ 2e73e963-ad17-454c-bab4-9513f03980e2
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			Julia简短教程——流程控制
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 83cad868-ee0b-469e-a7f7-09a6e4ca87ff
md"""
## 引言

在编程的世界里，控制流程是构建高效、可读和结构化代码的基石。控制流程语句允许我们指导程序的执行顺序，使其能够根据不同的条件和需求执行不同的代码路径。在 Julia 中，控制流程的实现包括但不限于条件判断、循环、异常处理和任务调度。这些机制使得程序能够根据不同的输入和状态做出决策，执行重复的任务，处理意外的错误，甚至并行执行多个任务。


Julia 提供了一系列控制流程构造，包括：

- **复合表达式**：使用 `begin...end` 和 `;` 来组织多个表达式。
- **条件求值**：通过 `if`、`elseif` 和 `else` 语句以及三元运算符 `?:` 来实现条件分支。
- **短路求值**：利用 `&&`（逻辑与）和 `||`（逻辑或）进行短路逻辑判断。
- **重复计算**：使用 `while` 和 `for` 循环进行代码的重复执行。
- **异常处理**：通过 `try`、`catch`、`error` 和 `throw` 来处理和抛出异常。
- **任务（协程）**：使用任务来实现非局部的控制流，支持异步编程和多任务处理。

本章的目标是帮助初学者理解和掌握 Julia 语言中的控制流程机制，达到如下目的：

- 掌握基本的控制流程语句，如条件判断和循环。
- 学会使用短路评估来编写更高效的逻辑表达式。
- 理解并应用异常处理来增强程序的健壮性。
- 探索任务和协程，以实现更高级的并发和异步编程。

通过本章节的学习，你将能够将这些控制流程的概念应用到实际的 Julia 编程中，编写出更加强大和灵活的代码。接下来，我们将深入探讨每一种控制流程构造，并提供实际的代码示例来加深理解。

"""

# ╔═╡ c9aa3223-c015-49ab-8f0e-f261913e7c0c
md"""
## 顺序结构

顺序结构是程序设计中最基础的执行方式，其中代码按照它们在源文件中出现的顺序依次执行，没有分支或循环的干预。这种结构在任何程序中都是必不可少的，因为它构成了程序执行的线性流程。

```julia
# 顺序结构示例
x = 5        # 第一个表达式：初始化变量 x
y = x + 3    # 第二个表达式：计算 x 加 3，并将结果赋值给 y
println(y)   # 第三个表达式：打印变量 y 的值
```
在这个例子中，三个表达式依次执行，每个表达式的执行结果决定了下一个表达式的输入。这种简单的从上到下的执行顺序就是顺序结构的核心。

### 复合表达式

在 Julia 中，当你需要在一个表达式中执行多个操作，并且希望整个表达式返回最后一个操作的结果时，可以使用复合表达式。复合表达式通过 `begin` 和 `;` 来实现，它们允许多个表达式按顺序执行，并返回最后一个表达式的值。

#### 使用 `begin` 块
```julia
z = begin
    x = 1  # 第一个表达式：初始化变量 x
    y = 2  # 第二个表达式：初始化变量 y
    x + y  # 最后一个表达式：计算 x 和 y 的和
end
println(z)  # 输出 3
```
在这个 `begin` 块中，三个表达式依次执行，整个 `begin` 块的值是最后一个表达式 `x + y` 的结果。
Julia并不要求语句有结束符， 不过， 如果我们想多条语句写到同一行中， 用分号；分隔即可。当然， begin...end也可以写到一行。 一条语句的后面有一个分号，意味着这条语句的执行结果不会被显示。
```julia
julia> begin ad = 1; bd = 2; ad + bd end;
```


#### 使用分号（`;`）
```julia
z = (x = 1; y = 2; x + y)
println(z)  # 输出 3
```
这个例子与 `begin` 块的作用相同，但是使用了分号链，更加简洁。分号链中的每个表达式依次执行，整个链的值是最后一个表达式的结果。

"""

# ╔═╡ 88c55ccb-08da-45ea-a3cb-c86d7e58fd6a
md"""
## 选择结构

选择结构是编程中用于基于条件控制程序执行流程的一种机制。在 Julia 中，选择结构通过 `if`-`elseif`-`else` 语句和三元运算符 `?:` 实现，允许程序根据不同的条件执行不同的代码块。

### `if`-`elseif`-`else` 语句

`if`-`elseif`-`else` 结构是选择结构中最常见的形式，它允许程序在多个选项中选择一个执行，基于条件表达式的真（`true`）或假（`false`）值。

#### 语法
```julia
if 条件表达式1
    # 当条件表达式1为 true 时执行的代码
elseif 条件表达式2
    # 当条件表达式1为 false 且条件表达式2为 true 时执行的代码
else
    # 当所有条件表达式都为 false 时执行的代码
end
```

#### 示例
```julia
x = 10
y = 20
if x > y
    println("x is greater than y")
elseif x < y
    println("x is less than y")
else
    println("x is equal to y")
end
```

在这个示例中，程序会根据变量 `x` 和 `y` 的值比较结果来选择执行不同的代码块。

### 三元运算符 `?:`

三元运算符提供了一种更简洁的方式来执行条件选择，特别适用于需要根据条件快速返回一个值的场景。

#### 语法
```julia
条件表达式 ? 表达式1 : 表达式2
```

如果条件表达式为 `true`，则整个表达式的值为 `表达式1` 的值；否则，为 `表达式2` 的值。

#### 示例
```julia
x = 10
y = 20
result = x > y ? "x is greater than y" : "x is not greater than y"
println(result)
```

这个示例通过三元运算符实现了与 `if-elseif-else` 相同的逻辑，但更为简洁。

### 短路求值

Julia 中的逻辑运算符 `&&`（逻辑与）和 `||`（逻辑或）支持短路求值，这意味着它们的第二个操作数仅在必要时才会被求值。

#### 示例
```julia
x = 10
y = 20
# 短路逻辑与
safe_increment = (x > 0) && (y = y + 1)
println(y)  # y 的值不会被修改，因为 x <= 0

# 短路逻辑或
safe_decrement = (x < 0) || (y = y - 1)
println(y)  # y 的值会被减 1，因为 x >= 0
```

在这个示例中，`safe_increment` 和 `safe_decrement` 利用短路评估避免了不必要的操作。

"""

# ╔═╡ 95f53f32-79c8-45a8-a79d-9ea7ff6adf5e
md"""
#### 短路逻辑与 (`&&`) 和短路逻辑或 (`||`)， 如果看成是：
	（条件） && （行动）
	（条件） || （行动）
结构。那么， 与（**羽**）运算：条件成立是行动启（**骑**）动的信号； 或（**祸**）运算：条件成立是行动**停**止的信号。所以是： 羽骑祸停。

所以，你是要启动一件事，还是要停止一件事，分清之后就知道该如何选择表达式了。
""" |> hint |> aside

# ╔═╡ 16b45b97-737a-482d-985b-c134b1e04f92
md"""

## 循环结构
Julia 提供了两种主要的循环结构：`while` 循环和 `for` 循环。

### `while` 循环

`while` 循环会持续执行代码块，直到给定的条件不再为真。它的基本语法如下：

```julia
while 条件表达式
    # 循环体
end
```

**特点**：
- 循环会一直执行，直到条件表达式的结果为 `false`。
- 必须确保条件最终会变为 `false`，否则会导致无限循环。

**示例**：
```julia
i = 1
while i <= 3
    println(i)
    global i += 1
end
```
在这个例子中，`while` 循环会打印数字 1、2、3，然后停止，因为 `i` 的值在每次迭代后会增加，最终会超过 3。

### `for` 循环

`for` 循环用于遍历一个序列（如数组、范围等），并对序列中的每个元素执行代码块。它的基本语法如下：

```julia
for 循环变量 in（或者=） 容器(序列，范围)
	# 循环体
end
```
在for循环中， 循环变量会依次取容器中的每一个值。 所以， 在每一次循环， 循环变量的值可能都不同。 `循环变量 in（或者=） 容器 ` 表示: `循环变量 in 容器`或者 `循环变量 = 容器`都是合法的语法。 注意， 这时候的等号=不是将容器赋值的意思，而是容器中的元素依次赋值。容器（collection）是Julia中一大类数据类型。形象的来说， 一个容器可以看成是一栋房子， 房子里包含很多房间（用于存储单个数据）。 不同的容器， 可能构造不同。就像房子可能内部构造不同一样。 在Julia中， 常见的元组、数组等也都是容器类型的数据。


**示例**：
```julia
for i in 1:3
    println(i)
end
```
这个例子中，`for` 循环遍历范围 `1:3`，即数字 1 到 3，打印每个数字。

### 循环控制

在某些情况下，可能需要提前退出循环或跳过当前迭代。Julia 提供了 `break` 和 `continue` 关键字来实现这些控制。

- `break`：立即退出循环，不再执行循环体内的剩余代码。
- `continue`：跳过当前迭代的剩余代码，直接进行下一次条件判断。

**示例**：
```julia
for i in 1:10
    if i % 3 != 0
        continue
    end
    println(i)
end
```
在这个例子中，`continue` 关键字使得循环跳过不是 3 的倍数的数字，只打印 3、6、9。

通过这些循环结构和控制语句，Julia 允许灵活地处理需要重复执行任务的场景。

"""

# ╔═╡ b191f5b5-3886-4846-bcdd-46a9a4922dc3
md"""
不像C/C++语言，在Julia中， 要求**条件**求值的结果必须是bool值， 即true或者false。如果不是， 则程序会错误。（在C/C++语言中， 不是0都当成是true, 0当成是false）

```julia
julia> if 1
println("你是1")
end

TypeError: non-boolean (Int64) used in boolean context
```
上面的类型错误（TypeError）表明， 我们在需要一个布尔值的地方输入了一个Int64类型的值(非布尔值non-boolean)。
""" |> danger

# ╔═╡ 6b99b8a9-49f9-41c8-a9e8-a0abe4139c7d
md"""
`println`通常用于在控制台输出信息， 表示打印带换行符的元素。Pluto会自动捕捉控制台的输出，显示到下面。不过，在Pluto中， 我们可以直接看到表达式计算的结果， 这比控制台的输出更好看。
""" |> tip |> aside

# ╔═╡ 832b10b8-a5d0-4ba9-9b5f-6f0c04772371
md"""
比如， 求 ``1+2+\cdots+100`` 的和，用for循环可以非常方便的实现：
```julia
s = 0
for i in 1:100
	s += i
end
```
1：100就是用冒号：运算构建的一个范围（这是一个典型容器)。如果用while循环， 可以这样做：
```julia
s = 0
i = 1
while i<=100
	s += i
	i += 1
end
```
上面两段代码中s最后的值都是所要的结果。
"""

# ╔═╡ d6488bb5-852b-4d2e-b55b-8780b2360c36
md"""
如果要遍历一个字典， 可以简单如下：
```julia
for (k,v) in D
	# 做一些事情
end
```
其中， k存储每一个元素的键key， v用于存储值value。	
"""

# ╔═╡ c7638b49-025c-4c16-bb67-37d649683916
md"""
如果在遍历一个容器的时候， 我们不仅需要值， 还希望知道当前的值是第几个元素。这时候， 可以这么做。
```julia
for (i, x) in enumerate(collection)
 # 做一些事情
end
```
这时候， 变量i保存遍历过程中元素的顺序（从1开始）， 变量x保存相应元素的值（第i个元素的值）。`enumerate(iter)`的作用是生成一个可迭代对象(i,x)。

比如， 我们要找到一个向量中的元素的最大值是哪个元素， 虽然有函数实现， 但可以用如下for循环:
```julia
v = rand(1:10, 10) # 从1:10中随机抽取10个元素构成向量。
ind = 1 # 用于保存最大值所在位置
for (i,x) in enumerate(v)
	if v[i]> v[ind] # 如果发现一个更大值
		ind = i # 更新最大值所在位置
	end
end
```
"""

# ╔═╡ 138e1978-1e17-41e6-b878-ca482664c57a
md"""
## 迭代类型（Iteration）
可迭代类型一种可以用for循环遍历的数据容器。
```julia
for i in iter   # or  "for i = iter"
    # body
end
```
说迭代类型是容器其实不太确切。 因为可迭代类型并没有将数据存起来， 数据是在迭代的过程中不断计算出来的。 因此， 可迭代类型的数据可能是一个无穷集合。想象一下， 我们肯定没办法构建一个包含无穷多个元素的向量（因为内存限制）。


一个可迭代类型， 只是在该类型上，定义了一个iterate函数：

`iterate(iter [, state]) -> Union{Nothing, Tuple{Any, Any}}`

该函数实现在迭代对象上（iter）， 根据当前的状态（state）， 获取容器中的下一个值和下一个状态。 一般， 值和状态构成一个元组。 如果容器中的元素全部取出， 那么再次迭代获取的值将是nothing。 

有了这样的特征设定， 上面的for循环其实被转换为下面的while循环：

```julia

next = iterate(iter)
while next !== nothing
    (i, state) = next
    # body
    next = iterate(iter, state)
end
```

一个迭代类型可能还实现了IteratorSize和IteratorEltype等特性， 可以用于求迭代器中的元素数量和元素类型。 当然， 只要定义了上面的iterator函数， 一个迭代器类型就自动实现了很多操作。

上面介绍的所有数据结构都是可迭代类型。因此， 任何适用于可迭代类型的函数， 将适用于上面介绍的所有数据类型。
"""

# ╔═╡ 9444435e-994e-4ea9-94bc-9e5fdb52223a
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
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "d237efa23f529a17c7ea590fcc4b3b8aec765612"

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
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

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
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

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
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

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
# ╠═341380c9-3b93-4f4f-adcd-01fc89c021d0
# ╠═37f847ca-9101-46eb-8114-fcc0de261556
# ╠═70a57d28-9efa-44ce-821c-5c340078f49f
# ╟─2e73e963-ad17-454c-bab4-9513f03980e2
# ╟─83cad868-ee0b-469e-a7f7-09a6e4ca87ff
# ╟─c9aa3223-c015-49ab-8f0e-f261913e7c0c
# ╟─88c55ccb-08da-45ea-a3cb-c86d7e58fd6a
# ╟─95f53f32-79c8-45a8-a79d-9ea7ff6adf5e
# ╟─16b45b97-737a-482d-985b-c134b1e04f92
# ╟─b191f5b5-3886-4846-bcdd-46a9a4922dc3
# ╟─6b99b8a9-49f9-41c8-a9e8-a0abe4139c7d
# ╟─832b10b8-a5d0-4ba9-9b5f-6f0c04772371
# ╟─d6488bb5-852b-4d2e-b55b-8780b2360c36
# ╟─c7638b49-025c-4c16-bb67-37d649683916
# ╟─138e1978-1e17-41e6-b878-ca482664c57a
# ╠═9444435e-994e-4ea9-94bc-9e5fdb52223a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
