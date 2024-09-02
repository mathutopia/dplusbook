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

# ╔═╡ bff5f244-66de-11ef-1248-cf917f18d161
using PlutoTeachingTools, PlutoUI, Tidier

# ╔═╡ 21104cc9-19fd-409a-81b8-1e601a912913
using StatsBase

# ╔═╡ d213aa7d-abff-4948-8ad8-52409716b1c7
begin
	Temp = @ingredients "../chinese.jl" # provided by PlutoLinks.jl
	PlutoTeachingTools.register_language!("chinese", Temp.PTTChinese.China())
	set_language!( PlutoTeachingTools.get_language("chinese") )
end;

# ╔═╡ 07a14ec5-db26-49b3-969b-665dbb000b00
TableOfContents()

# ╔═╡ c78e130c-d018-4107-b967-f916c9165270
md"""
# 数据读取
根据提供的文本内容，以下是 `read_csv` 和 `write_csv` 函数的函数原型及其参数含义：

### read_csv 函数
```julia
read_csv(file; delim=',', col_names=true, skip=0, n_max=Inf, comment=nothing, missingstring="", col_select=nothing, escape_double=true, col_types=nothing, num_threads=1)
```

#### 参数含义
- `file`: 路径或文件路径的向量，或者是指向文件或URL的路径。
- `delim`: 字段分隔符，默认为 ',' 。
- `col_names`: 是否使用第一行作为列名。可以是 true、false 或字符串数组，默认为 true。
- `skip`: 在读取数据前要跳过的行数，默认为 0。
- `n_max`: 要读取的最大行数，默认为 Inf（读取所有行）。
- `comment`: 表示要忽略的注释行的字符，默认为 nothing。
- `missingstring`: 表示缺失值的字符串，默认为 "" 。
- `col_select`: 可选的符号或字符串向量，用于选择要加载的列，默认为 nothing。
- `escape_double`: 将连续的双引号解释为单个引号，默认为 true。
- `col_types`: 可选的列类型说明，默认为 nothing（类型被推断）。
- `num_threads`: 用于并行执行的线程数，默认为 1。

### write_csv 函数
```julia
writecsv(x, file; missingstring="", append=false, colnames=true, eol="\n", num_threads=Threads.nthreads())
```

#### 参数含义
- `x`: 要写入的 DataFrame 。
- `file`: 输出文件的路径。
- `missingstring`: 表示缺失值的字符串，默认为空字符串。
- `append`: 是否追加到现有文件，默认为 false。
- `col_names`: 是否将列名作为第一行写入，默认为 true。
- `eol`: 行结束字符，默认为 "\n"。
- `num_threads`: 用于写入的线程数，默认为可用线程数。

这些函数用于读取和写入分隔文件（CSV、TSV或自定义分隔符）到 DataFrame 或从 DataFrame 到文件。

更多其他格式数据的读写，请参考[**这里.**](https://tidierorg.github.io/TidierFiles.jl/latest/)
"""

# ╔═╡ fd1ab803-27b9-4bba-af52-5c60d0e1232f
train = read_csv("../data/trainbx.csv")

# ╔═╡ 1ce45976-c9e9-41fe-b42b-05d85aa7e8bc
md"""
数据整理是数据分析中的一个重要步骤，它涉及数据的清洗、转换、聚合等操作，以便数据可以被有效地分析和解释。TidierData.jl 提供了一系列函数和宏，可以帮助用户执行数据整理的各种任务。以下是根据数据整理的典型过程与方法对这些函数和宏的总结：



### 数据过滤
- `@filter`: 根据条件筛选数据。

### 数据排序
- `@arrange`: 根据一列或多列对数据进行排序。

### 数据变换
- `@mutate`: 创建新列或修改现有列。
- `@transmute`: 创建仅包含新列的数据框。
- `@unite`: 将多列合并为一个新列。
- `@separate`: 将一列拆分为多个新列。
- `@unnest_longer`: 将数组列展开成长格式。
- `@unnest_wider`: 将数组列展开成宽格式。

### 数据聚合
- `@summarize` / `@summarise`: 对数据进行汇总，如计算均值、最小值、最大值等。
- `@group_by`: 对数据进行分组，以便进行分组聚合。
- `@tally`: 计数和频率分析。
- `@count`: 计算每个组的行数。

### 数据重塑
- `@pivot_longer`: 将宽格式数据框转换为长格式。
- `@pivot_wider`: 将长格式数据框转换为宽格式。



### 高级数据处理
- `@across`: 对多个列应用函数。
- `@if_else`: 条件语句，用于基于条件创建新列。
- `@case_when`: 多条件语句，用于基于多个条件创建新列。
- `@nest`: 将数据框中的列嵌套成列表或其他数据结构。

这些函数和宏提供了一套完整的工具，用于执行数据整理的各个步骤，从而为数据分析和建模打下坚实的基础。
"""

# ╔═╡ 25126385-adcf-4c83-8735-1d43e6896738
md"""
## 数据选择与排除
- `@select`: 选择数据框中的特定列。
- `@rename`: 重命名数据框中的列。
- `@distinct`: 选择唯一的行，去除重复数据。

数据选择与排除是数据处理中的两个基本操作，它们对于数据清洗和准备工作至关重要。这两个操作的目的是从原始数据集中提取有用的信息，并排除不必要的或干扰的信息，以便进行更有效的数据分析。下面是这两个操作的详细解释：

### 数据选择
数据选择是指从数据集中挑选出特定的数据元素（如行、列或单个值）以进行进一步分析的过程。选择可以基于不同的标准，例如：
- **列选择**：根据列的名字或功能选择特定的列。例如，在一个包含多个变量的数据库中，你可能只对某些特定的变量感兴趣。
- **行选择**：基于行的特定条件选择数据。例如，你可能只想分析满足特定条件（如年龄大于30岁）的用户数据。
- **值选择**：选择满足特定数值条件的数据。例如，选择所有销售额超过一定数值的记录。

在 TidierData.jl 中，数据选择可以通过以下函数实现：
- `@select`：选择或排除数据框中的列。
- `@rename`：重命名列，这有助于更好地描述所选数据。

### 数据排除
数据排除是指从数据集中移除不想要的数据元素，这通常是为了清理数据集，去除噪声或不相关的信息。排除可以基于多种条件，例如：
- **去除重复数据**：删除数据集中的重复行，确保每条数据都是唯一的。
- **去除缺失值**：移除包含缺失值的行或列，这些值可能会影响分析的准确性。
- **去除异常值**：排除那些显著偏离其他数据点的值，这些可能是错误或不准确的测量结果。

在 TidierData.jl 中，数据排除可以通过以下函数实现：
- `@distinct`：选择数据框中的唯一行，排除重复的行。
- `@drop_missing`：删除包含缺失值的行或列。

通过有效的数据选择与排除，数据科学家可以确保他们的分析基于最相关和最准确的数据，从而提高分析结果的质量和可靠性。
"""

# ╔═╡ 713b2a77-0b70-4d85-9943-630fc9f59bdc
@chain train begin
@glimpse 
end

# ╔═╡ adadce64-12df-4650-995a-5b0aa8bf8bb6
names(train)

# ╔═╡ e35d3e03-a8d6-425a-a126-b8981d5239f8
@chain train begin
@filter(age>35 || witnesses > 3)
end

# ╔═╡ 3d6341ca-2543-44bf-a6cd-f26f7df00b7a
is_number(train.witnesses)

# ╔═╡ ebb901f6-c15a-4d03-ba1f-0ce0a3bbd322
@chain df begin
	@select()
end

# ╔═╡ 9f056eef-64d9-4af7-86ae-bd18edfd7fd3
md"""
在数据分析中，对列（或称为变量、字段）的操作是数据处理的核心部分。以下是一些常见的列操作，以及在 `TidierData.jl` 中对应的函数：

### 选择和排除列
- **选择列**: `@select`
- **排除列**: `@select` 与 `-` 符号结合使用，如 `@select(-a)`
- **选择列范围**: `@select(a:b)` 选择从 `a` 到 `b` 的列
- **根据条件选择列**: `where` 函数，如 `@select(where(is_number))`

### 重命名和重新排列列
- **重命名列**: `@rename`
- **使用函数重命名列**: `@rename_with`



### 分组和聚合
- **分组**: `@group_by`
- **聚合**: `@summarize` 或 `@summarise`（注意：`@summarize` 和 `@summarise` 在 Julia 中是同一个函数，只是拼写不同）
- **聚合计算**: `n`, `mean`, `sum`, `minimum`, `maximum` 等

### 合并和连接
- **内连接**: `@inner_join`
- **左连接**: `@left_join`
- **右连接**: `@right_join`
- **全连接**: `@full_join`
- **反连接**: `@anti_join`
- **半连接**: `@semi_join`

### 长格式和宽格式转换
- **长格式转换**: `@pivot_longer`
- **宽格式转换**: `@pivot_wider`

### 拆分和合并列
- **拆分列**: `@separate`
- **合并列**: `@unite`

### 过滤和排序
- **过滤行**: `@filter`
- **排序**: `@arrange` 或 `desc`

### 特殊操作
- **去除重复**: `@distinct`
- **填充缺失值**: `@fill_missing`
- **随机抽样**: `@slice_sample`
- **统计摘要**: `@summary`

这些函数提供了强大的工具集，用于在数据分析过程中对列进行各种操作。通过组合这些函数，可以执行复杂的数据转换和分析任务。
"""

# ╔═╡ 159e86f0-9acf-4e1d-9bec-a62cc821c35f
# ╠═╡ disabled = true
#=╠═╡
df = DataFrame(a = ["1-1", "2-2", "3-3-3"]);
  ╠═╡ =#

# ╔═╡ b6bfcf78-8465-42af-9f66-77394db9c922
@separate(df, a, [b, c, d], "-")

# ╔═╡ 8f03fb46-e8c8-4584-b8cb-14c57d7e50d5
md"""



### 5. **数据类型转换**
- **类型转换**
  - `as_float(value)`
  - 参数：`value` (转换值)
  - 作用：将值转换为浮点数。

  - `as_integer(value)`
  - 参数：`value` (转换值)
  - 作用：将值转换为整数。

  - `as_string(value)`
  - 参数：`value` (转换值)
  - 作用：将值转换为字符串。

### 6. **数据合并和连接**
- **连接**
  - `@left_join(df1, df2, [by])`
  - 参数：`df1`, `df2` (DataFrames), `by` (连接键)
  - 作用：左连接两个数据框。

  - `@right_join(df1, df2, [by])`
  - 参数：同上
  - 作用：右连接两个数据框。

  - `@inner_join(df1, df2, [by])`
  - 参数：同上
  - 作用：内连接两个数据框。

  - `@full_join(df1, df2, [by])`
  - 参数：同上
  - 作用：全连接两个数据框。

### 7. **分组和拆分**
- **分组**
  - `@group_by(df, exprs...)`
  - 参数：`df` (DataFrame), `exprs...` (分组列)
  - 作用：按列分组数据。

- **拆分**
  - `@ungroup(df)`
  - 参数：`df` (GroupedDataFrame)
  - 作用：移除分组。

这些函数覆盖了数据处理的大部分需求，从基本的列选择和转换到复杂的数据聚合和连接操作。
"""

# ╔═╡ 24c0519e-9ec8-4f11-bdd7-34b7e47b58a3
md"""

## 1. **选择列（变量）**
在数据分析中，列操作是至关重要的.在 `TidierData.jl` 中通常使用 `@select` 宏进行列选择。其基本用法如下：

**选择列**
  - `@select(df, exprs...)`
  - 参数：`df` (DataFrame), `exprs...` (列选择表达式)
  - 作用：选择指定的列。

其中， 列选择表达式有多种写法， 以下是一些常见的列选择表达式写法：


1. **选择单个列**:
   ```julia
   @select(df, a)
   ```
其中，a是数据框df中的列名。不需要引号和冒号。以下类似。
2. **选择多个列**:
   ```julia
   @select(df, a, b, c)
   ```

3. **选择列范围**:
   ```julia
   @select(df, 1:3)  # 选择第1到第3列
   @select(df, a:c)  # 选择从列a到列c
   ```

4. **排除列**:
   ```julia
   @select(df, -a)  # 排除列a
   @select(df, -(1:2))  # 排除第1和第2列
   ```

5. **选择列的子集**（使用帮助函数）:
   ```julia
   @select(df, starts_with("a"), ends_with("b"))
   @select(df, contains("c"))
   @select(df, matches(r"^d"))
   ```

6. **排除列的子集**（结合 `-` 操作符）:
   ```julia
   @select(df, -starts_with("a"))
   @select(df, -contains("c"))
   ```

7. **选择所有列**:
   ```julia
   @select(df, everything())
   ```

8. **选择剩余的列**（在已选择某些列之后）:
   ```julia
   @select(df, a, everything())
   ```

9. **条件选择列**（使用 `where` 函数）:
   ```julia
   @select(df, where(is_number))
   ```

10. **使用运算符选择列**:
    - `+` 运算符用于保留列（相当于列的并集）:
      ```julia
      @select(df, a:c, +d:f)
      ```
    - `!` 运算符用于排除列（相当于列的差集）:
      ```julia
      @select(df, !(a:c))
      ```



11. **使用 `across` 函数**对选定的列应用函数:
    ```julia
    @select(df, a, across(b:c, sqrt))
    ```
 
12. **重命名列**（在 `@select` 中同时选择和重命名列）: 
    ```julia
    @select(df, old_name = new_name)
    ```

"""

# ╔═╡ 7fcc1672-3a18-4330-92bf-d76b1296a98b
@chain train begin 
@select(a = case_when(age > 45 => "o", 
					   age >30 =>  "m", 
					   true => "y"))
end

# ╔═╡ 032ab34f-0553-4c7b-bb85-f190e7ec3d43
case_when

# ╔═╡ e84759f7-7b85-4ed9-9e14-5c5c5d465dc4
md"""
## 2. **过滤行（样本）**
#### 过滤
过滤一般针对的是行的操作， 主要是找到想要的样本。其采用的函数是：`@filter(df, exprs...)`， 其中
 参数：`df` (DataFrame), `exprs...` (过滤条件)。其作用是根据条件过滤行。

以下是 `@filter` 的几种用法和相应的使用案例：

1. **基本过滤**：使用条件表达式来筛选行，仅保留满足条件的行。

```julia
@chain movies begin
  @filter(Budget >= mean(skipmissing(Budget)))
  @select(Title, Budget)
  @slice(1:5)
end
```

在这个例子中，我们筛选了那些预算超过平均预算的电影，并选择了标题和预算两列，最后仅显示前5行。

2. **使用逻辑与（AND）条件**：有三种方式可以指定“与”条件：

   - 使用短路运算符 `&&`，这是首选方法，因为它仅在第一个表达式为真时才评估第二个表达式。

   ```julia
   @chain movies begin
     @filter(Votes >= 200 && Rating >= 8)
     @select(Title, Votes, Rating)
     @slice(1:5)
   end
   ```

   - 使用位运算符 `&`，注意需要用括号包围比较表达式，以确保整体表达式正确评估。

   ```julia
   @chain movies begin
     @filter((Votes >= 200) & (Rating >= 8))
     @select(Title, Votes, Rating)
     @slice(1:5)
   end
   ```

   - 使用逗号分隔表达式，这与 tidyverse 中的 `filter()` 函数的行为类似。

   ```julia
   @chain movies begin
     @filter(Votes >= 200, Rating >= 8)
     @select(Title, Votes, Rating)
     @slice(1:5)
   end
   ```

3. **使用 `in` 运算符**：可以筛选属于特定元组或向量的行。

   - 使用元组：

   ```julia
   @chain movies begin
     @filter(Title in ("101 Dalmatians", "102 Dalmatians"))
     @select(1:5)
   end
   ```

   - 使用向量：

   ```julia
   @chain movies begin
     @filter(Title in ["101 Dalmatians", "102 Dalmatians"])
     @select(1:5)
   end
   ```

4. **结合 `row_number()` 函数**：可以用来获取前N行数据，类似于 `@slice` 的功能。

```julia
@chain movies begin
  @filter(row_number() <= 5)
  @select(1:5)
end
```

在这个例子中，我们使用 `row_number()` 来筛选前5行数据。



"""

# ╔═╡ 35e94f0e-312a-4c41-9db8-8a3a0aa768f0
md"""
如果你需要实现“或（OR）”条件，可以通过逻辑运算符 `||` 来实现, 这类似与`&&`。此外，你可以通过结合使用 Julia 的其他功能来实现“或”逻辑。以下是一个可能的方法：

**使用 `@mutate` 和 `@filter` 结合实现“或”条件**：
   你可以先使用 `@mutate` 创建一个新列，该列基于你想要测试的“或”条件，然后使用 `@filter` 根据这个新列进行筛选。

例如，假设我们想要筛选出电影评分大于 7 或者投票数超过 1000 的电影：

```julia
@chain movies begin
  @mutate(Condition = Rating > 7 || Votes > 1000)
  @filter(Condition)
  @select(Title, Rating, Votes)
end
```

在这个例子中，`@mutate` 用于创建一个名为 `Condition` 的新列，该列对于每一行都是根据 `Rating > 7 || Votes > 1000` 这个条件计算得到的布尔值。然后，`@filter` 用于筛选出 `Condition` 为 `true` 的行。

这种方法虽然不是直接使用“或”条件，但可以达到类似的效果，并且是在使用 TidierData.jl 进行数据筛选时处理“或”条件的一种有效方式。
"""

# ╔═╡ 1d89963a-a7f1-4bcb-b802-4d4ca5c41116
md"""
#### 排序
`@arrange` 函数用于对数据框中的行进行排序。它可以接收多个列名作为参数，根据这些列的值对数据进行排序。默认情况下，排序是升序的，但可以通过使用 `desc()` 函数来指定某些列进行降序排序。
##### @arrange 函数

```julia
@arrange(data, columns...)
```
**参数说明**
- `data`: 需要排序的数据框（DataFrame）。
- `columns`: 一个或多个列名，用于指定排序的列。默认情况下，这些列将按照升序排列。如果需要降序排列，可以使用 `desc()` 函数包裹列名。

##### 1. 按多个列升序排序
```julia
@chain movies begin
  @arrange(Year, Rating)
  @select(1:5)
  @slice(1:5)
end
```
这个例子中，`@arrange` 函数按照 `Year` 和 `Rating` 列进行升序排序，并选择了排序后的前5行。

##### 2. 混合排序（升序和降序）
```julia
@chain movies begin
  @arrange(Year, desc(Rating))
  @select(1:5)
  @slice(1:5)
end
```
在这个例子中，`@arrange` 函数首先按照 `Year` 列升序排序，然后按照 `Rating` 列降序排序。同样，它选择了排序后的前5行。

##### 3. 处理分组数据框
如果 `@arrange` 应用于一个 `GroupedDataFrame`，它将临时取消分组，执行排序，然后根据原始分组变量重新分组。

```julia
@chain grouped_data begin
  @arrange(Year, desc(Rating))
end
```
这个例子中，`@arrange` 函数用于排序一个分组后的数据框，先按 `Year` 升序，然后按 `Rating` 降序。

"""

# ╔═╡ 54c6998d-3ac7-4269-b90d-0f8c6bba2bf4
md"""
## 3 **重塑数据**

以下是涉及数据重塑的函数，包括它们的签名、参数含义、作用以及示例：

1. **@pivot_longer**
   - 签名: `@pivot_longer(df, cols, [names_to], [values_to])`
   - 参数含义:
     - `df`: 要重塑的DataFrame。
     - `cols`: 要转换成长的格式的列。
     - `names_to`: 新创建的列的名称，用于存储原DataFrame的列名，默认为"variable"。
     - `values_to`: 新创建的列的名称，用于存储原DataFrame的单元格值，默认为"value"。
   - 作用: 将DataFrame从宽格式转换为长格式。
   - 示例:
     ```julia
     julia> df_wide = DataFrame(id = [1, 2], A = [1, 3], B = [2, 4]);
     julia> @pivot_longer(df_wide, A:B)
     ```
 $(Foldable("为什么",md"The `CSV.read` function has lots of useful optional arguments."))
2. **@pivot_wider**
   - 签名: `@pivot_wider(df, names_from, values_from, [values_fill])`
   - 参数含义:
     - `df`: 要重塑的DataFrame。
     - `names_from`: 用于获取输出列名的列名。
     - `values_from`: 用于获取单元格值的列名。
     - `values_fill`: 用于替换缺失的名称/值组合的值，默认为缺失值。
   - 作用: 将DataFrame从长格式转换为宽格式。
   - 示例:
     ```julia
     julia> df_long = DataFrame(id = [1, 1, 2, 2], variable = ["A", "B", "A", "B"], value = [1, 2, 3, 4]);
     julia> @pivot_wider(df_long, names_from = variable, values_from = value)
     ```

3. **@unnest_longer**
   - 签名: `@unnest_longer(df, columns, [indices_include], [keep_empty])`
   - 参数含义:
     - `df`: 包含数组列的DataFrame。
     - `columns`: 要展开的列。
     - `indices_include`: 是否为每个展开的列添加索引列，默认为false。
     - `keep_empty`: 是否保留包含空数组的行，默认为false。
   - 作用: 将DataFrame中的数组列展开成长格式。
   - 示例:
     ```julia
     julia> df = DataFrame(a=[1, 2], b=[[1, 2], [3, 4]], c=[[5, 6], [7, 8]]);
     julia> @unnest_longer(df, 2)
     ```

4. **@unnest_wider**
   - 签名: `@unnest_wider(df, columns, [names_sep])`
   - 参数含义:
     - `df`: 包含数组或字典列的DataFrame。
     - `columns`: 要展开的列。
     - `names_sep`: 创建新列名时使用的分隔符，默认无分隔符。
   - 作用: 将DataFrame中的数组或字典列展开为宽格式。
   - 示例:
     ```julia
     julia> df = DataFrame(name = ["Zaki", "Farida"], attributes = [Dict("age" => 25, "city" => "New York"), Dict("age" => 30, "city" => "Los Angeles")]);
     julia> @unnest_wider(df, attributes)
     ```

这些函数是TidierData.jl包中用于数据重塑的工具，允许用户通过指定的参数将数据集从一种格式转换到另一种格式，以适应不同的分析需求。


"""

# ╔═╡ 023e6abb-2e96-4538-bc85-0b2102611bf2
md"""
## **4 计算和转换列**
计算和转换列是数据处理中的关键步骤，原因包括：

1. **数据清洗**：在数据预处理阶段，可能需要对原始数据进行清洗，比如修正错误、填补缺失值或删除异常值。

2. **数据转换**：为了满足分析需求，可能需要将数据转换成不同的格式或单位。例如，将温度从摄氏度转换为华氏度，或将货币从一种单位转换为另一种单位。

3. **特征工程**：在机器学习中，通过计算和转换列可以创建新的特征，这有助于提高模型的性能。例如，可以从日期时间数据中提取出有用的特征，如年份、月份、星期等。

4. **数据聚合**：在进行汇总统计时，可能需要对数据进行分组和聚合，计算和转换列可以帮助组织数据，以便更有效地进行这些操作。

5. **数据标准化**：为了比较不同来源或不同量级的数据，可能需要对数据进行标准化或归一化处理。

6. **提高可读性**：通过计算和转换列，可以使数据更易于理解和解释。例如，将数字ID转换为有意义的标签，或者将复杂的数值转换为更容易理解的百分比。

7. **适应不同的分析工具**：不同的分析工具可能要求数据以特定的格式输入。计算和转换列可以帮助数据适应这些工具的要求。

8. **数据可视化**：为了更直观地展示数据，可能需要对数据进行转换，以适应不同的可视化需求。

9. **模型构建**：在构建预测模型时，可能需要对数据进行特定的计算和转换，以确保模型能够正确地解释数据。

10. **遵守法规和标准**：在某些情况下，数据处理可能需要遵守特定的法规或行业标准，这可能涉及到对数据的特定计算和转换。

总的来说，计算和转换列是数据分析和处理过程中不可或缺的一部分，它们有助于提高数据的质量和可用性，为后续的分析和决策提供支持。


在TidierData.jl中用于计算和转换列的函数是：`@mutate`和`@transmute`。@transmute： 用于更新和选择列，实际上是@select的别名。

"""

# ╔═╡ dc2cbb2d-3331-4e3b-8027-04d6e857d0c7
md"""
### @mutate
在TidierData.jl中，`@mutate`是一个功能强大的宏，用于在数据框（DataFrame）中创建新列或更新现有列。以下是一些常见的`@mutate`用法示例：

1. **添加新列**：
   ```julia
   @chain data begin
     @mutate(New_Column = some_function(existing_column))
   end
   ```
   这里，`New_Column` 是新创建的列，`some_function` 是一个函数，用于对现有的 `existing_column` 进行计算。

2. **更新现有列**：
   ```julia
   @chain data begin
     @mutate(existing_column = existing_column * 2)
   end
   ```
   在这个例子中，`existing_column` 是一个已经存在的列，我们通过将其值乘以2来更新它。

3. **条件更新**：
   ```julia
   @chain data begin
     @mutate(Updated_Column = ifelse(condition, value_if_true, value_if_false))
   end
   ```
   使用条件语句来更新列。如果 `condition` 为真，则 `Updated_Column` 将被设置为 `value_if_true`，否则设置为 `value_if_false`。

4. **使用窗口函数**：
   ```julia
   @chain data begin
     @mutate(Running_Total = cumsum(existing_column))
   end
   ```
   这里使用累积求和（`cumsum`）作为窗口函数来创建一个运行总和列。

5. **结合`group_by`使用**：
   ```julia
   @chain data begin
     @group_by(Group_Column)
     @mutate(Group_Mean = mean(existing_column))
   end
   ```
   先按 `Group_Column` 进行分组，然后在每个组内计算 `existing_column` 的均值。

6. **使用`row_number`和`n`**：
   ```julia
   @chain data begin
     @mutate(Row_Number = row_number(), Total_Rows = n())
   end
   ```
   创建一个新列 `Row_Number` 来表示每行的行号，以及一个 `Total_Rows` 列来表示数据框的总行数。

7. **转换数据类型**：
   ```julia
   @chain data begin
     @mutate(Converted_Column = as_integer(existing_column))
   end
   ```
   将 `existing_column` 转换为整数类型。类似的转换函数还有`as_string`,`as_float`.

8. **使用`across`进行多列操作**：
   ```julia
   @chain data begin
     @mutate(across((Column1, Column2), (fn1, fn2)))
   end
   ```
   对多个列应用不同的函数。`Column1` 应用 `fn1`，`Column2` 应用 `fn2`。

这些示例展示了`@mutate`在不同场景下的灵活性和强大功能，使其成为数据框操作中不可或缺的工具。
"""

# ╔═╡ f1ee32d8-9cc8-4463-945a-4d693c780c78
Foldable("什么是窗口函数？",md"""
窗口函数（Window Functions）在数据处理和分析中扮演着重要的角色，尤其是在需要对数据进行分区或分组处理时。窗口函数允许你对数据集中的一组行执行计算，而不会将这些行聚合成单个输出行，这与传统的聚合函数（如 `sum`、`mean`、`count` 等）不同。窗口函数在处理时间序列数据、财务数据、排名和比较等场景中特别有用。

窗口函数之所以被称为“窗口”，是因为它们可以看作是在数据集上滑动一个“窗口”，并在这个窗口内对数据进行计算。这个窗口可以是整个数据集，也可以是数据集中的一部分，如基于某些条件划分的子集。窗口函数在计算时会考虑窗口内的所有行，但每个行的计算结果只与该行及其在窗口内的相对位置有关。


**窗口函数的作用**

1. **分区计算**：在不改变数据集结构的前提下，对数据的子集进行计算。
2. **保留数据行**：与传统聚合函数不同，窗口函数不会减少数据行数。
3. **灵活的计算**：可以对数据进行复杂的计算，如移动平均、累积总和等。
4. **排名和分区**：可以计算数据在组内的排名或分区。

**常见的窗口函数**

1. **`row_number()`**：
   - 返回当前行在其分区内的行号。

2. **`ntile(n)`**：
   - 将分区内的行分为 `n` 个大致相等的组，并为每行分配一个组号。

3. **`lead(column, n)`**：
   - 返回当前行后面第 `n` 行的 `column` 值。

4. **`lag(column, n)`**：
   - 返回当前行前面第 `n` 行的 `column` 值。

5. **`cumsum()`**：
   - 计算从分区开头到当前行的 `column` 的累积总和。


6. **`sum()`**：
    - 计算分区内 `column` 的总和。

7. **`mean()`**：
    - 计算分区内 `column` 的平均值。

8. **`median()`**：
    - 计算分区内 `column` 的中位数。

9. **`std()`**：
    - 计算分区内 `column` 的标准差。

10. **`var()`**：
    - 计算分区内 `column` 的方差。
11. **`~ordinalrank`**
    - 计算分区内 `column` 的ordinal排名（"1234" ranking)）。前面的~表示不要向量化。类似的函数还有，competerank("1224" ranking)、denserank("1223" ranking)。这些函数的使用需要`using StatsBase`

窗口函数是数据分析中非常强大的工具，它们提供了一种在保持数据行结构的同时进行复杂计算的方法。
""")

# ╔═╡ fedae49a-1db0-438e-9c45-d944728f8c93
md"""
## 5. **汇总和聚合**
数据的汇总（Summarization）和聚合（Aggregation）是指将大量数据中的信息进行简化和概括的过程，以便更容易地理解数据集中的关键信息和趋势。

1. **数据汇总**：
   - 汇总是将数据集的多个行或记录合并成一个或几个总结性的行或记录。
   - 它通常涉及计算统计量，如总和、平均值、中位数、最大值和最小值等。

2. **数据聚合**：
   - 聚合是将数据集中的多个行或记录按照某种逻辑（如分组）合并成一个或几个新的记录。
   - 聚合操作通常包括分组（grouping）、排序（sorting）和应用汇总函数（如求和、平均、计数）。

数据汇总和聚合具有多方面的作用：
1. **简化数据**：
   - 汇总和聚合可以将大量数据简化为更易于理解和分析的形式。
   - 通过减少数据量，可以更快速地进行数据处理和分析。

2. **提取关键信息**：
   - 通过汇总和聚合，可以快速识别数据中的关键趋势、模式和异常值。
   - 这有助于从大量数据中提取有用的信息，为决策提供支持。

3. **提高效率**：
   - 汇总和聚合可以减少处理和分析数据所需的时间，提高数据处理的效率。
   - 在大数据环境中，直接处理原始数据可能非常耗时，而汇总和聚合可以显著减少处理时间。

4. **支持决策制定**：
   - 汇总和聚合后的数据通常更易于解释，有助于决策者理解数据背后的含义。
   - 通过提供总结性的数据视图，可以帮助决策者做出更明智的决策。

5. **数据可视化**：
   - 汇总和聚合的数据更容易进行可视化，如图表和图形，这有助于直观地展示数据。
   - 可视化是理解复杂数据集的有效方式，汇总和聚合后的数据可以更清晰地展示数据的关键特征。

6. **数据预处理**：
   - 在进行更复杂的数据分析之前，汇总和聚合是数据预处理的重要步骤。
   - 它可以为机器学习、预测分析等高级分析方法提供准备好的数据。


假设有一个包含成千上万条电影记录的数据集，每条记录包含电影的名称、预算、票房收入、上映年份等信息。通过数据汇总和聚合，我们可以：
- **计算总票房**：对所有电影的票房收入进行求和。
- **平均预算**：计算所有电影的平均预算。
- **按年份分组**：将电影按上映年份分组，并计算每组的总票房和平均票房。

通过这些操作，我们可以快速了解电影行业的整体趋势，如哪些年份的电影票房表现最好，或者电影预算与票房收入之间的关系等。

总之，数据汇总和聚合是数据分析中的重要步骤，它们有助于简化数据、提取关键信息、提高效率、支持决策制定、便于数据可视化和作为数据预处理的一部分。


"""

# ╔═╡ 25289d9b-79a9-4eff-af74-d6403e2de077
md"""

`@summarize` 是 Julia 语言中 TidierData.jl 包的一个功能，它用于对数据集进行汇总。这个功能类似于 R 语言的 tidyverse 包中的 `summarize` 函数。以下是 `@summarize` 的主要作用和用法：

### 作用：
1. **数据聚合**：`@summarize` 可以将数据集中的多行数据聚合成通常的单行数据。这可以在整个数据集上进行，也可以在分组数据集上进行，为每个分组生成一行汇总数据。
2. **自动去除分组层级**：在执行 `@summarize` 后，会自动去除一层分组，除非需要额外的分组操作，否则不需要显式地调用 `@ungroup`。
3. **支持自定义汇总函数**：可以使用各种 Julia 的函数来进行数据的汇总计算，如计算平均值、中位数、计数等。

### 用法：
- **基本用法**：可以直接使用 `@summarize` 对整个数据集进行汇总，例如计算数据集中电影的数量或平均预算。

```julia
@chain movies begin
    @summarize(n = n())
end
```

- **计算特定统计量**：可以结合其他函数如 `median`、`mean` 等来计算数据集的中位数、平均值等统计量。

```julia
@chain movies begin
  @mutate(Budget = Budget / 1_000_000)
  @summarize(median_budget = median(skipmissing(Budget)),
             mean_budget = mean(skipmissing(Budget)))
end
```

- **结合 `@group_by` 使用**：可以先使用 `@group_by` 对数据集进行分组，然后使用 `@summarize` 对每个分组进行汇总。

```julia
@chain movies begin
  @group_by(Year)
  @summarise(n = n())
  @arrange(desc(Year))
  @slice(1:5)
end
```

在这个例子中，首先按年份分组，然后计算每个年份的电影数量，并按年份降序排列，最后选择最近的五年数据。

### 注意事项：
- **不自动向量化**：与 TidierData.jl 中的其他函数不同，`@summarize` 在使用时不会进行自动向量化。
- **分组层级变化**：每次使用 `@summarize` 后，会减少一层分组，除非需要额外的分组操作。


"""

# ╔═╡ 7012945e-be9b-48fa-acc3-23c387a31db8
string(TidierData.not_vectorized[])

# ╔═╡ d01ac4f8-6903-41ff-bbc2-1210b588f16a
md"""
## **6. 数据类型转换**

数据类型检查和数据转换也是数据分析常见的操作。以下是在TidierData.jl中，一些相关的函数：

1. **is_float**
   - **函数签名**：`is_float(column::AbstractVector)`
   - **参数解释**：
     - `column::AbstractVector`: 需要检查数据类型的列。
   - **作用**：确定给定的列是否包含浮点数。

2. **is_integer**
   - **函数签名**：`is_integer(column::AbstractVector)`
   - **参数解释**：
     - `column::AbstractVector`: 需要检查数据类型的列。
   - **作用**：确定给定的列是否包含整数。

3. **is_string**
   - **函数签名**：`is_string(column::AbstractVector)`
   - **参数解释**：
     - `column::AbstractVector`: 需要检查数据类型的列。
   - **作用**：确定给定的列是否包含字符串。

4. **as_float**
   - **函数签名**：`as_float(value)`
   - **参数解释**：
     - `value`: 需要转换的值，可以是字符串、数字或缺失值。
   - **作用**：将数字或字符串转换为`Float64`数据类型。如果值为缺失，则保持为缺失。

5. **as_integer**
   - **函数签名**：`as_integer(value)`
   - **参数解释**：
     - `value`: 需要转换的值，可以是字符串、数字或缺失值。
   - **作用**：将数字或字符串转换为`Int64`数据类型，小数点后的数值会被移除。如果值为缺失，则保持为缺失。

6. **as_string**
   - **函数签名**：`as_string(value)`
   - **参数解释**：
     - `value`: 需要转换的值，可以是数字、字符串或缺失值。
   - **作用**：将数字或字符串转换为字符串类型。如果值为缺失，则保持为缺失。

这些函数提供了对数据类型进行检查和转换的能力，使得在数据处理过程中能够更灵活地处理不同类型的数据。


"""

# ╔═╡ bf8d9758-fb7f-46d3-8230-df362e9362e9
md"""
连续变量的离散化是指将连续变量的值域分割成若干个区间，并把原来连续的数值转换为这些区间的表示。离散化通常用于数据分析和机器学习中，以下是离散化的一些原因和方法：

1. **简化问题**：在某些情况下，连续变量的离散化可以简化问题，使得问题更容易理解和处理。
2. **改善模型性能**：对于某些模型，如决策树，离散化可以提高模型的解释性和性能。
3. **减少噪声**：离散化可以减少数据中的噪声，提高模型的稳定性。
4. **满足算法要求**：某些算法，如某些聚类算法，可能需要离散化的数据作为输入。
5. **数据可视化**：离散化后的数据更容易进行可视化，如直方图等。

离散化是一个数据预处理步骤，需要根据具体的数据和分析目标来选择合适的方法。在实际操作中，可能需要尝试多种方法，以找到最适合当前问题的离散化策略。
"""

# ╔═╡ 75b22bfe-7f51-4e89-952b-dd88bcf17fc0
md"""
在 Julia 语言的 TidierData.jl 包中，可以使用 `cut` 函数来实现连续变量的离散化（cut函数来自CategoricalArray.jl包， 不过这个包中的所有函数都被Tidier包重导出了，所以在加载了Tidier.jl包后直接使）。`cut` 函数可以将连续变量分割成不同的类别或分组，通常用于将数值变量转换为因子（categorical）变量。

以下是一些使用 TidierData.jl 中 `cut` 函数进行离散化的示例：

### 1. 等宽离散化
假设你有一个连续变量 `age`，你想将其分为几个等宽的区间：

```julia
using TidierData

df = DataFrame(age = [22, 34, 45, 56, 78])

# 将年龄分为 18-35, 36-55, 56-75, 76+ 四个区间
df = @chain df begin
    @mutate(age_group = cut(age, [18, 35, 55, 75, Inf], 
                            labels = ["18-35", "36-55", "56-75", "76+"]))
end
```

### 2. 等频离散化
如果你想将数据分为包含大致相同数量数据点的区间，可以使用 `ntile` 函数：

```julia
using TidierData

df = DataFrame(age = [22, 34, 45, 56, 78])

# 将年龄分为四个等频区间
df = @chain df begin
    @mutate(age_group = ntile(age, 4))
end
```

### 3. 基于特定条件的离散化
你可以使用 `case_when` 函数来根据特定条件创建离散化分组：

```julia
using TidierData

df = DataFrame(age = [22, 34, 45, 56, 78])

df = @chain df begin
    @mutate(age_group = case_when(age < 30 => "Young",
                                   age < 50 => "Middle-aged",
                                   age >= 50 => "Senior"))
end
```

### 4. 使用分位数离散化
如果你想根据数据的分布将变量分为几个区间，可以使用分位数来定义区间：

```julia
using TidierData

df = DataFrame(income = [25000, 50000, 75000, 100000, 150000])

# 使用四分位数来离散化收入
quantiles = quantile(df.income, [0.25, 0.5, 0.75, 1.0])

df = @chain df begin
    @mutate(income_group = cut(income, quantiles, 
                               labels = ["Q1", "Q2", "Q3", "Q4"]))
end
```

这些方法提供了灵活的方式来离散化连续变量，可以根据具体的数据和分析需求选择合适的方法。在 TidierData.jl 中，这些操作可以通过链式调用（chaining）来实现，使得代码更加简洁和易于阅读。
"""

# ╔═╡ ddbbf55d-eff6-460b-8557-af46c524e24a
md"""
## **5. 数据合并**
- `@bind_rows`: 按行合并多个数据框。
- `@bind_cols`: 按列合并多个数据框。
- `@join` 系列宏（如 `@inner_join`, `@left_join`, `@right_join`, `@full_join`, `@anti_join`, `@semi_join`）: 执行不同类型的关联操作。

"""

# ╔═╡ 2db6dd47-520a-41bf-908d-e1ffb6674267
md"""
## 6. 数据处理
- `@drop_missing`: 删除包含缺失值的行。
- `@fill_missing`: 填充缺失值。
- `@replace_missing`: 替换缺失值。
- `@slice`: 根据行号选择、移除或复制行。
- `@slice_sample`: 随机抽样数据行。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
Tidier = "f0413319-3358-4bb0-8e7c-0c83523a93bd"

[compat]
PlutoTeachingTools = "~0.2.15"
PlutoUI = "~0.7.60"
StatsBase = "~0.34.3"
Tidier = "~1.4.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "994e293687f7c885691e10c232312bc53db3b1f6"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.AWS]]
deps = ["Base64", "Compat", "Dates", "Downloads", "GitHub", "HTTP", "IniFile", "JSON", "MbedTLS", "Mocking", "OrderedCollections", "Random", "SHA", "Sockets", "URIs", "UUIDs", "XMLDict"]
git-tree-sha1 = "319ade7f8fc88243369e119859a7d3a3e7e7f267"
uuid = "fbe9abb3-538b-5e4e-ba9e-bc94f4f92ebc"
version = "1.92.0"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "MacroTools", "Markdown", "Test"]
git-tree-sha1 = "f61b15be1d76846c0ce31d3fcfac5380ae53db6a"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.37"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"
    AccessorsUnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AdaptivePredicates]]
git-tree-sha1 = "7d5da5dd472490d048b081ca1bda4a7821b06456"
uuid = "35492f91-a3bd-45ad-95db-fcad7dcfedb7"
version = "1.1.1"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra"]
git-tree-sha1 = "0dd7edaff278e346eb0ca07a7e75c9438408a3ce"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.10.3"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Arrow]]
deps = ["ArrowTypes", "BitIntegers", "CodecLz4", "CodecZstd", "ConcurrentUtilities", "DataAPI", "Dates", "EnumX", "LoggingExtras", "Mmap", "PooledArrays", "SentinelArrays", "Tables", "TimeZones", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "f8d411d1b45459368567dc51f683ed78a919d795"
uuid = "69666777-d1a9-59fb-9406-91d4454c9d45"
version = "2.7.2"

[[deps.ArrowTypes]]
deps = ["Sockets", "UUIDs"]
git-tree-sha1 = "404265cd8128a2515a81d5eae16de90fdef05101"
uuid = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
version = "2.3.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "014bc22d6c400a7703c0f5dc1fdc302440cf88be"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.4"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.BangBang]]
deps = ["Accessors", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires"]
git-tree-sha1 = "e2144b631226d9eeab2d746ca8880b7ccff504ae"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.4.3"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTablesExt = "Tables"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitIntegers]]
deps = ["Random"]
git-tree-sha1 = "a55462dfddabc34bc97d3a7403a2ca2802179ae6"
uuid = "c3b6d118-76ef-56ca-8cc7-ebb389d030a1"
version = "0.3.1"

[[deps.BufferedStreams]]
git-tree-sha1 = "6863c5b7fc997eadcabdbaf6c5f201dc30032643"
uuid = "e1450e63-4bb3-523b-b2a4-4ffa8c0fd77d"
version = "1.2.2"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "7b6ad8c35f4bc3bca8eb78127c8b99719506a5fb"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.1.0"

[[deps.CairoMakie]]
deps = ["CRC32c", "Cairo", "Cairo_jll", "Colors", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools"]
git-tree-sha1 = "d3d4e823e2d7ccac4f1360beeea58597e93210a3"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.12.8"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a2f1c8c668c8e3cb4cca4e57a8efdb09067bb3fd"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+2"

[[deps.Cascadia]]
deps = ["AbstractTrees", "Gumbo"]
git-tree-sha1 = "c0769cbd930aea932c0912c4d2749c619a263fc1"
uuid = "54eefc05-d75b-58de-a785-1a3403f0919f"
version = "1.0.2"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "1568b28f91293458345dabba6a5ea3f183250a61"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.8"
weakdeps = ["JSON", "RecipesBase", "SentinelArrays", "StructTypes"]

    [deps.CategoricalArrays.extensions]
    CategoricalArraysJSONExt = "JSON"
    CategoricalArraysRecipesBaseExt = "RecipesBase"
    CategoricalArraysSentinelArraysExt = "SentinelArrays"
    CategoricalArraysStructTypesExt = "StructTypes"

[[deps.Chain]]
git-tree-sha1 = "9ae9be75ad8ad9d26395bf625dea9beac6d519f1"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.6.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "71acdbf594aab5bbb2cec89b208c41b4c411e49f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.24.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.Cleaner]]
deps = ["PrettyTables", "Tables", "Unicode"]
git-tree-sha1 = "664021fefeab755dccb11667cc96263ee6d7fdf6"
uuid = "caabdcdb-0ab6-47cf-9f62-08858e44f38f"
version = "1.1.1"

[[deps.ClickHouse]]
deps = ["CategoricalArrays", "CodecLz4", "DataFrames", "Dates", "DecFP", "ProgressMeter", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "8157605bfa30b90814079b7e5a6f4db559cfdf12"
uuid = "82f2e89e-b495-11e9-1d9d-fb40d7cf2130"
version = "0.2.3"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.CodecLz4]]
deps = ["Lz4_jll", "TranscodingStreams"]
git-tree-sha1 = "0db0c70ca94c0a79cadad269497f25ca88b9fa91"
uuid = "5ba52731-8f18-5e0d-9241-30f10d1ec561"
version = "0.4.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.CodecZstd]]
deps = ["TranscodingStreams", "Zstd_jll"]
git-tree-sha1 = "5e41a52bec3b0881a7eb54f5391b779994504186"
uuid = "6b39b394-51ab-5f42-8807-6242bab2b4c2"
version = "0.8.5"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "a33b7ced222c6165f624a3f2b55945fac5a598d9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.7"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DBInterface]]
git-tree-sha1 = "a444404b3f94deaa43ca2a58e18153a82695282b"
uuid = "a10d1c49-ce27-4219-8d33-6db1a4562965"
version = "2.6.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DecFP]]
deps = ["DecFP_jll", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "4a10cec664e26d9d63597daf9e62147e79d636e3"
uuid = "55939f99-70c6-5e9b-8bb0-5071ed7d61fd"
version = "1.3.2"

[[deps.DecFP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e9a8da19f847bbfed4076071f6fef8665a30d9e5"
uuid = "47200ebd-12ce-5be5-abb7-8e082af23329"
version = "2.0.3+1"

[[deps.Decimals]]
git-tree-sha1 = "e98abef36d02a0ec385d68cd7dadbce9b28cbd88"
uuid = "abce61dc-4473-55a0-ba07-351d65e31d42"
version = "0.4.1"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelaunayTriangulation]]
deps = ["AdaptivePredicates", "EnumX", "ExactPredicates", "Random"]
git-tree-sha1 = "b5f1c6532d2ea71e99b74231b0a3d53fba846ced"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "1.1.3"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "e6c693a0e4394f8fda0e51a5bdf5aef26f8235e9"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.111"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "AbstractTrees", "Base64", "CodecZlib", "Dates", "DocStringExtensions", "Downloads", "Git", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "MarkdownAST", "Pkg", "PrecompileTools", "REPL", "RegistryInstances", "SHA", "TOML", "Test", "Unicode"]
git-tree-sha1 = "9d29b99b6b2b6bc2382a4c8dbec6eb694f389853"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "1.6.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DuckDB]]
deps = ["DBInterface", "Dates", "DuckDB_jll", "FixedPointDecimals", "Tables", "UUIDs", "WeakRefStrings"]
git-tree-sha1 = "d638ab66b06b1b3501888fc944541d881e8ebeea"
uuid = "d2f5444f-75bc-4fdf-ac35-56f514c445e1"
version = "0.10.3"

[[deps.DuckDB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "542fca60b2916e59280bd5153c0d58886b1f8b37"
uuid = "2cbbab25-fc8b-58cf-88d4-687a02676033"
version = "0.10.3+0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExactPredicates]]
deps = ["IntervalArithmetic", "Random", "StaticArrays"]
git-tree-sha1 = "b3f2ff58735b5f024c392fde763f29b057e4b025"
uuid = "429591f6-91af-11e9-00e2-59fbe8cec110"
version = "2.2.8"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.Extents]]
git-tree-sha1 = "81023caa0021a41712685887db1fc03db26f41f5"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.4"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "380053d61bb9064d6aa4a9777413b40429c79901"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.2.0"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FNVHash]]
git-tree-sha1 = "d6de2c735a8bffce9bc481942dfa453cc815357e"
uuid = "5207ad80-27db-4d23-8732-fa0bd339ea89"
version = "0.1.0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePaths]]
deps = ["FilePathsBase", "MacroTools", "Reexport", "Requires"]
git-tree-sha1 = "919d9412dbf53a2e6fe74af62a73ceed0bce0629"
uuid = "8fc22ac5-c921-52a6-82fd-178b2807b824"
version = "0.8.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fd0002c0b5362d7eb952450ad5eb742443340d6e"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.12.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointDecimals]]
deps = ["BitIntegers", "Parsers"]
git-tree-sha1 = "187506ad3471ae4d5dc892095162e29a27f81681"
uuid = "fb4d412d-6eee-574d-9565-ede6634db7b0"
version = "0.5.3"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "2493cdfd0740015955a8e46de4ef28f49460d8bc"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.3"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "273bd1cd30768a2fddfa3fd63bbc746ed7249e5f"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.9.0"

[[deps.GZip]]
deps = ["Libdl", "Zlib_jll"]
git-tree-sha1 = "0085ccd5ec327c077ec5b91a5f937b759810ba62"
uuid = "92fee26a-97fe-5a0c-ad85-20a5f3185b63"
version = "0.6.2"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "9fff8990361d5127b770e3454488360443019bb3"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.5"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "b62f2b2d76cee0d61a2ef2b3118cd2a3215d3134"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.11"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Git]]
deps = ["Git_jll"]
git-tree-sha1 = "51764e6c2e84c37055e846c516e9015b4a291c7d"
uuid = "d7ba0133-e1db-5d97-8f8c-041e4b3a1eb2"
version = "1.3.0"

[[deps.GitHub]]
deps = ["Base64", "Dates", "HTTP", "JSON", "MbedTLS", "Sockets", "SodiumSeal", "URIs"]
git-tree-sha1 = "7ee730a8484d673a8ce21d8536acfe6494475994"
uuid = "bc5e4493-9b4d-5f90-b8aa-2b2bcaad7a26"
version = "5.9.0"

[[deps.Git_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "LibCURL_jll", "Libdl", "Libiconv_jll", "OpenSSL_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "d8be4aab0f4e043cc40984e9097417307cce4c03"
uuid = "f8c6e375-362e-5223-8a59-34ff63f689eb"
version = "2.36.1+2"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "7c82e6a6cd34e9d935e9aa4051b66c6ff3af59ba"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.2+0"

[[deps.GoogleCloud]]
deps = ["Base64", "Dates", "HTTP", "JSON", "Libz", "Markdown", "MbedTLS", "MsgPack", "Printf"]
git-tree-sha1 = "cf44f610884574b14f62e1533864f00170659325"
uuid = "55e21f81-8b0a-565e-b5ad-6816892a5ee7"
version = "0.11.0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Observables"]
git-tree-sha1 = "fc713f007cff99ff9e50accba6373624ddd33588"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.11.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.Gumbo]]
deps = ["AbstractTrees", "Gumbo_jll", "Libdl"]
git-tree-sha1 = "a1a138dfbf9df5bace489c7a9d5196d6afdfa140"
uuid = "708ec375-b3d6-5a57-a7ce-8257bf98657a"
version = "0.8.2"

[[deps.Gumbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "29070dee9df18d9565276d68a596854b1764aa38"
uuid = "528830af-5a63-567c-a44a-034ed33b8444"
version = "0.10.2+0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "401e4f3f30f43af2c8478fc008da50096ea5240f"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.3.1+0"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "7c4195be1649ae622304031ed46a2f4df989f1eb"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.24"

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

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "b2a7eaa169c13f5bcae8131a83bc30eff8f71be0"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.2"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Infinity]]
deps = ["Dates", "Random", "Requires"]
git-tree-sha1 = "cf8234411cbeb98676c173f930951ea29dca3b23"
uuid = "a303e19e-6eb4-11e9-3b09-cd9505f79100"
version = "0.2.4"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"
weakdeps = ["ArrowTypes", "Parsers"]

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14eb2b542e748570b56446f4c50fbfb2306ebc45"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IntervalArithmetic]]
deps = ["CRlibm_jll", "MacroTools", "RoundingEmulator"]
git-tree-sha1 = "433b0bb201cd76cb087b017e49244f10394ebe9c"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.22.14"

    [deps.IntervalArithmetic.extensions]
    IntervalArithmeticDiffRulesExt = "DiffRules"
    IntervalArithmeticForwardDiffExt = "ForwardDiff"
    IntervalArithmeticRecipesBaseExt = "RecipesBase"

    [deps.IntervalArithmetic.weakdeps]
    DiffRules = "b552c78f-8df3-52c6-915a-8e097449b14b"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "ac0aaa807ed5eaf13f67afe188ebc07e828ff640"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.10.0"

[[deps.InverseFunctions]]
git-tree-sha1 = "2787db24f4e03daf859c6509ff87764e4182f7d1"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.16"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "eb3edce0ed4fa32f75a0a11217433c31d56bd48b"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.14.0"
weakdeps = ["ArrowTypes"]

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "4b415b6cccb9ab61fec78a621572c82ac7fa5776"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.35"

[[deps.Kerberos_krb5_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "60274b4ab38e8d1248216fe6b6ace75ae09b0502"
uuid = "b39eb1a6-c29a-53d7-8c32-632cd16f18da"
version = "1.19.3+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "7d703202e65efa1369de1279c162b915e245eed1"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.9"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e16271d212accd09d52ee0ae98956b8a05c4b626"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "17.0.6+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Languages]]
deps = ["InteractiveUtils", "JSON", "RelocatableFolders"]
git-tree-sha1 = "0cf92ba8402f94c9f4db0ec156888ee8d299fcb8"
uuid = "8ef0a80b-9436-5d2c-a485-80b904378c43"
version = "0.4.6"

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

[[deps.LayerDicts]]
git-tree-sha1 = "6087ad3521d6278ebe5c27ae55e7bbb15ca312cb"
uuid = "6f188dcb-512c-564b-bc01-e0f76e72f166"
version = "1.0.0"

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "8f7f3cabab0fd1800699663533b6d5cb3fc0e612"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.2.2"

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "MatrixFactorizations", "SparseArrays"]
git-tree-sha1 = "35079a6a869eecace778bcda8641f9a54ca3a828"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "1.10.0"
weakdeps = ["StaticArrays"]

    [deps.LazyArrays.extensions]
    LazyArraysStaticArraysExt = "StaticArrays"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

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

[[deps.LibPQ]]
deps = ["CEnum", "DBInterface", "Dates", "Decimals", "DocStringExtensions", "FileWatching", "Infinity", "Intervals", "IterTools", "LayerDicts", "LibPQ_jll", "Libdl", "Memento", "OffsetArrays", "SQLStrings", "Tables", "TimeZones", "UTCDateTimes"]
git-tree-sha1 = "74feb1a63ebbcdcf1730016d2a4dfad0a655404f"
uuid = "194296ae-ab2e-5f79-8cd4-7183a0a5a0d1"
version = "1.17.1"

[[deps.LibPQ_jll]]
deps = ["Artifacts", "JLLWrappers", "Kerberos_krb5_jll", "Libdl", "OpenSSL_jll", "Pkg"]
git-tree-sha1 = "a299629703a93d8efcefccfc16b18ad9a073d131"
uuid = "08be9ffa-1c94-5ee5-a977-46a84ec9b350"
version = "14.3.0+1"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[deps.Libz]]
deps = ["BufferedStreams", "Random", "Test"]
git-tree-sha1 = "bf1510e80f1e0dba2297b05b59a3a7c8175a9517"
uuid = "2ec943e9-cfe8-584d-b93d-64dcb6d567b7"
version = "1.0.1"

[[deps.LightBSON]]
deps = ["DataStructures", "Dates", "DecFP", "FNVHash", "JSON3", "Sockets", "StructTypes", "Transducers", "UUIDs", "UnsafeArrays", "WeakRefStrings"]
git-tree-sha1 = "1c98cccebf21f97c5a0cc81ff8cebffd1e14fb0f"
uuid = "a4a7f996-b3a6-4de6-b9db-2fa5f350df41"
version = "0.2.20"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Loess]]
deps = ["Distances", "LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "a113a8be4c6d0c64e217b472fb6e61c760eb4022"
uuid = "4345ca2d-374a-55d4-8d30-97f9976e7612"
version = "0.6.3"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "1ce1834f9644a8f7c011eb0592b7fd6c42c90653"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.1"

[[deps.Lz4_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7f26c8fc5229e68484e0b3447312c98e16207d11"
uuid = "5ced341a-0733-55b8-9ab6-a4889d929147"
version = "1.10.0+0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "Dates", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FilePaths", "FixedPointNumbers", "Format", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Scratch", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun", "Unitful"]
git-tree-sha1 = "77d98de758529d79aa7e2d95812f3a5ebdb8db43"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.21.8"

[[deps.MakieCore]]
deps = ["ColorTypes", "GeometryBasics", "IntervalSets", "Observables"]
git-tree-sha1 = "b0e2e3473af351011e598f9219afb521121edd2b"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.8.6"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.MariaDB_Connector_C_jll]]
deps = ["Artifacts", "JLLWrappers", "LibCURL_jll", "Libdl", "Libiconv_jll", "OpenSSL_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "30523a011413b08ee38a6ed6a18e84c363d0ce79"
uuid = "aabc7e14-95f1-5e66-9f32-aea603782360"
version = "3.1.12+0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MarkdownAST]]
deps = ["AbstractTrees", "Markdown"]
git-tree-sha1 = "465a70f0fc7d443a00dcdc3267a497397b8a3899"
uuid = "d0879d2d-cac2-40c8-9cee-1863dc0c7391"
version = "0.1.2"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "e1641f32ae592e415e3dbae7f4a188b5316d4b62"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.6.1"

[[deps.MatrixFactorizations]]
deps = ["ArrayLayouts", "LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "6731e0574fa5ee21c02733e397beb133df90de35"
uuid = "a3b82374-2e81-5b9e-98ce-41277c0e4c87"
version = "2.2.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Memento]]
deps = ["Dates", "Distributed", "Requires", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "bb2e8f4d9f400f6e90d57b34860f6abdc51398e5"
uuid = "f28f55f0-a522-5efc-85c2-fe41dfb9b2d9"
version = "1.4.1"

[[deps.MicroCollections]]
deps = ["Accessors", "BangBang", "InitialValues"]
git-tree-sha1 = "44d32db644e84c75dab479f1bc15ee76a1a3618f"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.2.0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "2c140d60d7cb82badf06d8783800d0bcd1a7daa2"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.8.1"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "f5db02ae992c260e4826fe78c942954b48e1d9c2"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.2.1"

[[deps.MySQL]]
deps = ["DBInterface", "Dates", "DecFP", "Libdl", "MariaDB_Connector_C_jll", "Parsers", "Tables"]
git-tree-sha1 = "9b3bf27f7595454bf32013992cd18f3c9ce156f2"
uuid = "39abe10b-433b-5dbd-92d4-e302a9df00cd"
version = "1.4.6"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.ODBC]]
deps = ["DBInterface", "Dates", "DecFP", "Libdl", "Printf", "Random", "Scratch", "Tables", "UUIDs", "Unicode", "iODBC_jll", "unixODBC_jll"]
git-tree-sha1 = "7fe19bed38551e3169edaec8bb8673354d355681"
uuid = "be6f12e9-ca4f-5eb2-a339-a4f995cc0291"
version = "1.1.2"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "ec3edfe723df33528e085e632414499f26650501"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.5.0"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e127b609fb9ecba6f201ba7ab753d5a605d53801"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.54.1+0"

[[deps.Parquet2]]
deps = ["AbstractTrees", "BitIntegers", "CodecLz4", "CodecZlib", "CodecZstd", "DataAPI", "Dates", "DecFP", "FilePathsBase", "FillArrays", "JSON3", "LazyArrays", "LightBSON", "Mmap", "OrderedCollections", "PooledArrays", "PrecompileTools", "SentinelArrays", "Snappy", "StaticArrays", "TableOperations", "Tables", "Thrift2", "Transducers", "UUIDs", "WeakRefStrings"]
git-tree-sha1 = "58036936efa67e864e7fe640c6156add60f15e94"
uuid = "98572fba-bba0-415d-956f-fa77e587d26d"
version = "0.2.27"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

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

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "66b20dd35966a748321d3b2537c4584cf40387c7"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.PtrArrays]]
git-tree-sha1 = "f011fbb92c4d401059b2212c05c0601b70f8b759"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "e237232771fdafbae3db5c31275303e056afaa9f"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.10.1"

[[deps.RData]]
deps = ["CategoricalArrays", "CodecZlib", "DataAPI", "DataFrames", "Dates", "FileIO", "Requires", "TimeZones", "Unicode"]
git-tree-sha1 = "9a6220c8f59c38ddf6217638042ae6788973f617"
uuid = "df47a6cb-8c03-5eed-afd8-b6050d6c41da"
version = "1.0.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.ReadStatTables]]
deps = ["CEnum", "DataAPI", "Dates", "InlineStrings", "MappedArrays", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "ReadStat_jll", "SentinelArrays", "StructArrays", "Tables"]
git-tree-sha1 = "97140dfb54eabb5e99d13d1e09554d7456bb184c"
uuid = "52522f7a-9570-4e34-8ac6-c005c74d4b84"
version = "0.3.1"

[[deps.ReadStat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "28e990e90ca643e99f3ec0188089c1816e8b46f4"
uuid = "a4dc8951-f1cc-5499-9034-9ec1c3e64557"
version = "1.1.9+0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegistryInstances]]
deps = ["LazilyInitializedFields", "Pkg", "TOML", "Tar"]
git-tree-sha1 = "ffd19052caf598b8653b99404058fce14828be51"
uuid = "2792f1a3-b283-48e8-9a74-f99dce5104f3"
version = "0.1.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

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

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e60724fd3beea548353984dc61c943ecddb0e29a"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.3+0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "2803cab51702db743f3fda07dd1745aadfbf43bd"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.5.0"

[[deps.SQLStrings]]
git-tree-sha1 = "55de0530689832b1d3d43491ee6b67bd54d3323c"
uuid = "af517c2e-c243-48fa-aab8-efac3db270f5"
version = "0.1.0"

[[deps.SQLite]]
deps = ["DBInterface", "Random", "SQLite_jll", "Serialization", "Tables", "WeakRefStrings"]
git-tree-sha1 = "38b82dbc52b7db40bea182688c7a1103d06948a4"
uuid = "0aa819cd-b072-5ff4-a722-6bc24af294d9"
version = "1.6.1"

[[deps.SQLite_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "004fffbe2711abdc7263a980bbb1af9620781dd9"
uuid = "76ed43ae-9a5d-5a62-8c75-30186b810ce8"
version = "3.45.3+0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ff11acffdb082493657550959d4feb4b6149e73a"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.5"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "79123bc60c5507f035e6d1d9e563bb2971954ec8"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.4.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Snappy]]
deps = ["CEnum", "snappy_jll"]
git-tree-sha1 = "72bae53c0691f4b6fd259587dab8821ae0e025f6"
uuid = "59d4ed8c-697a-5b28-a4c7-fe95c22820f9"
version = "0.4.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SodiumSeal]]
deps = ["Base64", "Libdl", "libsodium_jll"]
git-tree-sha1 = "80cef67d2953e33935b41c6ab0a178b9987b1c99"
uuid = "2133526b-2bfb-4018-ac12-889fb3908a75"
version = "0.1.1"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsAPI", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "9022bcaa2fc1d484f1326eaa4db8db543ca8c66d"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.7.4"

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "b765e46ba27ecf6b44faf70df40c57aa3a547dcb"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.7"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TZJData]]
deps = ["Artifacts"]
git-tree-sha1 = "1607ad46cf8d642aa779a1d45af1c8620dbf6915"
uuid = "dc5dba14-91b3-4cab-a142-028a31da12f7"
version = "1.2.0+2024a"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Thrift2]]
deps = ["MacroTools", "OrderedCollections", "PrecompileTools"]
git-tree-sha1 = "9610f626cf80cf28468edb20ec2dc007f72aacfa"
uuid = "9be31aac-5446-47db-bfeb-416acd2e4415"
version = "0.2.1"

[[deps.Tidier]]
deps = ["Reexport", "TidierCats", "TidierDB", "TidierData", "TidierDates", "TidierFiles", "TidierPlots", "TidierStrings", "TidierText", "TidierVest"]
git-tree-sha1 = "23b118d06bb897dec5c972af0c39458799e8cb52"
uuid = "f0413319-3358-4bb0-8e7c-0c83523a93bd"
version = "1.4.0"

[[deps.TidierCats]]
deps = ["CategoricalArrays", "DataFrames", "Reexport", "Statistics"]
git-tree-sha1 = "bf7843c4477d1c3f9e430388f7ece546b9382bef"
uuid = "79ddc9fe-4dbf-4a56-a832-df41fb326d23"
version = "0.1.2"

[[deps.TidierDB]]
deps = ["AWS", "Arrow", "Chain", "ClickHouse", "DataFrames", "Documenter", "DuckDB", "GZip", "GoogleCloud", "HTTP", "JSON3", "LibPQ", "MacroTools", "MySQL", "ODBC", "Reexport", "SQLite"]
git-tree-sha1 = "b5a7711bc66d5a990418cd4e20603159976a7464"
uuid = "86993f9b-bbba-4084-97c5-ee15961ad48b"
version = "0.1.9"

[[deps.TidierData]]
deps = ["Chain", "Cleaner", "DataFrames", "MacroTools", "Reexport", "ShiftedArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "c8707f31337e168d0bb63f126315ad52694793c8"
uuid = "fe2206b3-d496-4ee9-a338-6a095c4ece80"
version = "0.15.2"

[[deps.TidierDates]]
deps = ["Dates", "Reexport", "TimeZones"]
git-tree-sha1 = "383fda08be2e455fa7f9d8c81485760e08bf3deb"
uuid = "20186a3f-b5d3-468e-823e-77aae96fe2d8"
version = "0.2.5"

[[deps.TidierFiles]]
deps = ["Arrow", "CSV", "DataFrames", "Dates", "Documenter", "HTTP", "Parquet2", "RData", "ReadStatTables", "Reexport", "XLSX"]
git-tree-sha1 = "dc001af877642561b6bf0366539b506ab0e8b811"
uuid = "8ae5e7a9-bdd3-4c93-9cc3-9df4d5d947db"
version = "0.1.4"

[[deps.TidierPlots]]
deps = ["CairoMakie", "CategoricalArrays", "ColorSchemes", "Colors", "DataFrames", "Dates", "Format", "GLM", "KernelDensity", "Loess", "Makie", "Reexport", "TidierData"]
git-tree-sha1 = "aa0b70fc6cbf5f5877e00d58977023bc704aa80c"
uuid = "337ecbd1-5042-4e2a-ae6f-ca776f97570a"
version = "0.7.8"

[[deps.TidierStrings]]
deps = ["StringEncodings"]
git-tree-sha1 = "04163119cd5d6897b70c187062d24cb32dcbce84"
uuid = "248e6834-d0f8-40ef-8fbb-8e711d883e9c"
version = "0.2.4"

[[deps.TidierText]]
deps = ["DataFrames", "Languages", "MacroTools", "Reexport", "StatsBase"]
git-tree-sha1 = "e2d33da7cb5c836dec5cdf1c1f6fb9d793c9184d"
uuid = "8f0b679f-44a1-4a38-8011-253e3a78fd39"
version = "0.1.1"

[[deps.TidierVest]]
deps = ["Cascadia", "DataFrames", "Gumbo", "HTTP"]
git-tree-sha1 = "4a3ccf757ea5884c725c6a77db93715910bb1d8f"
uuid = "969b988e-7aed-4820-b60d-bdec252047c4"
version = "0.4.4"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "bc7fd5c91041f44636b2c134041f7e5263ce58ae"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.0"

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "Mocking", "Printf", "Scratch", "TZJData", "Unicode", "p7zip_jll"]
git-tree-sha1 = "b92aebdd3555f3a7e3267cf17702033c2814ef48"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.18.0"
weakdeps = ["RecipesBase"]

    [deps.TimeZones.extensions]
    TimeZonesRecipesBaseExt = "RecipesBase"

[[deps.TranscodingStreams]]
git-tree-sha1 = "d73336d81cafdc277ff45558bb7eaa2b04a8e472"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.10"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Transducers]]
deps = ["Accessors", "Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "SplittablesBase", "Tables"]
git-tree-sha1 = "5215a069867476fc8e3469602006b9670e68da23"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.82"

    [deps.Transducers.extensions]
    TransducersBlockArraysExt = "BlockArrays"
    TransducersDataFramesExt = "DataFrames"
    TransducersLazyArraysExt = "LazyArrays"
    TransducersOnlineStatsBaseExt = "OnlineStatsBase"
    TransducersReferenceablesExt = "Referenceables"

    [deps.Transducers.weakdeps]
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    OnlineStatsBase = "925886fa-5bf2-5e8e-b522-a9147a512338"
    Referenceables = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UTCDateTimes]]
deps = ["Dates", "TimeZones"]
git-tree-sha1 = "4af3552bf0cf4a071bf3d14bd20023ea70f31b62"
uuid = "0f7cfa37-7abf-4834-b969-a8aa512401c2"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d95fe458f26209c66a187b1114df96fd70839efd"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.UnsafeArrays]]
git-tree-sha1 = "da0c9ca60d3371a4bc86b4e65c45db17086fb3ac"
uuid = "c4a57d5a-5b31-53a6-b365-19f8c011fbd6"
version = "1.0.6"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "319b05e790046f18f12b8eae542546518ef1a88f"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.10.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "1165b0443d0eca63ac1e32b8c0eb69ed2f4f8127"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.3+0"

[[deps.XMLDict]]
deps = ["EzXML", "IterTools", "OrderedCollections"]
git-tree-sha1 = "d9a3faf078210e477b291c79117676fca54da9dd"
uuid = "228000da-037f-5747-90a9-8195ccbf91a5"
version = "0.4.1"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "a54ee957f4c86b526460a720dbc882fa5edcbefc"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.41+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "bcd466676fef0878338c61e655629fa7bbc69d8e"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "f492b7fe1698e623024e873244f10d89c95c340a"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.10.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.iODBC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "785395fb370d696d98da91eddedbdde18d43b0e3"
uuid = "80337aba-e645-5151-a517-44b13a626b79"
version = "3.52.15+0"

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libsodium_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "848ab3d00fe39d6fbc2a8641048f8f272af1c51e"
uuid = "a9144af2-ca23-56d9-984f-0d03f7b5ccf8"
version = "1.0.20+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.snappy_jll]]
deps = ["Artifacts", "JLLWrappers", "LZO_jll", "Libdl", "Lz4_jll", "Zlib_jll"]
git-tree-sha1 = "8bc7ddafc0a7339b82a06c1dde849cd5039324d6"
uuid = "fe1e1685-f7be-5f59-ac9f-4ca204017dfd"
version = "1.2.0+0"

[[deps.unixODBC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg"]
git-tree-sha1 = "228f4299344710cf865b3659c51242ecd238c004"
uuid = "1841a5aa-d9e2-579c-8226-32ed2af93ab1"
version = "2.3.9+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
"""

# ╔═╡ Cell order:
# ╠═bff5f244-66de-11ef-1248-cf917f18d161
# ╠═d213aa7d-abff-4948-8ad8-52409716b1c7
# ╠═07a14ec5-db26-49b3-969b-665dbb000b00
# ╟─c78e130c-d018-4107-b967-f916c9165270
# ╠═fd1ab803-27b9-4bba-af52-5c60d0e1232f
# ╠═1ce45976-c9e9-41fe-b42b-05d85aa7e8bc
# ╟─25126385-adcf-4c83-8735-1d43e6896738
# ╠═713b2a77-0b70-4d85-9943-630fc9f59bdc
# ╠═adadce64-12df-4650-995a-5b0aa8bf8bb6
# ╠═e35d3e03-a8d6-425a-a126-b8981d5239f8
# ╠═3d6341ca-2543-44bf-a6cd-f26f7df00b7a
# ╠═ebb901f6-c15a-4d03-ba1f-0ce0a3bbd322
# ╠═9f056eef-64d9-4af7-86ae-bd18edfd7fd3
# ╠═159e86f0-9acf-4e1d-9bec-a62cc821c35f
# ╠═b6bfcf78-8465-42af-9f66-77394db9c922
# ╠═8f03fb46-e8c8-4584-b8cb-14c57d7e50d5
# ╟─24c0519e-9ec8-4f11-bdd7-34b7e47b58a3
# ╠═7fcc1672-3a18-4330-92bf-d76b1296a98b
# ╠═032ab34f-0553-4c7b-bb85-f190e7ec3d43
# ╟─e84759f7-7b85-4ed9-9e14-5c5c5d465dc4
# ╟─35e94f0e-312a-4c41-9db8-8a3a0aa768f0
# ╟─1d89963a-a7f1-4bcb-b802-4d4ca5c41116
# ╟─54c6998d-3ac7-4269-b90d-0f8c6bba2bf4
# ╟─023e6abb-2e96-4538-bc85-0b2102611bf2
# ╟─dc2cbb2d-3331-4e3b-8027-04d6e857d0c7
# ╟─f1ee32d8-9cc8-4463-945a-4d693c780c78
# ╟─fedae49a-1db0-438e-9c45-d944728f8c93
# ╟─25289d9b-79a9-4eff-af74-d6403e2de077
# ╠═21104cc9-19fd-409a-81b8-1e601a912913
# ╠═7012945e-be9b-48fa-acc3-23c387a31db8
# ╟─d01ac4f8-6903-41ff-bbc2-1210b588f16a
# ╠═bf8d9758-fb7f-46d3-8230-df362e9362e9
# ╟─75b22bfe-7f51-4e89-952b-dd88bcf17fc0
# ╟─ddbbf55d-eff6-460b-8557-af46c524e24a
# ╟─2db6dd47-520a-41bf-908d-e1ffb6674267
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
