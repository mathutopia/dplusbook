### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ dfc254a6-f91c-43f2-b007-15975017f34a
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ e739b947-91ae-4163-9dc7-9588787383c4
TableOfContents(title="目录")

# ╔═╡ 6cbffbbc-af94-4b0c-836e-da4b2e2fb8d4
present_button()

# ╔═╡ 84b5832e-562c-4ebd-8e91-838a0f445a00
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia简短教程
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			变量、值与基本类型
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 09d1789b-243f-4008-a6a7-d25fe570abf7
md"""
编程的核心在于数据结构和算法的结合，它们共同构成了程序的基础。数据结构是数据的组织方式，而算法则是对数据进行操作的步骤和方法。

掌握编程，需要理解以下概念：

1. **基本数据类型**：包括数值、字符（串）、日期等，它们是编程中处理信息的基本单位。

2. **构造数据类型**：如元组、命名元组、对（pair）、字典、数组等，它们允许将多个数据项组合为更复杂的结构。

3. **自定义数据类型**：通过`struct`等构造，允许创建符合特定需求的新类型。

算法学习路径通常从：

1. **基本运算符**：如加（+）、乘（*）等，它们是数据操作的基础。

2. **基本函数**：包括内置函数和运算符，它们封装了常见的操作。

3. **自定义函数**：在掌握流程控制（如条件判断、循环）后，学习如何定义和使用自定义函数。

本节内容专注于介绍基本数据类型及其相关的基本运算，为深入学习算法和复杂数据结构打下坚实的基础。


"""

# ╔═╡ e01b58a6-6950-4146-9357-3b38fd572309
md"""
# 变量与值

在编程中，**值（Value）**是数据在内存中的具体表现形式，它们是程序操作的直接对象。而**变量（Variable）**则是对这些值的命名引用，用于在代码中标识和操作特定的数据。

## 静态类型语言（如C语言）

在静态类型语言中，变量在声明时必须指定数据类型，这定义了变量可以存储的值的类型。例如：

```c
int myVariable = 10;  // myVariable 被声明为整型，只能存储整数。
```

这种类型系统在编译时确定，类型错误在编译阶段被捕获。

## 动态类型语言（如Julia）

Julia采用动态类型系统，变量与值之间的关系更为灵活：

1. **变量名的符号性**：变量名仅作为引用值的符号，不包含类型信息。

2. **动态绑定**：变量与值之间的关联是动态的，可以在程序运行时改变。

3. **值的类型性**：每个值都有明确的类型，而变量本身不具有类型。

在Julia中，变量可以轻松地指向不同类型的值：

```julia
myVariable = 10       // myVariable 指向一个整数。
myVariable = "hello"  // 随后指向一个字符串。
```
"""

# ╔═╡ c9103ca5-3c6e-43f5-b9c7-0626ea26d53d
md"""
 “=”在Julia中表达的含义是**绑定**， 将一个值一个变量名关联起来。 在其他语言中， 通常叫**赋值**。 后面我们并不区分是赋值还是绑定，读者知道其语义就行。
""" |> tip

# ╔═╡ c1153f0b-fb0a-4f45-bf9a-76457698e185
md"""
Julia中的变量是与值相关联的名称。以下是关于Julia变量的一些关键知识点，以及相应的例子：

1. **变量赋值**：
   变量通过等号`=`进行赋值。**赋值表达式本身会返回赋值的值**。
   ```julia
   x = 10  # 将整数10赋值给变量x
   x + 1   # 使用x的值进行数学运算，结果是11
   ```

2. **变量重赋值**：
   可以对同一个变量进行多次赋值，每次赋值都会覆盖之前的值。
   ```julia
   x = 1 + 1  # 将x的值更新为2
   ```

3. **变量命名规则**：
   - 变量名区分大小写。
   - 变量名可以包含Unicode字符，如希腊字母或其他数学符号。
   - 变量名必须以字母、下划线或某些Unicode码点开始。
   - 变量名可以包含数字、下划线、感叹号和其他Unicode字符。

   ```julia
   δ = 0.00001  # 使用希腊字母δ作为变量名
   ```

4. **特殊变量名**：
   - 仅包含下划线的变量（如`___`）只能被赋值，不能作为右值使用。
   ```julia
   x, ___ = 1, 2  # 忽略第二个赋值结果
   ```

5. **风格约定**：
   - 变量名使用小写字母，单词间可以用下划线分隔。
   - 类型和模块名以大写字母开头，单词间使用驼峰式分隔。
   - 函数和宏的命名使用小写字母，不使用下划线。

"""

# ╔═╡ 385ada41-c293-40d8-a15f-da9d207db46a
md"""
## 对比C/C++
Julia语言的变量系统与C/C++有一些显著的不同之处，这些差异主要体现在以下几个方面：

1. **动态类型**：
   - **Julia**：Julia是一种动态类型的语言，变量不需要声明类型，类型在运行时自动推断。这意味着你可以给同一个变量赋予不同类型的值，而不需要重新声明变量。
   ```julia
   x = 10         # x是整数
   x = "Hello"    # x现在是字符串
   ```

   - **C++**：C++是一种静态类型的语言，变量在声明时必须指定类型，类型在编译时确定。如果需要改变变量的类型，必须重新声明。
   
2. **类型推断**：
   - **Julia**：Julia的类型推断非常强大，它可以根据赋值的值自动推断变量的类型。这使得Julia在数值计算和科学计算中非常灵活和高效。

   - **C++**：C++需要在编译时确定类型，因此在编写代码时必须明确指定类型，这有助于编译器进行优化，但牺牲了一定的灵活性。

3. **变量命名**：
   - **Julia**：Julia允许使用Unicode字符作为变量名，包括希腊字母和其他数学符号，这在数学和科学计算中非常有用。
   ```julia
   δ = 0.00001  # 使用希腊字母δ作为变量名
   ```

   - **C++**：C++的变量名必须以字母或下划线开头，后续可以包含数字，但不支持Unicode字符作为变量名。

4. **可变类型与不可变类型**：
   - **Julia**：Julia中的数组是可变的，可以直接修改数组的元素。这种特性使得Julia在处理数据时非常灵活。
   ```julia
   a = [1, 2, 3]
   a[1] = 42  # 直接修改数组元素
   ```

   - **C++**：C++中的数组是不可变的，如果需要修改数组，通常需要使用向量（vector）或其他容器类。

总的来说，Julia的变量系统更加灵活和动态，特别适合于科学计算和数据处理，而C++的变量系统则更加严格和静态，适合于系统编程和性能要求较高的场景。
""" |> aside

# ╔═╡ a56d1b8a-821d-460a-b2a8-fe0eae7a712d
md"""
在 Julia 语言中，变量的赋值表达式 `a = b = value` 将变量 `a` 和 `b` 绑定到相同的值上。这意味着，如果 `value` 是一个可变的数据结构，例如向量，那么通过变量 `a` 对这个值进行修改，将会影响到通过变量 `b` 访问到的相同数据结构。这是因为 `a` 和 `b` 都指向内存中的同一个对象，它们仅仅是这个对象的不同名字而已。下面是一个使用中括号构造向量的例子：

```julia
julia> a = b = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3

julia> a
3-element Vector{Int64}:
 1
 2
 3

julia> b
3-element Vector{Int64}:
 1
 2
 3

julia> a[1] = 10
10

julia> b
3-element Vector{Int64}:
10
 2
 3
```

在上面的例子中，变量 `a` 和 `b` 都指向同一个向量 `[1, 2, 3]`。当我们通过 `a[1] = 10` 修改向量的第一个元素时，这个修改也反映在 `b` 指向的向量上，因为它们是同一个对象。

重要的是要认识到，变量本身没有实体，它们只是值的名称。只有当变量名与某个值（实体）关联时，变量才具有意义。如果我们要改变 `b` 指向的对象，我们可以简单地给 `b` 赋一个新的值，如下所示：

```julia
julia> b = [4, 5, 6]
3-element Vector{Int64}:
 4
 5
 6

julia> a
3-element Vector{Int64}:
10
 2
 3

julia> b
3-element Vector{Int64}:
 4
 5
 6
```

在这个例子中，`b` 被赋予了一个新的向量 `[4, 5, 6]`，而 `a` 仍然指向原来的向量 `[10, 2, 3]`。这表明变量的赋值并不影响其他变量指向的对象，除非它们指向的是同一个对象。
""" |> danger

# ╔═╡ f2346f33-9f66-4220-9fcb-e4772c1e3f5d
md"""
## 值的类型
值是代码构建的虚拟世界中的客观实体。 因此， 每个值都会占有一定的空间。 计算机根据什么决定值应该占有多大的空间，以及存在哪里呢？ 答案是**类型（type）**。 不同类型的值，其存储的位置和方式可能都不同。一般来说， 我们不必关心，值存在哪里。但为了更加高效的处理数据，我们需要知道值的类型。

可以使用`typeof`查看一个值的类型。比如， 字面值10的类型是：$(typeof(10))。即`typeof（10）`的返回结果为 $(typeof(10))。 由于变量是和值绑定到一起的。因此我们也可以查看变量的类型。但请注意。变量的类型只是这个变量绑定的值（或者能绑定的值， 如果限定了话）的类型。

```julia
julia>typeof(10)
Int64

julia> x = 10
julia> typeof(x)
Int64
```

Julia有丰富的数据类型。 这也是Julia语言高效的一个重要原因。在Julia语言中， 类型具有树形层次结构。通常任何类型都会具有一个父类型，可以通过`supertype`函数获取一个类型的父类型。一个类型也可能具有0个或多个子类型， 可以通过`subtypes`函数获取一个类型的所有子类型。注意这两个函数名的单复数形式。它表示了父类型只有一个，而子类型可能有多个的事实。


```julia
julia>supertype(typeof(10))
Signed

julia>supertype(Signed)
Integer

julia>supertype(Integer)
Real

julia>subtypes(Real)
[AbstractFloat,AbstractIrrational,FixedPoint,Integer,Rational]

```

下面两个自编函数print\_supertypes和print\_subtypes可以用于打印一个类型的所有父类型和子类型。暂时看不懂这两个函数也没关系。 后面还会讲到函数的编写。 
```julia
function print_supertypes(T)
        println(T)
        T == Any || print_supertypes(supertype(T))
        return nothing
end
function print_subtypes(T, indent_level=0)
    println(" " ^ indent_level, T)
       for S in subtypes(T)
            print_subtypes(S, indent_level + 2)
       end
       return nothing
end
```

"""

# ╔═╡ 7e978ec9-d510-4ff9-8afb-c973b866802c
md"""

下面的层次图展示了Julia中数字类型的结构。（省略了Number的父类型Any。Any类型是任何类型的父类型。是Julia系统中类型层次树的根节点。）
"""

# ╔═╡ 03578d70-23ed-49e9-b0e3-0a8454876f33
md"""
```
Number(数字)
├── Complex（复数）
└── Real（实数）
    ├── AbstractFloat(浮点数)
    │   ├── BigFloat
    │   ├── Float16
    │   ├── Float32
    │   └── Float64
    ├── AbstractIrrational（有理数）
    │   └── Irrational
    ├── FixedPointNumbers
    │   ├── FixedPointNumbers.Fixed
    │   └── FixedPointNumbers.Normed
    └── Integer（整数）
        ├── Bool
        ├── Signed
        │   ├── BigInt
        │   ├── Int128
        │   ├── Int16
        │   ├── Int32
        │   ├── Int64
        │   └── Int8
        └── Unsigned
            ├── UInt128
            ├── UInt16
            ├── UInt32
            ├── UInt64
            └── UInt8
```
"""

# ╔═╡ 6213a746-a0c1-4b03-9518-ab204f75d36e
md"""
上面显示了数字类型（Number）的所有子类型。从中可以看到在JUlia中， 数字具有丰富的类型。事实上，从小学学到的整数（integer)、分数(ratinal)到中学学习的实数(Real)、复数(complex)等， 数字概念的学习是一个不断扩展的过程, 数字本身也是有一个层次结构。 Julia语言的类型系统， 正好帮助实现了对这种类型层次的模拟。

丰富的类型系统可以使得在编程过程中充分的利用内存空间，提高计算效率。这也是julia语言相比Python更高效的一个原因。但编程过程中需要考虑值的类型可能也是一种负担， Julia语言考虑到了这一点。 在Julia的类型系统中， 处在这个类型树根部位置的是Any类型，也就是任何类型都是Any类型的子类型。 因此， 在编程过程中，我们可以不用考虑值或者变量的类型。Julia语言会默认它就是Any类型。在不考虑类型的情况下，我们可以把Julia语言当成Python或R语言一样的脚本语言来写。因此Julia语言可以写起来很简单。但它又提供了一种能力，可以让代码很高效。当然真正高效的原因是Julia语言会根据不同类型的值编译不同类型的代码, 使得代码的执行效率很高。

```julia
julia>supertype(Number)
Any

```

"""

# ╔═╡ 136cb029-5e54-4034-a785-ee35388b24de
md"""
## 抽象类型与具体类型
上面提到Julia类型系统是一个树形结构(如数字类型树所示)。 树的根节点是Any类型。 通常， 这棵树的中间节点对应的类型都是**抽象类型**， 而叶子节点对应的是**具体类型**。 也就是说， 抽象类型肯定有子类型， 子类型可能是抽象的，也可能是具体的。 而具体类型则没有子类型， 一个值的类型是具体的， 但同时也可以认为一个值是它的父类型的一个值。比如， 数值10是Int64类型的（具体类型）， 同时也是整数类型（Integer）。  

具体类型可以看成是跟具体存储实现相关的。 比如Int64表示64位的整数， 对应连续的8个字节的存储空间。 那为什么需要有抽象类型呢？ Julia的类型系统是为了实现Julia的多重分派而引入的。 简单来说， Julia允许用户在抽象类型上定义函数，这样我们用该抽象类型的任意子类型的值去调用该函数。这一点， 可能暂时不好理解， 后续在函数定义中还会进一步解释。
"""

# ╔═╡ b969accc-b93c-420f-9535-5b4124da2aea
md"""
## 类型的修饰与运算
虽然很多时候不需要管变量的类型，但想要写出高效的代码，有时候也是为了看懂别人的代码， 我们还是需要知道如何修饰（限定）变量的类型。

Julia中， 使用**两个冒号::**表示类型注释， 其基本形式是：**`变量名::类型名`**， 用于告诉系统左边的变量能绑定的类型只能是双冒号之后的限定的类型。 比如下面的代码限定变量x只能绑定Int16类型（16位（bit)的整数）的值， 当我们把常量10（Int64类型)与之绑定的时候， Julia会自动对其做类型转换。最终x绑定的值是Int16类型。
```julia
julia> x::Int16 = 10; 
julia> typeof(x)
Int16
```

这种形式的类型限定， 常出现在函数定义时对参数类型的限制上。
"""

# ╔═╡ 2c28f40f-3a22-4ea8-82e1-300eb48b204c
md"""
类型本身也是一种“值”（不管是系统提供的，还是用户定义的）。 因此， 类型也可以做相关的运算。 除了上述提到的获取类型的父、子类型，以及限定变量类型以外， 涉及类型的运算主要还有两种：1）判断类型的大小关系（父子关系）；2）断言值是某种类型。

判断类型关系可以使用**" <: 和 :> "**两种运算符。 一般来说`T1 <: T2` 或者 `T2 >: T1`用于判断在类型树上，T1的层级是否不超过T1的层级（越靠近树根层级越高）。 其返回结果是bool值ture或false。

如果要判断一个值是否是某种类型（或其类型的后代类型）的值， 可以用`isa`函数， 基本用法是`isa(x, type) -> Bool` 。 也可以这样用： ` x is type `。

```julia
julia> Int64 <: Integer
true
julia> Number >: Integer
true
julia> Number <: Number
true
julia> 10 isa Number 
true
julia> isa(10, AbstractFloat)
false
```

"""

# ╔═╡ c8b3081c-8246-45eb-95e3-dd086c8d7072
md"""
!!! info "类型层次树的作用"
	在C和C++等语言中，当进行计算或调用函数时，如果参数类型不匹配，编译器通常会执行隐式的类型提升或转换，以确保运算可以进行。这种做法虽然在某些情况下可以简化代码，但也可能导致不可预见的行为和性能问题，因为程序员可能没有意识到这些隐式转换正在发生。
	
	相比之下，Julia采用了一种称为“类型稳定性”的设计哲学。在类型稳定性的系统中，一个函数对于给定类型的输入参数应该总是返回相同类型的结果。这意味着Julia在编译时就可以确定函数调用的结果类型，从而优化代码的性能。这种类型系统的设计减少了运行时的类型检查和转换，提高了代码的执行效率。
	
	在Julia中，没有隐式的类型提升或转换（除非通过明确的类型提升规则或显式的类型转换函数）。如果一个函数或运算需要对多种类型的参数进行操作，那么这个函数或运算应该定义在这些类型的共同父类型上。这样，当使用不同类型的参数调用函数时，Julia的类型系统会确保调用正确的方法。
	
	假设我们有一个计算两个数相加的函数，我们希望这个函数能够接受整数和浮点数的任意组合。在Julia中，我们可以将这个函数定义在`Number`类型上，因为`Number`是整数和浮点数的共同父类型。
	
	```julia
	function add_numbers(x::Number, y::Number)
	    return x + y
	end
	
	# 调用函数
	add_numbers(1, 2)       # 整数相加
	add_numbers(1.0, 2.0)   # 浮点数相加
	add_numbers(1, 2.0)     # 整数和浮点数相加
	```
	
	在这个例子中，`add_numbers`函数定义在`Number`类型上，这意味着它可以接收任何`Number`类型的子类型（如`Int64`、`Float64`等）作为参数。当调用`add_numbers`时，Julia会根据传入参数的具体类型来确定调用哪个方法。由于`Number`是`Int`和`Float`的共同父类型，所以这个函数可以处理不同类型的参数组合。
	
	Julia的类型系统是基于类型层次树的，其中每个类型都有一个明确的超类型。这种层次结构使得类型决策和方法选择变得非常清晰和一致。当你想要为多种类型定义一个通用的函数或运算时，你应该在这些类型的共同超类型上进行定义。
	
	Julia的类型系统通过强调类型稳定性和显式类型转换，提供了一种更可预测和更高效的编程方式。这种设计减少了运行时的类型检查和转换，使得Julia在数值和科学计算方面表现出色。通过将函数定义在适当的类型层次上，Julia允许程序员编写既灵活又高效的代码。
	
"""

# ╔═╡ 74e9e637-8eb0-4ff9-8470-6c315b8252d6
md"""
在 Julia 的编程世界里，抽象类型和具体类型就像是一张精心编织的家族树，它们赋予数据和函数以生命和个性。想象一下，如果我们将数据类型比作地球上的居民，那么抽象类型就像是那些广阔的行政区划——它们是宽泛的分类，比如“亚洲”或“欧洲”，它们定义了一片广阔的地域和文化特征，但不指向具体的地点或个体。

具体类型则像是那些详细的籍贯——它们是具体的村庄、城市或地区，比如“北京”或“巴黎”。在 Julia 的代码中，当你定义一个函数，让它只接受“北京”（一个具体类型）的居民时，就像是赋予了这个地区的人一种特殊的能力或权限。这就像是说：“只有北京的居民才能进入这个花园。”

例如，假设我们有一个抽象类型叫做 `Animal`，它定义了所有动物共有的特征，如 `eat()` 方法。然后我们有具体类型 `Dog` 和 `Cat`，它们继承自 `Animal` 并具有自己的特定行为。当我们编写一个函数 `feed(animal::Animal)` 时，我们可以为 `Dog` 和 `Cat` 提供不同的实现，这样每个具体类型就会根据它们的具体籍贯——在这个例子中是它们的具体类型——来展示不同的行为。

多重分派就像是这个世界中的法律，它允许我们根据居民的籍贯（即数据的类型）来赋予他们不同的规则和能力。这与 C/C++ 中的函数重载不同，后者更像是一种更简单的规则，它基于居民数量（参数数量）来决定适用哪条法律。

通过这种层次分明的类型系统，Julia 让程序员能够以一种既结构化又逻辑清晰的方式组织代码，就像是城市规划师设计城市布局一样。抽象类型和具体类型的层次结构不仅反映了现实世界中的层级关系，而且为编程提供了一种强大的工具，帮助我们构建出既灵活又高效的软件世界。

"""

# ╔═╡ 33f03444-bfaf-448a-9cb5-e399376e39fb
md"""
# 数值类型

数值类型是编程语言中用于表示和存储数字的基础数据类型。在Julia语言中，数值类型被细分为多种，以适应不同的计算需求和优化内存使用。

## 整数类型
整数类型用于表示没有小数部分的数。Julia提供了多种整数类型，包括有符号和无符号类型，以及不同位数的类型：

- **Int8/UInt8**：8位整数
- **Int16/UInt16**：16位整数
- **Int32/UInt32**：32位整数
- **Int64/UInt64**：64位整数
- **Int128/UInt128**：128位整数

默认的整数类型（`Int`）取决于系统的架构：32位系统默认为`Int32`，64位系统默认为`Int64`。

```julia
julia> typeof(1)  # 64位系统下
Int64

julia> typemax(Int32)
2147483647

julia> typemin(Int32)
-2147483648
```

## 浮点数类型
浮点数类型用于表示有小数部分的数。Julia支持多种精度的浮点数：

- **Float16**：半精度浮点数
- **Float32**：单精度浮点数
- **Float64**：双精度浮点数

默认的浮点数类型是`Float64`。


```julia
julia> 1.0
1.0

julia> typeof(1.0)
Float64

julia> typemax(Float32)
3.4028235f38

julia> typemin(Float32)
1.4e-45f0
```

## 特殊数值
Julia中的特殊数值包括：

- **Inf**：无穷大，表示超出浮点数表示范围的正数。
- **-Inf**：负无穷大，表示超出浮点数表示范围的负数。
- **NaN**：非数（Not a Number），表示未定义或不可表示的值。

```julia
julia> 1/0
Inf

julia> -1/0
-Inf

julia> 0/0
NaN

julia> NaN == NaN
false  # NaN与自身不相等
```

在Julia中，逻辑值`true`和`false`是整数类型，分别对应整数值`1`和`0`。

```julia
julia> typeof(true)
Bool

julia> true + 1
2

julia> false - 1
-1
```

## 数值字面量的系数
Julia允许在变量前直接使用数值字面量作为系数，表示与变量的乘法。这使得编写数学表达式更加直观和简洁。

```julia
julia> x = 3
3

julia> 2x^2
18

julia> 1.5x^2
22.5
```
"""

# ╔═╡ f9254465-52be-44b4-befe-2a9e8af505cd
md"""
## 类型转化
在计算过程中， 需要的类型和提供的类型不同时， 系统通常会自动做合适的类型转化， 比如把整数变为浮点数等。 有时候， 如果我们要做强制的类型转化可以采用如下方式获得。
- **类型名（数值或数值变量）**
- **变量::类型名 = 数字**

```julia
julia> x = 16.0
julia> Int(x)
```
注意：当转化过程发生精度损失时， 转化会发生错误。 比如， 将带小数的浮点数转化为整数通常会出错（而不是截断小数部分）。
"""

# ╔═╡ 287b8da8-1b21-4c2a-b8cf-565bd294d8b4
typemax(Int64), typemax(Float64), 1/0, 0 * Inf

# ╔═╡ 3fb389f8-b091-4007-b23e-d6a83d8a7e7e
md"""
在Julia语言中，有许多常用的数学函数，下面是一些基础和常用的数学函数的概括：

1. **基础算术运算**
   - `+`：加法。例如：`julia> 1 + 2` 将返回 `3`。
   - `-`：减法。例如：`julia> 2 - 1` 将返回 `1`。
   - `*`：乘法。例如：`julia> 2 * 3` 将返回 `6`。
   - `/`：除法。例如：`julia> 6 / 2` 将返回 `3.0`。
   - `^`：幂运算。例如：`julia> 2 ^ 3` 将返回 `8`。

2. **三角函数**
   - `sin(x)`：计算x（以弧度为单位）的正弦值。例如：`julia> sin(pi / 2)` 将返回接近 `1.0` 的值。
   - `cos(x)`：计算x（以弧度为单位）的余弦值。例如：`julia> cos(pi)` 将返回 `0.0`。
   - `tan(x)`：计算x（以弧度为单位）的正切值。例如：`julia> tan(pi / 4)` 将返回 `1.0`。

3. **指数和对数函数**
   - `exp(x)`：计算自然对数的底e的x次幂。例如：`julia> exp(1)` 将返回 `2.71828...`。
   - `log(x)`：计算x的自然对数。例如：`julia> log(exp(1))` 将返回 `1.0`。
   - `log10(x)`：计算x的以10为底的对数。例如：`julia> log10(100)` 将返回 `2.0`。

4. **绝对值和幂函数**
   - `abs(x)`：计算x的绝对值。例如：`julia> abs(-5)` 将返回 `5`。
   - `sqrt(x)`：计算x的平方根。例如：`julia> sqrt(16)` 将返回 `4.0`。

5. **舍入函数**
   - `round(x)`：将x四舍五入到最接近的整数。例如：`julia> round(pi)` 将返回 `3.0`。
   - `floor(x)`：向下取整到最接近的整数。例如：`julia> floor(pi)` 将返回 `3.0`。
   - `ceil(x)`：向上取整到最接近的整数。例如：`julia> ceil(pi)` 将返回 `4.0`。

6. **随机数生成**
   - `rand()`：生成一个在[0, 1)区间内的随机浮点数。例如：`julia> rand()` 可能返回 `0.37444...`。
   - `randn()`：生成一个服从标准正态分布的随机数。例如：`julia> randn()` 可能返回 `-0.24123...`。

7. **复数函数**
   - `cis(x)`：计算复数的余弦和正弦形式，即计算 `cos(x) + isin(x)`。例如：`julia> cis(pi / 2)` 将返回复数 `0.0 + 1.0im`。

8. **特殊函数**
  - `factorial`： 计算阶乘。例如： `julia> factorial(5)` 返回 `120`。
  - `gcd`：计算最大公约数。 例如： `julia> gcd(8, 12)` 返回 `4`。
  - `lcm`：计算最小公倍数。 例如： `julia> lcm(4, 6)` 返回 `12`。

这些只是Julia中众多数学函数的一部分，Julia还提供了更多的数学和统计函数，可以通过Julia的官方文档进行查询和学习。另外，在SpecialFunctions.jl包里还有许多特殊的数学函数。不过这个包就需要我们手动下载了。
"""

# ╔═╡ b84cb44d-0e2f-4b64-b312-6ee7725e61c7
md"""
# 字符与字符串
字符和字符串也是一种常见的数据形式。简单来说， 字符串就是由字符构成的有限序列。 真正需要理解的是什么是字符。 由于Julia可以方便的处理Unicode编码。这里对字符与字符串做一个深入介绍。

## 字符
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

# ╔═╡ 87883261-7484-48a8-8ed5-d710318ac317
md"""
## 字符串类型
在Julia中，字符串常量可以通过直接在代码中赋值来定义。字符串常量一旦定义，其值就不能被改变，因为Julia中的字符串是不可变的。下面举例说明如何定义字符串常量：

### 字符串类型定义

1. **双引号基本字符串类型**：Julia中的基本字符串类型是`String`，它支持完整的Unicode字符集，通过UTF-8编码。

   ```julia
   str = "Hello, world!"  # 普通字符串
   ```

2. **三引号定义多行字符串常量**：

   ```julia
   # 定义一个多行字符串常量
   MULTILINE_STRING = \"\"\"
   Hello,
   World!
   \"\"\"
   ```

3. **字符类型**：Julia中表示单个字符的类型是`Char`，它是32位原始类型，可以表示任何Unicode字符。

   ```julia
   c = 'A'  # Char类型
   ```

### 常见字符串操作

1. **字符串连接**：使用`*`运算符或`string`函数来连接字符串。

   ```julia
   greet = "Hello"
   whom = "world"
   println(greet * ", " * whom * ".\n")  # 使用*连接
   println(string(greet, ", ", whom, ".\n"))  # 使用string函数
   ```

2. **字符串插值**：使用`$`符号将变量或表达式嵌入到字符串中。

   ```julia
   name = "Julia"
   println("Hello, $name!")  # 字符串插值
   ```

3. **字符串索引**：使用方括号来访问字符串中的特定字符。

   ```julia
   str = "Hello"
   println(str[1])  # 输出 'H'
   ```

4. **切片和子字符串**：使用范围索引来获取字符串的一部分。

   ```julia
   str = "Hello, world!"
   println(str[1:5])  # 输出 "Hello"
   println(str[7:end])  # 输出 "world!"
   ```

5. **Unicode和UTF-8支持**：Julia完全支持Unicode字符和字符串。

   ```julia
   s = "\u2200 x \u2203 y"  # Unicode字符
   println(s)  # 输出 "∀ x ∃ y"
   ```

6. **字符串比较**：使用比较运算符来比较字符串。

   ```julia
   str1 = "apple"
   str2 = "banana"
   println(str1 < str2)  # 按字典顺序比较
   ```

7. **搜索和替换**：使用`findfirst`, `findnext`, `occursin`, `replace`等函数进行搜索和替换。

   ```julia
   str = "Hello, world!"
   println(findfirst('w', str))  # 查找字符'w'的位置
   println(occursin("world", str))  # 检查子字符串是否存在
   println(replace(str, "world" => "Julia"))  # 替换子字符串
   ```

8. **大小写转换**：使用`uppercase`和`lowercase`函数转换字符串的大小写。

   ```julia
   str = "Hello, World!"
   println(uppercase(str))  # 全部大写
   println(lowercase(str))  # 全部小写
   ```

这些是Julia中字符串类型定义和常见操作的概述。Julia的字符串处理功能非常强大，支持复杂的Unicode操作，并且与其他编程语言相比，提供了一些独特的功能和操作符。
"""

# ╔═╡ dd10a23b-02c4-44e2-93b6-4b81e3a4a50f
md"""
# Symbol类型

`Symbol` 类型是 Julia 中的一个基本类型，用于**唯一地表示一个名称或标识符**。当你在 Julia 中创建一个 `Symbol` 时，实际上是在创建一个指向该名称字符串的引用。`Symbol` 的一个关键特性是它们是唯一的，即对于任何给定的字符串，Julia 中的 `Symbol` 都是唯一的。


1. **Symbol的创建**：
   `Symbol` 可以通过冒号 `:` 加上有效的标识符来创建。这种方式创建的`Symbol`在Julia中是唯一的。
   ```julia
   sym = :my_symbol  # 创建一个Symbol
   typeof(sym)        # Symbol
   ```

2. **Symbol的作用**：
   `Symbol` 主要用于表示变量名、函数名和其他标识符，它们在内部表示中作为编译时的常量。
   ```julia
   x = 10
   eval(:(x = 20))  # 使用Symbol来动态赋值，此时变量x指向20
   ```

3. **Symbol与字符串的关系**：
   - `Symbol` 和字符串看似相似，但它们在Julia中有本质的不同。
   - `Symbol` 是不可变的，且在Julia的整个运行时期间是唯一的，而字符串是可变的。
   - `Symbol` 通常用于内部表示和元编程，而字符串用于表示文本数据。

   ```julia
   str = "my_symbol"  # 字符串
   sym = Symbol(str)   # 将字符串转换为Symbol
   ```
4. **Symbol的不可变性**：
   由于 `Symbol` 的不可变性，它们在Julia中用于确保变量名和函数名的唯一性，这对于性能优化和内部表示至关重要。

   ```julia
   sym1 = :my_symbol
   sym2 = :my_symbol
   sym1 === sym2  # true，表明两个Symbol是同一个对象
   ```

"""

# ╔═╡ 44ec34ec-804c-43ab-b6a2-be4d99617a9d
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
# ╠═dfc254a6-f91c-43f2-b007-15975017f34a
# ╠═e739b947-91ae-4163-9dc7-9588787383c4
# ╟─6cbffbbc-af94-4b0c-836e-da4b2e2fb8d4
# ╟─84b5832e-562c-4ebd-8e91-838a0f445a00
# ╟─09d1789b-243f-4008-a6a7-d25fe570abf7
# ╟─e01b58a6-6950-4146-9357-3b38fd572309
# ╟─c9103ca5-3c6e-43f5-b9c7-0626ea26d53d
# ╟─c1153f0b-fb0a-4f45-bf9a-76457698e185
# ╟─385ada41-c293-40d8-a15f-da9d207db46a
# ╟─a56d1b8a-821d-460a-b2a8-fe0eae7a712d
# ╟─f2346f33-9f66-4220-9fcb-e4772c1e3f5d
# ╟─7e978ec9-d510-4ff9-8afb-c973b866802c
# ╟─03578d70-23ed-49e9-b0e3-0a8454876f33
# ╟─6213a746-a0c1-4b03-9518-ab204f75d36e
# ╟─136cb029-5e54-4034-a785-ee35388b24de
# ╟─b969accc-b93c-420f-9535-5b4124da2aea
# ╟─2c28f40f-3a22-4ea8-82e1-300eb48b204c
# ╟─c8b3081c-8246-45eb-95e3-dd086c8d7072
# ╟─74e9e637-8eb0-4ff9-8470-6c315b8252d6
# ╟─33f03444-bfaf-448a-9cb5-e399376e39fb
# ╟─f9254465-52be-44b4-befe-2a9e8af505cd
# ╠═287b8da8-1b21-4c2a-b8cf-565bd294d8b4
# ╟─3fb389f8-b091-4007-b23e-d6a83d8a7e7e
# ╟─b84cb44d-0e2f-4b64-b312-6ee7725e61c7
# ╟─87883261-7484-48a8-8ed5-d710318ac317
# ╟─dd10a23b-02c4-44e2-93b6-4b81e3a4a50f
# ╠═44ec34ec-804c-43ab-b6a2-be4d99617a9d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
