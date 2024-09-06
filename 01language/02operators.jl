### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ c6a8ded8-0ea9-487e-aae1-69eb6d08ddbb
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ 52171e5d-55b4-42f2-80bf-ca2456262b61
TableOfContents(title="目录")

# ╔═╡ 7dfe8c00-83c0-463a-8bc7-10dafd514b55
present_button()

# ╔═╡ 1520aa51-41a7-401b-9944-0f7cf44f64c0
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia简短教程
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			运算符与表达式
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ b45bea93-b175-4c58-a76b-29edb3b6e56b
md"""
<h3>简介:</h3>

这是一份Julia做数据挖掘的一些笔记，参考资料。后续会不断修改。

第一部分Julia教程粗略的摘录了 Julia 的基本语法，不熟悉 Julia 的同学可以先粗略地通读该教程，以大致熟悉基本操作。

如果想要了解详细内容可以查阅[官方文档](https://docs.julialang.org/en/v1/)。

如果想比较全面的学一下Julia, 可以看看Github上面的这种本[Julia编程基础](https://github.com/hyper0x/JuliaBasics/tree/master/book)

"""

# ╔═╡ 85b21e86-0211-4e07-b250-db19a75687f4
md"""
在Julia语言中，运算符是执行操作的特殊符号，而表达式则是由运算符、操作数（变量、字面量等）和函数调用组成的代码片段，它们共同构成了程序中用于计算和数据处理的基本单元。Julia提供了丰富的内置运算符，支持常见的数学运算、逻辑判断、位操作等，同时也允许开发者定义自己的运算符，以适应特定的计算需求。

表达式是Julia中实现算法和逻辑的核心。它们可以是简单的，如对两个数字的加法，也可以是复杂的，如嵌套函数调用和条件判断。在本章中，我们将简单总结Julia语言中的运算符和表达式，包括它们的类型、用法和实际例子。

"""

# ╔═╡ 62b3aba7-c9d9-4df8-b7a3-1638d5a14225
md"""

## 算术运算符
算术运算符是编程语言中用于执行数学运算的符号。Julia语言支持以下算术运算符，适用于所有原始数值类型。

| 运算符 | 含义 | 用法 | Julia中的特殊说明 |
|--------|------|-----|-------------------|
| `+x`   | 一元加 | `+a` | 恒等运算，返回变量本身 |
| `-x`   | 一元减 | `-a` | 取反运算，返回变量的相反数 |
| `x + y` | 二元加 | `a + b` | 执行加法 |
| `x - y` | 二元减 | `a - b` | 执行减法 |
| `x * y` | 乘法 | `a * b` | 执行乘法 |
| `x / y` | 除法 | `a / b` | 执行浮点除法 |
| `x \ y` | 逆除法 | `a \ b` | 等价于 `b / a` |
| `x ^ y` | 幂运算 | `a ^ b` | 执行指数运算 |
| `x % y` | 余数 | `a % b` | 求两数相除的余数 |
| `x ÷ y` | 整数除法 | `a ÷ b` | 执行整数除法，结果向下取整 |

在Julia中，`+` 和 `-` 可以用作一元运算符，它们分别表示恒等和取反。此外，Julia完全支持Unicode字符，这意味着您可以使用类似于数学书写的方式去编写算术表达式。例如，整除运算符 `÷` 可以通过在REPL或Julia IDE中键入 `\div` 然后按Tab键来输入。

布尔值 `true` 和 `false` 在算术运算中分别等价于数值 `1` 和 `0`。这使得布尔值可以直接用于数值运算，增加语言的表达力和灵活性。

此外，Julia还提供了一些特殊的算术运算符，如整数除法 `÷`，它通过截断结果来返回整数。如果您需要进一步的帮助，可以通过在REPL中输入 `?运算符` 来获得关于特定运算符的帮助信息，或者使用 `@doc 运算符` 来获取详细的帮助文档。
"""

# ╔═╡ 9585e9b8-0e96-46b6-89f6-65841691c1b7
md"""
根据您提供的文档内容和比较运算符的介绍，我们可以进一步优化比较运算符的描述，以确保它与Julia语言的特性和文档保持一致。以下是优化后的比较运算符介绍：

## 比较运算符
在Julia中，比较运算符用于比较两个值的大小，并返回逻辑值 `true` 或 `false`。这些运算符广泛应用于条件语句和逻辑判断中。以下是Julia支持的比较运算符及其用法：

| 运算符 | 含义 | 用法 | 描述 |
|--------|------|-----|------|
| `>`    | 大于 | `x > y` | 如果左操作数大于右操作数，则结果为 `true` |
| `<`    | 小于 | `x < y` | 如果左操作数小于右操作数，则结果为 `true` |
| `==`   | 等于 | `x == y` | 如果左操作数等于右操作数，则结果为 `true` |
| `!=`, `≠` | 不等于 | `x != y` 或 `x ≠ y` | 如果左操作数不等于右操作数，则结果为 `true` |
| `>=`, `≥` | 大于或等于 | `x >= y` 或 `x ≥ y` | 如果左操作数大于或等于右操作数，则结果为 `true` |
| `<=`, `≤` | 小于或等于 | `x <= y` 或 `x ≤ y` | 如果左操作数小于或等于右操作数，则结果为 `true` |

### 特殊值的比较
在Julia中，比较运算符遵循以下规则：

- 有限的数值按照常规方式排序。
- 正零 (`+0.0`) 等于负零 (`-0.0`)，但不大于负零。
- 正无穷 (`Inf`) 等于自身，大于除 `NaN` 以外的所有值。
- 负无穷 (`-Inf`) 等于自身，小于除 `NaN` 以外的所有值。
- `NaN`（非数字）不等于、不小于、也不大于任何值，包括它自己。

这些规则在处理浮点数时尤为重要，尤其是涉及到 `NaN` 值时。在某些情况下，直接使用 `==` 运算符比较 `NaN` 会返回 `false`，即使两个值都是 `NaN`。为了正确处理这种情况，可以使用 `isequal` 函数：

```julia
julia> NaN == NaN
false

julia> isequal(NaN, NaN)
true

julia> [1, NaN] == [1, NaN]
false

julia> isequal([1, NaN], [1, NaN])
true
```

"""

# ╔═╡ 7d49a10c-4f05-45c6-97a7-8c914bebe3a1
md"""
在Julia中，比较运算符可以被连续书写，形成所谓的“链式比较”。这种链式比较实际上是利用了逻辑运算符 `&&`（逻辑与）进行短路求值。如果第一个比较的结果为 `false`，则不会继续进行后续的比较，因为整个表达式的值已经确定为 `false`。如果第一个比较的结果为 `true`，则会继续进行后续的比较。

例如：

```julia
julia> 1 < 2 < 3
true
```

这个表达式首先比较 `1 < 2`，结果为 `true`，然后这个 `true` 值会被当作第二个比较 `true < 3` 的左操作数。由于 `true` 在Julia中被视为 `1`，所以这个表达式等价于 `1 < 3`，结果也是 `true`。

但是，如果链中的任何一个比较返回 `false`，整个表达式的结果就会是 `false`。例如：

```julia
julia> 3 < 2 < 1
false
```

这里，`3 < 2` 的结果是 `false`，因此整个表达式的结果就是 `false`，而不会去比较 `false < 1`。

需要注意的是，链式比较的求值顺序是未定义的，因此在使用带有副作用的表达式时需要格外小心。不过，在进行简单的数值比较时，这种未定义的顺序通常不会造成问题。
"""

# ╔═╡ 591fecdc-7a73-4fc3-a2a1-7d83ad8c5d19
md"""
根据您提供的内容和Julia文档，我们可以总结Julia中的逻辑运算符如下：

## 逻辑运算符
Julia语言中的逻辑运算符用于对布尔值（`true` 和 `false`）进行逻辑运算，主要用于构造复合条件和控制程序流程。以下是Julia中支持的逻辑运算符及其用法：

| 运算符 | 含义 | 用法 | 描述 |
|--------|------|-----|------|
| `&&`   | 逻辑与 | `x && y` | 当且仅当 `x` 和 `y` 都为 `true` 时，结果为 `true`。 |
| `\|\|` | 逻辑或 | `x \|\| y` | 当至少有一个操作数为 `true` 时，结果为 `true`。 |
| `!`    | 逻辑非 | `!x` | 将 `true` 变为 `false`，将 `false` 变为 `true`。 |


### 短路求值
在Julia中，逻辑与 (`&&`) 和逻辑或 (`||`) 运算符都采用短路求值。这意味着：

- 对于 `&&`，如果第一个操作数为 `false`，则不计算第二个操作数，因为整个表达式的结果已经确定为 `false`。
- 对于 `||`，如果第一个操作数为 `true`，则不计算第二个操作数，因为整个表达式的结果已经确定为 `true`。

这种短路求值机制可以提高程序的效率，并且可以防止在某些情况下计算不必要的或可能产生错误的表达式。

### 注意事项
- 逻辑运算符的优先级低于算术和比较运算符，因此在使用时可能需要使用括号来明确表达式的求值顺序。
- 逻辑非 (`!`) 运算符的优先级高于逻辑与 (`&&`) 和逻辑或 (`||`) 运算符。

"""

# ╔═╡ c3f0d6a1-acff-4781-a4df-c00f475069f1
md"""
## 其他运算符
Julia 除了提供算术、比较、逻辑运算符外，还支持以下类型的运算符：

1. **位运算符**：对整数进行位级操作。
   - `~x`（按位取反）
   - `x & y`（按位与）
   - `x | y`（按位或）
   - `x ⊻ y` 或 `xor(x, y)`（按位异或）
   - `x ⊼ y` 或 `nand(x, y)`（按位与非）
   - `x ⊽ y` 或 `nor(x, y)`（按位或非）
   - `x >>> y`（逻辑右移）
   - `x >> y`（算术右移）
   - `x << y`（左移）

   例如：
   ```julia
   julia> ~0x03
   0xfffffffc

   julia> 0x01 & 0x02
   0x00

   julia> 0x01 | 0x02
   0x03

   julia> 0x01 ⊻ 0x02
   0x03
   ```

2. **更新运算符**：将二元运算符的结果赋值给左侧的操作数。
   - `+=`, `-=`, `*=`, `/=`, `\=`, `÷=`, `%=`, `^=`, `&=`, `|=`, `⊻=`, `>>>=`, `>>=`, `<<=`

   例如：
   ```julia
   julia> x = 1
   1

   julia> x += 3
   4

   julia> x
   4
   ```

3. **矢量化点运算符**：对数组或集合中的每个元素执行操作。
   - `.+`, `.-`, `.*`, `./`, `.^`, `.&`, `.|`, `.⊻` 等

   例如：
   ```julia
   julia> [1, 2, 3] .* 2
   3-element Vector{Int64}:
    2
    4
    6
   ```

4. **赋值运算符**：将值赋给变量。
   - `=`

   例如：
   ```julia
   julia> x = 10
   10
   ```

5. **并行管道运算符**：将左侧表达式的结果作为右侧函数的第一个参数。
   - `|>`

   例如：
   ```julia
   julia> [1, 2, 3] |> sum
   6
   ```

6. **元组运算符**：用于创建元组。
   - `,`

   例如：
   ```julia
   julia> x, y = 1, 2
   (1, 2)
   ```

8. **范围运算符**：构建一个范围。
   - `:`

   例如：
   ```julia
   julia> 1：2：10
   1:2:9
   ```

9. **插值运算符**：用于在字符串中插入变量或表达式的值。
   - `$`

   例如：
   ```julia
   julia> name = "Julia"
   "Julia"

   julia> "Hello, $name!"
   "Hello, Julia!"

   julia> x = 10
   10

   julia> "The value of x is $(2x)."
   "The value of x is 20."
   ```
   插值运算符 `$` 允许你在字符串字面量中直接嵌入变量或表达式的值。这使得字符串的构建更加灵活和动态。当 `$` 符号后跟变量名或表达式时，Julia 会计算该变量或表达式的值，并将其转换为字符串，然后插入到外层字符串中。这种特性在生成包含变量值的字符串时非常有用。


"""

# ╔═╡ e2d1e847-bf0e-4e80-af4e-2e84fd3fa4a9
md"""
## 运算符的优先级
在 Julia 中，运算符的优先级决定了表达式中运算的顺序。以下是一些常见运算符的优先级，从最高到最低：

1. 指数和根号（`^`, `√`）
2. 单目运算符（一元加 `+`, 一元减 `-`）
3. 位左移和位右移（`<<`, `>>`, `>>>`）
4. 冒号运算符(`:`)
5. 乘法和除法（`*`, `/`, `%`, `\`, `÷`）
6. 加法和减法（`+`, `-`）
7. 比较运算符（`==`, `!=`, `<`, `>`, `<=`, `>=`）
8. 逻辑与（`&&`）
9. 逻辑或（`||`）
10. 赋值运算符（`=`, `+=`, `-=`, `*=`, `/=`, `\=`, `÷=`, `%=`, `^=`, `&=`, `|=`, `⊻=`, `>>>=`, `>>=`, `<<=`）

"""

# ╔═╡ fc8fa999-b45d-44d0-92dd-af00a0974018


# ╔═╡ dc7e7157-3ce8-4bda-abdd-fc6f475b54ed
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
# ╠═c6a8ded8-0ea9-487e-aae1-69eb6d08ddbb
# ╠═52171e5d-55b4-42f2-80bf-ca2456262b61
# ╟─7dfe8c00-83c0-463a-8bc7-10dafd514b55
# ╟─1520aa51-41a7-401b-9944-0f7cf44f64c0
# ╠═b45bea93-b175-4c58-a76b-29edb3b6e56b
# ╟─85b21e86-0211-4e07-b250-db19a75687f4
# ╟─62b3aba7-c9d9-4df8-b7a3-1638d5a14225
# ╟─9585e9b8-0e96-46b6-89f6-65841691c1b7
# ╟─7d49a10c-4f05-45c6-97a7-8c914bebe3a1
# ╟─591fecdc-7a73-4fc3-a2a1-7d83ad8c5d19
# ╟─c3f0d6a1-acff-4781-a4df-c00f475069f1
# ╟─e2d1e847-bf0e-4e80-af4e-2e84fd3fa4a9
# ╠═fc8fa999-b45d-44d0-92dd-af00a0974018
# ╠═dc7e7157-3ce8-4bda-abdd-fc6f475b54ed
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
