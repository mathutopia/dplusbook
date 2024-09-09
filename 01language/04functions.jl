### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ ad023817-e8f8-4dc9-9e14-e2ee24a57b2f
begin
using PlutoUI,PlutoTeachingTools
end;

# ╔═╡ 1fc39b77-54ce-4f56-9100-3e259a64dc6e
TableOfContents(title="目录")

# ╔═╡ 88c10e46-5b8d-4844-b61a-090cad7b67d7
present_button()

# ╔═╡ 6b4549fe-1587-4a20-ba90-b153498564dc
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia简短教程
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			函数
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ 203e0107-b2cf-4311-800d-9e108fca8197
md"""
在数学上， 一个函数是一个映射``f:x\rightarrow y``, 它将自变量x映射到因变量y。在编程语言中，函数（Function）是一段可以重复使用的代码，它接受输入参数，执行一系列操作，并产生输出结果。编程中的函数与数学中的函数概念相似，都描述了输入与输出之间的映射关系，但编程中的函数更加灵活和复杂，因为它们可以执行各种类型的计算，并且可以有副作用（如修改全局变量或与用户交互）。

"""

# ╔═╡ 9ac2160e-96c5-4fe9-98cf-d9d92dc0204e
md"""
# 函数定义
在 Julia 语言中，有几种定义函数的方法，每种方法都适用于不同的场景。以下是一些常见的定义函数的方法，以及相应的代码示例：

"""

# ╔═╡ fea66c84-6a4e-4c8e-a8b4-363333136682
md"""
## 基本方式
在 Julia 中， 基本的函数定义遵循以下语法规范：

```julia
function 函数名(参数1[::类型1], 参数2[::类型2], ...)[：：类型n]
    函数体
    return 返回值
end
```

- **函数名**：是一个有效的 Julia 标识符（跟变量命名方式类似），用来标识函数。
- **参数**：是传递给函数的变量，可以指定类型，也可以不指定。
- **类型**：是 Julia 中的类型注解，用于指明参数的类型, 类型n用于限制返回类型。**类型注解是可选的**。
- **函数体**：是函数内部执行的代码块。
- **return**：是 Julia 中的一个关键字，用于从函数返回一个值。**如果不使用 `return` 关键字，函数将返回函数体中最后一个表达式的值。**


下面是一个具体的示例，定义了一个计算两个数相加的函数：

```julia
function add(x::Int, y::Int)
    result = x + y
    return result
end
```

在这个例子中：

- `add` 是函数名。
- `x` 和 `y` 是参数名，后面跟着的是类型注解 `::Int`，指明这两个参数应该接收整数类型的值。
- `result = x + y` 是函数体中的一行代码，计算两个数的和。
- `return result` 表示返回计算结果。虽然在这个例子中即使不写 `return` 也会返回 `result` 的值，但使用 `return` 可以更清晰地表示函数的返回值。

!!! tip "带！的函数"
	在Julia中， 有一个关于函数的习惯，**如果一个函数会修改其输入参数，该函数名要以！结尾**。 反过来， 如果发现一个带惊叹号的函数， 那么这个函数会修改输入参数。

"""

# ╔═╡ f862d8e0-898f-438a-8720-81969d4a4f31
md"""
## 紧凑方式
在 Julia 中，紧凑的函数定义方式是一种简洁的语法，允许你直接将函数体写成一个表达式，而不需要显式的 `return` 语句或 `function` 关键字。这种定义方式适用于那些只包含单个表达式的函数。紧凑的函数定义语法如下：

```julia
函数名(参数1, 参数2, ...) = 表达式
```

- **函数名**：是函数的名称，遵循 Julia 的命名规则。
- **参数**：是函数接受的变量名，可以有多个。
- **表达式**：是计算并返回的单个表达式。函数的返回值是这个表达式的结果。

假设我们需要定义一个函数来计算两个数的和， 用紧凑方式可以：

```julia
add(x, y) = x + y
```

在这个例子中：

- `add` 是函数名。
- `x` 和 `y` 是参数。
- `x + y` 是表达式，它计算两个参数的和并作为函数的返回值。


"""

# ╔═╡ 210066a8-a284-4156-b227-4aa2775279ce
md"""
## 匿名函数（Anonymous Functions）

在Julia编程语言中，匿名函数是一种无需命名即可定义的函数对象，它们可以被赋值给变量或直接作为参数传递给其他函数。匿名函数在Julia中通过使用`->`操作符来定义，提供了一种简洁且直观的语法。


匿名函数的基本定义格式如下：

```julia
(parameters) -> expression
```

在上述语法中，`parameters`代表参数列表。当只有一个参数时，可以省略括号；但在没有参数的情况下，括号是必需的。由于匿名函数没有名称，它们不能被直接调用。通常，匿名函数作为值传递给需要函数参数的其他函数。例如，Julia中的`map`函数，其签名定义如下：

```julia
map(f, collection...) -> collection
```

`map`函数将函数`f`应用于容器中的每个元素，其中`f`必须是函数类型的参数。

以下是为了批量计算1到5的所有整数的平方， 通过定义一个求平方的匿名函数作为第一个参数放进`map`里。

```julia
julia> map(x -> x^2, 1:5)
5-element Array{Int64,1}:
 1
 4
 9
 16
 25
```

### 使用do...end块

当匿名函数较为复杂时，可以使用`do...end`块来定义。以下是一个使用`do...end`块的示例：

```julia
julia> map(1:5) do x
       x^2
     end
5-element Array{Int64,1}:
 1
 4
 9
 16
 25
```


匿名函数也可以被赋值给变量，从而可以通过变量名来调用。例如，以下代码将匿名函数赋值给`square`变量，之后可以像调用普通函数一样使用它：

```julia
julia> square = x -> x^2
```

现在，`square`变量可以作为一个函数被调用，例如`square(4)`将返回`16`。



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
除了短路求值运算符外（`｜｜， ＆＆`）， 其他的算术运算符（`＋－＊/`等），比较运算（`<,>`等）都是函数。 
"""

# ╔═╡ d8bc5b7a-5457-4bc7-a153-c417264f01a6
md"""
## Julia中函数是一等公民
在编程语言理论中，**一等公民（First-class citizen）**是指在语言中被视为与其他数据类型（如整数、浮点数、字符串等）同等地位的实体。具体来说，一个数据类型如果满足以下条件，就可以被认为是语言中的一等公民：

1. **可赋值给变量**：可以将其存储在变量中。
2. **可作为参数传递**：可以作为函数调用的参数。
3. **可作为返回值**：可以作为函数调用的结果返回。
4. **可存储在数据结构中**：可以作为数组、列表、字典等数据结构的元素。

Julia语言中的函数是一等公民，因为它们满足上述所有条件。以下是Julia中函数作为一等公民的几个具体体现：

1. **可赋值给变量**：
   Julia允许将函数赋值给变量，这意味着函数可以像其他数据类型一样被存储和操作。

   ```julia
   add = (x, y) -> x + y
   ```

   在这个例子中，`add`变量存储了一个匿名函数，该函数接受两个参数并返回它们的和。

2. **可作为参数传递**：
   Julia中的函数可以作为参数传递给其他函数。这使得高阶函数（接受函数作为参数的函数）成为可能。

   ```julia
   function apply_function(f, x)
       return f(x)
   end

   result = apply_function(add, 3)  # 调用 apply_function 函数，传递 add 函数和参数 3
   ```

   在这个例子中，`apply_function`是一个高阶函数，它接受一个函数`f`和一个参数`x`，然后调用`f`。

3. **可作为返回值**：
   Julia中的函数可以作为其他函数的返回值。

   ```julia
   function create_adder(y)
       return (x) -> x + y
   end

   add_five = create_adder(5)
   ```

   在这个例子中，`create_adder`函数返回一个新的匿名函数，该函数将一个参数与`y`相加。

4. **可存储在数据结构中**：
   Julia中的函数可以存储在数组、字典或其他数据结构中。

   ```julia
   functions = [(x) -> x^2, (x) -> x^3]
   square = functions[1]
   cube = functions[2]
   ```

Julia语言中的函数作为一等公民，提供了极大的灵活性和表达力。这种特性使得Julia非常适合进行函数式编程，同时也支持其他编程范式，如命令式和面向对象编程。通过将函数视为一等公民，Julia能够支持高阶函数、闭包、函数组合等高级编程技术，从而提供了强大的编程能力。

""" |> aside

# ╔═╡ 9c46ff2a-0298-46ef-8cbd-c5adba4e139e
md"""
# 函数参数

## 参数分类

在Julia语言中，函数参数有两种类型： **位置参数**和**关键字参数**， 每一种又分**可选**和**必选**。

在函数定义时位置参数和关键字参数要用**分号(；)分隔**, 分号之前的是位置参数，分号之后的是关键字参数。 
参数的分类及其调用时的赋值方式是该语言多态性和灵活性的重要体现。以下是Julia中函数参数的分类以及调用时如何赋值的详细说明和示例。

#### 1. 位置参数（Positional Arguments）

位置参数是函数定义中最基本的参数类型，调用函数时必须按照定义的顺序提供相应的值。

**代码示例：**

```julia
function calculate_sum(a, b)
    return a + b
end

# 调用函数
calculate_sum(5, 3)  # 输出：8
```

在此示例中，`a` 和 `b` 是必选位置参数。调用函数时，必须按照定义顺序提供这两个参数的值。

#### 2. 可选位置参数（Optional Positional Arguments）

可选位置参数在定义时可以指定默认值，如果调用时未提供值，则自动采用默认值。

**代码示例：**

```julia
function greet(name, message="Hello")
    println("$message, $name!")
end

# 调用函数
greet("Alice")          # 输出："Hello, Alice!"
greet("Bob", "Hi")      # 输出："Hi, Bob!"
```

在这个示例中，`name` 是必选位置参数，而 `message` 是可选位置参数，其默认值为 `"Hello"`。

#### 3. 关键字参数（Keyword Arguments）

关键字参数在调用时必须使用参数名，这提供了更高的可读性和灵活性。

**代码示例：**

```julia
function setup(options; host="localhost", port=8080)
    println("Setting up server at $host:$port")
end

# 调用函数
setup(; host="192.168.1.1", port=9000)  # 输出："Setting up server at 192.168.1.1:9000"
```

在此示例中，`host` 和 `port` 是关键字参数，它们都有默认值。调用时必须使用参数名来指定这些参数的值。

#### 4. 必选关键字参数（Required Keyword Arguments）

必选关键字参数在定义时没有默认值，调用时必须显式提供。

**代码示例：**

```julia
function create_user(name; age)
    println("Creating user $name who is $age years old.")
end

# 调用函数
create_user("Alice"; age=30)  # 输出："Creating user Alice who is 30 years old."
```

在这个示例中，`name` 是位置参数，而 `age` 是必选关键字参数。

#### 5. 可变参数（Varargs）

可变参数允许函数接受任意数量的参数，这些参数在函数体内作为一个元组处理。

**代码示例：**

```julia
function sum_numbers(nums...)
    total = 0
    for num in nums
        total += num
    end
    return total
end

# 调用函数
sum_numbers(1, 2, 3, 4)  # 输出：10
```

在此示例中，`nums...` 表示函数可以接收任意数量的数字，这些数字在函数体内作为一个元组处理。

"""

# ╔═╡ 165fc5e7-1f2f-4075-a622-fe6dc78ba33f
md"""
可变参数后面的三个点是Julia中一个特殊的操作符， 在Julia中有两种作用，可以参考[`...文档`](https://docs.julialang.org/en/v1/manual/faq/#What-does-the-...-operator-do?)了解更多。在函数定义的场景中， 可以表示“卷入”操作：把多个参数卷到一个参数上（多个参数构成元组）。

比如在下面的函数定义， 只有一个参数，args，但args后面有三个点，他表示不管你输入多少个参数， 都将被卷入args这个变量里。当然这个变量会是一个元组，包含你给的所有参数。
```julia

function printargs(args...)
        println(typeof(args))
        for (i, arg) in enumerate(args)
            println("Arg #$i = $arg")
        end
end

julia> printargs(1, 2, 3,4)
NTuple{4, Int64}
Arg #1 = 1
Arg #2 = 2
Arg #3 = 3
Arg #4 = 4
```
""" |> aside

# ╔═╡ d71ab211-8c83-444c-93d9-e3137f06ee69
md"""
## 类型限定
### 参数类型限定
在Julia语言中，函数参数的类型通常不作硬性规定，这种设计哲学旨在提高代码的通用性和灵活性。然而，在某些特定情况下，通过使用类型注释符号（`::`），我们可以明确指定参数应当遵循的类型约束。以下是一个计算斐波那契数列的函数，它明确要求参数 `n` 必须为整数类型（`Integer`）：

```julia
function fib(n::Integer)
    if n ≤ 2
        return one(n)
    else
        return fib(n-1) + fib(n-2)
    end
end

# 调用函数
fib(10)  # 返回 55
```

在这个例子中，函数 `fib` 通过类型注解 `(n::Integer)` 明确指出参数 `n` 必须是整数类型。如果尝试传递一个非整数类型的参数，如浮点数，将引发 `MethodError`，提示没有匹配该类型参数的方法：

```julia
fib(3.5)  # 引发 MethodError
```
"""

# ╔═╡ 1eedc7b1-0bb9-4bc3-a889-8f75b9c2cda0
md"""
尽管Julia鼓励使用动态类型，但在以下情况下，对参数类型进行限定是有益的：

1. **多重分派**：当你希望利用Julia的多重分派特性，为不同类型的参数提供不同的函数实现时。类型限定使得你可以定义一个函数的多个版本，每个版本针对不同的参数类型进行优化。

2. **错误提示**：在参数类型不符时，类型限定可以提供更明确的错误提示，帮助调用者快速定位和解决问题。

3. **代码清晰性**：通过明确指定参数类型，你为函数的使用者提供了清晰的指导，说明了函数期望的输入类型，从而增强了代码的可读性和可维护性。
""" |> aside

# ╔═╡ de36cffc-9b4e-4ab8-803f-bed68f85f77e
md"""
### 返回类型限定
除了输入的参数可以限定类型， 在 Julia 中， 函数的返回值类型也可以通过在函数声明的末尾使用 `::` 符号后跟类型名称来限定。这种方式称为返回类型注解（return type annotation），它告诉 Julia 期望函数返回特定类型的值。

假设我们有一个计算圆面积的函数，我们希望确保返回值类型为 `Float64`：

```julia
function area_of_circle(radius::Float64)::Float64
    return π * radius^2
end
```

在这个例子中，我们限定了 `radius` 参数和返回值都是 `Float64` 类型。这样做的好处是，即使传入的 `radius` 是一个整数，Julia 也会将其转换为 `Float64` 类型来计算，确保计算的准确性和返回值类型的一致性。

返回类型注解的好处是：

1. **类型安全**：通过明确指定返回类型，可以使得函数的行为更加明确和可预测，有助于避免类型错误。
2. **性能优化**：Julia 编译器可以利用返回类型注解来优化代码，比如可以预先分配特定类型的内存空间，避免不必要的类型转换。
3. **代码清晰**：为函数返回值指定类型可以作为文档的一部分，使得其他开发者更容易理解函数的预期行为。
4. **错误检查**：如果在运行时函数返回了一个非注解类型的值，Julia 会抛出一个错误，这有助于及时发现和修复潜在的问题。
"""

# ╔═╡ 86920356-7427-4732-a6bb-64521e1cd425
md"""
三点操作符的另一个用法是展开， 通常，它可以将其前面的对象展开成一个一个元素组成的元组。这个用法经常出现在函数调用的场景， 我们给函数的参数，看上去可能只有一个， 但我们可以将这个参数展开， 得到多个值，分配给多个参数。
"""

# ╔═╡ c053e037-53b5-4024-b02b-1a4f8eea1951
md"""

# 函数拼接与函数复合
## 函数拼接
在 Julia 中，操作符 `|>` 被称为“管道”操作符，它允许你将一个函数的输出直接作为另一个函数的输入（函数拼接到一起）。这种用法非常类似于 Unix 命令行中的管道，其中每个命令的输出成为下一个命令的输入。在 Julia 中，这使得代码更加简洁和易于阅读，特别是在处理数据流和链式操作时。

下面两个例子演示了管道操作的使用方法。

1. **数据处理**：
   假设我们有一个数组，我们想要先对其进行排序，然后取最大值：

   ```julia
   function max_value(xs)
       return maximum(xs)
   end

   array = [3, 1, 4, 1, 5, 9, 2, 6]
   result = array |> sort |> max_value
   ```

   这里，数组首先被排序，然后 `max_value` 函数计算排序后数组的最大值。

2. **字符串处理**：
   对字符串进行转换，先转为大写，然后计算长度：

   ```julia
   function length_of_uppercase(s)
       return length(uppercase(s))
   end

   greeting = "hello, world!"
   length = greeting |> uppercase |> length_of_uppercase
   ```

   这里，字符串首先被转换为大写，然后计算其长度。



## 函数复合
类似函数拼接， 在Julia语言中，提供了复合操作符  `∘`  模拟数学中的复合函数。它将两个函数组合成一个新函数。新函数首先应用第二个函数，然后将结果传递给第一个函数。

```julia
f(x) = x + 3
g(x) = x * 2
h = f ∘ g
```

#### 具体案例
1. **数学运算**：
   ```julia
   add_five(x) = x + 5
   square(x) = x^2
   process = add_five ∘ square
   result = process(4)  # (4^2) + 5 = 21
   ```

2. **数据处理**：
   ```julia
   data_transform(x) = x / 100
   scale_data(x) = x * 10
   process_data = scale_data ∘ data_transform
   result = process_data(50)  # (50 / 100) * 10 = 5
   ```
"""

# ╔═╡ 6df03254-a17c-48c7-9dfc-58543c85bdae
md"""
# 宏
在 Julia 语言中，函数和宏是两种不同的代码构建块，它们在定义、功能和调用方式上有一些关键的异同点。

### 定义
- **普通函数**：使用 `function` 关键字定义。函数是 Julia 中的基本计算单元，可以有零个或多个输入参数，并返回一个值。
  ```julia
  function add(a, b)
      return a + b
  end
  ```

- **宏**：使用 `@macro_name` 定义。宏在编译时展开，它们用于代码的元编程，可以在编译时生成或修改代码。
  ```julia
  macro repeat(ex, n)
      quote
          for i = 1:$n
              $ex
          end
      end
  end
  ```

### 功能
- **普通函数**：执行运行时计算，可以有复杂的逻辑，并且可以返回任何类型的值。
  ```julia
  add(2, 3)  # 返回 5
  ```

- **宏**：在编译时执行，用于生成或修改代码。它们可以用来创建新的表达式，这些表达式在程序运行时会被执行。
  ```julia
  @repeat for i = 1:3
      println(i)
  end 5
  ```

### 调用方式
- **普通函数**：通过函数名和一对圆括号调用，圆括号内是参数列表。
  ```julia
  result = add(2, 3)
  ```

- **宏**：通过 `@` 符号和宏名调用，后面跟着一对圆括号（可选），圆括号内是要被宏处理的表达式。
  ```julia
  @repeat println("Hello World!") 3
  ```

### 异同点
- **相同点**：
  - 两者都是代码复用的手段。
  - 都可以接受参数。
  - 都可以在其他函数或宏内部被定义（嵌套定义）。

- **不同点**：
  - **作用时机**：函数在运行时执行，而宏在编译时执行。
  - **返回内容**：函数返回值，宏返回的是表达式。
  - **调用方式**：函数使用普通调用语法，宏使用 `@` 符号。
  - **副作用**：宏可以用于编写没有运行时开销的代码，如调试打印或条件编译，而普通函数则不能。
  - **代码修改**：宏可以修改代码结构，例如循环展开、代码插桩等，而普通函数则不能。

### 示例
- **函数示例**：
  ```julia
  function square(x)
      return x * x
  end

  println(square(4))  # 输出 16
  ```

- **宏示例**：
  ```julia
  macro debug(x)
      quote
          println("x = ", $x)
          $x
      end
  end

  @debug sqrt(16)  # 输出 "x = 4" 并返回 4
  ```

在上述示例中，`square` 函数计算一个数的平方，而 `debug` 宏则在执行表达式之前打印它的值。宏通过 `@` 符号调用，并在编译时展开，允许在表达式执行前添加额外的行为。

"""

# ╔═╡ 9b58826e-0113-4af6-b583-55169e462a55
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
# ╠═ad023817-e8f8-4dc9-9e14-e2ee24a57b2f
# ╠═1fc39b77-54ce-4f56-9100-3e259a64dc6e
# ╟─88c10e46-5b8d-4844-b61a-090cad7b67d7
# ╟─6b4549fe-1587-4a20-ba90-b153498564dc
# ╟─203e0107-b2cf-4311-800d-9e108fca8197
# ╟─9ac2160e-96c5-4fe9-98cf-d9d92dc0204e
# ╟─fea66c84-6a4e-4c8e-a8b4-363333136682
# ╟─f862d8e0-898f-438a-8720-81969d4a4f31
# ╟─210066a8-a284-4156-b227-4aa2775279ce
# ╟─e73ca1c6-a56d-4dfa-b745-0d29602ebd70
# ╟─d8bc5b7a-5457-4bc7-a153-c417264f01a6
# ╟─9c46ff2a-0298-46ef-8cbd-c5adba4e139e
# ╟─165fc5e7-1f2f-4075-a622-fe6dc78ba33f
# ╟─d71ab211-8c83-444c-93d9-e3137f06ee69
# ╟─1eedc7b1-0bb9-4bc3-a889-8f75b9c2cda0
# ╟─de36cffc-9b4e-4ab8-803f-bed68f85f77e
# ╟─86920356-7427-4732-a6bb-64521e1cd425
# ╟─c053e037-53b5-4024-b02b-1a4f8eea1951
# ╟─6df03254-a17c-48c7-9dfc-58543c85bdae
# ╠═9b58826e-0113-4af6-b583-55169e462a55
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
