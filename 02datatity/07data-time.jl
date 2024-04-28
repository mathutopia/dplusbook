### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ d868a6b0-b88d-11ed-218b-0f2953e9334a
using PlutoUI, Dates

# ╔═╡ 20723e85-9a1c-4001-95bf-e154f2fd4685
TableOfContents(title = "目录")

# ╔═╡ 67134c51-6915-4cdf-b49e-c3b0feb9e1de
md"""
## 写在前面的话
本教程的主要目的是介绍一下在Julia中处理时间的包Dates. 这是系统自带的包， 但在使用前仍需要`using Dates`。 本教程的内容大部分来自Julia的[官方文档](https://docs.julialang.org/en/v1/stdlib/Dates/)。所以， 感觉英文更舒服的同学可以直接学习[这里](https://docs.julialang.org/en/v1/stdlib/Dates/)。
"""

# ╔═╡ 9cd28b02-1862-4c27-a565-51889a7e66d1
md"""
# 概览
Dates模块提供了两种使用日期的类型:Date和DateTime，分别表示日精度和毫秒精度;两者都是抽象TimeType的子类型。本质上，这两种类型都是包装了Int64类型的整数。不同类型的日期用于不同的场景， 当我们不需要小时等更细的时间的时候，我们应该要使用Date类型。 Dates模块没有记录时区信息。 虽然可以用其他的包去增加时区信息。
"""

# ╔═╡ 11134bb9-b279-4940-b6ba-adbf41a7d07a
md"""
# 1. 构造
Date和DateTime类型可以用整数来构造。可以设想一个时间包含了：年月日时分秒等信息， 那么我们可以通过指定这些信息去构造时间。 简单来说， 我们可以通过给定相应的信息直接构造， 不一定要给全， 因为有默认值。
"""

# ╔═╡ 8b1f850f-fd66-4654-b790-21ca9afe3bcc
Date(2023,3,5), DateTime(2023,3)

# ╔═╡ 34e87d1b-1c39-48c9-a7fc-ee0bbca3a5aa
md"""
时间构造最常见的场景是我们从数据中读取到以文本格式表示时间，需要对其进行转换。 这个时候， 我们可以通过指定时间的格式， 将相应的文本转换为日期或时间。 下面的格式字符串是简单易懂的。ymdhms分别表示年y，月m，日d，时h，分m， 秒s。
"""

# ╔═╡ b2d0b3e5-a3cf-4b26-91ee-332548388cf4
Date("2015-01-01",dateformat"y-m-d"), DateTime("20150101",dateformat"yyyymmdd")

# ╔═╡ 76824297-1ee9-4c5c-976f-feb32829c9a4
md"""
有时候， 为了提高效率， 我们可以先构造一个时间格式对象， 然后利用这个对象去批量构建时间。
"""

# ╔═╡ 84a566d1-7ef0-473a-9844-fac83c50bfbd
begin
df = DateFormat("yyyy")
years = ["2015", "2016"]
Date.(years, df)
end

# ╔═╡ 22ebbf97-5b13-42d7-aac6-6cf95fe3a9b8
md"""
# 2. 持续与比较
我们可以经常需要比较时间， 这个跟生活中时间的比较是类似的， 出现较早的时间比较小。有时候， 我们需要计算两个时间时间的间隔，通常两个日期之间的差是得到的是日， 两个时间之间的差得到的是毫秒。
"""

# ╔═╡ f7f42927-5456-4e0a-8b6f-d64feb48b803

begin
dt1 = Date(2012,2,19)
dt2 = Date(2022,2,21)
end;

# ╔═╡ d7beda3d-a41d-4941-9476-3bfef72742e5
dt1 < dt2

# ╔═╡ 4c342d3f-f8bb-43ab-ae0f-943fb5a53f99
dt2 - dt1

# ╔═╡ 0a5c2550-45d7-45d1-84c8-bd1d23d47302
begin
dt3 = DateTime(2022,1,12, 0,0,1)
dt4 = DateTime(2022,1,12, 0,0,3)
end;

# ╔═╡ 66f177c5-ccba-4783-ae6d-02926fb0c199
dt4 - dt3

# ╔═╡ 39dff874-3d1e-43b0-acb6-9f3521496b2f
md"""
两个时间不能直接相加， 因为没有意义， 但可以将一个时间加上一段时间（比如，一个小时， 一天等）
"""

# ╔═╡ 66426786-b02b-4da7-9c0c-82c211230d0d
dt3 + Hour(1) + Day(1)

# ╔═╡ 46214a34-a43f-4d59-98f5-cb82c6a61b5a
md"""
# 3. 访问函数
我们可能需要访问一个时间中的某个具体组件， 比如， 月份， 小时数等， 这可以非常方便的做到。通过小写字母的函数，我们可以返回具体数值， 通过大写字母函数，我们可以得到周期值。潜在的组件有很多：
	Period
	Year
	Quarter
	Month
	Week
	Day
	Hour
	Minute
	Second
	Millisecond
	Microsecond
	Nanosecond
"""

# ╔═╡ d9a486d0-793a-42b8-a31e-5ae9849e3d85
dt5 = now()

# ╔═╡ b707c025-2d34-43ee-8f9d-0f096df3dfa5
year(dt5), month(dt5),day(dt5),week(dt5),hour(dt5),minute(dt5),second(dt5)

# ╔═╡ b8316888-66c0-4af5-81e6-782d68881495
Year(dt5), Month(dt5),Day(dt5),Week(dt5),Hour(dt5),Minute(dt5),Second(dt5)

# ╔═╡ 8bbe05e6-c431-465c-9d7a-dcdca309388e
md"""
# 4. 查询函数
查询函数解决的问题是获取一个时间的日历信息， 比如： 这一天是星期几，是一年的第几天等等。

	- dayofweek:星期几
	- dayname星期几的名字,
	- monthname 月份的名字
	- dayofyear一年中的第几天,
	- quarterofyear一年中的第几个季度
	- dayofquarter 一个季度中的第几天
"""

# ╔═╡ 63275aff-c33b-4f01-8838-1cfd83ccfdae
dt6 = Date(2021, 3,14)

# ╔═╡ 20c11620-1f7c-430b-ab75-ec95cf120828
dayofweek(dt6), dayname(dt6),dayofyear(dt6),quarterofyear(dt6),dayofquarter(dt6)

# ╔═╡ 5b1d9977-59b0-487b-8250-9a722f12c34b
md"""
# 5. 时间的持续周期运算
时间运算是一个需要注意的点。 把一个时间点加上一个时间段， 到底是怎么算的， 在julia里面跟某些语言可能不同。 Dates模块方法试图遵循一个简单的原则，即在进行Period算术时尽可能少地更改。这种方法也经常被称为历法算术，或者如果有人在对话中问你同样的计算，你可能会猜出来。具体的细节，请参考[这里](https://docs.julialang.org/en/v1/stdlib/Dates/#TimeType-Period-Arithmetic)。 此处， 不展开了。
"""

# ╔═╡ de14c67b-e41f-4a21-b231-a425edaa6125
md"""
# 6. 调整函数
尽管日期-周期算术很方便，但日期所需的计算类型通常具有日历或时间性质，而不是固定数量的周期。假期就是一个很好的例子;比如“感恩节= 11月的第4个星期四”。这些类型的时态表达式处理与日历相关的规则，比如每月的第一个或最后一个，下周二，或者第一个和第三个星期三，等等。当我们要实现这些计算的时候， 我们需要用到调整函数。

简单来说， 调整函数是通过一个时间， 获得满足某个条件的另一个时间。

第一组调整函数是：获取某个日期所在周（week）、月(month)、季(quarter)的，第一个（firstdayof）或最后一个(lastdayof)日期。

"""

# ╔═╡ 9531f8b5-df6d-4f16-a2cf-20ff333cd3aa
firstdayofweek(Date(2014,7,16)) , firstdayofmonth(Date(2014,7,16)), lastdayofweek(Date(2014,7,16))

# ╔═╡ 618ed4f9-b8aa-4810-acf1-ad1fe2551c8d
md"""
接下来的两个高阶方法tonext和toprev, 通过一个日期，找到这个日期前面（toprev）或后面（tonext）满足某个条件的日期。 这个条件， 通常用一个输入是时间，返回是true，或false的匿名函数表示。

比如， 我们要计算Date(2014,7,13)之后的第一个周二是哪一天，可以这样做： 1） 定义一个函数， 用于判断一个日期是否是周二。接下来， 2)调用tonext函数。

"""

# ╔═╡ 960d772b-f0f3-4565-9eba-2e6b15cf651d
istuesday = x -> dayofweek(x) == Dates.Tuesday # 档x是周二时返回true，否则是false

# ╔═╡ b91f2988-1f5b-43dc-9a08-93590ec0a4e3
tonext(istuesday, Date(2014,7,13))

# ╔═╡ 973c1e4f-0bde-433f-8f6f-b5f2c9cf58c1
md"""
有时候， 判断条件比较复杂， 可以放到一个do block里面。下面是找到
2014-11-27日之后感恩节的日期。
"""

# ╔═╡ 89852f09-04d1-4c6e-85d6-a09dbc79fe32
tonext(Date(2014,7,13)) do x
           # 11月第4个星期四(感恩节)返回true
           dayofweek(x) == Thursday &&
           dayofweekofmonth(x) == 4 &&
           month(x) == November
       end

# ╔═╡ da5905f1-95e0-4472-beaa-78b380f79674
md"""
最后， 一个常见的关于时间的操作是获取一段时间内，满足某种条件的所有时间。这可以通过filter函数实现。

比如， 我们要找到2023年的每一个月的第二个周二
"""

# ╔═╡ 081369f6-ba12-4d92-bd68-dc56105041de
dr = Date(2023):Day(1):Dates.Date(2024)

# ╔═╡ d21d5b36-0404-4907-883e-089403061ad8
filter(dr) do x
	dayofweek(x) == 2 &&
	dayofweekofmonth(x) == 2 
end

# ╔═╡ 7e8adf23-aa78-4387-81ab-afc4205e5ae3


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "479de4f38950bd7f7822fcb4c77dbc6ee3e018a1"

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
version = "0.5.2+0"

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
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
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
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
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

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═d868a6b0-b88d-11ed-218b-0f2953e9334a
# ╠═20723e85-9a1c-4001-95bf-e154f2fd4685
# ╠═67134c51-6915-4cdf-b49e-c3b0feb9e1de
# ╟─9cd28b02-1862-4c27-a565-51889a7e66d1
# ╟─11134bb9-b279-4940-b6ba-adbf41a7d07a
# ╠═8b1f850f-fd66-4654-b790-21ca9afe3bcc
# ╟─34e87d1b-1c39-48c9-a7fc-ee0bbca3a5aa
# ╠═b2d0b3e5-a3cf-4b26-91ee-332548388cf4
# ╟─76824297-1ee9-4c5c-976f-feb32829c9a4
# ╠═84a566d1-7ef0-473a-9844-fac83c50bfbd
# ╠═22ebbf97-5b13-42d7-aac6-6cf95fe3a9b8
# ╠═f7f42927-5456-4e0a-8b6f-d64feb48b803
# ╠═d7beda3d-a41d-4941-9476-3bfef72742e5
# ╠═4c342d3f-f8bb-43ab-ae0f-943fb5a53f99
# ╠═0a5c2550-45d7-45d1-84c8-bd1d23d47302
# ╠═66f177c5-ccba-4783-ae6d-02926fb0c199
# ╟─39dff874-3d1e-43b0-acb6-9f3521496b2f
# ╠═66426786-b02b-4da7-9c0c-82c211230d0d
# ╟─46214a34-a43f-4d59-98f5-cb82c6a61b5a
# ╠═d9a486d0-793a-42b8-a31e-5ae9849e3d85
# ╠═b707c025-2d34-43ee-8f9d-0f096df3dfa5
# ╠═b8316888-66c0-4af5-81e6-782d68881495
# ╠═8bbe05e6-c431-465c-9d7a-dcdca309388e
# ╠═63275aff-c33b-4f01-8838-1cfd83ccfdae
# ╠═20c11620-1f7c-430b-ab75-ec95cf120828
# ╟─5b1d9977-59b0-487b-8250-9a722f12c34b
# ╟─de14c67b-e41f-4a21-b231-a425edaa6125
# ╠═9531f8b5-df6d-4f16-a2cf-20ff333cd3aa
# ╠═618ed4f9-b8aa-4810-acf1-ad1fe2551c8d
# ╠═960d772b-f0f3-4565-9eba-2e6b15cf651d
# ╠═b91f2988-1f5b-43dc-9a08-93590ec0a4e3
# ╟─973c1e4f-0bde-433f-8f6f-b5f2c9cf58c1
# ╠═89852f09-04d1-4c6e-85d6-a09dbc79fe32
# ╟─da5905f1-95e0-4472-beaa-78b380f79674
# ╠═081369f6-ba12-4d92-bd68-dc56105041de
# ╠═d21d5b36-0404-4907-883e-089403061ad8
# ╠═7e8adf23-aa78-4387-81ab-afc4205e5ae3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
