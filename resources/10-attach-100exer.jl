### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 978e2cbe-84ce-11ed-0f1a-d53b3452c01a
using PlutoUI

# ╔═╡ 41273e55-9e4a-4167-97cd-de4c288cd330
using StatsBase

# ╔═╡ f56a8f78-2404-4bee-aac6-20661b2acf39
using LinearAlgebra

# ╔═╡ 9f4e5407-ff00-4685-98c5-02ec4374e4dd
using Dates

# ╔═╡ 2a25e16d-bf1c-4adb-a579-a2536e56ede2
TableOfContents(title = "目录")

# ╔═╡ 0800820d-7231-4b9e-8f34-939652305fde
md"""
[原文](https://github.com/RoyiAvital/Julia100Exercises)
"""

# ╔═╡ 2e4cfe1f-5d4a-4d94-b45c-cc64d07b7e8a
md"""
## 问题001 
用名称LA导入LinearAlgebra包
"""

# ╔═╡ 6449dbe9-d94f-4982-be5d-9c6bb061a58d
import LinearAlgebra as LA

# ╔═╡ 6aeacc12-9b52-4722-a774-bf217b787e22
md"""
## 问题002
打印julia的版本信息
"""

# ╔═╡ ce8aa6e5-d2ca-439a-ae05-e8f37c613979
println(VERSION)

# ╔═╡ 6bbe72f3-73ac-4d8b-9337-d0f1814cc8ec
md"""
## 问题003
创建一个大小为10的Float64的未初始化向量
"""

# ╔═╡ 66adef56-1e7e-410a-836e-1b54f81a9897
va = Vector{Float64}(undef, 10)

# ╔═╡ bc1adec9-95e9-4dca-aa2c-4f9049a15fde
# 也可以用通用的构造方法
Array{Float64, 1}(undef, 10)

# ╔═╡ 910e2ca5-93f1-4e1c-8a19-c5ed64b300dd
md"""
## 问题004
求任意数组的内存大小
"""

# ╔═╡ f5b83488-2b24-4895-8b1b-9067a551cae4
sizeof(va)

# ╔═╡ 44c0ae91-23f5-4d28-9882-e56d9990e706
md"""
## 问题005
显示+ (Add)方法的文档
"""

# ╔═╡ 92ceef05-91a7-486b-856d-4e0b8075e5c4
@doc +

# ╔═╡ 134b4f1d-e6d1-468a-a758-02dfd3d9748d
md"""
## 问题006
创建一个大小为10的零向量，但第五个值为1
"""

# ╔═╡ c0f87299-a9f1-4ce0-9bfd-f3d6b1ee222e
begin
a = zeros(10)
a[5] = 1
a
end

# ╔═╡ 991bec68-a83c-4d0a-a587-88b5a48becce
md"""
## 问题007
创建一个值为7到12的向量
"""

# ╔═╡ 64cc5663-0fbb-4081-b054-8e101615a607
7:12

# ╔═╡ 1210be65-e60b-4bb0-9674-6e7b554f5ff7
md"""
上面是一种向量的高效表示， 如果要明确的构造出向量，可以collect
"""

# ╔═╡ 8503e4ba-0b28-42a4-be13-510eb9cfa96a
collect(7:12)

# ╔═╡ 8717c2e9-c31c-41ce-8a00-70133f947da0
md"""
## 问题008
反转一个向量(第一个元素变成最后一个元素)
"""

# ╔═╡ 044450fb-2f4b-42ac-9c19-25f4a4cf6bba
begin
vA = collect(1:3);
vB = vA[end:-1:1];
vB
end

# ╔═╡ fc706483-8c18-4681-9f4a-60d87cd64661
reverse(vA)

# ╔═╡ 7928d82d-dd74-4119-934c-8001fb9d42dc
reverse!(vA)

# ╔═╡ 7e28976f-52e5-4b53-a1a4-76120f1a1168
md"""
## 问题009
创建一个3x3矩阵，值从0到8
"""

# ╔═╡ 4f1be356-e1c2-46ef-a2da-7752c10c05c9
reshape(0:8, 3,3)

# ╔═╡ 3bcab68e-dc7a-4637-9179-5faaaaca87b2
begin
mA = Matrix{Float64}(undef, 3, 3);
mA[:] = 0:8;
mA
end

# ╔═╡ f83ef7bb-c754-4745-a5bd-254efe299456
md"""
## 问题010
从[1,2,0,0,4,0]中寻找非零元素的索引
"""

# ╔═╡ 5bc0f846-e309-4fc0-8d6e-ebb4f6b9f88d
begin
t = [1,2,0,0,4,0]
findall(!iszero, t)
end

# ╔═╡ 4bcd248f-bd85-41b0-93d6-daf0032cf4fd
md"""
## 问题011
创建一个3x3单位矩阵
"""

# ╔═╡ 1c4df179-e349-419c-969d-8ca0a90e7c49
LA.I(3)

# ╔═╡ 8369a383-60a9-491c-955c-f8e86ea132b7
 Matrix(LA.I, 3, 3)

# ╔═╡ 28db1229-fbf1-4f48-8b78-a7620d923f46
md"""
## 问题012
创建一个随机值的2x2x2数组
"""

# ╔═╡ f05905f4-7b39-4a25-9fcb-efb189e6859a
randn(2,2,2)

# ╔═╡ 86506685-8ebb-4335-ad34-9714736a4678
md"""
## 问题013
创建一个随机值的5x5数组，并找到最小值和最大值
"""

# ╔═╡ 6c134710-4887-486a-ae4d-3969d8772f0a
a13 = rand(5,5)

# ╔═╡ a71c83db-a0d8-444a-ab40-ba0496cf40da
maximum(a13)

# ╔═╡ 21a19762-2e23-4ed0-a5f9-52ae74c0214f
minimum(a13)

# ╔═╡ e1fd18e2-9116-431f-9332-915481ce1f18
extrema(a13)

# ╔═╡ 17161d93-d114-40c0-a265-5213bddf0d0a
md"""
## 问题14
创建一个大小为30的随机向量，并找到平均值
"""

# ╔═╡ 0c7f5204-55e6-4994-ab86-6741a44e6112
mean(randn(30))


# ╔═╡ 4e3bbb6a-ce86-4e1a-a24b-fa30140770e9
md"""
## 问题15
创建一个2d数组，边界为1，内部为0
"""

# ╔═╡ 47214202-f582-400e-8190-80911aa6844e
m15 = zeros(4,4)

# ╔═╡ 245dae59-2d08-4b18-a4c2-96894728a3b4
m15[1,1:end] = m15[4,1:end] = m15[1:end,1] = m15[end,1:end] .= 1

# ╔═╡ 71c5d060-49ad-4095-950f-a342d0011fe3
m15

# ╔═╡ 9540d221-d9a4-4837-8f1a-3d65b08bdf68
md"""
## 问题16
在数组周围添加一个零边框
"""

# ╔═╡ 3dd25267-39ab-428e-9131-c89564a375c6
mB = zeros(size(mA) .+ 2)

# ╔═╡ 5d981825-98f9-40fd-b4fe-83bf1424e122
mB[2:(end - 1), 2:(end - 1)] = mA;

# ╔═╡ 5eb89f20-b37a-4954-8ca0-4515a1d47123
mB

# ╔═╡ b41e115f-7da8-4a8b-83e4-c4f217b6c455
md"""
## 问题18 
创建一个5x5矩阵，在对角线下方值为[1,2,3,4]
"""

# ╔═╡ 8c699a78-cd82-49f7-9719-8459fbe9ac57
zeros(5,5)

# ╔═╡ 2d1f9656-19c9-4fec-b265-d8ec43f93c5c
diagm(-1 => 1:4)

# ╔═╡ 32927332-5a99-425a-a24a-a4d32386c5d1
md"""
## 问题19
创建一个8x8的矩阵，并填充一个棋盘图案
"""

# ╔═╡ 0280a384-c6d7-4b52-b6a7-6a11a4dc2fc8
m19 = zeros(8,8)

# ╔═╡ 49829e90-a16e-470b-8ed7-b7e37e369fe5
	begin
	m19[1:2:end, 2:2:end] .= 1;
    m19[2:2:end, 1:2:end] .= 1;
	end

# ╔═╡ 8f235e6e-c22b-42f8-a832-be87f5269be4
m19

# ╔═╡ 9b1cf0c5-61a0-4173-b84d-29232b661335
Int[isodd(ii + jj) for ii in 1:8, jj in 1:8]

# ╔═╡ 31c015b8-be1e-4874-a5a3-ff79626aaca7
md"""
## 问题020
将线性索引100转换为大小为(6,7,8)的笛卡尔索引
"""

# ╔═╡ ce10d722-48ea-4fcf-9e87-e3e6a4b4b70a
m20 = rand(6, 7, 8);


# ╔═╡ ddf45fa1-6e97-4988-b899-4e1c4d417310
cartIdx = CartesianIndices(m20)[100] #<! See https://discourse.julialang.org/t/14666


# ╔═╡ 5dac8c4a-0eef-4b2d-9026-f3fd5c93784c
m20[cartIdx] == m20[100]

# ╔═╡ 9afb6b99-cf55-49b4-bd18-a27cc574f90a
md"""
## 问题021
使用repeat()函数创建一个8x8的棋盘式矩阵
"""

# ╔═╡ acbb3da2-886d-4b91-a1a3-227287eb5b72
repeat([0 1; 1 0], 4,4)

# ╔═╡ b77071f7-002f-4023-81f2-0480bf4ca847
md"""
## 问题022
规范化一个4x4随机矩阵
"""

# ╔═╡ 67d49c90-b341-43be-9bb5-b2760c280eb5
m22 = rand(4,4)

# ╔═╡ dd981392-9a19-4844-86cc-fee767eb89e1
 m22 .= (m22 .- mean(m22)) ./ std(m22)

# ╔═╡ a0e86116-b2fb-4b2c-8921-2c4ce172c9be
md"""
## 问题023
创建一个自定义类型，将颜色描述为四个无符号字节(RGBA). (★☆☆)
"""

# ╔═╡ 9511505e-b505-482b-bb8f-63a380a799ec
struct sColor
    R::UInt8;
    G::UInt8;
    B::UInt8;
    A::UInt8;
end

# ╔═╡ 452918f8-524d-4b07-9758-fb20f1df04a9
sMyColor = sColor(rand(UInt8, 4)...)

# ╔═╡ d3320afc-d76a-458b-8bab-38059767d520
md"""
## 问题024
用一个2x4矩阵乘以一个4x3矩阵。
"""

# ╔═╡ f3283376-c4d9-4e9a-81cf-ae464b31ef1c
rand(2,4) * rand(4,3)

# ╔═╡ 932e1846-c895-4acf-a117-5d8eec25689f
md"""
## 问题025
给定一个一维数组，对所有在3到8之间的元素求反。
"""

# ╔═╡ 9e7c9f4d-8c6d-4603-9bdb-949aef1e9674
v25 = rand(1:10, 8)

# ╔═╡ 29b180ac-fdbe-43ac-b0b5-e9c8dbe4cce7
map!(x -> 3 <x< 8 ? -x : x, v25, v25)

# ╔═╡ 6aa42e8e-2a5d-4dde-bf1e-e7f17888a46e
md"""
## 问题026
将1:4的数组与初始值-10相加
"""

# ╔═╡ 21d7faf1-76be-43b0-9bf2-36404f8cde34
sum(1:4,init=-10)

# ╔═╡ f8f42707-e1b8-4234-9d0f-cde0e665e4be
md"""
## 问题027
考虑一个整数向量vZ验证以下表达式
```julia
vZ .^ vZ
2 << vZ >> 2
vZ <- vZ
1im * vZ
vZ / 1 / 1
vZ < Z > Z
```
"""

# ╔═╡ 8ba3debf-f563-4861-93e2-c8870426e5e2
vZ = rand(1:10,4)

# ╔═╡ 607b3fa1-3e22-40a7-bf60-82c5dc18db5e
vZ .^ vZ

# ╔═╡ 0abb993b-1a99-47a4-a73e-88eb0c517f2d
try
    2 << vZ >> 2
catch e
    println(e)
end

# ╔═╡ 11003c3b-2582-4568-82bc-e4d4179c8701
vZ <- vZ

# ╔═╡ b929f1ce-0f8a-4b84-a52f-96aea71b91e7
vZ / 1 / 1

# ╔═╡ 8d914cb9-a447-4765-b0ff-96513cc748ac
md"""
## 问题028
计算以下表达式
[0] ./ [0]
"""

# ╔═╡ e1a9ba85-7f13-4622-8705-6ba77c1a57d8
[0] ./ [0]

# ╔═╡ d0c12f21-0955-4bd5-bb8f-b62048ad77e4
try [0] .÷ [0]
catch e
println(e)
end

# ╔═╡ 7af862aa-0e38-457e-a5ed-e3599a56500f
md"""
## 问题029
浮点数组从远离零的方向取整.
"""

# ╔═╡ 6350455c-b93e-43ed-b29d-f694e28bb412
v29 = randn(10)

# ╔═╡ 9a3b1127-faac-4616-96ad-2ddf1abdedba
map(x -> x >0 ? ceil(x) : floor(x), v29)

# ╔═╡ a41ab657-2aba-4dd2-96f2-5ab0245bedc2
md"""
## 问题030
找到两个数组之间的公共值。
"""

# ╔═╡ 85f621da-5904-4485-a432-7eefae058b2c
begin
v30 = rand(1:10, 6)
v31 = rand(1:10, 6)
end

# ╔═╡ 8cef4053-6c60-4c93-9936-255621b29677
intersect(v30, v31)

# ╔═╡ 05e46197-b154-480e-aa2f-c32553804c28
md"""
## 问题031
抑制julia的警告信息。
"""

# ╔═╡ 8bc86396-2f2d-4a6a-a53a-f2fc077f7e86


# ╔═╡ ba6d4145-c054-4b81-953f-45d5547e44af
md"""
## 问题032
对比 sqrt(-1) 和 sqrt(-1 + 0im)
"""

# ╔═╡ 654739c4-df11-43fb-8d4c-c614a3784f9b
try 
	sqrt(-1)
catch e
	println(e)
end

# ╔═╡ 63362a17-bffb-42a5-b086-0e1f20f7dd6f
try 
	sqrt(-1 + 0im)
catch e
	println(e)
end

# ╔═╡ 8588ef64-221f-4b70-b5a7-7a86bef79492
md"""
## 问题033
显示昨天、今天和明天的日期
"""

# ╔═╡ a3a88d35-22eb-455b-8273-fd96f5637bf8
today() - Day(1), today(), today() + Day(1)

# ╔═╡ 184e15ab-bbe7-4c87-a95f-ca802978db41
md"""
## 问题034
显示与2016年7月对应的所有日期。
"""

# ╔═╡ 00be179c-212c-447f-a756-5d2e698403b1
collect(Date(2016,7,1):Day(1):Date(2016,7,31))

# ╔═╡ dc5892d9-03be-4ce7-850e-a125b464f621
md"""
## 问题035
计算((mA + mB) * (-mA / 2))
"""

# ╔═╡ 5fc62092-6e0c-4ad6-94f7-603863a3f42a
begin
ma = rand(2,2)
mb = rand(2,2)
ma .= ((ma .+ mb) .* (-ma ./ 2))
end

# ╔═╡ ee44acd2-4ed9-4a17-9d40-a33f2d1bd5d2
md"""
## 问题36
使用4种不同的方法提取一个随机正数数组的整数部分。
"""

# ╔═╡ 9ebd49e0-4542-4dc7-b4f0-7c13b6532a16
m36 = 5 * rand(3, 3)

# ╔═╡ e2094f43-e554-4ff4-8e79-23817368d4a9
floor.(m36)

# ╔═╡ a4853f16-1acf-4fb7-b3b8-27edce245f2a
round.(m36 .- 0.5)

# ╔═╡ 7c683de7-8937-4337-a45a-ec4e88b808ab
m36 .÷ 1

# ╔═╡ b4e583e9-c7b2-456b-94bb-2fa55f88219e
m36 .- rem.(m36, 1)

# ╔═╡ e07ddd70-8b6f-4bda-af27-2a768769c797
md"""
## 问题037
创建一个5x5矩阵，行值范围为0到4
"""

# ╔═╡ aab45e9b-549a-45ac-a784-ddbdb079f9d5
reshape(repeat(0:4, 5),5,5)'

# ╔═╡ 4f509ee7-583f-46fb-b5f0-4257fffd0786
repeat(reshape(0:4, 1,5),5,1)

# ╔═╡ dd00921f-f796-4331-aa1a-109554580485
md"""
## 问题038
使用包含10个数字的生成器生成一个数组
"""

# ╔═╡ ed7e692c-3974-49ff-9e63-4a263b927f5c
[x for x in 1:10]

# ╔═╡ 050f7f18-be3d-4226-9859-bbe7e91c5ef3
md"""
## 问题039
创建一个大小为10的向量，值范围为0到1，两者都不包含
"""

# ╔═╡ c50f3e50-80b1-4833-b4aa-5328ed73f5b2
collect(range(0,1,length=12)[2:11])

# ╔═╡ 7af28335-e891-4731-9cd7-441bffd2beac
LinRange(0,1,12)[2:11]

# ╔═╡ ce98ac48-efc9-457f-ad17-f550ab6ec82c
md"""
## 问题040
创建一个大小为10的随机向量并对其排序
"""

# ╔═╡ 02764f62-86b6-404c-b928-4ba3e4604cf0
v40 = rand(1:10, 10)

# ╔═╡ d3b4edfe-cc10-4130-8f6d-9c09ad90c9b2
sort(v40)

# ╔═╡ b262fa18-aacd-4288-82fb-01f4e9232a73
md"""
## 问题041
手动实现sum()函数
"""

# ╔═╡ d97940ee-46a0-4c2d-aafb-46af7b83b480
function mysum(vec::Vector{T}) where {T <: Number}
	sumval = vec[1]
	for i in 2:length(vec)
		sumval += vec[i]
	end
	return sumval
end

# ╔═╡ 6e5c3eab-2563-400a-9ff4-4934c3178ee6
tmp = rand(1:10, 10)

# ╔═╡ a2b79e5a-3370-487b-91e7-e4e6df126de4
mysum(tmp)

# ╔═╡ 9c36dae1-680c-4599-b098-3049a848c8e8
mysum(collect(1:10))

# ╔═╡ d7c17f80-53f5-4849-9fd3-e4ba35720b8d
md"""
## 问题042
检查2个数组是否相等
"""

# ╔═╡ c1656587-c9f8-493d-b2ba-b9c7c8f28a3d
begin
v1 = rand(10)
v2 = rand(10)
end

# ╔═╡ eed2b757-b85a-40fe-860b-84c8d83a7e76
all(v1 .== v2)

# ╔═╡ 303475e5-a702-4402-b16d-7fa4116c7427
md"""
## 问题043
创建不可变数组(只读)。
"""

# ╔═╡ 36e16737-30f6-414d-bbe1-4187d63fe479
md"""
## 问题044
考虑一个表示笛卡尔坐标的随机10x2矩阵，将其转换为极坐标。
"""

# ╔═╡ c8a91083-e67f-4485-90c8-dbf10ac8eaf4
begin
m44 = rand(10, 2);

ConvToPolar = vX -> [hypot(vX[1], vX[2]), atan(vX[2], vX[1])]

[ConvToPolar(vX) for vX in eachrow(m44)]

end

# ╔═╡ a96e9ea4-d857-47be-b734-0fafb494c1c5
md"""
## 问题045
创建大小为10的随机向量，并将最大值替换为0
"""

# ╔═╡ ceaf4c1b-a9a4-480e-b787-18c10f832e02
v45 = rand(1:10, 10)

# ╔═╡ e5cb24d1-e04c-4498-8287-d5fa1048dc71
argmax(v45)

# ╔═╡ 82d2e209-ce32-4b7a-bf40-95b61a3cf4e5
findall(x -> x == maximum(v45), v45)

# ╔═╡ 1012c317-52a7-4aa8-a26e-c61be405559e
v45[findall(x -> x == maximum(v45), v45)] .=0

# ╔═╡ bda4081a-eddb-4670-87ec-a24194658916
v45

# ╔═╡ 5069f2bf-fb97-44d5-991e-a75604e0508f
[x for x in 1:5 , j in 1:10]

# ╔═╡ 89fb1bf5-73dc-475b-9dbe-a38195827901
md"""
## 问题046
给定两个向量vX和vY，构造柯西矩阵mC:(Cij = 1 / (xi - yj))
"""

# ╔═╡ ecf3c2b2-c395-4162-a1c4-cb5942cb06b2
begin
v46 = rand(5)
v47 = rand(5)
[1/(v46[i] - v47[j]) for i in 1:length(v46) ,j in 1:length(v47)]
end

# ╔═╡ 6f8d0021-52ef-4c8a-a9e4-0f6fe496d915
1 ./ (v46 .- v47')

# ╔═╡ e81edac7-dcb8-4e8c-b955-74f6bf337bff
md"""
## 问题047
打印每个Julia标量类型的最小和最大可表示值。
"""

# ╔═╡ 3d2bac90-3b2d-41f4-b4cf-2cd84fe0015c
types = [UInt8 UInt16 UInt32 UInt64 Int8 Int16 Int32 Int64 Float16 Float32 Float64]

# ╔═╡ e1c22fce-32b3-40bf-b4ed-5056204d1247
[(typemax(t), typemin(t)) for t in types]

# ╔═╡ 0f3709f9-71a7-4549-85d0-ff6960011ba1
for juliaType in types
    println(typemin(juliaType));
    println(typemax(juliaType));
end

# ╔═╡ edb4a755-2527-4ac4-b4af-231992913afa
md"""
## 问题50
求向量中与给定标量最接近的值
"""

# ╔═╡ f60575cf-9d83-404e-b7fb-49efc835642d
function closevalue(v::Vector{T}, m::T) where {T <: Number}
	v[argmin(abs.(v .- m))]
end

# ╔═╡ 68f78724-1063-4633-9eb4-d7f464a4e0ea
function closevalue2(v::Vector{T}, m::T) where {T <: Number}
	argmin(x -> abs(x - m), v)
end

# ╔═╡ 4cd5322b-f24d-4b0d-a296-f8ab41885739
v = rand(1:10,5)

# ╔═╡ d33eba04-7aaf-4734-8cfc-10b0702fe594
closevalue2(v, 5)

# ╔═╡ 7a4da00c-67ff-4f9e-b601-ee1a3166ba11
md"""
${D}{i, j} = {\left| {x}{i} - {x}{j} \right|}{2}$
"""

# ╔═╡ da830e19-f2fb-47b6-9c31-c8cb8915bd4f
randperm

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
PlutoUI = "~0.7.49"
StatsBase = "~0.33.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "a80df0d64504acf363620426685e6981ed328348"

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

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

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

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "946607f84feb96220f480e0422d3484c49c00239"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.19"

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

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

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
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

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
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

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
# ╠═978e2cbe-84ce-11ed-0f1a-d53b3452c01a
# ╠═2a25e16d-bf1c-4adb-a579-a2536e56ede2
# ╟─0800820d-7231-4b9e-8f34-939652305fde
# ╟─2e4cfe1f-5d4a-4d94-b45c-cc64d07b7e8a
# ╠═6449dbe9-d94f-4982-be5d-9c6bb061a58d
# ╟─6aeacc12-9b52-4722-a774-bf217b787e22
# ╠═ce8aa6e5-d2ca-439a-ae05-e8f37c613979
# ╟─6bbe72f3-73ac-4d8b-9337-d0f1814cc8ec
# ╠═66adef56-1e7e-410a-836e-1b54f81a9897
# ╠═bc1adec9-95e9-4dca-aa2c-4f9049a15fde
# ╟─910e2ca5-93f1-4e1c-8a19-c5ed64b300dd
# ╠═f5b83488-2b24-4895-8b1b-9067a551cae4
# ╟─44c0ae91-23f5-4d28-9882-e56d9990e706
# ╠═92ceef05-91a7-486b-856d-4e0b8075e5c4
# ╟─134b4f1d-e6d1-468a-a758-02dfd3d9748d
# ╠═c0f87299-a9f1-4ce0-9bfd-f3d6b1ee222e
# ╠═991bec68-a83c-4d0a-a587-88b5a48becce
# ╠═64cc5663-0fbb-4081-b054-8e101615a607
# ╟─1210be65-e60b-4bb0-9674-6e7b554f5ff7
# ╠═8503e4ba-0b28-42a4-be13-510eb9cfa96a
# ╠═8717c2e9-c31c-41ce-8a00-70133f947da0
# ╠═044450fb-2f4b-42ac-9c19-25f4a4cf6bba
# ╠═fc706483-8c18-4681-9f4a-60d87cd64661
# ╠═7928d82d-dd74-4119-934c-8001fb9d42dc
# ╠═7e28976f-52e5-4b53-a1a4-76120f1a1168
# ╠═4f1be356-e1c2-46ef-a2da-7752c10c05c9
# ╠═3bcab68e-dc7a-4637-9179-5faaaaca87b2
# ╠═f83ef7bb-c754-4745-a5bd-254efe299456
# ╠═5bc0f846-e309-4fc0-8d6e-ebb4f6b9f88d
# ╟─4bcd248f-bd85-41b0-93d6-daf0032cf4fd
# ╠═1c4df179-e349-419c-969d-8ca0a90e7c49
# ╠═8369a383-60a9-491c-955c-f8e86ea132b7
# ╠═28db1229-fbf1-4f48-8b78-a7620d923f46
# ╠═f05905f4-7b39-4a25-9fcb-efb189e6859a
# ╟─86506685-8ebb-4335-ad34-9714736a4678
# ╠═6c134710-4887-486a-ae4d-3969d8772f0a
# ╠═a71c83db-a0d8-444a-ab40-ba0496cf40da
# ╠═21a19762-2e23-4ed0-a5f9-52ae74c0214f
# ╠═e1fd18e2-9116-431f-9332-915481ce1f18
# ╟─17161d93-d114-40c0-a265-5213bddf0d0a
# ╠═41273e55-9e4a-4167-97cd-de4c288cd330
# ╠═0c7f5204-55e6-4994-ab86-6741a44e6112
# ╟─4e3bbb6a-ce86-4e1a-a24b-fa30140770e9
# ╠═47214202-f582-400e-8190-80911aa6844e
# ╠═245dae59-2d08-4b18-a4c2-96894728a3b4
# ╠═71c5d060-49ad-4095-950f-a342d0011fe3
# ╟─9540d221-d9a4-4837-8f1a-3d65b08bdf68
# ╠═3dd25267-39ab-428e-9131-c89564a375c6
# ╠═5d981825-98f9-40fd-b4fe-83bf1424e122
# ╠═5eb89f20-b37a-4954-8ca0-4515a1d47123
# ╟─b41e115f-7da8-4a8b-83e4-c4f217b6c455
# ╠═8c699a78-cd82-49f7-9719-8459fbe9ac57
# ╠═f56a8f78-2404-4bee-aac6-20661b2acf39
# ╠═2d1f9656-19c9-4fec-b265-d8ec43f93c5c
# ╟─32927332-5a99-425a-a24a-a4d32386c5d1
# ╠═0280a384-c6d7-4b52-b6a7-6a11a4dc2fc8
# ╠═49829e90-a16e-470b-8ed7-b7e37e369fe5
# ╠═8f235e6e-c22b-42f8-a832-be87f5269be4
# ╠═9b1cf0c5-61a0-4173-b84d-29232b661335
# ╟─31c015b8-be1e-4874-a5a3-ff79626aaca7
# ╠═ce10d722-48ea-4fcf-9e87-e3e6a4b4b70a
# ╠═ddf45fa1-6e97-4988-b899-4e1c4d417310
# ╠═5dac8c4a-0eef-4b2d-9026-f3fd5c93784c
# ╟─9afb6b99-cf55-49b4-bd18-a27cc574f90a
# ╠═acbb3da2-886d-4b91-a1a3-227287eb5b72
# ╠═b77071f7-002f-4023-81f2-0480bf4ca847
# ╠═67d49c90-b341-43be-9bb5-b2760c280eb5
# ╠═dd981392-9a19-4844-86cc-fee767eb89e1
# ╟─a0e86116-b2fb-4b2c-8921-2c4ce172c9be
# ╠═9511505e-b505-482b-bb8f-63a380a799ec
# ╠═452918f8-524d-4b07-9758-fb20f1df04a9
# ╟─d3320afc-d76a-458b-8bab-38059767d520
# ╠═f3283376-c4d9-4e9a-81cf-ae464b31ef1c
# ╟─932e1846-c895-4acf-a117-5d8eec25689f
# ╠═9e7c9f4d-8c6d-4603-9bdb-949aef1e9674
# ╠═29b180ac-fdbe-43ac-b0b5-e9c8dbe4cce7
# ╟─6aa42e8e-2a5d-4dde-bf1e-e7f17888a46e
# ╠═21d7faf1-76be-43b0-9bf2-36404f8cde34
# ╟─f8f42707-e1b8-4234-9d0f-cde0e665e4be
# ╠═8ba3debf-f563-4861-93e2-c8870426e5e2
# ╠═607b3fa1-3e22-40a7-bf60-82c5dc18db5e
# ╠═0abb993b-1a99-47a4-a73e-88eb0c517f2d
# ╠═11003c3b-2582-4568-82bc-e4d4179c8701
# ╠═b929f1ce-0f8a-4b84-a52f-96aea71b91e7
# ╠═8d914cb9-a447-4765-b0ff-96513cc748ac
# ╠═e1a9ba85-7f13-4622-8705-6ba77c1a57d8
# ╠═d0c12f21-0955-4bd5-bb8f-b62048ad77e4
# ╟─7af862aa-0e38-457e-a5ed-e3599a56500f
# ╠═6350455c-b93e-43ed-b29d-f694e28bb412
# ╠═9a3b1127-faac-4616-96ad-2ddf1abdedba
# ╟─a41ab657-2aba-4dd2-96f2-5ab0245bedc2
# ╠═85f621da-5904-4485-a432-7eefae058b2c
# ╠═8cef4053-6c60-4c93-9936-255621b29677
# ╟─05e46197-b154-480e-aa2f-c32553804c28
# ╠═8bc86396-2f2d-4a6a-a53a-f2fc077f7e86
# ╟─ba6d4145-c054-4b81-953f-45d5547e44af
# ╠═654739c4-df11-43fb-8d4c-c614a3784f9b
# ╠═63362a17-bffb-42a5-b086-0e1f20f7dd6f
# ╟─8588ef64-221f-4b70-b5a7-7a86bef79492
# ╠═9f4e5407-ff00-4685-98c5-02ec4374e4dd
# ╠═a3a88d35-22eb-455b-8273-fd96f5637bf8
# ╟─184e15ab-bbe7-4c87-a95f-ca802978db41
# ╠═00be179c-212c-447f-a756-5d2e698403b1
# ╠═dc5892d9-03be-4ce7-850e-a125b464f621
# ╠═5fc62092-6e0c-4ad6-94f7-603863a3f42a
# ╟─ee44acd2-4ed9-4a17-9d40-a33f2d1bd5d2
# ╠═9ebd49e0-4542-4dc7-b4f0-7c13b6532a16
# ╠═e2094f43-e554-4ff4-8e79-23817368d4a9
# ╠═a4853f16-1acf-4fb7-b3b8-27edce245f2a
# ╠═7c683de7-8937-4337-a45a-ec4e88b808ab
# ╠═b4e583e9-c7b2-456b-94bb-2fa55f88219e
# ╟─e07ddd70-8b6f-4bda-af27-2a768769c797
# ╠═aab45e9b-549a-45ac-a784-ddbdb079f9d5
# ╠═4f509ee7-583f-46fb-b5f0-4257fffd0786
# ╟─dd00921f-f796-4331-aa1a-109554580485
# ╠═ed7e692c-3974-49ff-9e63-4a263b927f5c
# ╠═050f7f18-be3d-4226-9859-bbe7e91c5ef3
# ╠═c50f3e50-80b1-4833-b4aa-5328ed73f5b2
# ╠═7af28335-e891-4731-9cd7-441bffd2beac
# ╟─ce98ac48-efc9-457f-ad17-f550ab6ec82c
# ╠═02764f62-86b6-404c-b928-4ba3e4604cf0
# ╠═d3b4edfe-cc10-4130-8f6d-9c09ad90c9b2
# ╟─b262fa18-aacd-4288-82fb-01f4e9232a73
# ╠═d97940ee-46a0-4c2d-aafb-46af7b83b480
# ╠═6e5c3eab-2563-400a-9ff4-4934c3178ee6
# ╠═a2b79e5a-3370-487b-91e7-e4e6df126de4
# ╠═9c36dae1-680c-4599-b098-3049a848c8e8
# ╟─d7c17f80-53f5-4849-9fd3-e4ba35720b8d
# ╠═c1656587-c9f8-493d-b2ba-b9c7c8f28a3d
# ╠═eed2b757-b85a-40fe-860b-84c8d83a7e76
# ╠═303475e5-a702-4402-b16d-7fa4116c7427
# ╟─36e16737-30f6-414d-bbe1-4187d63fe479
# ╠═c8a91083-e67f-4485-90c8-dbf10ac8eaf4
# ╟─a96e9ea4-d857-47be-b734-0fafb494c1c5
# ╠═ceaf4c1b-a9a4-480e-b787-18c10f832e02
# ╠═e5cb24d1-e04c-4498-8287-d5fa1048dc71
# ╠═82d2e209-ce32-4b7a-bf40-95b61a3cf4e5
# ╠═1012c317-52a7-4aa8-a26e-c61be405559e
# ╠═bda4081a-eddb-4670-87ec-a24194658916
# ╠═5069f2bf-fb97-44d5-991e-a75604e0508f
# ╟─89fb1bf5-73dc-475b-9dbe-a38195827901
# ╠═ecf3c2b2-c395-4162-a1c4-cb5942cb06b2
# ╠═6f8d0021-52ef-4c8a-a9e4-0f6fe496d915
# ╟─e81edac7-dcb8-4e8c-b955-74f6bf337bff
# ╠═3d2bac90-3b2d-41f4-b4cf-2cd84fe0015c
# ╠═e1c22fce-32b3-40bf-b4ed-5056204d1247
# ╠═0f3709f9-71a7-4549-85d0-ff6960011ba1
# ╟─edb4a755-2527-4ac4-b4af-231992913afa
# ╠═f60575cf-9d83-404e-b7fb-49efc835642d
# ╠═68f78724-1063-4633-9eb4-d7f464a4e0ea
# ╠═4cd5322b-f24d-4b0d-a296-f8ab41885739
# ╠═d33eba04-7aaf-4734-8cfc-10b0702fe594
# ╠═7a4da00c-67ff-4f9e-b601-ee1a3166ba11
# ╠═da830e19-f2fb-47b6-9c31-c8cb8915bd4f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
