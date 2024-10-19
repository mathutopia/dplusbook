### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ 4a3126ab-f51a-4be6-a0c9-48d735958832
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ d6dcee7b-519d-42a9-9eb9-0a85da22c80c
TableOfContents(title="目录")

# ╔═╡ 3b2cdb54-faba-4bcd-9d1b-3dc2847d6780
present_button()

# ╔═╡ 025404c8-cba6-4932-ab89-b29309446c0c
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia简短教程
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
		复合类型
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ e0aab4d3-7832-475d-94e8-3918248f1b3d
md"""
## 复合类型定义（Composite Types）

在面向对象编程（OOP）的语言中，我们能够通过定义类（class）来封装数据和行为。类是对象的蓝图，而对象（object）是类的实例。在这些语言中，对象通过方法（method）来暴露行为，而这些方法通常通过 `对象.方法` 语法调用，表明方法调用依赖于对象的类。与此相对，Julia 采用了一种不同的方法，将数据和行为分离，并通过多重分派机制来决定调用哪个方法。在 Julia 中，数据类型和函数是独立定义的，而方法的适用性是基于所有位置参数的类型，而不仅仅是第一个参数（多重分派）。

在 Julia 中，我们不定义类，而是定义复合类型，这些类型可以包含多个字段（fields），即数据字段。复合类型通过 `struct` 关键字定义，它允许我们将多个数据字段组织成一个命名的实体。

```julia
struct Point
    x
    y
end
```

上述代码定义了一个名为 `Point` 的复合类型，其中包含两个字段：`x` 和 `y`。这种定义方式非常灵活，因为我们没有指定字段的类型，它们默认为 `Any` 类型，这是 Julia 中的最通用类型。然而，为了提高代码的性能和可读性，也可以指定字段的类型。

为了指定字段类型并确保类型的安全性，我们可以使用类型注解，通过在字段名后使用 `::` 符号来指定字段的类型。

```julia
struct Point
    x::Float32
    y::Float32
end
```

在这个定义中，我们明确指出 `x` 和 `y` 字段必须是 `Float32` 类型的值。这种类型注解不仅提高了代码的清晰度，还有助于 Julia 编译器优化存储和访问这些字段的代码，从而提高运行时效率。

通过这种方式，Julia 的复合类型为数据结构的设计提供了强大的灵活性和类型安全，同时保持了代码的简洁性和高性能。

"""

# ╔═╡ aa9a72bf-b1d1-4e54-89bd-16c11202bdcd
md"""
## 复合类型的可变性

在 Julia 中，复合类型（也称为结构体）默认是不可变的，这意味着一旦创建了结构体实例，其字段的值就不能被更改。这种特性在某些情况下非常有用，尤其是当需要确保数据不被改变时。然而，在其他情况下，我们可能需要能够修改结构体的内容。为了实现这一点，Julia 提供了 `mutable` 关键字，允许我们定义可变的结构体。

### 不可变结构体

不可变结构体的定义不需要 `mutable` 关键字。下面是一个定义不可变结构体的例子：

```julia
struct Point
    x
    y
end
```

创建一个 `Point` 结构体的实例，并尝试修改它：

```julia
p = Point(1, 2)  # 创建实例
# p.x = 3        # 尝试修改，将会导致编译错误
```

在上面的代码中，尝试修改 `p.x` 将会导致一个编译时错误，因为我们试图修改一个不可变的实例。

### 可变结构体

要定义一个可变的结构体，需要在 `struct` 之前添加 `mutable` 关键字。下面是一个定义可变结构体的例子：

```julia
mutable struct Point
    x
    y
end
```

创建一个 `Point` 结构体的可变实例，并修改它：

```julia
p = Point(1, 2)  # 创建可变实例
p.x = 3          # 修改实例的 x 字段
p.y = 4          # 修改实例的 y 字段
```

在这个例子中，我们可以在运行时自由修改 `p.x` 和 `p.y` 的值，因为 `Point` 是一个可变的结构体。


"""

# ╔═╡ 30aeb721-c5de-4011-9159-ca8b0b1a5f1b
md"""
!!! info "注意"
	在Julia中， 如果我们定义类型的话， 习惯上， 使用大写字母开头的名字，涉及多个单词时， 每个单词首字母大写
""" 

# ╔═╡ f4e02b42-8fab-4dff-80dc-3db96a76a9c9
md"""
用struct直接定义的类型默认是不可修改的。比如，下面试图修改p的坐标的操作会失败。
"""

# ╔═╡ b99159a2-3060-4aff-a3e5-67095ab582b8
md"""
## 构造函数

定义了复合类型之后， 如何构造复合类型的对象呢？ 通常情况下， 数据类型会有自动生成构造函数。 默认的构造函数， 函数名就是类型名， 参数会依次赋值给每一个域。如果数据类型不同， 会尝试用convert转换后去赋值， 如果转换不了， 则会构造失败。 下面的代码可以定义平面上的一个点（x, y）。 然后用`Point2D(3, 4)`则可以生成一个具体的点。
```
struct Point2D
	x::Float32
	y::Float32
end
```
我们可以通过 `对象.字段名` 的方式获取对象的特定字段的值。 你可以通过`fieldnames(类型名)`函数获取一个类型的所有的字段名。

"""

# ╔═╡ 0a3e8baa-d462-4b31-9f51-ceb499bea05c
md"""
我们把一个复合类型当成函数调用， 实际上是调用了类的默认构造函数`constructor`。 一般一个复合类型在定义之后， Julia会自动为其提供两个默认构造函数：一个接受任意类型参数的构造函数和一个接受精确类型参数的构造函数。 接受任意类型参数的构造函数会自动调用convert函数将参数转化为类型指定的类型。 比如， 上面构造的点p， 我们输入的数据是整数2,3， 但仍然能正确构造出对象，是因为整数可以转化为浮点数。
"""

# ╔═╡ e3e16b48-5aab-44b5-975a-09625ab546cf
md"""
!!! info "像函数一样的对象"

	前面讲到， Julia中数据和行为是分离的。 但Julia也提供了一种能力，可以给一个结构体实例（对象）绑定一个函数。这需要特殊的定义方式。
	
	```julia 
	function (对象名::Point)(参数列表)
		函数体
	end
	```
	比如， 这里为Point类型定义了一个函数， 后面就可以通过将对象视为一个函数一样直接调用。在这个函数定义中， 函数名被(对象名::Point)替代， 表示这是给Point类的对象定义的函数。这里对象名的存在只是为了方便在函数体中引用对象的数据， 所以可以随便取合法的变量名。如果函数体中不需要用到对象本身， 对象名可以没有。

请看下面的应用案例。
""" 

# ╔═╡ 97bf55a0-3e23-438e-9b0f-6bf46d85a5ec
md"""
## 应用举例

"""

# ╔═╡ d71fe863-82b7-41fd-873b-3d3f26bf11dc
md"""

### 问题定义
我们的目标是用结构体写一个最大最小规范化的功能。它能将输入的任意向量， 规范到所有元素取值为[0,1]之间的向量。


最大最小规范化（Max-Min Normalization）是一种数据预处理技术，通常用于机器学习和统计学中，目的是将数据缩放到一个特定的范围内，以便于不同特征之间的比较和计算。这种规范化的形式可以表示为：

设 $X$ 是一个原始数据点， $X_{\text{norm}}$ 是规范化后的数据点， $X_{\text{min}}$ 和 $X_{\text{max}}$ 分别是数据集中的最小值和最大值。最大最小规范化的公式为：

$$X_{\text{norm}} = \frac{X - X_{\text{min}}}{X_{\text{max}} - X_{\text{min}}}$$

这个公式确保了 $X_{\text{norm}}$ 的值会在 0 到 1 之间。通过这种方式，所有的特征都会被缩放到相同的尺度。

尽管实现最大最小规范化有多种方式， 为了演示结构体的应用， 我们采用定义结构体的方式。 这也是很多机器学习模型采用的方式。

"""

# ╔═╡ 96c86b3a-de8b-44d2-acf3-06129b4c630c
md"""
### 结构体定义
我们可以把最大最小规范化看成是一个数据处理的模型。 这个模型有两个参数（最大值和最小值）。模型将按照上述公式将输入的向量做转化。

我们引入一个结构体来表示这个模型。
```julia
struct MinMaxScale
	min
	max
end
```

接下来， 生成一个具体的MinMaxScale变量就可以得到一个具体的模型。

```julia
model = MinMaxScale(3,18)
```

接下来， 我们希望这个模型能够将输入的向量做相应的转化。比如， 假设我们的向量是`v`， 我们希望`v'=model(v)`就是转化后的向量。看上去， 相当于MinMaxScale对象可以像函数一样调用。 这要求我们给MinMaxScale结构体绑定一个函数。

```julia 
function (m::MinMaxScale)(v)
	(v .- m.min) ./ (m.max-m.min)
end
```

接下来可以测试一下：
```julia
julia> v = [3,5,7,10]

julia> model(v)
0.0
0.133333
0.266667
0.466667
```

上面的模型已经能够转化向量了， 不过并不是转化到[0,1]之间，因为我们的模型是自己随便指定的参数。 现实情况下， 我们需要让模型从数据中学习具体的参数。学习参数也是拟合参数， 我们定义一个模型的学习函数。

```julia
function fit!(t::MinMaxScale, v)
	t.min = minimum(v)
	t.max = maximum(v)
end
```
请注意， 这个函数是！结尾，表明，我们会修改参数。实际上， 我们对t中的两个字段进行了赋值。这要求，我们的类型必须是可变类型的。所以上面的类型定义需要mutable修饰。
```julia
mutable struct MinMaxScale
	min
	max
end
```
接下来， 我们可以根据给定的数据，拟合模型，进而用模型转化数据了。
```julia
julia> fit!(model, v)

julia> model(v)
0.0
0.285714
0.571429
1.0
```
"""

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
# ╠═4a3126ab-f51a-4be6-a0c9-48d735958832
# ╠═d6dcee7b-519d-42a9-9eb9-0a85da22c80c
# ╟─3b2cdb54-faba-4bcd-9d1b-3dc2847d6780
# ╟─025404c8-cba6-4932-ab89-b29309446c0c
# ╟─e0aab4d3-7832-475d-94e8-3918248f1b3d
# ╟─aa9a72bf-b1d1-4e54-89bd-16c11202bdcd
# ╟─30aeb721-c5de-4011-9159-ca8b0b1a5f1b
# ╟─f4e02b42-8fab-4dff-80dc-3db96a76a9c9
# ╟─b99159a2-3060-4aff-a3e5-67095ab582b8
# ╟─0a3e8baa-d462-4b31-9f51-ceb499bea05c
# ╟─e3e16b48-5aab-44b5-975a-09625ab546cf
# ╟─97bf55a0-3e23-438e-9b0f-6bf46d85a5ec
# ╟─d71fe863-82b7-41fd-873b-3d3f26bf11dc
# ╟─96c86b3a-de8b-44d2-acf3-06129b4c630c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
