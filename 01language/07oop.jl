### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ 8d72b0cc-7940-11ef-2759-0d0f72804ff9
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ 551a0008-f001-493a-b7c6-9b56006ff0e4
TableOfContents(title="目录")

# ╔═╡ 3b31ac47-1323-47ef-b1da-833a731ae521
present_button()

# ╔═╡ 572b8238-20ed-4e81-81e2-49ff2bea35b3
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia简短教程
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
		面向对象编程
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 730474ee-ca45-4043-b1a0-785591c7934e
md"""
## **引言**

在当今的软件开发领域，面向对象编程（OOP）是一种广泛采用的编程范式，它通过将数据和操作数据的方法封装在对象中，提供了一种自然而直观的方式来组织和管理代码。OOP的核心概念包括类、对象、封装、继承和多态性，这些概念共同构成了一个强大的工具集，使得代码更加模块化、可重用和易于维护。

Julia语言，作为一种高性能的动态编程语言，专为科学计算、数据分析和机器学习等领域设计。它结合了Python的易用性和C语言的性能，使得它在处理复杂数学运算和大规模数据处理时表现出色。尽管Julia最初被设计为一种函数式编程语言，但它同样支持面向对象编程，提供了一套完整的OOP工具，使得开发者能够以面向对象的方式构建复杂的应用程序。

在本介绍中，我们将深入探讨Julia语言中的面向对象编程。我们将从OOP的基本概念开始，逐步介绍如何在Julia中定义类和对象，如何实现继承和多态性，以及如何利用封装来保护数据。我们还将探讨Julia特有的OOP特性，如多重方法和类型系统，以及它们如何帮助我们构建高效、灵活和可扩展的软件系统。

通过本介绍，无论是Julia的新手还是经验丰富的开发者，都将能够更好地理解和应用面向对象编程的原则和实践，以提高他们的编程技能，并在Julia中构建更加强大和可靠的应用程序。


"""

# ╔═╡ bb5ba3f8-1d47-4ddb-b1a9-e5e2d55a24a3
md"""
## **面向对象编程基础**

面向对象编程（OOP）是一种编程范式，它使用“对象”来设计应用程序和程序结构。在OOP中，对象可以被视为现实世界中的事物，它们具有状态（数据）和行为（函数或方法）。OOP的核心概念包括：

1. **类（Class）**
   - 类是对象的蓝图或模板，它定义了对象的属性（数据）和方法（行为）。类可以被看作是对象的类型。

2. **对象（Object）**
   - 对象是根据类创建的实例。每个对象都拥有类定义的属性和方法。对象是类的具体化，可以独立存在。

3. **封装（Encapsulation）**
   - 封装是将数据（属性）和操作数据的方法（行为）捆绑在一起的过程。它还隐藏了对象的内部状态，只通过方法暴露有限的接口与外部交互。

4. **继承（Inheritance）**
   - 继承是一种机制，允许一个类（子类）继承另一个类（父类或超类）的属性和方法。这支持代码重用，并允许创建层次化的关系。

5. **多态（Polymorphism）**
   - 多态性是指对象可以采用多种形态的能力。在OOP中，多态性允许使用统一的接口来处理不同类型的对象。

"""

# ╔═╡ 3b2f025e-7330-420c-8922-24c62b667393
md"""
在Julia中，结构体（Struct）和类（Class）在概念上非常相似，但它们在语义和使用上有所不同。在许多面向对象的编程语言中，类是定义对象行为和状态的主要方式。然而，在Julia中，结构体扮演了这个角色，并且是实现面向对象编程特性的主要工具。 在Julia中把结构体当成一种类的实现的几个原因：

1. **不可变性**：在Julia中，结构体是不可变的，这意味着一旦创建，它们的字段（属性）就不能被修改。当然也可以显式的定义mutable的结构， 这样结构体的字段可以绑定到不同类型的数据。

2. **简洁性**：在Julia中，结构体的定义比传统的类更简洁。它们使用`struct`关键字定义，并且不需要显式的构造函数或析构函数。这使得定义和使用结构体更加直观和方便。

3. **类型系统**：Julia拥有一个强大的类型系统，其中结构体是类型系统的核心组成部分。结构体可以定义为其他类型的子类型，这使得它们非常适合用于实现类型层次结构和继承。

4. **多重派发**：Julia的多重派发机制允许函数根据参数的类型来有不同的行为。这种机制与结构体结合使用，可以非常方便地实现多态性。

"""

# ╔═╡ a23834d7-2ff1-40f0-aa77-ce6f836ca0fc
md"""
## **封装**
在C++和Julia中，我们都使用结构体（struct）和类（class）来组织数据，但它们在管理数据访问方面采取了不同的策略。

在C++中，您可能习惯了使用访问修饰符（public, protected, private）来精细控制类成员的可见性和可修改性。这种机制允许您创建一个清晰的接口，同时隐藏内部实现细节，这是面向对象编程中封装的一个重要方面。

转到Julia，你会发现结构体的定义（通过`struct`关键字）默认带来了一种不可变的行为。也就是说，一旦一个Julia结构体被创建，它的字段值就被固定下来，不能更改。这种默认的不可变性是Julia设计的核心，它有助于提高程序的安全性和预测性。如果你需要可变的行为，可以通过`mutable struct`关键字来定义结构体。不过，即便在可变结构体中，Julia也不使用访问修饰符；字段默认是公开的，可以被任何代码访问和修改。Julia鼓励使用不可变对象，因为它们在并发和多线程环境中更加安全。

在C++中，成员函数通常与类紧密绑定，它们是类定义的一部分，并且可以访问类的私有成员。这种封装性使得成员函数成为类接口的关键组成部分。

而在Julia中，函数与结构体的关系更为松散。函数不是结构体定义的一部分，它们可以在结构体外部定义，并且可以操作任何传入的参数，无论其类型如何。这种设计强调了函数的通用性和重用性，而不是将它们限制在特定的类或结构体上。Julia的函数通常不依赖于对象的状态，因此它们可以在不修改对象的情况下被调用。

总的来说，C++提供了一种严格的封装和访问控制机制，而Julia则倾向于使用不可变对象和通用函数，以简化并发编程并提高代码的清晰度。这些不同的机制反映了两种语言在面向对象编程方法上的根本差异。

"""

# ╔═╡ e4482139-197b-4ec8-9ced-e459c8949236
md"""
在Julia中，类型的继承关系是通过单继承模型实现的，这意味着每个子类型只有一个直接父类型。这种设计简化了类型系统，避免了多继承可能带来的复杂性和歧义。以下是对Julia中类型继承和层次结构的进一步描述：

## 继承

在Julia中，类型继承是通过关键字`<:`来表示的，它定义了类型之间的层次关系。子类型继承自父类型，这意味着子类型不仅继承了父类型的名称和类型，还继承了父类型的所有方法。这种继承关系在Julia的类型系统中是单向的，即从抽象类型指向具体类型。

### 抽象类型

抽象类型是Julia中不能被实例化的类型，它们用于定义类型层次结构中的节点，但不包含具体的数据实现。抽象类型使得类型系统更加灵活，因为它们可以作为多种具体类型的通用父类型。在定义抽象类型时，通常使用`abstract type`关键字，如下所示：

```julia
abstract type Feature end
abstract type Categorical <: Feature end
abstract type Numerical <: Feature end
```

在这个例子中，`Feature`是一个抽象类型，它有两个子类型：`Categorical`和`Numerical`，分别代表类别特征和数值特征。

### 具体类型

具体类型（也称为结构体）是通过`struct`关键字定义的，它们可以被实例化，并包含具体的数据字段。在定义具体类型时，可以使用`<:`关键字来指定它们继承的父类型。例如：

```julia
struct Nominal <: Categorical
    name::String
end

struct Ordinal <: Categorical
    rank::Int
end

struct Interval <: Numerical
    range::Tuple{Float64, Float64}
end

struct Ratio <: Numerical
    ratio::Float64
end
```

在这个例子中，`Nominal`和`Ordinal`是`Categorical`的子类型，而`Interval`和`Ratio`是`Numerical`的子类型。每个具体类型都定义了它们自己的数据字段。

### 类型层次树

在Julia中，类型通过继承形成了一个层次树，这棵树的根是`Any`类型，它是所有类型的超类型。从`Any`类型分支出许多抽象类型，这些抽象类型又分支出更多的子类型，直到达到具体的结构体类型。这个层次树反映了类型之间的层次关系，并且可以用于指导方法的分派。

"""

# ╔═╡ 4e3035f4-c381-4798-bdd8-2d6c066699e9
md"""
上面定义的类型， 可以用如下结构图来表示， 这里我们略去了Any类型。
```
Feature（特征）
├── Categorical（类别特征）
│   ├── Nominal（标称属性）
│   └── Ordinal（序数属性）
└── Numerical（数值特征）
    ├── Interval（区间属性）
    └── Ratio（比率属性）
```
"""

# ╔═╡ ed85518b-55cb-45aa-b1be-9ae86cb48040
md"""
## 多重分派

Julia的强大之处在于其多重分派机制，它允许根据函数调用中所有参数的类型来选择最合适的方法。这种机制依赖于类型层次树，因为函数可以定义在抽象类型上，而具体的结构体类型会自动继承这些方法。当调用一个函数时，Julia会查找与调用中参数类型最匹配的方法。

### 示例

假设我们有一个函数，它处理不同的特征类型：

```julia
function analyze(feature::Feature)
    println("Analyzing a feature.")
end

function analyze(feature::Categorical)
    println("Analyzing a categorical feature.")
end

function analyze(feature::Numerical)
    println("Analyzing a numerical feature.")
end
```

在这个例子中，`analyze`函数有三个不同的方法，分别处理`Feature`、`Categorical`和`Numerical`类型。当我们调用`analyze`函数时，Julia会根据传入的参数类型选择最合适的方法。 我们可以通过`method`函数查看一个通用函数有多少方法。

通过这种方式，Julia的类型系统提供了一种强大而灵活的方式来组织代码，使得代码可以轻松地扩展和维护。
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
git-tree-sha1 = "2984284a8abcfcc4784d95a9e2ea4e352dd8ede7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.36"

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
git-tree-sha1 = "c2b5e92eaf5101404a58ce9c6083d595472361d6"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.2"

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
# ╠═8d72b0cc-7940-11ef-2759-0d0f72804ff9
# ╠═551a0008-f001-493a-b7c6-9b56006ff0e4
# ╠═3b31ac47-1323-47ef-b1da-833a731ae521
# ╟─572b8238-20ed-4e81-81e2-49ff2bea35b3
# ╟─730474ee-ca45-4043-b1a0-785591c7934e
# ╟─bb5ba3f8-1d47-4ddb-b1a9-e5e2d55a24a3
# ╟─3b2f025e-7330-420c-8922-24c62b667393
# ╟─a23834d7-2ff1-40f0-aa77-ce6f836ca0fc
# ╟─e4482139-197b-4ec8-9ced-e459c8949236
# ╟─4e3035f4-c381-4798-bdd8-2d6c066699e9
# ╟─ed85518b-55cb-45aa-b1be-9ae86cb48040
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
