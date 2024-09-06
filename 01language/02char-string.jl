### A Pluto.jl notebook ###
# v0.19.46

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

# ╔═╡ f7648323-aa83-45eb-881d-17470d9a9a33
using PlutoUI

# ╔═╡ a8b1a254-4745-4546-ad55-31164b33cb10
begin
	using PlutoTeachingTools
	Temp = @ingredients "../chinese.jl" # provided by PlutoLinks.jl
	PlutoTeachingTools.register_language!("chinese", Temp.PTTChinese.China())
	set_language!( PlutoTeachingTools.get_language("chinese") )
end;

# ╔═╡ c4687401-849d-4b77-b7c7-26ba8fa75067
TableOfContents(title="目录")

# ╔═╡ 518a017f-ac6b-4f30-ab58-0c87650a0fde
md"""

# 字符与字符串
字符和字符串也是一种常见的数据形式。简单来说， 字符串就是由字符构成的有限序列。 真正需要理解的是什么是字符。 由于Julia可以方便的处理Unicode编码。这里对字符与字符串做一个深入介绍。

## Unicode字符集
最常见的字符是英文字母、数字、一些标点符号等构成的常见字符集。 这个字符集通常采用ASCII编码，即：用0～127之间的整数来表示这些字符。

Unicode是国际标准字符集，它将世界各种语言的每个字符定义一个唯一的编码，以满足跨语言、跨平台的文本信息转换。 Unicode字符集的编码范围是0x0000 - 0x10FFFF , 可以容纳一百多万个字符， 每个字符都有一个独一无二的编码，也即每个字符都有一个二进制数值和它对应，这里的二进制数值也叫 **码点**, 比如：汉字 “中” 的码点是 0x4E2D, 大写字母 A 的码点是 0x41. 

理论上来说， 要表示所有Unicode字符， 需要三个字节。但如果每个字符都用三个字节， 那有些字符（比如英文字母等）就要浪费很多的存储空间。 UTF－8是一种unicode字符的存储方案， 它采用1～3个变长字节去存储码点值。 UTF－8的具体规则这里不讨论。 我们只需要知道， 每一个unicode字符都有一个“码点”，相当于整数。 然后其存储可能涉及1～3个字节就行， 其一个字节存储的，刚好是ASCII编码的字符， 也就是UTF－8是兼容ASCII编码的。

在Julia中， 用单引号包裹的单个对象就是一个字符， 其类型是： Char。 每一个Char在Julia中是一个32位（4个字节的）对象(可以通过sizeof查看其字节数）。 可以使用Int、Char非常方便的获得一个字符的码点（整数）以及将整数转化为一个字符。
```julia

julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> sizeof(c)
32

julia> typeof(c)
Char

julia> c = Int('x')
120

julia> Char(120)
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

在Julia中， 可以使用\u后跟最多四个十六进制数字或\U后跟最多八个十六进制数字（最长的有效值只需要六个）表示Unicode字符。

```julia

julia> '\u0'
'\0': ASCII/Unicode U+0000 (category Cc: Other, control)

julia> '\u78'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> '\u2200'
'∀': Unicode U+2200 (category Sm: Symbol, math)

julia> '\U10ffff'
'\U10ffff': Unicode U+10FFFF (category Cn: Other, not assigned)
```
此外， Julia支持C风格的转义字符表示形式
```julia
julia> Int('\0')
0

julia> Int('\t')
9

julia> Int('\n')
10

julia> Int('\e')
27

julia> Int('\x7f')
127

julia> Int('\177')
127
```

由于字符是用整数表示的， 因此， 其可以做有限的一些数值运算和比较运算。

```julia

julia> 'A' < 'a'
true

julia> 'A' <= 'a' <= 'Z'
false

julia> 'A' <= 'X' <= 'Z'
true

julia> 'x' - 'a'
23

julia> 'A' + 1
```
"""

# ╔═╡ 88c68a92-0832-46cf-b27a-914d1061fc40
md"""
# 字符串 
字符串是用双引号或三引号包裹的字符序列。 三引号的表示方式的存在是为了方便表示字符串中本身存在双引号的情形。
```julia
julia> str = "Hello, world.\n"
"Hello, world.\n"

julia> \"""包含 "双引号" 的字符串\"""
"包含 \"双引号\" 的字符串"

```

有时候， 字符串可能跨行， 这只要用反斜杠加回车就行

```julia
julia> "这一行有点长，所以 \
       后面有一个回车！"
"这一行有点长，所以后面有一个回车！"
```



"""

# ╔═╡ 1cfa8ad6-8277-4f88-987e-e599ddc47f2e
md"""
## 字符串索引
由于字符串是一个序列，可以使用整数下标索引（index）这个序列。 只是要注意： 在julia中， **下标是从1开始的**。

```julia
julia> str[begin]
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> str[1]
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[end]
'\n': ASCII/Unicode U+000A (category Cc: Other, control)
```

上面出现的两个关键字`begin`和`end`分别表示一个序列的最开始和最后一个元素的**合法下标**。 这两个关键字在索引的场景很常用。 可以把这两个关键词理解为两个整数。因此， 也可以用于运算。 


```julia

julia> str[end-1]
'.': ASCII/Unicode U+002E (category Po: Punctuation, other)

julia> str[end÷2]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```
有时候， 我们希望提取一个字符串的中间某些字符（子字符串）， 这时候可以使用冒号运算符:构建一个**下标范围**去提取。不过请注意：**用范围提取的结果是一个字符串， 就算只是提取了一个字符"**。

```julia
julia> str[4:9]
"lo, wo"

julia> str[6:6]
","

```

用下标范围的方式提取的子字符串，会自动复制一份返回。 但在有些场景下， 这个操作浪费时间和空间。 这时候， 可以使用`Substring(str, from, to)`实现构建字符串str的从from到to之间的视图, 其类型是SubString。 这样可以避免数据的复制。

```julia

julia> str = "long string"
"long string"

julia> substr = SubString(str, 1, 4)
"long"

julia> typeof(substr)
SubString{String}
```
"""

# ╔═╡ 7f03d80e-4815-4b23-b3f1-c217dda0482d
md"""
## 令人沮丧的字符串索引
你可能已经注意到， 上面在字符串提取的时候， 我强调要用合法的下标。 下标会不合法吗？ 由于Julia支持Unicode字符， 一个字符串里每一个字符所占用的空间通常为1～4不等。而下标表示的是基本的字符存储单位(**code unit**)—在这里是1个字节。通常， 如果一个下标在字符串所在的字节范围内就是一个**可行的下标**。不可行的下标意味着下标越界了。如果某个下标（相当于某个字节）是一个字符的中间某个字节， 这就不是一个**合法的下标**。只有当下标表示的字节位置刚好是一个字符的开始字节时， 下标才是合法的。 

```julia

julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"

julia> s[1]
'∀': Unicode U+2200 (category Sm: Symbol, math)

julia> s[2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'∀', [4]=>' '
Stacktrace:
[...]

julia> s[3]
ERROR: StringIndexError: invalid index [3], valid nearby indices [1]=>'∀', [4]=>' '
Stacktrace:
[...]

julia> s[4]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)

```

上面的第一个字符`∀`占了三个字节（三个单位）的存储空间。所以， 只有下标1是合法的。 下标2、3都不合法，得到的结果就是错误ERROR 。


"""

# ╔═╡ ca3027a4-d7fc-4650-9fb6-190483c6fe04
md"""
如果你处理的是英文文档， 下标的合法性是不需要考虑的（只要不越界就行）。 但如果处理中文文本， 这时候可能会比较棘手， 因为判断一个下标是否合法是一件很麻烦的事情。

为了解决这个问题， Julia提供了`lastindex(s)`:表示字符串s的最后一个合法下标；`firstindex(s)`表示字符串s的第一个合法下标(等价于`begin`和`end`两个下标关键字)。 这两个整数可以看做字符串合法下标的边界。 
此外， `nextind`和`prevind`两函数可以用于从一个给定的下标获取其后或其前的合法下标。其中：

- `nextind(s, i, n=1)`表示字符串s的第i个可行下标之后的第n个合法下标。
- `prevind(s, i, n=1)`表示字符串s的第i个可行下标之前的第n个合法下标。
以上两个函数的更多细节， 请参考帮助文档。 这两个函数可以方便的从两个方向遍历合法下标。 

如果想要得到所有的合法下标， 可以使用`collect(eachendex(s))`, 这里`eachindex`获取一个字符串的所有合法下标的“可迭代对象”， `collect`收集所有这些值。 后续介绍“容器”数据类型时还会进一步介绍这两个函数。

"""

# ╔═╡ 974910a4-551d-499f-a559-39a3c0e9d7ea
md"""
由于Julia支持Unicode编码， 一个常见的问题是：字符串的长度length(s)不一定等于字符串的最右一个下标(lastindex(s))。 
""" |> box(:yellow)

# ╔═╡ ddb25886-6734-4eac-8954-09167302744f
md"""
## 字符串拼接
尝尝需要将两个或多个字符串拼接成一个字符串， 在Julia中， 可以使用`string`函数:

```julia
julia> greet = "Hello"
"Hello"

julia> whom = "world"
"world"

julia> string(greet, ", ", whom, ".\n")
"Hello, world.\n"
```
有时候， 也可以使用＊运算符实现字符串拼接：
```julia
julia> greet * ", " * whom * ".\n"
```
"""

# ╔═╡ 2ad09d60-f372-4b2b-9459-49665067ab90
md"""
为什么用乘法＊而不是加法＋表示字符串拼接， 一个小理由是：Julia更强调符合数学习惯。在很多数学系统中， 加法是满足交换律的，而乘法不满足， 比如对矩阵来说就是这样。 字符串的拼接明显不符合交换律。所以采用了乘法符号*。
""" |> box

# ╔═╡ 559dd1bd-ef9d-4280-934e-8acb69676288
md"""
一个更加强悍的拼接的函数是`join`。只是要拼接的对象需要构建在一个向量中（本质上可迭代对象中，后面再解释）

```julia

julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"

julia> join([1,2,3,4,5])
```

"""

# ╔═╡ aef94074-7a8f-40fd-9ab9-fee55beeb775
md"""
## 字符串插值
字符串插值就是把一个值插入一个字符串。 Julia提供了非常方便的字符串插值方法。 只需要用一个\$符号，就可以把一个变量插入一个字符串。

```julia

julia> greet = "Hello"; whom = "world";

julia> "$greet, $whom.\n"
"Hello, world.\n"
```
"""

# ╔═╡ 68b4b649-5098-47cf-bf89-618cbf39bdff
md"""
你可以在下面的文本框中输入任何名字， 观察下面一行文本的变化。 `@bind name TextField(default="不告诉你")`, 注意， 这一行代码只是把你输入的内容，TextField的值，绑定@bind到了一个变量name。 如果你想了解更多这种UI项目， 可以参考Pluto的主界面上的介绍。 
"""

# ╔═╡ 090e3344-2c9a-47c4-bb5a-4a90b1e94fc3
@bind name TextField(default="不告诉你")

# ╔═╡ c2ddb7a2-a926-4c8e-a59a-4319b58df67e
"我的名字叫：$name"

# ╔═╡ 844523a0-71cf-4898-8da6-2bc42263d2d5
md"""
 上面只是简单的把一个变量的值插入字符串， 更有趣的场景是，把一个计算表达式的结果直接插入一个字符串。这时候， 只需要在\$符号后紧跟一对括号包裹表达式就好。

```julia
julia> "1 + 2 = $(1 + 2)"
"1 + 2 = 3"

julia> x = 10;
julia> "x=10，则sin(x)=$(sin(x))."
"x=10, 则sin(x)=-0.5440211108893698"
```
"""

# ╔═╡ f74255d9-54be-4c50-9e03-4590a6c71eea
md"""
## 常用操作汇总
- `sizeof` 获取字符串（任何对象都可以）占用的字节数。
- `length` 获取字符串的字符数量。
- `*` 字符串拼接， 也可以使用`string`函数。
- [i] 字符串索引(获取第i个字符）， 不过请注意Unicode字符串索引可能引发的问题。
- [i:j] 字符串截取（获取索引号从i到j的所有字符）。
- `$(var)` 用变量var的值插入字符串中。
- **搜索**。 `findfirst`, `findlast`, 请使用`@doc 函数名` 的方式获取其使用方法。
- occursin, contains 判断一个字符串是否包含某个子串（或模式）
- startswith， endswith 判断字符串是否以某个子串开头或结尾
- first, last 获取字符串前面或结尾的n个字符。
- `parse(type, str)`把一个字符串解释为某种类型。通常用于字符串转数值。
- `string`可以把数字转字符串。
"""

# ╔═╡ 4c8327a8-4744-45de-bebf-9721620af494
md"""
## 符号Symbol
在Julia中，有一种跟字符串非常相似的数据类型－－符号类型（Symbol）。 符号类型是在已解析的julia代码中用于表示标识符的类型， 也经常用作标识实体的名称或标签(例如，作为字典键)。 可以使用:操作符构建。 

符号跟变量名是不同的东西。变量名绑定了值。访问变量名就是访问相应的值。而符号代表的是被解析的代码（抽象语法树）中的标识符。通过对表达式求值eval，可以获得对应的值。 每一个变量名都会有一个对应的符号, 但Symbol不一定是变量。比如一个字典变量中的键。

**千万不要混淆Symbol和字符串。**
"""

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
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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
# ╠═f7648323-aa83-45eb-881d-17470d9a9a33
# ╠═a8b1a254-4745-4546-ad55-31164b33cb10
# ╠═c4687401-849d-4b77-b7c7-26ba8fa75067
# ╠═518a017f-ac6b-4f30-ab58-0c87650a0fde
# ╠═88c68a92-0832-46cf-b27a-914d1061fc40
# ╟─1cfa8ad6-8277-4f88-987e-e599ddc47f2e
# ╟─7f03d80e-4815-4b23-b3f1-c217dda0482d
# ╟─ca3027a4-d7fc-4650-9fb6-190483c6fe04
# ╠═974910a4-551d-499f-a559-39a3c0e9d7ea
# ╟─ddb25886-6734-4eac-8954-09167302744f
# ╟─2ad09d60-f372-4b2b-9459-49665067ab90
# ╟─559dd1bd-ef9d-4280-934e-8acb69676288
# ╟─aef94074-7a8f-40fd-9ab9-fee55beeb775
# ╟─68b4b649-5098-47cf-bf89-618cbf39bdff
# ╠═090e3344-2c9a-47c4-bb5a-4a90b1e94fc3
# ╠═c2ddb7a2-a926-4c8e-a59a-4319b58df67e
# ╟─844523a0-71cf-4898-8da6-2bc42263d2d5
# ╟─f74255d9-54be-4c50-9e03-4590a6c71eea
# ╟─4c8327a8-4744-45de-bebf-9721620af494
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
