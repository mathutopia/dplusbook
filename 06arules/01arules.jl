### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 349bbd34-b34e-46c3-8c47-8bb415d497c8
using PlutoUI, ARules

# ╔═╡ 552abfd5-a12c-46a4-8754-bf6c38e465bf
PlutoUI.TableOfContents(title = "目录", depth = 3, aside = true)

# ╔═╡ 00488270-759d-11ec-12fe-cb07b9231320
md"""
# 关联规则
**学习目标**
1. 理解关联规则的相关概念和挖掘算法的基本思想。
2. 会利用工具包相关数据进行关联规则挖掘。
3. 能对不同领域的问题， 通过恰当的方式， 将其转换为关联规则挖掘的问题， 并通过编码实现挖掘。

"""

# ╔═╡ 31884ab1-54ad-4dce-8a4f-64679b91f988
md"""
## 核心概念😊
以购物篮分析为例， 一个用户结账的时候， 数据库中会为顾客的这一次购买生成一个唯一的事务ID（tid）， 这个事务相应字段会包含顾客这次购买的所有商品(Item)。 比如下表是一个典型购物数据库， 目前该数据库中共有N = 10 条事务记录，编号（T1~T10）。

|交易号(TID) | 顾客购买的商品(Items)| 交易号(TID) | 顾客购买的商品(Items)|
|---|---|---|---|
|T1| bread, cream, milk, tea| T6|bread, cream, tea|
|T2|bread, cream, milk 		| T7| bread, milk, tea|
|T3| cake, milk             | T8| beer, cream, tea|
|T4| milk, tea              | T9| bread, milk, tea|
|T5| bread, cake, milk      | T10| beer, milk, tea|

下面列出几个相关的概念：
- **数据项**： 客户购买的某一种商品， 比如面包（bread）， 用小写字母t表示， $t_i$表示第i种商品。
- **k-项集**： 包含k个数据项的集合， 比如2-项集合{bread, cream}。
- **事务**： 数据库中的一条记录， 通常对应一个数据项的集合。 比如事务T1对应的数据项集合为4-项集{bread, cream, milk, tea}。 用大写字母T表示。
- **支持度计数**：一个项集的支持度计数是指整个事务数据集中包含该项集的事务数。 设项集X， 其支持度计数表示为 $$\sigma (X) = |\{t_i|X \subseteq t_i, t_i \in T\}|$$。 注：一个项集如果出现在某个事务中， 则认为该事务“支持”这个项集， 支持度计数就是统计有多少个事务支持这个项集。
- **规则 `A => B`**: 表示项集A和B之间存在某种关系， 比如 `{bread, milk} => {tea}`， 有时候为了方便， 我会省略规则两边的大括号。 注意： 这里**要求项集A和B是不相交的**。
- **支持度（support）**： 规则`A=>B`的支持度是指同时包含项集A和B的事务的比例。 即：
$$support(A, B) = P(A \cup B) = \sigma(A \cup B)/N$$
其中，N表示数据库中记录条数， $\sigma(A \cup B)$ 表示包含项A和B的事务在数据库中出现的次数。
- **频繁项集**： 一个项集出现的比例超过指定的阈值（min_sup）， 则称该项集为频繁项集。
- **置信度**： 一条关联规则A => B的置信度是指项集A出现的情况下， 项集B出现的概率。 数据库中， 同时出现项集A、B的事务占出现项集A的事务的比例。 可以条件概率表示如下：
$$confidence(A, B) = P(B|A) = \sigma(A \cup B)/\sigma(A)$$

**例1**
计算上表给出的数据库中， 规则`bread, milk => tea`的支持度和置信度。

**解：** 由表格可知， 事务总量N=10， 2-项集{bread, milk}的支持度计数是5（事务T1， T2, T5， T7， T9都包含了该2-项集）， 3-项集{bread, milk, tea}的支持度计数是3(事务T1, T7， T9都包含了该3-项集)。
故，support(`bread, milk => tea`) = 3/10 = 0.3;   
confidence(`bread, milk => tea`) = 3/5 = 0.6

**注意:**
在例1中， A = {bread, milk}， B = {tea}， 我们发现： $A\cup B$的支持度计数必然小于A的支持度计数， 这是因为包含项集A和B的事务是必然会包含项集A的， 这可以直接得到下面的性质：

- 性质（1）： 频繁项集的任何子集都是频繁项集。
- 性质（2）： 非频繁项集的超集都是非频繁项集。

性质（1）是显然的， 性质（2）可以看成性质（1）的逆否命题。

"""

# ╔═╡ afb12a01-61bc-4f9d-909c-34b7572d19c1
md"""
## 问题定义
关联规则挖掘的目标是寻找满足下面条件的所有规则 `A => B`

$$support(A, B) \geq min\_sup$$
$$confidence(A, B) \geq min\_cof$$

由于支持度和置信度的计算都包含了一个项集的支持度计数的计算。 因而， 关联规则挖掘的一个核心问题， 是寻找频繁项集。

寻找频繁项集的第一步是要构造出一个项集， 然后去判断其是否频繁。 
1. 构造项集。 假定总共有N中商品， 我们可以构造项集包括1-项集（$C_N^1$种）， 2-项集（$C_N^2$种），..., N-项集（$C_N^N$种），总共有（$C_N^1 + C_N^2 + \cdots + C_N^N = 2^N-1$）种可能的项集。
2. 判断是否频繁。 判断一个项集是否频繁只需要首先计算其支持度计数， 再与给定的阈值去比较一下即可。 而计算支持度计数， 只需要扫描一遍数据库， 看看每条事务是否有包含给定的项集。


通过上面这种方法去寻找频繁项集的方式就是穷举法（蛮力法）。 
"""

# ╔═╡ ad289256-4d6b-4776-9315-799daa3962ed
md"""
txs变量存储的是例题1中使用的数据集。 下面的存储方式对人类是友好的， 我们可以方便的看到每一个事务包含的项。 但对我们的问题来说， 这种方式不适合计算。 因此， 购物篮数据一般都转换为二元0/1表示。 也就是， 我们用一个长度等于商品类别总量的向量去表示一个事务。向量的元素只能是0/1， 0表示对应的商品不在该事务中， 而1表示对应的商品在该事务中。

以例题1为例， 这个数据库共有6种商品， 分别为 "beer", "bread", "cake", "cream", "milk", "tea", 假定我们保持这种商品名的排序， 我们就可以用一个长度为6的向量表示一个事务， 比如： `[0, 1, 0, 0, 1, 0]`，就表示由cake和milk组成的一个事务。 由于向量的元素仅仅是0/1， 只需要一个bit就可以表示一个元素了。因此， 我们可以使用比特向量BitVector来表示以节省空间。 

接下来， 假定我们有了一个购物篮数据， 用代码演示如何将其转换为方便计算的形式。 首先， 我们需要求出商品品种总量， 即

**问题1**： 计算数据库中有多少种商品

这个很简单， 我们只需要将所有的事务合并在一起， 然后去重， 统计数量就可以了。
"""

# ╔═╡ 63a1a20c-4649-453f-be3e-9406f8196301
txs = [[ "bread", "cream", "milk", "tea"],  ["bread", "cream", "tea"],
 ["bread", "cream", "milk"] ,		 [ "bread", "milk", "tea"],
 [ "cake", "milk"]  ,            [ "beer", "cream", "tea"],
 [ "milk", "tea" ] ,             [ "bread", "milk", "tea"],
 [ "bread", "cake", "milk" ] ,     [ "beer", "milk", "tea"]]

# ╔═╡ f617f0ce-9a8a-43ab-8ba2-5ad6418785da
typeof(txs)

# ╔═╡ 45b245c4-0065-42ee-a494-be666d1a2318
frequent(txs, 2,6)

# ╔═╡ 042a3783-2fc0-4d86-a1f7-4a2c9aeb9f6d
function unique_items(transactions) 
	# 注意， 我们并没有真的去遍历整个事务数据库transactions， 然后合并，去重； 而是利用字典这种数据结构的键不能重复的特点， 遍历的时候通过将商品名称做成key， 遍历完之后， 取出所有的key就可以了。 这个字典的value是Bool值， 已经是最省空间的类型了。 这个算法的平均时间复杂度是O(T*M）, T是事务总数， M是事务的平均长度。 
    dict = Dict{String, Bool}()

    for t in transactions
        for i in t 
            dict[i] = true
        end
    end
    uniq_items = collect(keys(dict))
	# 注意我们将返回结果排序了
    return sort(uniq_items)
end

# ╔═╡ 2c97e2fc-7314-46fe-be49-62e50c7095a5
# 接下来调用我们定义的函数， 就可以返回唯一商品向量， 用length可以求得商品总量
uniq_items = unique_items(txs)

# ╔═╡ 8be4c165-6b96-4063-9df4-f488886050d9
md"""
当我们知道所有的项时， 为其编号就是非常简单的事情了。 比如， 我们可以将其编号为1：length(项目总数)。比如，我们可以将上面求出的唯一项集编号为 ["beer","bread","cake","cream","milk","tea"] = [1,2,3,4,5,6], 这样， 一个项集[2,3]就表示项集["bread","cake"]。这种表示方式已经比原始的用项名称表示要简单了， 但仍存在两个问题： 

1. 每个事务的宽度是不一样的， 多个事务放一起时不方便比较（比如要计算两个事务是否包含相同的项时就比较麻烦）； 
2. 这种表示方法还有点浪费空间。

为了解决第一个问题， 我们可以用一个同样长度的向量表示每一个事务， 然后用向量中元素是否为1表示对应位置的商品是否在该事务中。 比如我们可以用向量[0, 1, 1, 0, 0, 0, 0]，表示包含第2、3号商品的一个事务。 事务的这种表示方法称为0/1表示法。 由于我们表示的信息仅仅某个位置对应的项是否存在， 我们只需要一个比特位就可以了。因此， 我们可以用比特向量(BitVector)来表示一个事务。（注意： 如果我们的商品品种非常多， 比如上百万， 那这种表示方法也会浪费很多空间， 这时候可能需要考虑使用系数矩阵、向量去表示了。）接下来， 我们将事务集转换为一种更加紧凑的写法， 即把事务数据集表示为一个比特矩阵， 矩阵的每一行代表一个事务， 每一列代表某种商品， [i,j]元素是true或false, true表示对应的商品(列）， 出现在某个事务（i）中： 

"""

# ╔═╡ c869cefe-70ce-4e36-aeb2-5c2867ade31b
function occurrence(transactions::Array{Array{S, 1}, 1}, uniq_items::Array{S, 1}) where S
    n = length(transactions) # 事务总数
    p = length(uniq_items) # 商品总数

    itm_pos = Dict(zip(uniq_items, 1:p)) # 用一个字典来表示一个商品（key）应该在哪个位置(value)
    res = falses(n, p) # 初始化一个n*p的比特矩阵（全部初始化为false）
    for i = 1:n
        for itm in transactions[i] # 求出第i个事务中每一个商品的位置j
            j = itm_pos[itm] 
            res[i, j] = true # 并在比特矩阵的对应位置设为true
        end
    end
    res 
end

# ╔═╡ 273076e2-9e04-465a-bc3c-d23e14b7743b
# 下面调用这个函数看一下结果
occ = occurrence(txs, uniq_items)

# ╔═╡ 20be9aa9-53c5-4b2e-abfd-43e126da052f
# 我们可以方便的获得每个事务的比特向量表示， 以及对应的商品
occ[1, :], uniq_items[occ[1, :]]

# ╔═╡ f356eed1-4638-4bf5-b195-d897d6c4b395
md"""
有了这个矩阵， 我们可以方便的计算每一个商品出现的次数， 对行求和可以得到每个事务的商品总量， 对列求和可以得到相应商品在各个事务中出现的次数， 相当于单个商品的支持度计数。
"""

# ╔═╡ 8c1ca817-9c48-4f41-9d46-4857e5545f1e
# 对第一个维度求和， 就是按列求和
sum(occ, dims = 1)

# ╔═╡ 223658d2-c7c7-4964-8b62-5e50e0246f40
md"""
**问题2：** 如何计算2项集的支持度计数呢？

注意到， occ矩阵的每一行表示一个事务， 而每一列表示的是一个对应商品在各个事务中出现的比特向量。 比如occ[:, 1]表示第1个商品（beer）在每一个事务中出现的比特矩阵， 其中occ[i, 1] = true表示第1个商品出现在第i个事务中。 如果两个商品同时出现在某个事务中， 那么它们的事务向量对应位置都为true， 这样， 我们可以对两个事务向量的对应位置做按位与（&）运算， 就可以从结果是否为true中判断这两个商品是否同时出现在某个事务中。 对结果向量求和就可以得到2项集的支持度计数了。

依此 类推， 如果要计算k项集的支持度计数， 那就应该是对应的k个向量做按位与操作， 再对结果向量求和。
"""

# ╔═╡ f2ea8ffa-2201-4a39-8ea0-1b41caf96001
# 1项集的支持度计数
sum(occ, dims = 1)

# ╔═╡ 2d8e2ba8-ca09-4096-9ac9-e0fb1e412189
# 二项集{beer， bread}的支持度计数, 为0
occ[:, 1] .& occ[:, 2], sum(occ[:, 1] .& occ[:, 2])

# ╔═╡ 94f5ac44-6755-42db-b619-ea880cde6e29
md"""
从上面可以看出，计算一个k项集的支持度计数是非常容易的， 那怎么不重复不遗漏的列出所有的k项集呢？如果我们将所有项的顺序固定（不妨假定共有n项：$t_1, t_2, \cdots, t_n$， 且（$t_1 < t_2 < \cdots < t_n$））， 那我们总是可以按照这个顺序去产生项集。 

要产生所有的1项集， 我们只需要列出所有的项即可。 

要产生2项集， 我们可以先确定第一个位置的项（前缀）， 再确定第二个位置的项。 在确定第一个位置的项之后， 第二个位置的项必须要大于第一个位置的项。 因此， 我们可以把2项集分为n-1类， 他们的前缀（第一个位置的项）分别为$t_1, t_2, \cdots, t_{n-1}$。 例如其中的第k类应该为：${t_kt_{k+1}, t_kt_{k+2}, \cdots,t_kt_n}$

类似的，对k项集， 我们可以将其按照第一个位置的元素分为n-k+1种情况，即第一项分别为$t_1， t_2， ...， t_{n- k + 1}$。 确定了第一项， 第2至k项就变成了一个(k-1)-项集的构造问题。 此时， 假定构造的第一项为$t_i$, 那么后面的(k-1)-项只能是从$t_{i+1}, \cdots, t_{n}$中选取(k-1)项， 然后将其与第一项拼接就好了。

以5个项{A, B, C, D, E}产生所有2项集为例： 他们应该是{{A，B}， {A,C}， {A，D}， {A，E} |  {B，C}, {B,D},{B,E} | {C,D}, {C,E} | {D, E}}

据此， 我们可以写出产生频繁项集的递归算法。
"""

# ╔═╡ c31df9f6-8c11-4c26-b7e0-e775d2db0e58
# 用递归算法实现对items集合中 k个元素的组合的枚举
function kitem(items, k) 
	if  k == 1
		return items
	else        
        ret = String[]
		for  i in 1:(length(items) - k + 1)
			tmp = map(x -> join([items[i], x], '-'), kitem(items[(i+1):end], k-1))
            push!(ret, tmp...)
		end
        return ret
	end
end


# ╔═╡ 87206bbf-9b30-4cfd-866c-43c263e68fc8

kitem(['A', 'B', 'C', 'D', 'E'], 3)

# ╔═╡ 90c2f01d-0089-4b85-8b3f-649f54c1c205
kitem([1,2,3,4,5], 3)

# ╔═╡ 37d26bf2-129c-48e2-923e-48fe50a7b159
md"""
完成了上面的工作， 计算频繁项集就简单了，下面给出其大致伪代码。

```
for k = 1:n 
	枚举所有的k项集
	挑出满足阈值的k项集	
end
```
虽然这种方式可以获得频繁项集， 但当数据量大时， 这种方法是明显低效的。 事实上， 我们做了大量的不必要计算。由前面的性质可知， 一个项集如果是非频繁的， 那么其所有的超集都是非频繁的， 因此， 我们在枚举项集的时候， 如果发现有非频繁的项集，那以这个项集为前缀的任何其他项集都不需要再去枚举和计算支持度计数， 因为他们肯定不频繁。 比如， 我们发现项集{beer， bread}支持度为0， 显然是非频繁的。 那么所有包含{beer， bread}的项集都是非频繁的， 从而也就无需再去构造了。 一般的， 如果一个k项集$t_{i1},t_{i2},\cdots,t_{ik}$是非频繁的， 那么由这个项集作为前k项（前缀）构造的任何t-项集（$t>k$）都是非频繁的。这样， 在计算支持度计数的时候， 我们不再需要生成以这个项集为前缀的其他项集，也无需去计算对应的支持度计数。 这个方式就叫剪枝。

利用了这一性质的频繁项集挖掘算法， 被称为Apriori算法。 算法的大致流程是：
1. k =1， 计算频繁1-项集
2. 以频繁1-项集里的每一个项为前缀， 按照顺序构造2-项集。 评估构造的每一个2项集是否频繁。留下所有频繁项，形成频繁2项集。
3. 以频繁2项集为前缀， 构造所有3项集，并挑选频繁项形成频繁3项集。 以此类推。
注：上面的每一次构造k项集之后，都要挑出频繁k项集， 非频繁项直接丢弃了。 这样可以保证， 我们不会以非频繁项集为前缀去构造新的项集。

有兴趣的同学可以按照上面的思路去实现频繁项集的构造函数。

下面，调用ARules包中的`frequent`函数去实现频繁项集的计算。该函数调用方式如下： 
```
frequent(transactions::Vector{Vector{S}}, minsupp::T, maxdepth) where {T <: Real, S}
```
其中， transactions是用向量的向量表示的所有项集，  minsupp表示支持度阈值， maxdepth表示支持的最大的项集宽度。项集的类型是S， S可以代表任何类型，而支持度的类型是实数的子类型都行（T <: Real）
"""

# ╔═╡ 7b74ee8c-9c57-4301-bf83-0fe477889740
frequent(txs, 2, 3)

# ╔═╡ 45cf84c8-269b-4428-aca5-ef84c9c2fcc5
txss = [["A","B"],
["A","C","D","E"],
["B","C","D","F"],
["A","B","C","D"],
["A","B","C","F"]]

# ╔═╡ bed78f58-123c-4603-98ec-4a03eb56f6eb
frequent(txss, 2, 4)

# ╔═╡ 086c55e1-24b6-4550-8fbc-413d6dba2ffc
frequent(txss, 1,4)

# ╔═╡ 2a2277ac-80c6-42ea-a4b7-93b2ea96167f
md"""
## 产生关联规则
一旦产生了频繁项集， 接下来就可以去产生关联规则了。 一个n-项集， 我们可以将其中任意k个作为前件(A)，剩下的部分作为后件（B），形成一个规则`A=>B`。 根据组合数原理， 不考虑，前件和后件为空的情况， 总共有$2^n - 2$个可能的规则。 对每一个规则， 我们可以通过一定的标准（比如置信度）， 去筛选复合要求的强规则。 由于置信度的计算只涉及支持度， 而支持度计数已经在前文求解了， 因此， 实现强关联规则的产生就不难了。

由于候选的规则是项集的指数规模， 类似于频繁项集的发现， 我们需要有更好的算法去实现强关联规则的筛选。 


性质（3） 如果规则$A => B-A$不满足置信度阈值， 则形如$A' => B-A'$的规则也一定不满足置信度阈值， 其中$A'$是$A$的子集。

**证：** 考虑规则$A => B-A$和$A' => B-A'$， 其中$A'$是$A$的子集。这两个规则的置信度分别为$\sigma(B) /\sigma(A) $ 和 $\sigma(B) /\sigma(A') $, 因为 $A'$ 是 $A$ 的子集， g故$\sigma(A) \geq \sigma(A')$。 因此前一个规则的置信度不可能大于后一个规则。

基于这个性质设计的
"""

# ╔═╡ 01151e96-a6e9-4c69-be96-e4d7267f4b4a
md"""
## 一些总结
1. 支持度是项集在数据库中出现的频率， 需要有一定的支持度才是我们该关注的对象。支持度比较低， 那就变成小概率事件了。 
2. 置信度可以看成是原因（前件）和结果（后件）之间的关系强度， 这个需要大一点， 以表示比较强的关联规则。置信度的特点是： 将一个项集划分为原因和结果， 那么较少的原因导致较多的结果的置信度要不会超过较多的原因导致较少的结果。
3. 提升度是原因（前件）和结果（后件）的相关性度量。 有了前件之后， 结果的概率是不是比结果单纯出现的概率要高。 或者说， 对结果的预测， 引入原因是不是会提升概率？ 

"""

# ╔═╡ d5491db6-b4b9-486a-82a6-332a024f1682
md"""
## 问题拓展
一条规则`A=>B`， 如果是强关联的， 意味着这条规则出现的概率较大。 如果我们把A看成是“原因”， B看成是“结果”(请注意，这是不严谨的看法)， 那么， 关联规则的挖掘就意味着找到一些值得关注的“因果”联系， 虽然找到的不见得是直接的因果。 带着这种想法， 我们可以将关联规则的挖掘应用到很多场景， 比如， 股票市场中， 是否存在一些股票的价格变化会强关联到另一些股票价格的变化？ 如果我们能找到这种规则， 那么就可以利用这个规则去做量化投资了。

**思考：**
1. 如果利用关联规则挖掘去分析股票市场的价格变化结构？
2. 如果利用关联规则挖掘去分析用户的交易行为？（如果有相关数据）
"""

# ╔═╡ 88ee3c83-c007-4352-a886-defa8795390c
md"""
## ARules 包使用
下面是事务集，总共包含9条事务（记录）。
"""

# ╔═╡ 1ec65a13-fb2d-4fa3-9b22-1877914f8532
transactions = [["milk", "eggs", "bread"],
                       ["butter", "milk", "sugar", "flour", "eggs"],
                       ["bacon", "eggs", "milk", "beer"],
                       ["bread", "ham", "turkey"],
                       ["cheese", "ham", "bread", "ketchup"],
                       ["mustard", "hot dogs", "buns", "hamburger", "cheese", "beer"],
                       ["milk", "sugar", "eggs"],
                       ["hamburger", "ketchup", "milk", "beer"],
                       ["ham", "cheese", "bacon", "eggs"]]

# ╔═╡ efbe2002-8695-4624-9a51-cc61ac040969
frequent(transactions, 2, 6)

# ╔═╡ 61566b83-d96f-4ba7-b687-3ab4eff82b27
md"""
apriori(transactions; supp = 0.01, conf = 0.8, maxlen = 5)
"""

# ╔═╡ dc7ce647-23e4-415c-ac9a-c5f5fa8a65d0
# 
apriori(transactions, supp = 0.1)

# ╔═╡ cabf5ade-2b27-4ed9-bafb-aa68d65668dd
lines = readlines("data/groceries - groceries.csv")

# ╔═╡ 319728c6-a180-4069-931c-88f7dd474d03
Txs= 
Vector{Vector{String}}() 

# ╔═╡ 58555c13-769d-4631-9605-8d589d15f217
for line in lines
	if startswith(line, "Item(s)")
		continue
	end
	tmp = split(line,",")
	nitem = parse(Int, tmp[1])
	items = tmp[2:(nitem + 1)]
	push!(Txs, items)
end

# ╔═╡ 757208cd-8da6-468b-b901-d9778af7b8d8
Txs

# ╔═╡ bd83bbef-0aab-45ec-923d-e2cc5cdb0123
frequent(Txs, 0.05, 6)

# ╔═╡ 3bbde0f5-0247-4cac-a46f-df9f7fd9b21a
apriori(Txs, supp = 0.001)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ARules = "7cbe2057-1070-5a1a-9a20-8e476bfa53e1"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ARules = "~0.0.2"
PlutoUI = "~0.7.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "8a65192f95bd219284de03d33808953081fd42ef"

[[deps.ARules]]
deps = ["DataFrames", "StatsBase"]
git-tree-sha1 = "28d08a275d00e869550a41d4859b5fcbe1f2b7b6"
uuid = "7cbe2057-1070-5a1a-9a20-8e476bfa53e1"
version = "0.0.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "JSON", "Missings", "Printf", "Statistics", "StructTypes", "Unicode"]
git-tree-sha1 = "2ac27f59196a68070e132b25713f9a5bbc5fa0d2"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.8.3"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "6c0100a8cf4ed66f66e2039af7cde3357814bad2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.46.2"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["CategoricalArrays", "Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "Missings", "PooledArrays", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ecd850f3d2b815431104252575e7307256121548"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "0.21.8"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

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

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

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

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f8c673ccc215eb50fcadb285f522420e29e69e1c"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "0.4.5"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "Logging", "Markdown", "Random", "Suppressor"]
git-tree-sha1 = "45ce174d36d3931cd4e37a47f93e07d1455f038d"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.1"

[[deps.PooledArrays]]
deps = ["DataAPI"]
git-tree-sha1 = "b1333d4eced1826e15adbdf01a4ecaccca9d353c"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "0.5.3"

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
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
deps = ["Pkg"]
git-tree-sha1 = "7b1d07f411bc8ddb7977ec7f377b97b158514fe0"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "0.2.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "f6cb12bae7c2ecff6c4986f28defff8741747a9b"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "0.3.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "ca4bccb03acf9faaf4137a9abc1881ed1841aa70"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.Suppressor]]
deps = ["Logging"]
git-tree-sha1 = "6cd9e4a207964c07bf6395beff7a1e8f21d0f3b2"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

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
# ╠═552abfd5-a12c-46a4-8754-bf6c38e465bf
# ╟─00488270-759d-11ec-12fe-cb07b9231320
# ╠═349bbd34-b34e-46c3-8c47-8bb415d497c8
# ╟─31884ab1-54ad-4dce-8a4f-64679b91f988
# ╟─afb12a01-61bc-4f9d-909c-34b7572d19c1
# ╟─ad289256-4d6b-4776-9315-799daa3962ed
# ╠═63a1a20c-4649-453f-be3e-9406f8196301
# ╠═f617f0ce-9a8a-43ab-8ba2-5ad6418785da
# ╠═45b245c4-0065-42ee-a494-be666d1a2318
# ╠═042a3783-2fc0-4d86-a1f7-4a2c9aeb9f6d
# ╠═2c97e2fc-7314-46fe-be49-62e50c7095a5
# ╟─8be4c165-6b96-4063-9df4-f488886050d9
# ╠═c869cefe-70ce-4e36-aeb2-5c2867ade31b
# ╠═273076e2-9e04-465a-bc3c-d23e14b7743b
# ╠═20be9aa9-53c5-4b2e-abfd-43e126da052f
# ╠═f356eed1-4638-4bf5-b195-d897d6c4b395
# ╠═8c1ca817-9c48-4f41-9d46-4857e5545f1e
# ╟─223658d2-c7c7-4964-8b62-5e50e0246f40
# ╠═f2ea8ffa-2201-4a39-8ea0-1b41caf96001
# ╠═2d8e2ba8-ca09-4096-9ac9-e0fb1e412189
# ╟─94f5ac44-6755-42db-b619-ea880cde6e29
# ╠═c31df9f6-8c11-4c26-b7e0-e775d2db0e58
# ╠═87206bbf-9b30-4cfd-866c-43c263e68fc8
# ╠═90c2f01d-0089-4b85-8b3f-649f54c1c205
# ╟─37d26bf2-129c-48e2-923e-48fe50a7b159
# ╠═7b74ee8c-9c57-4301-bf83-0fe477889740
# ╠═45cf84c8-269b-4428-aca5-ef84c9c2fcc5
# ╠═bed78f58-123c-4603-98ec-4a03eb56f6eb
# ╠═086c55e1-24b6-4550-8fbc-413d6dba2ffc
# ╟─2a2277ac-80c6-42ea-a4b7-93b2ea96167f
# ╠═01151e96-a6e9-4c69-be96-e4d7267f4b4a
# ╟─d5491db6-b4b9-486a-82a6-332a024f1682
# ╠═88ee3c83-c007-4352-a886-defa8795390c
# ╟─1ec65a13-fb2d-4fa3-9b22-1877914f8532
# ╠═efbe2002-8695-4624-9a51-cc61ac040969
# ╠═61566b83-d96f-4ba7-b687-3ab4eff82b27
# ╠═dc7ce647-23e4-415c-ac9a-c5f5fa8a65d0
# ╠═cabf5ade-2b27-4ed9-bafb-aa68d65668dd
# ╠═319728c6-a180-4069-931c-88f7dd474d03
# ╠═58555c13-769d-4631-9605-8d589d15f217
# ╠═757208cd-8da6-468b-b901-d9778af7b8d8
# ╠═bd83bbef-0aab-45ec-923d-e2cc5cdb0123
# ╠═3bbde0f5-0247-4cac-a46f-df9f7fd9b21a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
