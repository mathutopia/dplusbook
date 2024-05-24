### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ d113eb95-cb54-4f6d-b175-bd011e9e2571
using PlutoUI

# ╔═╡ f75b03fb-ea9d-45db-9dde-a11787b9c667
TableOfContents(title="目录")

# ╔═╡ 203e0107-b2cf-4311-800d-9e108fca8197
md"""
# 函数function
在数学上， 一个函数是一个映射``f:x\rightarrow y``, 它将自变量x映射到因变量y。 在编程语言中， 函数的内涵更丰富。 简单来说， 一个函数就是一个功能function， 这个功能可以将一定的**输入**（可以没有），转化为**某种输出**。 

输入也称为**参数列表**， 一般用括号形成的元组表示。 函数的输出是函数的返回值（return），默认情况下是函数的最后一条语句的计算结果。 

函数编写是一门编程语言非常重要的内容， 有了上述流程控制的内容， 编写函数就容易多了。 在Julia中， 有多种定义函数的方法。

"""

# ╔═╡ 7c2dfe32-f55f-4ba3-b2a0-c30b63ccfa10
md"""
## 函数定义
定义函数很简单， 用关键词`function`， 给出函数名， 参数列表， 和函数体（函数的计算过程）即可。例如：
```julia
function f(x,y)
 	return x^2 + y^2
end
```
一个函数有四个组成部分： 1）关键词对function ... end； 2)函数名； 3） 参数列表; 4) 函数体。 其中， 函数名类似变量名， 只是一个名字。 参数列表由括号表示，如果没有参数， 括号也不能省略。

上面的函数定义中， `f`是函数名。之后紧跟的是参数列表`(x,y)`。这里x和y是两个参数名。其下一行`x^2 + y^2`是函数体。 这个函数很简单， 只是返回这两个参数的平方和。`return`是表示返回的关键字， 当函数执行到return语句时， 不管其后是否还存在语句，它都会返回return语句后面的表达式的值。当然return可以省略。这是函数返回的时期最后一条语句的值。

函数名和变量名几乎是一样的。 从命名规则上来说， 函数名跟变量名一样。 从作用上来说， 函数名也是“绑定”到了一个对象上， 只是这个对象是函数对象而已。 因此， 可以方便我的将函数重新命名。比如执行语句`g = f`之后， `g`也可以像函数名`f`一样使用。

"""

# ╔═╡ 184811a8-3326-43db-ae30-c85bd57b06e7
md"""
## 一句话函数
上面的函数很简单（只有一句话）， 像上面那样去定义会显得啰嗦。这时候可以使用赋值直接定义。 赋值定义的方式是将函数名和参数列表写在赋值符号的左边。将函数体写在赋值符号的右边。如下所示：
```julia
f(par1, par2, ...) = 表达式
```
上面的函数很简单，用赋值方式定义，可以简单的写成：

```julia
julia> f(x,y) = x^2 + y^2;
```

赋值定义的函数写法类似于数学函数的写法， 比如二次函数$f(x) = 3x^2 + 2x + 1$， 写成一个Julia函数，几乎是一样的。注意在下面，数字和字母x之间可以没有乘号*， Julia自己能判断这种情况是省略乘号的乘法（是不是很数学？）， 因为变量不能以数字开头去命名。
```
f(x) = 3x^2 + 2x + 1
```
当然， 这里的“一句话”可以是复合语句， 比如：`begin ... end`包裹的多句话， 或者元组形式的多句话 `(语句1；语句2；语句3)`。
"""

# ╔═╡ f6299698-0e82-4744-9929-fb43410148a0
md"""
## 函数调用
函数调用很简单，只要给相应参数赋予相应的值即可。
```julia
julia> f(x,y) = x^2 + y^2;

julia> f(3,4) 
25

julia> g = f; #将g绑定到f绑定的对象， g也可以像函数f一样使用了

julia> g(3,4)
25

```
这里3和4两个值是按照**顺序**分别赋值给参数x和y。在Julia里面， 在函数调用过程中，值跟参数名之间的关系是： 参数名只是值的一个别名。也就是值被绑定在了参数名上（类似赋值）。因此如果一个值是可以修改的，那么在函数里对参数的修改会改变传递进来的值。

```julia
julia> f!(x) = (x[1] = 10;)

julia> a = [1,2]
[1,2]

julia> f!(a);

julia> a
[10, 2]
```
上面的函数`f!`很简单，只是将参数的第一个下标对应的元素修改为10。当我们用一个向量a调用完这个函数之后，我们会发现向量a变了。所以函数对参数的修改反应到了被调用的值上。像这种会修改参数值的函数。在Julia语言里通常都用一个**惊叹号做结尾**, 以提醒这个函数会修改参数。
"""

# ╔═╡ bc894456-3d47-4285-9301-d536e1f2317e
md"""
!!! info "带！的函数"
	在Julia中， 有一个关于函数的习惯，**如果一个函数会修改其输入参数，该函数名要以！结尾**。 反过来， 如果发现一个带惊叹号的函数， 那么这个函数会修改输入参数。
""" 

# ╔═╡ f6d3f96e-6c9a-4d80-ba93-0152e0a072b5
md"""

## 函数参数
函数在定义时可以有多种类型的参数，如下所示的函数f， 就包括了两类参数。其中分号之前的是**位置参数**（包括a,m); 分号之后的是**关键字参数**（key1,key2）。

在函数调用时，位置参数必须按照顺序依次赋予相应的值。而关键字参数在调用传递值时时，必须带有关键字。参数里`m=x1, key2 = xk`表示参数`m，key2`具有默认值， 也就是如果调用函数时不传递相应的参数值。那么参数的取值就是给出的默认值。**如果一个参数没有默认值，在调用时就必须赋值。**

```julia
function f(a,m=x1; key1, key2 = x2)
#函数体省略
end

```

下面都是上述函数的合理的调用方法
```julia
f(1, 2; key1 = 3, key2 = 4) # a=1,m=2，key1 = 3, key2=4;
f(1, 2, key1 = 3, key2 = 4) # 同上， 位置参数和关键字参数之间用逗号分隔。
f(1, 2, key2 = 4, key1 = 3) # 同上， 交换关键字参数的顺序无关紧要。
f(1; key1 = 3) # a=1,m=x1， key1 = 3, key2=x2; m,key2都采用了默认值。
```
下面的调用方式都不对：

```julia
f(key1 = 3, key2 = 4) # 没有给没有默认值的位置字参赋值。
f(1, 2, key2 = 4) # 没有给没有默认值的关键字参数赋值。
f(1, 2, 3, 4) #关键字参数赋值时必须要带参数的名字。
f(a=1,m=2,key1=3, key2=4) # 位置参数赋值时，不需要参数名字。
```


总结一下： 在定义时， 函数参数有两种类型： 位置参数和关键字参数， 每一种又分**可选**和**必选**， 位置参数和关键字参数在定义时用**分号(；)分隔**, 分号之前的是位置参数，分号之后的是关键字参数。 在调用时， 位置参数必须按顺序传值， 不需要参数名。 关键字参数可以不按顺序， 但必须要参数名。 有默认值的参数可以不传值， 但没有默认值的参数必须要传值。 位置参数和关键字参数之间可以用逗号分隔。


"""

# ╔═╡ d71ab211-8c83-444c-93d9-e3137f06ee69
md"""
## 参数类型限定
上面在定义函数时都没有限定参数应该是某种类型， 这也是Julia推荐的方式， 通常你不需要关注参数的类型。 但你也可以用类型注释符号(::)， 限制参数可以接受的值的类型。比如下面的。求斐波拉契数列的函数就把参数限定在了整数类型上（::Integer）。
```julia
julia> fib(n::Integer) = n ≤ 2 ? one(n) : fib(n-1) + fib(n-2)
fib (generic function with 1 method)

julia> fib(10)
55

julia> fib(3.5)
MethodError: no method matching fib(::Float64)

Closest candidates are:

fib(!Matched::Integer)

```
当我们用整数调用这个函数的时候(比如10），他能够正确的返回相应的值。但如果不是一个整数， 这时候会出现方法错误的提示（MethodError)。

通常我们不需要对参数的类型做限定， 除非：
 1. 你是想获得Julia的多重分派能力（后面解释）
2. 为了在输入参数类型不对时，返回更好的错误提示。
3. 让你的代码更清晰（因为你明确告诉用户你需要的参数是什么类型。）。
"""

# ╔═╡ e73ca1c6-a56d-4dfa-b745-0d29602ebd70
md"""
## 操作符函数
在Julia中， 很多操作符本质上只是支持特殊语法的函数， 因此， 操作符也可以像函数一样调用：
```julia
julia> 1 + 2 + 3
6

julia> +(1,2,3)
6
```
这些操作符在内部都会转换为相应的函数调用。 因此一个操作符可以看成是一个具有特殊名字的函数。既然只是名次，那我们也可以用另外的名字代替：

```julia
julia> f = +;

julia> f(1,2,3)
6
```
除了短路求值运算符外（｜｜， ＆＆）， 其他的算术运算符（＋－＊/等），比较运算（<,>等）都是函数。 
"""

# ╔═╡ 2db36183-01f7-4b65-bde3-4b7de6cef342
md"""
## 匿名函数
Julia中的函数是**一等公民(first-class object)**： 这意味着， 它们可以被赋值给变量，并使用标准的函数调用语法从变量中调用。它们可以用作参数，也可以作为值返回。

函数既然可以作为一个值， 那它不见得需要名字。没有名字的函数就叫**匿名函数**。可以使用如下的方式定义匿名函数。

```julia
(parlist) -> 表达式
```
上面parlist是参数列表。如果只有一个参数， 括号可以省略。 匿名函数没有名字， 所以我们没法直接调用它。 一般匿名函数都是作为值， 传入一个需要函数参数的函数。 比如，在Julia中，有一个函数map， 其签名为
```julia 
map(f, c...) -> collection
``` 
该函数可以将一个函数`f`作用到容器中的每一个元素， 其第一个参数f就必须是函数。

```julia
julia> map(x -> x^2, 1:5)
[1,4,9,16,25]
```
上面的代码中， `x->x^2`就是一个将`x`变为`x^2`的匿名函数。 当匿名函数可能很复杂时， 可以使用do...end形式。 下面的`do ... end`之间的部分是一个匿名函数， 函数的参数是x。 这个函数将作为map的第一个参数。这种写法也被称为do代码块。

```julia  
julia> map(1:5) do x
    x^2
end
[1,4,9,16,25]

```
"""

# ╔═╡ 55775e04-eb2a-407e-b91e-f7141cac8357
md"""
## ...操作符
"""

# ╔═╡ 41927f03-eb46-42a7-871a-abeda1777351
md"""
这个三点操作符是Julia中一个特殊的操作符， 在Julia中有两种作用，可以参考[`...文档`](https://docs.julialang.org/en/v1/manual/faq/#What-does-the-...-operator-do?)了解更多。

在函数定义的场景中， 可以表示“卷入”操作：把多个参数卷到一个参数上。比如在下面的函数定义， 只有一个参数，args，但args后面有三个点，他表示不管你输入多少个参数， 都将被卷入args这个变量里。当然这个变量会是一个元组，包含你给的所有参数。
```julia

function printargs(args...)
        println(typeof(args))
        for (i, arg) in enumerate(args)
            println("Arg #$i = $arg")
        end
end
```
"""

# ╔═╡ c0f33bf0-4cff-4654-85c8-a5b630590f7a
function printargs(args...)
        println(typeof(args))
        for (i, arg) in enumerate(args)
            println("Arg #$i = $arg")
        end
end

# ╔═╡ ffbd139c-3c51-4b1f-bc57-714bfe4c645c
printargs(1, 2, 3,4)

# ╔═╡ 86920356-7427-4732-a6bb-64521e1cd425
md"""
三点操作符的另一个用法是展开， 通常，它可以将其前面的对象展开成一个一个元素组成的元组。这个用法经常出现在函数调用的场景， 我们给函数的参数，看上去可能只有一个， 但我们可以将这个参数展开， 得到多个值，分配给多个参数。
"""

# ╔═╡ ca73a92d-86b7-488e-9de4-68aee3e30482
tx = [1,2,3]

# ╔═╡ e0218467-9f70-493e-a506-bb9314b40f47
(tx...,)

# ╔═╡ 58acc135-3372-4232-8e44-77f0a9aca6a0
printargs(tx...)

# ╔═╡ 6f4dc741-7a17-4484-8b80-a58e28df7e86
md"""
## 通用函数与多重分派
通常情况下，我们可能会希望一个函数具有多种功能。比如乘法是一个函数， 当用数字调用乘法时，得到的结果是通常意义下的乘法。当用字符串去调用乘法时，得到的结果却是字符串的拼接。

```julia
julia> 3*5
15

julia> "hello" * "world"
"helloworld"
```
这种函数被称为通用函数(generical function), 用不同的对象调用函数时， 本质上是不同的方法。Julia是如何判断应该调用什么方法的呢？ 答案是多重分派。



"""

# ╔═╡ ea520cd1-2970-4dbf-a5b7-6a3d01c83e06
md"""
## 函数编写练习
"""

# ╔═╡ 062b1e41-0040-4e85-91bb-27edde8179da
md"""
##### Ex1. 编写一个函数，用于返回一个向量的2范数。
""" 

# ╔═╡ 6952d202-4865-4359-885a-ae9d6ca58bb3
norm(v) = sqrt(sum(v.^2))

# ╔═╡ 9bf3dbcf-82cf-4e77-b816-daf990974ddd
norm(v1, v2) = norm(v1 .- v2)

# ╔═╡ 9a72fd9a-c645-4b4f-bc97-2caf75865f93
norm(ones(10), 2*ones(10))

# ╔═╡ 31f0cfa6-b6cc-4bc7-8feb-974eb212e356
md"""
#### Ex2. 编写一个函数， 用于实现对向量的最小-最大规范化。
在数据分析中， 因为不同的变量可能存在不同的量纲， 导致数据的大小分布情况是不一致的。 为了减少量纲的影响， 通常我们需要将数据转换到相同的尺度， 这称为数据的规范化。  最小-最大规范化是利用向量的最小-最大值将数据转换到给定的区间， 通常为[0,1]。 即
$$z = \frac{x - min_x}{max_x - min_x}$$
"""

# ╔═╡ 43be64e3-94cb-4cb5-acfa-fddb04891bd0
md"""
!!! hint "参考答案"

	```julia
	function zminmax(v)
		dn = minimum(v)
		up = maximum(v)

		(v .- dn) ./ (up - dn)
	end
	```
""" 

# ╔═╡ c6d1efb7-8429-4ce7-8745-877f40d6bca3
md"""
#### Ex3. 编写一个函数， 输入参数是一个表示年龄的整数， 输出结果是年龄代表的类别：老中青三种之一。判断条件是：年龄>60岁为老， [40, 60]为中， <40为青。
"""

# ╔═╡ db7d57e6-9eff-488c-8b74-ccb513715c21
md"""
!!! hint "参考答案"
	```julia
	function getclass(age)
		if age > 60
			return "老"
		elseif age >= 40
			return "中"
		else
			return "青"
		end
	end
	```
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
# ╠═d113eb95-cb54-4f6d-b175-bd011e9e2571
# ╠═f75b03fb-ea9d-45db-9dde-a11787b9c667
# ╟─203e0107-b2cf-4311-800d-9e108fca8197
# ╟─7c2dfe32-f55f-4ba3-b2a0-c30b63ccfa10
# ╟─184811a8-3326-43db-ae30-c85bd57b06e7
# ╟─f6299698-0e82-4744-9929-fb43410148a0
# ╟─bc894456-3d47-4285-9301-d536e1f2317e
# ╟─f6d3f96e-6c9a-4d80-ba93-0152e0a072b5
# ╟─d71ab211-8c83-444c-93d9-e3137f06ee69
# ╟─e73ca1c6-a56d-4dfa-b745-0d29602ebd70
# ╟─2db36183-01f7-4b65-bde3-4b7de6cef342
# ╠═55775e04-eb2a-407e-b91e-f7141cac8357
# ╟─41927f03-eb46-42a7-871a-abeda1777351
# ╠═c0f33bf0-4cff-4654-85c8-a5b630590f7a
# ╠═ffbd139c-3c51-4b1f-bc57-714bfe4c645c
# ╟─86920356-7427-4732-a6bb-64521e1cd425
# ╠═ca73a92d-86b7-488e-9de4-68aee3e30482
# ╠═e0218467-9f70-493e-a506-bb9314b40f47
# ╠═58acc135-3372-4232-8e44-77f0a9aca6a0
# ╟─6f4dc741-7a17-4484-8b80-a58e28df7e86
# ╟─ea520cd1-2970-4dbf-a5b7-6a3d01c83e06
# ╟─062b1e41-0040-4e85-91bb-27edde8179da
# ╠═6952d202-4865-4359-885a-ae9d6ca58bb3
# ╠═9bf3dbcf-82cf-4e77-b816-daf990974ddd
# ╠═9a72fd9a-c645-4b4f-bc97-2caf75865f93
# ╟─31f0cfa6-b6cc-4bc7-8feb-974eb212e356
# ╟─43be64e3-94cb-4cb5-acfa-fddb04891bd0
# ╟─c6d1efb7-8429-4ce7-8745-877f40d6bca3
# ╟─db7d57e6-9eff-488c-8b74-ccb513715c21
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
