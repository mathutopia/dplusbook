### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ bff5f244-66de-11ef-1248-cf917f18d161
using PlutoTeachingTools, PlutoUI, TidierFiles,TidierData

# ╔═╡ 07a14ec5-db26-49b3-969b-665dbb000b00
TableOfContents()

# ╔═╡ 055f8e68-b697-4c0f-af54-640a92e4ec7b
html"""
	<p style="font-weight:bold; font-size: 60px;text-align:center">
		Julia数据分析与挖掘
	</p>
	<div style="text-align:center">
		<p style="font-weight:bold; font-size: 35px; font-variant: small-caps; margin: 0px">
			数据分析简介，基于TidierData
		</p>
		<p style="font-size: 30px; font-variant: small-caps; margin: 0px">
			Weili Chen
		</p>
		<p style="font-size: 20px;">
			GDUFS
		</p>
	</div>
"""

# ╔═╡ fd1ab803-27b9-4bba-af52-5c60d0e1232f
train = read_csv("../data/trainbx.csv")

# ╔═╡ 713b2a77-0b70-4d85-9943-630fc9f59bdc
@chain train begin
@glimpse 
end

# ╔═╡ adadce64-12df-4650-995a-5b0aa8bf8bb6
names(train)

# ╔═╡ bf10eba6-ec5c-441e-9b09-e89c81bfe8b3
size(train)

# ╔═╡ d2be92cd-28cf-4846-b122-427ae1312708
md"""
这里介绍的TidierData， 是属于Tidier家族的一个数据处理的包， 这个家族是模仿R语言的tidyverse， 家族里还有很多相关的包。需要读者自己去了解。 请阅读[**官方文档**](https://tidierorg.github.io/Tidier.jl/dev/).
"""

# ╔═╡ 97e6a277-8968-438f-8b90-ffce9855a5cb
md"""
# 数据分析常见操作
## 0 数据分析**流**
数据分析常常是多个步骤，先后链接在一起的。 这写步骤当然可以用管道操作符链接到一起。不过， Julia中有一个非常漂亮的宏`@chain`。 `@chain` 是 Julia 语言中 `Chain.jl` 包提供的宏(Tidier.jl中重新导出， 所有可以直接使用。），它允许用户以一种比 Julia 原生管道操作符 `|>` 更为方便的语法来处理数据流。这个宏使得数据可以通过一系列转换表达式进行传递，同时保持代码的清晰和简洁。

### 基本用法

```julia
@chain df begin
  @drop_missing
  @filter(id>6)
  @group_by(group)
  @summarize(total_age = sum(age))
end
```


在这个例子中，`df` 是一个数据框（DataFrame），`@chain` 宏将 `df` 通过一系列 `TidierData.jl` 的函数调用进行处理：

1. `@drop_missing`：去除缺失值。
2. `@filter(:id => >(6), _)`：过滤出 `id` 大于 6 的行。
3. `@group_by(group)`：根据 `group` 列的值进行分组。
4. `@summarize(total_age = sum(age))`：对每个分组的 `age` 列求和，并将结果列命名为 `total_age`。

`@chain`的核心作用就是将后面的表达式拼在一起， begin...end包裹的多个表达式也不例外。然后将上一个表达式计算的结果，放进下一个表达式的第一个参数（所以，通常第一个表达式应该是用于提供数据的变量名）。 比如下面的两个代码是等价的。
```julia
@chain a b c d e f

@chain a begin
    b
    c
    d
end e f
```
这里只是这个宏的基本知识， 如果你想了解更多有趣的应用， 看一下 [**这个页面.**](https://github.com/jkrumbiegel/Chain.jl)
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

这些函数是TidierData.jl包中用于数据重塑的工具，允许用户通过指定的参数将数据集从一种格式转换到另一种格式，以适应不同的分析需求。


"""

# ╔═╡ 671245a6-05b4-43c9-b3c4-265470de1869
md"""
重塑数据也叫长宽格式转换。 下面稍微多解释一下。

对于一份表格型的数据， 如图所示， 我们可以将蓝色部分字段想象成y坐标， 绿色字段标题可以看成是一个是x坐标。这样， 表格中的所有数据（黄色部分）都可以由这两个坐标定义出来。 当我们做宽变长操作时， 相当于将每一个数据写成`(y,x， data)`的形式。

[![pivot.png](https://free2.yunpng.top/2024/09/09/66de762b1a94a.png)](https://free2.yunpng.top/2024/09/09/66de762b1a94a.png)

当我们需要一次性分析多个变量的时候， 宽变长很有用。
"""

# ╔═╡ 023e6abb-2e96-4538-bc85-0b2102611bf2
md"""
## **4 计算和转换列**
计算和转换列是数据处理中的关键步骤，在TidierData.jl中用于计算和转换列的函数是：`@mutate`和`@transmute`。@transmute： 用于更新和选择列，实际上是@select的别名。

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

# ╔═╡ 25289d9b-79a9-4eff-af74-d6403e2de077
md"""

## 5. **汇总和聚合**
数据的汇总（Summarization）和聚合（Aggregation）是指将大量数据中的信息进行简化和概括的过程，以便更容易地理解数据集中的关键信息和趋势。

假设有一个包含成千上万条电影记录的数据集，每条记录包含电影的名称、预算、票房收入、上映年份等信息。通过数据汇总和聚合，我们可以：
- **计算总票房**：对所有电影的票房收入进行求和。
- **平均预算**：计算所有电影的平均预算。
- **按年份分组**：将电影按上映年份分组，并计算每组的总票房和平均票房。

通过这些操作，我们可以快速了解电影行业的整体趋势，如哪些年份的电影票房表现最好，或者电影预算与票房收入之间的关系等。

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

# ╔═╡ 5c8ec974-8b6a-40bc-aa4e-534f6552a74c
md"""
### 统计函数汇总
#### 标准差函数
- **std**
  - **作用**：计算集合的样本标准差。
  - **计算公式**：$\text{std}(X) = \sqrt{\frac{\sum_{i=1}^{n} (x_i - \bar{x})^2}{n-1}}$
  - **例子**：`julia> std([1, 2, 3, 4, 5])` 返回样本标准差。

- **stdm**
  - **作用**：计算已知均数的集合的样本标准差。
  - **计算公式**：$\text{stdm}(X, \mu) = \sqrt{\frac{\sum_{i=1}^{n} (x_i - \mu)^2}{n-1}}$
  - **例子**：`julia> stdm([1, 2, 3, 4, 5], mean=3.0)` 返回样本标准差。

#### 方差函数
- **var**
  - **作用**：计算集合的样本方差。
  - **计算公式**：$\text{var}(X) = \frac{\sum_{i=1}^{n} (x_i - \bar{x})^2}{n-1}$
  - **例子**：`julia> var([1, 2, 3, 4, 5])` 返回样本方差。

- **varm**
  - **作用**：计算已知均数的集合的样本方差。
  - **计算公式**：$\text{varm}(X, \mu) = \frac{\sum_{i=1}^{n} (x_i - \mu)^2}{n-1}$
  - **例子**：`julia> varm([1, 2, 3, 4, 5], mean=3.0)` 返回样本方差。

#### 相关性函数
- **cor**
  - **作用**：计算Pearson相关系数或相关矩阵。
  - **计算公式**：$\text{cor}(X, Y) = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum_{i=1}^{n} (x_i - \bar{x})^2} \sqrt{\sum_{i=1}^{n} (y_i - \bar{y})^2}}$
  - **例子**：`julia> cor([1, 2, 3], [4, 5, 6])` 返回Pearson相关系数。

#### 协方差函数
- **cov**
  - **作用**：计算向量或矩阵的协方差。
  - **计算公式**：$\text{cov}(X, Y) = \frac{\sum_{i=1}^{n} (x_i - \bar{x})(y_i - \bar{y})}{n-1}$
  - **例子**：`julia> cov([1, 2, 3], [4, 5, 6])` 返回协方差。

#### 均值函数
- **mean**
  - **作用**：计算集合的均值。
  - **计算公式**：$\text{mean}(X) = \frac{\sum_{i=1}^{n} x_i}{n}$
  - **例子**：`julia> mean([1, 2, 3, 4, 5])` 返回均值。

#### 中位数函数
- **median**
  - **作用**：计算集合的中位数。
  - **计算公式**：$\text{median}(X) = \text{the middle value when X is ordered}$
  - **例子**：`julia> median([1, 2, 3, 4, 5])` 返回中位数。

#### 中位数计算函数（数值中间值）
- **middle**
  - **作用**：计算两个数或数组的中间值。
  - **计算公式**：$\text{middle}(x, y) = \frac{x + y}{2}$
  - **例子**：`julia> middle(1, 3)` 返回中间值2。

#### 分位数函数
- **quantile**
  - **作用**：计算集合的分位数。
  - **计算公式**：$\text{quantile}(X, p) = \text{the value such that p proportion of X is less than this value}$
  - **例子**：`julia> quantile([1, 2, 3, 4, 5], 0.5)` 返回中位数（0.5分位数）。

"""

# ╔═╡ f2dccd3c-8f9f-43cf-bd2e-cc2c56860d8c
md"""
### 其他统计函数
下面的函数主要来自于[StatsBase.jl](https://juliastats.org/StatsBase.jl/stable/)包。 想要使用的化需要`using StatsBase`   


下表列出了常见的统计量名称、作用和相应的Julia函数。这里对统计量作用的描述并非严谨的数学定义， 只是为了方便理解和记忆而粗略的给出， 严谨的定义请参考有关书籍。

|统计量名称| 作用 | Julia函数 |
|----|---|---|
|计数 |统计给定的区间中（默认为：min~max）某个值出现的次数  | countmap|
|众数 |出现次数最多的数 | mode|
|最大值|向量元素的最大值| maximum|
|最小值|向量元素的最小值| minimum|
|p-分位数|p%的观测的最小上界；使用最多的是四分位数（p=.25, .5, .75）|quantile|
|均值|平均值|mean|
|中值|近似0.5分位数|median|
|极值|计算极大值、极小值|extrema|
|方差|计算方差， 默认是修正的| var|
|标准差|标准差|std|
|偏度|统计数据分布偏斜方向和程度|skewness|
|峰度|分布的尖锐程度， 正态分布，峰度为0|kurtosis|
|截断|去掉最大、最小的部分值（基于截断后的数据做统计被称为截断统计或鲁棒统计）|trim|

"""

# ╔═╡ d01ac4f8-6903-41ff-bbc2-1210b588f16a
md"""
## **6. 数据转换**
### 数据类型转换

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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
TidierData = "fe2206b3-d496-4ee9-a338-6a095c4ece80"
TidierFiles = "8ae5e7a9-bdd3-4c93-9cc3-9df4d5d947db"

[compat]
PlutoTeachingTools = "~0.3.0"
PlutoUI = "~0.7.60"
TidierData = "~0.16.2"
TidierFiles = "~0.1.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "400886cee0ae4ea0244bc702b83478ccaa0a4908"

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
deps = ["CompositionsBase", "ConstructionBase", "InverseFunctions", "LinearAlgebra", "MacroTools", "Markdown"]
git-tree-sha1 = "b392ede862e506d451fc1616e79aa6f4c673dab8"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.38"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsDatesExt = "Dates"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"
    AccessorsTestExt = "Test"
    AccessorsUnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

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
git-tree-sha1 = "4ece4573f169d64b1508b0c8dd38c7919ae7a907"
uuid = "69666777-d1a9-59fb-9406-91d4454c9d45"
version = "2.7.3"

[[deps.ArrowTypes]]
deps = ["Sockets", "UUIDs"]
git-tree-sha1 = "404265cd8128a2515a81d5eae16de90fdef05101"
uuid = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
version = "2.3.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

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
git-tree-sha1 = "6158239ac409f960abbc232a9b24c00f5cce3108"
uuid = "c3b6d118-76ef-56ca-8cc7-ebb389d030a1"
version = "0.3.2"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "1568b28f91293458345dabba6a5ea3f183250a61"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.8"

    [deps.CategoricalArrays.extensions]
    CategoricalArraysJSONExt = "JSON"
    CategoricalArraysRecipesBaseExt = "RecipesBase"
    CategoricalArraysSentinelArraysExt = "SentinelArrays"
    CategoricalArraysStructTypesExt = "StructTypes"

    [deps.CategoricalArrays.weakdeps]
    JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    SentinelArrays = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
    StructTypes = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"

[[deps.Chain]]
git-tree-sha1 = "9ae9be75ad8ad9d26395bf625dea9beac6d519f1"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.6.0"

[[deps.Cleaner]]
deps = ["PrettyTables", "Tables", "Unicode"]
git-tree-sha1 = "664021fefeab755dccb11667cc96263ee6d7fdf6"
uuid = "caabdcdb-0ab6-47cf-9f62-08858e44f38f"
version = "1.1.1"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "7eee164f122511d3e4e1ebadb7956939ea7e1c77"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.6"

[[deps.CodecInflate64]]
deps = ["TranscodingStreams"]
git-tree-sha1 = "d981a6e8656b1e363a2731716f46851a2257deb7"
uuid = "6309b1aa-fc58-479c-8956-599a07234577"
version = "0.1.3"

[[deps.CodecLz4]]
deps = ["Lz4_jll", "TranscodingStreams"]
git-tree-sha1 = "0db0c70ca94c0a79cadad269497f25ca88b9fa91"
uuid = "5ba52731-8f18-5e0d-9241-30f10d1ec561"
version = "0.4.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "b8fe8546d52ca154ac556809e10c75e6e7430ac8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.5"

[[deps.CodecZstd]]
deps = ["TranscodingStreams", "Zstd_jll"]
git-tree-sha1 = "5e41a52bec3b0881a7eb54f5391b779994504186"
uuid = "6b39b394-51ab-5f42-8807-6242bab2b4c2"
version = "0.8.5"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

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
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

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

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "380053d61bb9064d6aa4a9777413b40429c79901"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.2.0"

[[deps.FNVHash]]
git-tree-sha1 = "d6de2c735a8bffce9bc481942dfa453cc815357e"
uuid = "5207ad80-27db-4d23-8732-fa0bd339ea89"
version = "0.1.0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

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
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

    [deps.FillArrays.weakdeps]
    PDMats = "90014a1f-27ba-587c-ab20-58faa44d9150"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

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

[[deps.InputBuffers]]
git-tree-sha1 = "d5c278bee2efd4fda62725a4a794d7e5f55e14f1"
uuid = "0c81fc1b-5583-44fc-8770-48be1e1cca08"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "2984284a8abcfcc4784d95a9e2ea4e352dd8ede7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.36"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

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

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "MatrixFactorizations", "SparseArrays"]
git-tree-sha1 = "35079a6a869eecace778bcda8641f9a54ca3a828"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "1.10.0"
weakdeps = ["StaticArrays"]

    [deps.LazyArrays.extensions]
    LazyArraysStaticArraysExt = "StaticArrays"

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

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.LightBSON]]
deps = ["DataStructures", "Dates", "DecFP", "FNVHash", "JSON3", "Sockets", "StructTypes", "Transducers", "UUIDs", "UnsafeArrays", "WeakRefStrings"]
git-tree-sha1 = "1c98cccebf21f97c5a0cc81ff8cebffd1e14fb0f"
uuid = "a4a7f996-b3a6-4de6-b9db-2fa5f350df41"
version = "0.2.20"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

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
git-tree-sha1 = "c2b5e92eaf5101404a58ce9c6083d595472361d6"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "3.0.2"

[[deps.Lz4_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7f26c8fc5229e68484e0b3447312c98e16207d11"
uuid = "5ced341a-0733-55b8-9ab6-a4889d929147"
version = "1.10.0+0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

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
git-tree-sha1 = "a028ee3cb5641cccc4c24e90c36b0a4f7707bdf5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

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
deps = ["Downloads", "HypertextLiteral", "Latexify", "Markdown", "PlutoLinks", "PlutoUI"]
git-tree-sha1 = "e2593782a6b53dc5176058d27e20387a0576a59e"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.3.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

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

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Snappy]]
deps = ["CEnum", "snappy_jll"]
git-tree-sha1 = "098adf970792fd9404788f4558e94958473f7d57"
uuid = "59d4ed8c-697a-5b28-a4c7-fe95c22820f9"
version = "0.4.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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
git-tree-sha1 = "159331b30e94d7b11379037feeb9b690950cace8"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.11.0"

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
git-tree-sha1 = "36b40607bf2bf856828690e097e1c799623b0602"
uuid = "dc5dba14-91b3-4cab-a142-028a31da12f7"
version = "1.3.0+2024b"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Thrift2]]
deps = ["MacroTools", "OrderedCollections", "PrecompileTools"]
git-tree-sha1 = "9610f626cf80cf28468edb20ec2dc007f72aacfa"
uuid = "9be31aac-5446-47db-bfeb-416acd2e4415"
version = "0.2.1"

[[deps.TidierData]]
deps = ["Chain", "Cleaner", "DataFrames", "MacroTools", "Reexport", "ShiftedArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "2649cad958374080016511376e647c15942825dc"
uuid = "fe2206b3-d496-4ee9-a338-6a095c4ece80"
version = "0.16.2"

[[deps.TidierFiles]]
deps = ["Arrow", "CSV", "DataFrames", "Dates", "HTTP", "Parquet2", "RData", "ReadStatTables", "Reexport", "XLSX"]
git-tree-sha1 = "aba95360310134ac54a3fc478457926d81f03927"
uuid = "8ae5e7a9-bdd3-4c93-9cc3-9df4d5d947db"
version = "0.1.5"

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "Mocking", "Printf", "Scratch", "TZJData", "Unicode", "p7zip_jll"]
git-tree-sha1 = "8323074bc977aa85cf5ad71099a83ac75b0ac107"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.18.1"

    [deps.TimeZones.extensions]
    TimeZonesRecipesBaseExt = "RecipesBase"

    [deps.TimeZones.weakdeps]
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.TranscodingStreams]]
git-tree-sha1 = "96612ac5365777520c3c5396314c8cf7408f436a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.1"
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

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnsafeArrays]]
git-tree-sha1 = "da0c9ca60d3371a4bc86b4e65c45db17086fb3ac"
uuid = "c4a57d5a-5b31-53a6-b365-19f8c011fbd6"
version = "1.0.6"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipArchives", "ZipFile"]
git-tree-sha1 = "1c36015573a833883f5a352af446bc461d8af2fa"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.10.3"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "1165b0443d0eca63ac1e32b8c0eb69ed2f4f8127"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.3+0"

[[deps.ZipArchives]]
deps = ["ArgCheck", "CodecInflate64", "CodecZlib", "InputBuffers", "PrecompileTools", "TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "c77707ebf7aad0caa57ad7b561b4f89b0caefc73"
uuid = "49080126-0e18-4c2a-b176-c102e4b3760c"
version = "2.3.0"

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

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.snappy_jll]]
deps = ["Artifacts", "JLLWrappers", "LZO_jll", "Libdl", "Lz4_jll", "Zlib_jll"]
git-tree-sha1 = "8bc7ddafc0a7339b82a06c1dde849cd5039324d6"
uuid = "fe1e1685-f7be-5f59-ac9f-4ca204017dfd"
version = "1.2.0+0"
"""

# ╔═╡ Cell order:
# ╠═bff5f244-66de-11ef-1248-cf917f18d161
# ╠═07a14ec5-db26-49b3-969b-665dbb000b00
# ╟─055f8e68-b697-4c0f-af54-640a92e4ec7b
# ╠═fd1ab803-27b9-4bba-af52-5c60d0e1232f
# ╠═713b2a77-0b70-4d85-9943-630fc9f59bdc
# ╠═adadce64-12df-4650-995a-5b0aa8bf8bb6
# ╠═bf10eba6-ec5c-441e-9b09-e89c81bfe8b3
# ╟─d2be92cd-28cf-4846-b122-427ae1312708
# ╟─97e6a277-8968-438f-8b90-ffce9855a5cb
# ╟─24c0519e-9ec8-4f11-bdd7-34b7e47b58a3
# ╠═7fcc1672-3a18-4330-92bf-d76b1296a98b
# ╠═032ab34f-0553-4c7b-bb85-f190e7ec3d43
# ╟─e84759f7-7b85-4ed9-9e14-5c5c5d465dc4
# ╟─35e94f0e-312a-4c41-9db8-8a3a0aa768f0
# ╟─1d89963a-a7f1-4bcb-b802-4d4ca5c41116
# ╟─54c6998d-3ac7-4269-b90d-0f8c6bba2bf4
# ╟─671245a6-05b4-43c9-b3c4-265470de1869
# ╟─023e6abb-2e96-4538-bc85-0b2102611bf2
# ╟─dc2cbb2d-3331-4e3b-8027-04d6e857d0c7
# ╟─f1ee32d8-9cc8-4463-945a-4d693c780c78
# ╟─25289d9b-79a9-4eff-af74-d6403e2de077
# ╟─5c8ec974-8b6a-40bc-aa4e-534f6552a74c
# ╟─f2dccd3c-8f9f-43cf-bd2e-cc2c56860d8c
# ╟─d01ac4f8-6903-41ff-bbc2-1210b588f16a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
