### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ db39dcaf-2337-4006-ac36-60a996586cdc
using PlutoUI

# ╔═╡ 45067057-7706-4de3-b5ae-ab7a0a1e53a6
using Unicode

# ╔═╡ 54a9068e-f7f8-4ae1-92f3-1b53bdad9140
TableOfContents(title = "目录")

# ╔═╡ 95bf6dab-60e9-45ab-840d-ce47d9a2c9f0
md"""
# 字符串处理
## 字符与字符串
Julia支持Unicode编码(一个字符可能由1~4个字节表示)， 单个的字符用**单引号**包裹。 字符串用**双引号**包裹，  也可以用三联双引号， 通常用于文档中。 字符的类型是Char， 字符串的类型是String。
"""

# ╔═╡ 461b55f1-f20d-4bc4-838d-f0520a54ef46
typeof('a')

# ╔═╡ e585f4f7-80f7-4f78-bc87-fbe29d4ccde0
'中'

# ╔═╡ 8c0946e6-de78-4fc2-be99-b6b9976a7062
typeof("我爱Julia！")

# ╔═╡ bfc5f457-37da-4ce3-a9ff-e6453402adad
md"""
## 码点
由于Julia支持Unicode编码， 任何一个字符都有一个相应的码点(code point)， 可以认为是该字符对应的整数。 可以通过`codepoint`获取该整数， 也可以通过Char和一个整数构造一个字符。 
"""

# ╔═╡ d01ddfe7-0da5-4296-b746-69612ba17957
codepoint('我') # 0x表示16进制

# ╔═╡ 1d864b6b-5764-4f32-a385-5127504b49f0
Char(0x00006211) 

# ╔═╡ 910bd1fc-3472-4f9f-af76-1f50d8852bbf
Int(0x00006211) # 将16进制转换为10进制

# ╔═╡ c8598c87-33af-4c53-bff1-e8d980a19e2c
Char(25105)

# ╔═╡ 053e0125-4af3-4062-994c-49990844da39
md"""
!!! warning "请注意："
	简单来说， 可以认为码点和字符之间是一对一的关系。 码点通常是整数， 可能是4个字节的整数（UInt32）。因此， 字符的字节数一般大于1。
"""

# ╔═╡ c9bc0e99-a5ee-4bdf-895b-06fd23c4454a
md"""
#### 👉 练习 
请结合点运算，计算英文所有大小写英文字母的码点。 提示： 冒号运算符可以用于构造连续的序列， 例如'a' : 'z' 表示所有小写字母构成的连续序列。
"""

# ╔═╡ c26e69f5-a5da-4933-9304-53d2c6262e8a
Int.(codepoint.('A':'Z'))

# ╔═╡ c36198e4-b208-42c9-95e0-4bd07ce45a6a
Int.(codepoint.('a':'z'))

# ╔═╡ c3ce90c8-a0b0-4026-8cc3-181742b156ab
md"""
## 字符串
字符串是由字符构成的序列， 本质上是码点构成的序列。 字符串是数据处理中经常碰到的一个问题。 下面总结一些常见的字符串处理技巧。
"""

# ╔═╡ feddb72c-4a17-4e31-b906-fb3b5d6e0e9c
md"""
### 字符串拼接
用 * 运算可以直接将多个字符串拼接到一起。
"""

# ╔═╡ 5a40b305-720e-4983-8751-49dd525a8cac
"我爱" * "Julia" * "吗？"

# ╔═╡ bab91e31-0b05-4b32-aac3-eac7442dc65e
md"""
有时候， 我们需要将很多的对象（保存在一个可迭代对象中， 如向量）拼接到一起， 这时可以用join。 
"""

# ╔═╡ 8e408b39-c327-4391-8ea9-0980b78cb2d3
join(["张三", "李四", "王五"], "， ", " 和 ")

# ╔═╡ aeb64546-8b86-4019-ab72-918f3ac96f36
md"""
把多个对象按照它们打印的方式拼接到一起用string函数。
"""

# ╔═╡ 70accb60-7ec3-490b-9703-52790a4bc9b7
string("a", 1, true)

# ╔═╡ 060630e1-8d2a-44fd-9428-4358eeb1bd2d
md"""
### 提取信息
获取字符串占用的字节数sizeof, 长度length， 子字符串[i:j]。 当字符串不是由纯ASCII码组成时， 用中括号提取字符串很容易出错， 更安全的做法是， 使用函数graphemes（需要Julia 1.9版本以上）。 有时候，需要提取一个字符串的前、后面给定数量的字符可以使用first、last。
"""

# ╔═╡ 05cb892c-d400-4914-8bf3-f4db177f4033
str1 = "Hello, World!!"

# ╔═╡ 233f74ed-c55a-496c-98da-1db5e2b709ea
str2 = "我爱julia！"

# ╔═╡ d90c8222-4b62-4f1f-a98b-71e1a9063705
sizeof(str2)

# ╔═╡ ec4641bc-7a5d-4175-9c2a-b40fed8676d3
length(str2)

# ╔═╡ f9f9dbe7-9a3f-49d1-80f1-68b6f25d1a7c
str1[1:2] #

# ╔═╡ 8ad678f6-1ce3-4a9d-a5cc-451f8d0d86fb
str2[1:2]

# ╔═╡ 2174564c-7648-4a4b-8544-581e0e9b7f7e
graphemes(str2,1:2)

# ╔═╡ a58f1010-d481-4179-81b6-c3e7f7b6979c
first(str2, 2)

# ╔═╡ 5af2b2a2-f335-4999-82a0-006ef9616298
last(str2, 3)

# ╔═╡ 8aa6f8ff-574f-40c6-8800-c05f91e5a86f
md"""
### 判断信息
有时候， 我们需要对字符串做一些断言， 比如， 是否包含数字？是否包含特定字符等等。下面是一些相关函数及例子。
"""

# ╔═╡ 370e8eb3-8849-4135-8a61-b1fc289e0125
str3 = "这是一个随便构造的例子， 中间有一个数字34， 结尾是haha"

# ╔═╡ 08f15343-35c6-4e99-b427-bc3ff3b3b25c
md"""
判断字符串是否是以特定字符串开头或结尾？
"""

# ╔═╡ 5f7c648d-7670-41ad-ae8e-5c81e289013c
startswith(str3, "A" )

# ╔═╡ 8496ac3f-7c89-4b4e-813b-81952b827c38
startswith(str3, "这" )

# ╔═╡ 57ad1f0f-3336-4872-b9bb-29475a5f3ec5
endswith(str3, "haha")

# ╔═╡ 9b31f3e4-66e3-4271-aaec-95bd8b457a4c
md"""
判断一个模式(正则表达式)、子字符串是否出现在一个字符串中。 可以采用occursin、或者contain(两个函数的参数顺序不同).
"""

# ╔═╡ 13f0e4ca-c14e-4664-a123-7912ee6ba69a
occursin("3", str3)

# ╔═╡ 3a3df9aa-2900-4907-a287-235eab1cce30
contains(str3, "3" )

# ╔═╡ 749b6ce5-61cd-40f0-837f-08940138f660
occursin(r"\d+", str3)

# ╔═╡ d7756695-6873-4353-b836-c0839a59cb1a
md"""
### 查找信息
一般是查找给定模式所在的位置， 方便后续去提取。 下面从字符串中提取“一个”。 由于字符串中包含多个“一个”， 可以使用findnext从指定位置去查找另一个。 如果找不到给定的信息， 返回值是nothing。
"""

# ╔═╡ c8015fbb-941f-46b9-91cd-349e42f40ca4
idx = findfirst("一个", str3) 

# ╔═╡ b2a0034a-86fe-41cf-bca7-f78299f965bf
str3[idx]

# ╔═╡ a195c390-d4f7-4400-8e25-7f14ec9f0110
idx2 = findnext("一个", str3, idx[end] + 1 ) 

# ╔═╡ 382a6914-d2bb-45a7-a063-9dc372352a87
idx3 = findnext("一个", str3, idx2[end] + 1 ) 

# ╔═╡ cb6087b3-34c9-42b5-b6d2-8c97fe6ba4bc
isnothing(idx3)

# ╔═╡ ae17e0f1-0e3e-4213-8dec-ce298aa769f0
md"""
### 字符串插值
有时候， 我们可能会动态构建字符串， 即将变量的值作为字符串的一部分插入字符串中。 通常是在构建字符串时， 用 `$变量名` 的方式将其加入字符串的构造。 有时候， 为了避免变量名跟字符串中的其他字符产生混淆， 可以将变量用括号包裹起来， 及`$(变量名)`。
"""

# ╔═╡ 3027ec82-269f-4bc4-b721-eb63243804e8
nm = "San Zhang"; course = "Data Mining";

# ╔═╡ 0a102bdc-27cb-45ab-b377-55e620716bec
"我们$(course)课程的老师是： $nm."

# ╔═╡ eff2736c-f473-4912-83be-8fa627d3535d
id = "352719200008101112"

# ╔═╡ 9af13bd5-515a-43c3-8e6a-49c60b7a8385
md"""
### 字符串变换
字符串在数据分析中一种常用应用是： 我们读取的数据可能是字符串格式， 需要将其转换为数字。常使用的函数是`parse(type, str)`， 这个函数通常用于类型之间的转换。
"""

# ╔═╡ b41d5c25-8bc7-4f8b-b531-271e1ec08ea7
x = parse(Int64,"35")

# ╔═╡ 9d72d803-29c4-498c-8164-6b9b86b102ae
typeof(x)

# ╔═╡ fa6dec8f-c11f-4600-896f-55515f18c262
parse(Float64, "33222.45")

# ╔═╡ 55cabcf6-308b-416c-ad6d-c1e5a15f3da6
md"""
如果要把数字变换为字符串， 可以使用string函数, 该函数还可以指定进制。
"""

# ╔═╡ 29e28ca6-2435-4bf4-a091-811138025c8b
string(356.8)

# ╔═╡ 27c389e6-1949-4bb5-ac88-98685831117f
string(128, base = 2) # 把128转换为2进制表示的字符串形式

# ╔═╡ 4d5df4c1-14f2-4779-9e63-9c81b8fa1c9b
md"""
如果要将一个字符串逆序， 可以使用reverse函数。
"""

# ╔═╡ f776f6b6-4268-454b-8ec4-fc5ec7a9a53e
reverse(str3)

# ╔═╡ 5fcfd25d-e1ac-411f-aef9-f1c08225a1be
md"""
#### 👉 练习 
已知某人的身份证号码为"430524199108241121"， 即构造一个新的字符串: 某人的生日是：****年\**月\**日， 其中**应该替换为相应的数字。
"""

# ╔═╡ adb8fcc2-e5b3-4c7e-8bd0-9bd15581778f
code = "430524199108241121"

# ╔═╡ 24ac4e8c-27ac-4ac5-9b76-4602fde888e8
"某人的生日是：$(code[7:10])年$(code[11:12])月$(code[13:14])日"

# ╔═╡ 874f4cde-e07c-4385-9681-a75a048a38a7
md"""
## 总结
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unicode = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[compat]
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "4fb6a90df31ba1ab1f056c9b265be548a51b5fff"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

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
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

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
git-tree-sha1 = "a5aef8d4a6e8d81f171b2bd4be5265b01384c74c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.10"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "259e206946c293698122f63e2b513a7c99a244e8"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

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
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

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
# ╠═db39dcaf-2337-4006-ac36-60a996586cdc
# ╠═54a9068e-f7f8-4ae1-92f3-1b53bdad9140
# ╟─95bf6dab-60e9-45ab-840d-ce47d9a2c9f0
# ╠═461b55f1-f20d-4bc4-838d-f0520a54ef46
# ╠═e585f4f7-80f7-4f78-bc87-fbe29d4ccde0
# ╠═8c0946e6-de78-4fc2-be99-b6b9976a7062
# ╟─bfc5f457-37da-4ce3-a9ff-e6453402adad
# ╠═d01ddfe7-0da5-4296-b746-69612ba17957
# ╠═1d864b6b-5764-4f32-a385-5127504b49f0
# ╠═910bd1fc-3472-4f9f-af76-1f50d8852bbf
# ╠═c8598c87-33af-4c53-bff1-e8d980a19e2c
# ╟─053e0125-4af3-4062-994c-49990844da39
# ╟─45067057-7706-4de3-b5ae-ab7a0a1e53a6
# ╟─c9bc0e99-a5ee-4bdf-895b-06fd23c4454a
# ╟─c26e69f5-a5da-4933-9304-53d2c6262e8a
# ╟─c36198e4-b208-42c9-95e0-4bd07ce45a6a
# ╟─c3ce90c8-a0b0-4026-8cc3-181742b156ab
# ╟─feddb72c-4a17-4e31-b906-fb3b5d6e0e9c
# ╠═5a40b305-720e-4983-8751-49dd525a8cac
# ╟─bab91e31-0b05-4b32-aac3-eac7442dc65e
# ╠═8e408b39-c327-4391-8ea9-0980b78cb2d3
# ╟─aeb64546-8b86-4019-ab72-918f3ac96f36
# ╠═70accb60-7ec3-490b-9703-52790a4bc9b7
# ╟─060630e1-8d2a-44fd-9428-4358eeb1bd2d
# ╠═05cb892c-d400-4914-8bf3-f4db177f4033
# ╠═233f74ed-c55a-496c-98da-1db5e2b709ea
# ╠═d90c8222-4b62-4f1f-a98b-71e1a9063705
# ╠═ec4641bc-7a5d-4175-9c2a-b40fed8676d3
# ╠═f9f9dbe7-9a3f-49d1-80f1-68b6f25d1a7c
# ╠═8ad678f6-1ce3-4a9d-a5cc-451f8d0d86fb
# ╠═2174564c-7648-4a4b-8544-581e0e9b7f7e
# ╠═a58f1010-d481-4179-81b6-c3e7f7b6979c
# ╠═5af2b2a2-f335-4999-82a0-006ef9616298
# ╟─8aa6f8ff-574f-40c6-8800-c05f91e5a86f
# ╠═370e8eb3-8849-4135-8a61-b1fc289e0125
# ╟─08f15343-35c6-4e99-b427-bc3ff3b3b25c
# ╠═5f7c648d-7670-41ad-ae8e-5c81e289013c
# ╠═8496ac3f-7c89-4b4e-813b-81952b827c38
# ╠═57ad1f0f-3336-4872-b9bb-29475a5f3ec5
# ╟─9b31f3e4-66e3-4271-aaec-95bd8b457a4c
# ╠═13f0e4ca-c14e-4664-a123-7912ee6ba69a
# ╠═3a3df9aa-2900-4907-a287-235eab1cce30
# ╠═749b6ce5-61cd-40f0-837f-08940138f660
# ╟─d7756695-6873-4353-b836-c0839a59cb1a
# ╠═c8015fbb-941f-46b9-91cd-349e42f40ca4
# ╠═b2a0034a-86fe-41cf-bca7-f78299f965bf
# ╠═a195c390-d4f7-4400-8e25-7f14ec9f0110
# ╠═382a6914-d2bb-45a7-a063-9dc372352a87
# ╠═cb6087b3-34c9-42b5-b6d2-8c97fe6ba4bc
# ╟─ae17e0f1-0e3e-4213-8dec-ce298aa769f0
# ╠═3027ec82-269f-4bc4-b721-eb63243804e8
# ╠═0a102bdc-27cb-45ab-b377-55e620716bec
# ╠═eff2736c-f473-4912-83be-8fa627d3535d
# ╟─9af13bd5-515a-43c3-8e6a-49c60b7a8385
# ╠═b41d5c25-8bc7-4f8b-b531-271e1ec08ea7
# ╠═9d72d803-29c4-498c-8164-6b9b86b102ae
# ╠═fa6dec8f-c11f-4600-896f-55515f18c262
# ╟─55cabcf6-308b-416c-ad6d-c1e5a15f3da6
# ╠═29e28ca6-2435-4bf4-a091-811138025c8b
# ╠═27c389e6-1949-4bb5-ac88-98685831117f
# ╟─4d5df4c1-14f2-4779-9e63-9c81b8fa1c9b
# ╠═f776f6b6-4268-454b-8ec4-fc5ec7a9a53e
# ╟─5fcfd25d-e1ac-411f-aef9-f1c08225a1be
# ╠═adb8fcc2-e5b3-4c7e-8bd0-9bd15581778f
# ╟─24ac4e8c-27ac-4ac5-9b76-4602fde888e8
# ╟─874f4cde-e07c-4385-9681-a75a048a38a7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
