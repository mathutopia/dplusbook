### A Pluto.jl notebook ###
# v0.19.41

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

# ╔═╡ e612a3ce-d970-467e-87e6-5b841e365b55
begin
using PlutoUI,Box
TableOfContents(title="目录")
end

# ╔═╡ c3e24379-0b76-4a0a-9a57-191a7f2eb37a
md"""
# 流程控制
流程控制是实现计算逻辑的重要一环。程序从结构上可以分为顺序结构、分支结构和循环结构三种。默认情况下，程序会顺序执行， 当需要构造分支和循环时， 需要特殊的关键字。在Julia中，有以下基本的流程控制方法：
1. begin ... end 构造复合语句。 
2. if elseif else end. 实现分支语句， 当然也有三元操作符?:。
3. for i in collection ... end。 实现固定范围的for循环。
4. while condition... end。 实现基于条件的while循环。
5. continue, break， 用于跳出、提前结束循环。

注意，Julia中任何一个代码块开始关键字都需要以end结尾
"""

# ╔═╡ dcfca088-46dc-4e53-bea4-1fb9b919e94d
md"""
## 顺序结构与复合语句
默认情况下， 程序都是按照顺序一句一句按顺序执行的。 这种结构的程序是顺序结构。 

复合语句是由多条语句组合成的一条语句的时候。需要用到`begin...end`构造， 可以看成是多条语句了构成了一个顺序执行结构。在Pluto中，任何一个cell只能输入一条语句， 如果你要输入多条， 则需要用begin...end构造成复合语句。

下面是三条语句组成的复合语句。该语句的值为复合语句中最后一条语句的值。

```julia
julia> z1 = begin
    ac = 1
    bc = 2
    ac + bc
end;
julia> z1
3
```

Julia并不要求语句有结束符， 不过， 如果我们想多条语句写到同一行中， 用分号；分隔即可。当然， begin...end也可以写到一行。 一条语句的后面有一个分号，意味着这条语句的执行结果不会被显示。
```julia
julia> begin ad = 1; bd = 2; ad + bd end;
```

有时候， 一些简短的代码用`begin ... end`可能显得有点大材小用。这时候， 可以用小括号。
```julia
julia> z = (x = 1; y = 2; x + y)
3
```

"""

# ╔═╡ 5cd1788f-4f4c-45c2-9b10-b4b48bd9b61c
md"""
## if-elseif-else-end
if语句用于实现分支结构，其基本的用法如下：
```julia
#单分支条件语句=====================
if 条件
	满足条件要执行的语句
end

# 两分支语句======================
if 条件
	满足条件要执行的语句
else 
	不满足条件要执行的语句
end


# 多分支语句====elseif可以有多个
if 条件1
	满足条件1要执行的语句
elseif 条件2
	不满足条件1， 满足条件2要执行的语句
elseif 条件3
	不满足条件1、2， 满足条件3要执行的语句
else
	不满足条件1、2、3要执行的语句
end

```
注意： 条件和关键词之间要有空格； 条件不需要用括号括起来； if代码块需要用end结束。
"""

# ╔═╡ 155db473-eb47-4716-83ce-d471e0abcd8a
md"""
不像C等语言，在Julia中， 要求**条件**求值的结果必须是bool值， 即true或者false。如果不是， 则程序会错误。（在C语言中， 不是0都当成是true, 0当成是false）

```julia
julia> if 1
	println("你是1")
end

TypeError: non-boolean (Int64) used in boolean context
```
上面的类型错误（TypeError）表明， 我们在需要一个布尔值的地方输入了一个Int64类型的值(非布尔值non-boolean)。
""" |> box(:red)

# ╔═╡ bcc930fa-2af1-48f1-a311-4df58ed79970
md"""
`println`通常用于在控制台输出信息， 表示打印带换行符的元素。Pluto会自动捕捉控制台的输出，显示到下面。不过，在Pluto中， 我们可以直接看到表达式计算的结果， 这比控制台的输出更好看。
""" |> box

# ╔═╡ ba2af638-d545-4a7c-9f7b-612f341c09c9
md"""
单分支语句有一个常用的替换， 也就是利用逻辑运算（&&和||）的**短路求值**。 由于`a&&b`只有在a和b同时为true时才能为ture， 因此， 当a计算的结果为false时， b不需要计算， 只有当a为true时， 才需要计算b的值。因此，
```julia
if 条件
	表达式 
end 
```
可以写成
```julia
条件 && 	表达式 
```
类似的， `a||b`只有在a计算结果为false时， 才需要计算b的值。因此， 当我们要表达不满足某个条件要执行某条语句时， 可以利用或运算。即：

```julia
if 不满足条件(!条件)
	表达式 
end 
```
可以写成
```julia
条件 || 	表达式 
```
可以写成

"""

# ╔═╡ 0845fa2d-7d7a-446c-9f75-03390702ce5a
md"""
对于双分支语句， 可以用一个简单的三元表达式表示：
```julia
a ? b : c
```
在这个简单表达式中， a是条件表达式，如果a的测试结果为真true， 则返回表达式b的值， 否则返回表达式c的值。
"""

# ╔═╡ 90dd6711-2eff-4718-9dc3-15ebdfe74418
md"""
你可以输入两个不同的值xn= $(@bind xn  NumberField(1:10, default=3)) ， yn= $(@bind yn  NumberField(1:10, default=4))， 然后下面的语句会根据你输入的值的大小比较结果输出不同的值。
"""

# ╔═╡ f08d510a-3eb6-4764-8234-d1c76e389029
println(xn < yn ? "xn < yn" : "xn >= yn")

# ╔═╡ 9b8a5afa-d5e7-4951-9e6b-49a2cdd54dca
md"""
下面的代码根据你选择的不同， 会告诉你选择的对象是什么
"""

# ╔═╡ 505396ad-c2c6-4a38-8455-4576d6cbd0c0
md"""
你可以选择一个动物，  $(@bind animal Select(["🐂", "🐝", "🐱"]))， 下面的代码块就会告诉你，你选择的是什么动物。
"""

# ╔═╡ e951060a-f1e1-42ff-a67a-20048f8a7906
begin
	# 这是一个 if 语句，缩进不是必要的
	if animal == "🐂"
	    println("你选择的是牛.")
	elseif animal == "🐝"    # elseif 是可选的.
	    println("你选择的是蜜蜂.")
	else                    # else 也是可选的.
	    println("你选择的是猫.")
	end
	# => prints "some var is smaller than 10"
end

# ╔═╡ 630a9e29-006d-4e24-b859-191fdc6be0a9
md"""
## for/while 循环
当我们需要重复的做一件事情时， 可以使用for/while循环。

for循环通常用于循环次数或范围已知的情形。for 循环的典型用法如下：

```julia
for 循环变量 in（或者=） 容器
	# 做点事情， 一般会跟循环变量有关
	...
end
```

在for循环中， 循环变量会依次取容器中的每一个值。 所以， 在每一次循环， 循环变量的值可能都不同。 `循环变量 in（或者=） 容器 ` 表示: `循环变量 in 容器`或者 `循环变量 = 容器`都是合法的语法。 注意， 这时候的等号=不是将容器赋值的意思，而是容器中的元素依次赋值。容器（collection）是Julia中一大类数据类型。形象的来说， 一个容器可以看成是一栋房子， 房子里包含很多房间（用于存储单个数据）。 不同的容器， 可能构造不同。就像房子可能内部构造不同一样。 在Julia中， 常见的元组、数组等也都是容器类型的数据。

while循环通常用于表示满足条件就要重复做的事，其基本用法如下：
```julia
while 条件
    # 条件满足时，要做的事情
	...
end
```
while循环更简单， 只要条件能够满足， 就会执行while 和 end之间的代码。只是请注意，跟if语句中的条件一样， 这里的条件也必须是逻辑值。 
"""

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

# ╔═╡ f555c131-6878-49b2-abaf-1aa801e73174
md"""
## break/continue
break 用于强制结束循环。 而continue则表示跳过循环中未执行的所有语句，执行执行下一次循环
```julia
julia> for j = 1:1000
           println(j)
           if j >= 3
               break
           end
       end
1
2
3

julia> for i = 1:10
           if i % 3 != 0
               continue
           end
           println(i)
       end
3
6
9
```
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
# ╠═e612a3ce-d970-467e-87e6-5b841e365b55
# ╟─c3e24379-0b76-4a0a-9a57-191a7f2eb37a
# ╟─dcfca088-46dc-4e53-bea4-1fb9b919e94d
# ╟─5cd1788f-4f4c-45c2-9b10-b4b48bd9b61c
# ╟─155db473-eb47-4716-83ce-d471e0abcd8a
# ╟─bcc930fa-2af1-48f1-a311-4df58ed79970
# ╟─ba2af638-d545-4a7c-9f7b-612f341c09c9
# ╟─0845fa2d-7d7a-446c-9f75-03390702ce5a
# ╟─90dd6711-2eff-4718-9dc3-15ebdfe74418
# ╠═f08d510a-3eb6-4764-8234-d1c76e389029
# ╟─9b8a5afa-d5e7-4951-9e6b-49a2cdd54dca
# ╟─505396ad-c2c6-4a38-8455-4576d6cbd0c0
# ╠═e951060a-f1e1-42ff-a67a-20048f8a7906
# ╟─630a9e29-006d-4e24-b859-191fdc6be0a9
# ╟─832b10b8-a5d0-4ba9-9b5f-6f0c04772371
# ╟─f555c131-6878-49b2-abaf-1aa801e73174
# ╠═d6488bb5-852b-4d2e-b55b-8780b2360c36
# ╟─c7638b49-025c-4c16-bb67-37d649683916
# ╟─138e1978-1e17-41e6-b878-ca482664c57a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
