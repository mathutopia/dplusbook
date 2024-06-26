### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ a37e7480-7e13-4c45-9dcd-8a6f0688d7f3
begin
using PlutoUI
TableOfContents(title="目录")
end

# ╔═╡ 7de2e473-79be-4f2a-8fc0-b9b1a1712c03
md"""
# 准备工作
"""

# ╔═╡ 8cc0e920-a680-4b44-9d34-710a378f19dc
md"""
## 安装REPL环境
虽然是编译型的语言， 但Julia语言提供了一个类似R语言的控制台。 其安装过程非常简单， 只需按照如下步骤依次操作即可。

1. 请根据自己的电脑系统， 到[**Julia官网**](https://julialang.org/downloads/)下载最新版本的相应软件。下面假定是windows系统。

2. 双击下载的exe文件，选择安装路径（或者采用默认的安装路径），其余都是默认就行。

3. 安装成功之后，桌面上会出现Julia图标。
5. 双击图标打开Julia控制台， 通常叫做**REPL环境**。REPL是“Read–Eval–Print Loop”(读取-求值-打印-循环)的缩写,是一种简单的、交互式的编程环境。

下面是一个打开的REPL环境的图片。 图中的 `julia>` 提示当前是Julia语句的输入模式， 在该模式下， 在光标处输入语句，回车之后就可以看到语句执行的结果。

"""

# ╔═╡ a4781db0-1cbe-46f2-9c5a-3efe0329e902
LocalResource("../img/repl.png")

# ╔═╡ 4ca8ac78-fbc6-427c-9555-2a81cad221e2
md"""
REPL环境有四种模式： 第一种模式就是**代码（Julian）模式**，提示符是 `julia>`， 这也是REPL启动的时候的默认模式。 这种模式下， 可以直接写Julia的代码。

在代码模式下， 输入右边中括号`]`,进入第二种模式—**包模式**，其提示符是Julia的版本号。例如：`(@v1.10 pkg)>`。这种模式下， 可以使用`add Pkgname`安装需要的包（Package）。 比如，安装Pluto包(`add Pluto`) 。 可以同时安装多个包，只需要逗号分隔就好。 在包模式下， 按删除键可以退回代码模式。

在代码模式下， 输入问号`?`， 将进入**帮助（help）模式**， 其提示符是`help?>`。在该模式下， 输入任何`名字`, 可获得该名字的帮助文档。 在帮助模式下， 按删除键可以退回代码模式。 

在代码模式下， 按分号键`;`， 可以进入**shell模式**。其提示符为`shell>`。 命令模式可以执行一些操作系统命令。同样， 按删除键可以退回代码模式。


"""

# ╔═╡ 20de8e05-edb4-43aa-a14e-5fd24e290ecd
md"""
!!! warn "设置包安装路径"
	不管你安装Julia的时候选择的路径是什么， 后续Julia都会将你安装的包之类的资料放到全局变量`DEPOT_PATH`指定的路径下， 你可以在REPL中输入这个变量名看看路径是什么， 通常是当前用户的家目录下的`.julia`目录（`~/.julia`）。对Windows系统而言， 这个目录通常在C盘。随着Julia的使用， 安装的包等各类资源可能会越来越多， 这个目录下的文件可能会越来越多， 为了避免C盘空间不足， 建议在安装任何第三方包之前先修改这个路径。修改的方式有很多， 推荐最省事的一种。定义一个环境变量， `JULIA_DEPOT_PATH`, 其值为你想要设置的路径， 比如设置为""D:/.julia"。这样，以后所有的包都会默认安装在D盘， 不会影响C盘的空间。
"""

# ╔═╡ 4dfeadb7-ca9b-45ac-a332-5bb621a133aa
md"""
## 安装Pluto包
Pluto是一个基于Julia的科学计算环境， 类似Jupyte notebook， 但存在一些设计上的显著差异。 本教程关于Julia的操作都在Pluto中完成。 下面介绍如何安装Pluto环境， 具体可以参考下面的视频。

Pluto是一个Julia的包（package）， 其安装只需要
1. 在REPL环境中， 将REPL切换到包安装模式（在Julia模式下，输入**英文状态**的右中括号 ]。）
2. 在包模式下（提示符： `(@v1.9) pkg>`, 不同版本会稍有不同），执行`add Pluto`就可以了（你的安装信息可能跟视频中的不同， 视频中是因为已经安装了）。
3. 安装完成之后， 通过输入删除符号（Backspace）切换到Julia语句模式下， 通过执行
```julia
using Pluto
Pluto.run()
```
两条语句即可启动Pluto环境。默认情况下，Pluto会打开一个网页。
"""

# ╔═╡ 49ace3ca-acb5-4028-aae5-b38d0ac6e5f7
LocalResource("../video/pluto安装.mp4", :width => 800)

# ╔═╡ 357f5116-3a19-4591-a5c5-6efc1165b63a
md"""
## Pluto的使用
由于Pluto是本教程的关键计算环境， 下面的视频简要介绍了一下Pluto的使用。 更多使用的方法， 可以参考Pluto提供的官方notebook。
"""

# ╔═╡ 7fe6300f-72c4-4ce3-ac1e-6c2cf2e9579f
LocalResource("../video/Pluto写代码.mp4", :width => 800)

# ╔═╡ 2f91e247-0ecd-411c-852f-ba1bbc229813
md"""
关于Pluto， 需要了解以下内容：

- 如何打开和保存Pluto文件
- Pluto文件，本质上还是可直接运行的jl文件
- Pluto文件中， 每一个cell只能有一条julia语句。如果要写多条语句， 需要用`begin...end`包裹起来。相当于构建复合语句。
- 如果想在cell中写文本，可以按照makdwon格式去写，然后将文本用三引号包裹（相当于Julia中的字符串)，再在前面加一个`md`即可。这是Julia中的一种特殊字符串， Julia会按照`markdwon`语法解析字符串，并最终形成html文本显示出来。 如果觉得这么写比较麻烦， 可以使用快捷键`Ctrl + M`， 它会自动给一个cell加上`md`关键字和字符串标识。
```julia
md'''
...你的文本...
'''
```
当然， 你也可以直接写html字符串。只需要在字符串的前面加上`html`标识即可。
- Pluto文件中， 每一个变量名只能定义一次（这是一个跟写Jupyer Notebook 有显著差异的地方）。
"""

# ╔═╡ 4f968683-efca-4d27-8952-7a02ba9c09a0
md"""
!!! info "更简洁的启动"
	上面介绍的是Pluto启动的一般方法。在这个文件夹中， 有一个`run_julia_pluto.bat`文件， 如果你是windows系统， 并且按上面的要求安装了Julia，设置了路径， 只要点击这个文件， 就可以自动打开Pluto了（不需要启动Julia）。 如果你启动了Julia， 只要执行include本目录下的"start.jl"文件也是可以的。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "f64cdffc70331b0a2f407efefd54fd84eb680773"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

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
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

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
# ╠═a37e7480-7e13-4c45-9dcd-8a6f0688d7f3
# ╟─7de2e473-79be-4f2a-8fc0-b9b1a1712c03
# ╟─8cc0e920-a680-4b44-9d34-710a378f19dc
# ╠═a4781db0-1cbe-46f2-9c5a-3efe0329e902
# ╟─4ca8ac78-fbc6-427c-9555-2a81cad221e2
# ╟─20de8e05-edb4-43aa-a14e-5fd24e290ecd
# ╟─4dfeadb7-ca9b-45ac-a332-5bb621a133aa
# ╠═49ace3ca-acb5-4028-aae5-b38d0ac6e5f7
# ╟─357f5116-3a19-4591-a5c5-6efc1165b63a
# ╠═7fe6300f-72c4-4ce3-ac1e-6c2cf2e9579f
# ╟─2f91e247-0ecd-411c-852f-ba1bbc229813
# ╟─4f968683-efca-4d27-8952-7a02ba9c09a0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
