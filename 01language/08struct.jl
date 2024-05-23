### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 983f9c7e-4ce5-4975-ba80-fbc50f148a61
using PlutoUI
# ╔═╡ f86101a1-6391-4b9a-bb17-dca64b6f8632
TableOfContents(title="目录")

# ╔═╡ e0aab4d3-7832-475d-94e8-3918248f1b3d
md"""
# 复合类型Composite Type
在面向对象的编程语言中， 比如Python， 我们可以定义自己的类（class）。一个类可以包含一些字段（数据）， 同时也会有这个类的对象可以调用的相关函数（方法）。 一般， 类实例化之后被称为对象（object）。要调用相关函数， 我们需要使用`对象.方法`这样的语法形式， 这表明， 方法是由对象的类决定的。 在Julia中， 数据和方法是分开的。决定调用何种方法是由函数的位置参数共同决定的（多重分派），而不仅仅是函数的第一个参数。这种将数据跟方法解耦的方式具有非常多的优势。

因此， 在Julia中，我们不能定义类， 但可以定义包含一些字段的数据类型--复合类型。简单来说， 复合类型就是一个把多个名字绑定为一个整体的数据类型。 类似在C语言中， Julia使用struct关键字定义复合类型。
```julia
struct Point
	x
	y
end
```
上面定义了一个名为Point的复合类型。在该类型中， 有两个名字(字段field)。 这个定义很简单， 你可以给两个字段赋予任何的值。因为，我们没有对字段的数据类型做任何的限制， 这种情况下是默认类型Any。当然， 对于特定的应用来说， 我们限制字段的类型是有好处的（可以获得更快的代码）。如果我们要对类型做出限制， 可以使用类型断言符--两个冒号`::` 

```julia
struct Point
	x::Float32
	y::Float32
end
```
在这个定义里， 我们限制了字段的类型的字段只能是32位的浮点数。 
"""

# ╔═╡ aa9a72bf-b1d1-4e54-89bd-16c11202bdcd
md"""
默认的复合内容是不可修改的， 为了让结构中各个域可修改， 可在定义之前加关键字mutable。

```julia
mutable struct Point
x::Float32
y::Float32
end
```
"""

# ╔═╡ 30aeb721-c5de-4011-9159-ca8b0b1a5f1b
md"""
!!! info "注意"
	在Julia中， 如果我们定义类型的话， 习惯上， 使用大写字母开头的名字，涉及多个单词时， 每个单词首字母大写
""" 

# ╔═╡ 3d39117c-7011-497c-914e-5043c0aa08a2
struct Point
	x::Float32
	y::Float32
end

# ╔═╡ deb6c1c6-7bf1-48b2-b6d4-7ee7dacb9969
fieldnames(Point)

# ╔═╡ 8ffa29ef-ab8e-440f-917e-0e713ecb7b63
p = Point(2,3)

# ╔═╡ d5cb8de2-55ee-4719-b1af-87b8dc0430f0
p.x, p.y

# ╔═╡ f4e02b42-8fab-4dff-80dc-3db96a76a9c9
md"""
用struct直接定义的类型默认是不可修改的。比如，下面试图修改p的坐标的操作会失败。
"""

# ╔═╡ 7c55f112-671c-4f1f-b3ec-22f1f75b8b38
p.x = 4

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

# ╔═╡ 28f7ab8b-9769-4141-9e0f-c7fd2337bb2a
p.x, p.y

# ╔═╡ 0bdee471-5437-453e-a9e2-857ccf9ed5cf
md"""
## 再说函数
函数抽象的来看是一定数据类型的对象到结果的一个映射。对象就是通过元组形式构造的参数列表。
"""

# ╔═╡ b6deb0d6-fc23-4b36-aa90-2a99e7b09ef4
md"""
### 用结构体重写Ex2.
在建模过程中， 我们对原始数据施加了某个变换， 当新的样本来临时， 我们仍需要进行同样的变换才能用于模型的预测。 这时候， 我们需要将变换保存起来， 在后续碰到新的数据时， 再使用它去做变换。 这意味着， 我们需要存储变换过程中使用到的值。 为了实现这一点， 我们用一个结构体表示一个变换。

下面先定义最小-最大变换结构体。

""" |> timu

# ╔═╡ 21e57a19-c19e-40f9-ba2c-33b449c1b8e5
(p::Int)(a) = p+a

# ╔═╡ 47d9aa6a-26e2-4541-b5b7-9ae89f7243fd
x = 3

# ╔═╡ ef024edc-38c8-4008-a6ae-386f2829c802
x(5)

# ╔═╡ 464c22b1-95cc-4ccb-a7f6-36daaf2a46e9
mutable struct MinMax
	dn
	up
end

# ╔═╡ d7506a49-ac06-4d58-bd57-1ba2aecebd4f
md"""
因为我们会在模型训练的时候修改这个结构体中存的值。所以我们需要将模型定义为mutable的。

有了结构体之后， 相当于我们有了一个抽象的变换。 当我们给定一个向量去“训练”后， 我们就可以用这个变换去变换数据了。
"""

# ╔═╡ c8bd7ef5-8d6c-4890-b4f5-d7618ea10565
function fit!(t::MinMax, v)
	t.dn = minimum(v)
	t.up = maximum(v)
end

# ╔═╡ d9914cdc-ea19-4f8f-8222-26e7cd7b1341
T1 = MinMax(0,0)

# ╔═╡ 994a1afa-23ae-4943-93f0-f273a741672c
fit!(T1, [4,5,6,7,10])

# ╔═╡ cc1f1bfa-d908-4af0-ae96-138146c54f04
T1

# ╔═╡ beca5496-1748-44f0-8dbc-123db3586072
function transform(T::MinMax, v)
	(v .- T.dn) ./ (T.up - T.dn)
end

# ╔═╡ 7a737533-1108-4568-a688-9e41c88ea48d
transform(T1, [4,5,6,7,10])

# ╔═╡ 59aa4dc5-7189-4753-bd6f-dc3f001ef6df
md"""
当有新的数据需要转换时
"""

# ╔═╡ 3a1d6911-6842-4e04-be03-2c13e62f586c
transform(T1, [8,12])

# ╔═╡ 52752dc6-fd37-43fb-a497-a9a8893fc79a
md"""
有时候， 可能还需要逆变换， 比如知道变换后的值是 0.7， 变换之前是多少？
"""

# ╔═╡ 1b929cc3-d456-4d22-8ea2-641f6b2c3c92
function inverse_transform(t::MinMax, v)
	v .* (t.up - t.dn) + t.dn
end

# ╔═╡ 44cd23a2-5a89-44c6-924b-afdc0c1d8f26
inverse_transform(T1, 0.166667)

# ╔═╡ 2c49c44b-fb6c-4058-b489-8f82d73b6ce1
md"""
在一些高级语言中， 我们可以定义类(class)， 类中同时具有数据和可以绑定方法。 Julia的自定义类型不能在类型定义时定义方法（构造函数除外）。 但我们可以基于类型定义相应的函数（这种函数， 有时候称为函子）。 比如， 下面的代码我们希望定义一个多项式， 用coeffs来存储多项式的系数：
```
struct Polynomial
	coeffs
end
```
定义了这个多项式的表示类型之后， 我们可以定义该类型绑定的函数如下， 这个函数没有函数名， 函数名对应的是一个类型名， 前面的p在具体调用的时候会指向类型的对象。
```
function (p::Polynomial)(x)
	v = p.coeffs[end]
for i = (length(p.coeffs)-1):-1:1 
	v = v*x + p.coeffs[i]
end
	return v
end
```

此后， 在我们构造了类型的对象之后， 我们就可以用对象去调用这个函数了。 
```
t = Polynomial([1,10,100])
t(5)
```

这种通过给类型加方法使得类型的对象变得可被调用的机制(有点类似于Python中通过class定义数据和方法的过程)， 在一些高级的编程场合使用非常广泛， 比如， 在神经网络中， 就可以通过这种方式定义一种特殊的数据类型， 代表特殊的网络层， 然后定义相应的类型方法， 在初始化之后， 就可以通过对象去计算结果了。 可以把这种机制看成是面向对象编程的一种模拟。
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
# ╠═983f9c7e-4ce5-4975-ba80-fbc50f148a61
# ╠═f86101a1-6391-4b9a-bb17-dca64b6f8632
# ╟─e0aab4d3-7832-475d-94e8-3918248f1b3d
# ╠═aa9a72bf-b1d1-4e54-89bd-16c11202bdcd
# ╟─30aeb721-c5de-4011-9159-ca8b0b1a5f1b
# ╠═3d39117c-7011-497c-914e-5043c0aa08a2
# ╠═deb6c1c6-7bf1-48b2-b6d4-7ee7dacb9969
# ╠═8ffa29ef-ab8e-440f-917e-0e713ecb7b63
# ╠═d5cb8de2-55ee-4719-b1af-87b8dc0430f0
# ╟─f4e02b42-8fab-4dff-80dc-3db96a76a9c9
# ╠═7c55f112-671c-4f1f-b3ec-22f1f75b8b38
# ╟─b99159a2-3060-4aff-a3e5-67095ab582b8
# ╟─0a3e8baa-d462-4b31-9f51-ceb499bea05c
# ╠═28f7ab8b-9769-4141-9e0f-c7fd2337bb2a
# ╟─0bdee471-5437-453e-a9e2-857ccf9ed5cf
# ╟─b6deb0d6-fc23-4b36-aa90-2a99e7b09ef4
# ╠═21e57a19-c19e-40f9-ba2c-33b449c1b8e5
# ╠═47d9aa6a-26e2-4541-b5b7-9ae89f7243fd
# ╠═ef024edc-38c8-4008-a6ae-386f2829c802
# ╠═464c22b1-95cc-4ccb-a7f6-36daaf2a46e9
# ╠═d7506a49-ac06-4d58-bd57-1ba2aecebd4f
# ╠═c8bd7ef5-8d6c-4890-b4f5-d7618ea10565
# ╠═d9914cdc-ea19-4f8f-8222-26e7cd7b1341
# ╠═994a1afa-23ae-4943-93f0-f273a741672c
# ╠═cc1f1bfa-d908-4af0-ae96-138146c54f04
# ╠═beca5496-1748-44f0-8dbc-123db3586072
# ╠═7a737533-1108-4568-a688-9e41c88ea48d
# ╠═59aa4dc5-7189-4753-bd6f-dc3f001ef6df
# ╠═3a1d6911-6842-4e04-be03-2c13e62f586c
# ╠═52752dc6-fd37-43fb-a497-a9a8893fc79a
# ╠═1b929cc3-d456-4d22-8ea2-641f6b2c3c92
# ╠═44cd23a2-5a89-44c6-924b-afdc0c1d8f26
# ╟─2c49c44b-fb6c-4058-b489-8f82d73b6ce1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
