### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ e3174c82-eb1c-11ed-05cd-b1b3fe800222
using CSV, DataFrames, MLJ,DataFramesMeta

# ╔═╡ 8fe5ad69-945f-4a7f-86cd-aa2400c02940
using PlutoUI

# ╔═╡ e477c42e-3fd1-4f41-b6fc-d2e682cef0bb
using MLJDecisionTreeInterface 

# ╔═╡ e2ae8e73-700b-4dc3-8ca7-ca77487367c8
using NearestNeighborModels 

# ╔═╡ 030859b4-ec8b-4167-b994-28c8e723f049
using Dates

# ╔═╡ 0eeea922-09af-4cf7-99d5-a4b3fa9e7ace
using BetaML

# ╔═╡ 6f6d2c41-41d0-4b7a-8bcc-759979ed89c0
using MLJXGBoostInterface 

# ╔═╡ 9d1eb86f-6310-4263-9c21-1828dddc2708
using MLJNaiveBayesInterface 

# ╔═╡ ecef4cc4-3f66-4459-9cc6-88900b0b49e6
TableOfContents(title = "目录")

# ╔═╡ 05eca293-f707-4f41-8cfe-cf4c1628a56a
trains = CSV.read("../data/trainbx.csv", DataFrame)

# ╔═╡ 888371ce-a188-49c6-84a9-37aac25cd6a8
train = select(trains, Not(:fraud))

# ╔═╡ 05cda491-e45d-4c3f-b099-a792b035d4ed
X = @select train :age :mon = :customer_months  :claim = :property_claim

# ╔═╡ e390a3f0-0d4d-4499-9917-1d4433a9c7ca
schema(X)

# ╔═╡ 28ccb6fd-dc31-4ea3-a416-dc6aa45e53e1
y = categorical(trains.fraud)

# ╔═╡ aa7912e1-f298-412c-a5ee-60a998d86ee7
md"""
# MLJ建模回顾
简单来说， 用MLJ建模可以划分为以下7个步骤，
1. 加载合适模型
2. 构建模型实例
3. 构造机器
4. 划分训练集、测试集
5. 模型拟合
6. 模型预测
7. 模型评估

不过， 要建立一个合理的模型， 需要更多的操作。比如， 如何更好的评估模型？如何找到更优的模型参数？ 如何整合数据预处理与模型的整个过程？如何整合更多的模型等等。
"""

# ╔═╡ 5bedd223-2d0f-4537-ad58-7111f3950762
models(matching(X,y))

# ╔═╡ 67cab88b-dcf2-4ac6-a082-9285f341ecbf
rfm = (@load RandomForestClassifier pkg = DecisionTree)()

# ╔═╡ 2df651e2-d66a-4071-9c8c-2e379abfe334
machrfm = machine(rfm, X, y)

# ╔═╡ 20935091-4d7b-472c-b32b-25d717d37cf7
trainid, testid = MLJ.partition(eachindex(y), 0.7, shuffle = true)

# ╔═╡ 6a4eaadb-beab-46c6-a066-f069f12579a1
 MLJ.fit!(machrfm,rows = trainid)

# ╔═╡ c465bc4a-06e5-479f-953f-b8578174caca
ŷ =  MLJ.predict(machrfm, X[testid, :])

# ╔═╡ d71dfbee-6d35-4da3-9af9-5d404cd8b824
 MLJ.auc(ŷ, y[testid])

# ╔═╡ ca1da493-245d-4962-b150-22fce25b4e95
 MLJ.accuracy( MLJ.mode.(ŷ), y[testid])

# ╔═╡ 5bf4e368-d8ba-4fe5-9033-9f79b74d5651
md"""
# 更好的评估模型
从上面可以看得出来， 每一次评估模型，我们需要划分训练集、测试集， 绑定机器， 同时需要指定评估的指标。 但实际上， 对每一个可能的模型。 上面的过程是重复的。 因此， 我们可以将其纳入一个函数， 实现更好的评估模型。

evaluate函数可以实现只要给定模型实例、数据、抽样策略（用于生成训练集、测试集）、评估函数，就可以方便测试模型。
"""

# ╔═╡ 3859e530-0eff-4b0d-b3eb-0821dac00124
eres = evaluate(rfm, X, y, resampling=CV(nfolds=5), measure=[auc])

# ╔═╡ 5eeb8a81-1461-49f0-994f-9eb965861859
eres.per_fold[1]

# ╔═╡ a236f70b-8e0c-4d3c-855a-0d66222e92b7
md"""
上面的measurement是每一折检验的评估函数的取值的均值。SE表示标准误（Stand Error）。反映的是估计的均值跟真实的均值之间的偏离程度。1.96\*SE是95%置信区间的大小， 即真正的均值以95%概率
分布在 [ measurement \- 1.96\*SE, measurement + 1.96\*SE]之间。


"""

# ╔═╡ a3167f7a-374d-4a87-989f-deab4f1302e6
1.96*std(eres.per_fold[1])/sqrt(5-1)

# ╔═╡ f8214d53-51c8-4cb1-baf9-1c6d2a7e81d1
 evaluate(rfm, X, y)

# ╔═╡ c3e7514e-802c-4f3c-ab47-ec57a856d866
md"""
# 模型调优*
一个模型包含了很多的参数， 通常必要的参数都会有默认的值， 但默认的参数值不见得是最适合数据的。 因此， 需要通过一定的方法找到最合适的模型参数。 这个过程被称为**模型调优**。 简单来说， 模型调优就是要遍历所有可能的参数组合， 找到最合适的那个模型。 然而， 对连续取值的参数来说， 遍历所有可能的取值是不现实的。 因此， 调优的过程必然涉及到调优策略的问题。 

在MLJ中，模型调优是作为模型包装器实现的。在调优策略中包装模型并将包装的模型绑定到mach机器中的数据之后，调用fit!(mach)在指定的范围内搜索最优模型超参数，然后使用所有提供的数据来训练最佳模型。要使用该模型进行预测，可以调用predict(mach, Xnew)。通过这种方式，包装模型可以被视为未包装模型的“自调优”版本。也就是说，包装模型只是将某些超参数转换为学习参数。

更多细节请看[这里](https://alan-turing-institute.github.io/MLJ.jl/dev/tuning_models/#Tuning-Models)
"""



# ╔═╡ 170cc719-f924-44b9-aa3c-d92d0f946520
rfm

# ╔═╡ c65471f5-0579-413e-8173-366d5ddfeee5
md"""
## 指定调优参数范围
要对一个模型的某个参数去调优， 首先需要指定参数取值的范围。这可以通过range实现。
"""

# ╔═╡ 156eb3ff-964c-4412-b7b9-3b188a7e402b
r = range(rfm, :n_trees  , lower=10, upper=100);

# ╔═╡ 13101220-9fec-4809-884a-bfeef608777a
md"""
## 构造调优模型
因为调优过程本质上是在一系列模型中选取最好的模型。 在MLJ中， 我们通过构造调优模型的，然后去拟合该模型实现调优。

构造调优模型可以指定调优策略tuning， 和采样策略resampling。 默认情况下， tuning=RandomSearch(),
                         resampling=Holdout()。

下面用网格搜索策略构建随机森林的调优模型， 可以通过调整resolution(每一个维度的网格点数量， 当只有一个维度时， 相当于模型的个数)参数或通过设置goal参数（总体模型数量）， 指定要评估的模型的数量。 
"""

# ╔═╡ 97bba1f9-ccc2-49eb-b924-54fa74093b9c
tuning_rfm = TunedModel(model=rfm,
							  resampling=CV(nfolds=3),
							  tuning=Grid(resolution=5),
							  range=r,
							  measure=auc)

# ╔═╡ fd762ff7-08ed-48c0-bfd3-846fee87014f
md"""
## 构造和拟合机器
"""

# ╔═╡ 2c9fd713-a60e-48f1-b7a7-2b4d16ab3e99
tmach1 = machine(tuning_rfm, X,y)

# ╔═╡ 1d8e3f90-38e1-4302-ac74-709ff235784b
 MLJ.fit!(tmach1)

# ╔═╡ 0ee7514e-6f91-4e83-82b8-54cb6cb44deb
md"""
## 查看拟合的最优模型
"""

# ╔═╡ e10b524f-c25f-4e3b-bac2-1c646b8a6879
 MLJ.fitted_params(tmach1).best_model

# ╔═╡ e50087d7-4449-4aab-b04c-ffe86c97ccb9
md"""
## 查看拟合过程
主要是了解拟合的最优模型的一些计算过程中的参数。
"""

# ╔═╡ c07fe7c1-5f2b-4a03-9c3b-5e04eb270e41
report(tmach1).best_history_entry

# ╔═╡ af001d41-4e03-47dd-a501-c55fbfdf365a
report(tmach1)

# ╔═╡ b71f529a-a12a-48dd-9481-9e60fa5a934f
md"""
## 多个参数同时调优*
有时候， 我们可能需要多个参数同时调优， 这可以通过设置多个range实现。

假定我们还要对min\_purity\_increase参数进行调优。 那么，我们可以新建一个range，重新构造模型。
"""

# ╔═╡ d4b467a2-0fd7-4044-9fdd-bddd3d31e08b
rfm

# ╔═╡ de3ae8f9-20a3-4372-83cf-befb2e3d52b6
r2 = range(rfm, :min_purity_increase   , lower=0, upper=1);

# ╔═╡ 567b3baa-9dbe-4a4e-94b4-95d7c21a3393
tuning_rfm2 = TunedModel(model=rfm,
							  resampling=CV(nfolds=3),
							  tuning=Grid(goal=10),
							  range=[r,r2],
							  measure=auc)

# ╔═╡ 0e962366-6eeb-4847-93eb-7f345a870a3e
mach2 = machine(tuning_rfm2, X, y)

# ╔═╡ 4d3903cc-a9b4-4e5e-96f8-09ea4f5c8779
 MLJ.fit!(mach2)

# ╔═╡ 553a527f-bcc1-4bf0-9fc8-739768918b84
report(mach2).best_history_entry

# ╔═╡ a79d6ebe-6389-4a79-a575-1716637f9949
report(mach2).best_model

# ╔═╡ 6952d91d-3a03-4190-a5a0-9514e845dfa8
md"""
## 预测
拟合的调优模型可以直接用于预测， 注意，默认情况下会使用最优模型去预测， 所以不需要将最优模型调出来。

可以直接通过rows指定要预测的数据所在的行， 或者直接给出预测属性。
"""

# ╔═╡ b0983a06-c67e-4c2b-bbc6-41ba87f5414f
 MLJ.predict(tmach1, rows = 1:10)

# ╔═╡ 8e7085a6-d4cf-4bc9-b18c-ff913acda6c4
 MLJ.predict(tmach1, X[1:10,:])

# ╔═╡ eaec9ada-bec5-4121-86b9-11668c87aa6b
md"""
## 练习
请采用NearestNeighborModels包中的KNNClassifier模型重新做以上练习， 并对K参数进行调优。
"""

# ╔═╡ b75de4db-0686-4e5d-8450-5c15eb345800
knn = (@load KNNClassifier pkg = NearestNeighborModels)()

# ╔═╡ 229b00c1-d8b5-43cf-a21c-c8c38615172c
rknn = range(knn, :K, lower=3, upper=20)

# ╔═╡ db3efefc-179d-49d1-a5ff-e33ea98a5f84
tknn = TunedModel(knn, range = rknn, measure =  auc)

# ╔═╡ 905e3990-a015-4a2d-8435-9a4341970529
r2

# ╔═╡ 1daca5ef-bfdd-410f-9e51-6489b3ddc0fa
schema(X)

# ╔═╡ c5c9f36f-96bd-4449-adf6-c33fe9304a7f
mtknn = machine(tknn, coerce(X, Count => Continuous), y)

# ╔═╡ 04f5c592-086c-4f89-8727-3c5ff14db366
 MLJ.fit!(mtknn)

# ╔═╡ a9ed5add-f537-45be-b893-3ff15db2ba54
fitted_params(mtknn)

# ╔═╡ 1f221bb2-fbc6-45dc-89fa-59949aa969da
report(mtknn).best_history_entry

# ╔═╡ 5e7509f4-27b8-4e2c-89d2-f23b81b65793
md"""
# 完整代码示例
上面的演示只关注模型的选择， 下面考虑用不同的特征重做以上问题。
"""

# ╔═╡ 32f83d73-8a90-4651-b435-a9a7ee33681f
md"""
## 选择特征
"""

# ╔═╡ 66ba2f79-eb10-4ea3-8566-8547ee8147df
train

# ╔═╡ 977095fb-c564-48ff-b6e3-c588c6ddd7d0
unique(schema(train).scitypes)

# ╔═╡ ebf4d337-56c5-4f7d-9db8-6ef62778fc18
Xn = @select train :age :cmons = :customer_months :state = :policy_state :sex = :insured_sex :edu = :insured_education_level :autoage = year.(:incident_date) .-  :auto_year  :claim = :property_claim :occu = :insured_occupation :hobby =:insured_hobbies

# ╔═╡ 95cd012a-2cd4-426f-81dc-be835f68160c
schema(Xn)

# ╔═╡ faf553bf-a730-416b-a423-945281337fbc
coerce(coerce(Xn, :state => Multiclass), :state => Count)

# ╔═╡ 55fdd78b-5b62-46e5-8744-78b3a7bfdc86
md"""
## 科学类型修正
很明显， 上面的类型中， 文本类型（Textual）几乎不能用于任何模型的输入， 我们必须要转为类别变量。 其他的Count类型， 虽然可以用于一些模型， 但会还是会有限值。我们考虑将其转为连续类型。
"""

# ╔═╡ 4f772515-a727-4ed4-937f-147873704687
Xnn = coerce(Xn, Count => Continuous, Textual => Multiclass)

# ╔═╡ 856e731d-4713-484e-8e35-17678eaf5f48
schema(Xnn)

# ╔═╡ 632883ce-ac35-42cc-8235-b33c83be9b5c
models(matching(Xnn, y))

# ╔═╡ e17f2106-b93b-4cab-926a-e8c8143e1df3
rfc2 = (@load RandomForestClassifier pkg = BetaML)()

# ╔═╡ a9fff7e3-852b-40c7-8e34-b794df35c2ca
evaluate(rfc2, Xnn , y, resampling=CV(nfolds=5), measure=[auc]) 

# ╔═╡ ae24f188-88e5-45cd-a174-093e972476fe
md"""
## 编码转换
上面可以看到， 虽然我们修正了科学类型。 但适合的模型却不是很多。 原因是类别变量一般作为预测目标， 作为属性可能不是很方便。 我们最好将其独热编码转换为连续变量。 因此， 我们考虑使用连续编码转换器， 将数据做进一步的转换。
"""

# ╔═╡ 47a5c810-3d48-4272-84ae-f4c6981a062e
encode = ContinuousEncoder()

# ╔═╡ 34c0ce71-aa17-4c86-bdd0-39737e696026
mx = machine(encode, Xnn)

# ╔═╡ 2ec39c32-f5fb-41be-a8e6-1b26f94451ea
MLJ.fit!(mx)

# ╔═╡ aa3aa791-73f4-4283-b609-9b33b673879c
 Xok = MLJ.transform(mx, Xnn)

# ╔═╡ 19d34f1f-0f7a-4da2-8bbd-46e5261c9d76


# ╔═╡ 5b198b9a-6cde-438c-afe6-26e4e712a0eb
models(matching(Xok, y))

# ╔═╡ 8c19e28f-4642-42b8-9f14-641d4425230d
md"""
现在再来看， 可选的模型就非常多了。 接下来， 我们还是采用跟上面同样的模型。 看看效果有什么变化。
"""

# ╔═╡ 0e239f17-04f3-4f15-b21d-afa131002804
evaluate(rfm, Xok, y, resampling=CV(nfolds=5), measure=[auc]) 

# ╔═╡ 685ddaa3-3dd5-4bc4-8471-2f378130559d
md"""
Xgb是在竞赛中用的比较多的模型， 比较复杂， 我们可以看一下， 效果怎么样。从下面的代码来看， 似乎效果也不怎么好。 一个可能的原因是特征也不是很多。然后， 模型的参数可能选的不够好。我们这里不去深究了。 至少可以明确的一点是：特征的选择是重要的。 因为同样的模型， 在最开始的时候， 效果很差， 但现在的效果明显要提升了很多。 所以， 首先找到最有价值的特征， 再去优化模型参数是比较好的选择。
"""

# ╔═╡ 731508f9-9389-48b3-85b6-b493dc39fbe9
xgb = (@load XGBoostClassifier pkg = XGBoost)()

# ╔═╡ 59c5d7b7-c3b0-4261-a3c7-4c8845d161aa
evaluate(xgb, Xok, y, resampling=CV(nfolds=5), measure=[auc]) 

# ╔═╡ 838faf88-8f18-42ec-8f0e-b6b43c6312cd
md"""
## 预测测试集
如果我们认为上面的模型已经不错了。想要用上面的模型去做预测。应该要怎么做呢？ 首先， 上面的模型在评估时并没有保存在机器里面， 因此， 我们虽然了解了模型的效果， 但暂时还没法拿过来直接预测。 所以， 先将模型和新的数据绑定起来， 构建一个机器再说。
"""

# ╔═╡ f1ab828a-54db-40c0-b75d-734edf118902
md"""
### 构造出机器
"""

# ╔═╡ 42f8024d-4a30-4d81-8f27-7072ce2b482a
machn = machine(rfm, Xok, y)

# ╔═╡ aca9bb94-54aa-4311-967e-b73200ff0830
md"""
### 在训练集上重新训练模型
"""

# ╔═╡ b72d3213-56fe-484e-8b2d-eb0b4d6d158a
md"""
接下来， 我们再训练一下模型， 由于上面已经评估过， 这个模型还可以， 那我们可以直接在所有数据上训练模型，以期得到最好的模型参数， 然后用于预测。
"""

# ╔═╡ c1801e55-7539-4276-9f34-913e57884398
MLJ.fit!(machn)

# ╔═╡ 4932260a-a6e4-4fa8-a166-df6d3b3f05d3
md"""
我们可以看一下模型在整个训练集上的效果。
"""

# ╔═╡ a8e10e3d-9be5-4e53-8403-f170248d219a
MLJ.accuracy(MLJ.predict_mode(machn, Xok), y)

# ╔═╡ 15e0c46d-38ff-49c1-bb11-948a96f8e8bc
MLJ.auc(MLJ.predict(machn, Xok), y)

# ╔═╡ 76cbbbfa-f178-45a8-8415-d1d293b000d1
md"""
!!! warn "注意："
	你会发现， 这个模型的效果出奇的好。 但不要被假象给迷惑了。 你的模型时在所有数据上训练了一下，同时预测的是训练集， 相当于样本内预测， 所以看上去效果很好。 
"""

# ╔═╡ 8014496b-e808-451e-8564-73a73c927a01
md"""
### 读取测试集
"""

# ╔═╡ 2c7696cd-a3ee-431e-8d67-8af12ec36d9d
test = CSV.read("../data/testbx.csv", DataFrame)

# ╔═╡ 8d553aec-383d-4440-8fce-810cb75e708c
md"""
### 对测试集做同样变换
下面要对测试集做跟训练集同样的变换， 才能用模型去预测。 暂时， 我们可以将前面的代码复制过来， 应用于测试集就好。
"""

# ╔═╡ 8c17090f-4c7a-49fa-b370-870224fa686e
md"""
1) 先从测试集中选择特征
"""

# ╔═╡ d7961543-1b0c-438b-a006-544c5f4b51cd
Xt = @select test :age :cmons = :customer_months :state = :policy_state :sex = :insured_sex :edu = :insured_education_level :autoage = year.(:incident_date) .-  :auto_year  :claim = :property_claim :occu = :insured_occupation :hobby =:insured_hobbies

# ╔═╡ 6949712b-a489-44c5-9e1b-e6dff2d69812
md"""
2） 再对特征做科学类型修正
"""

# ╔═╡ 7892eebd-4390-4b4b-af61-44c19d364dc9
Xtt = coerce(Xt, Count => Continuous, Textual => Multiclass)

# ╔═╡ abe26275-ea61-47cc-bfe2-f673f1a4db34
md"""
3） 最后对数据做变换
"""

# ╔═╡ ca56fb57-dd93-4b04-a8bc-459cd6bb9f4f
Xtok = MLJ.transform(mx, Xtt)

# ╔═╡ 8d23b8a6-d4a7-4679-8edb-11f8a3be6e70
md"""
!!! warn "注意："
	这时候做变换就不要再训练模型了， 我们直接使用测试集的变换就行（这样才能确保训练集合测试集做同样的处理）。 
"""

# ╔═╡ 904e56a6-6251-4706-bf0d-b5da9c34b90f
md"""
4） 现在可以在新构建的数据上做预测了
"""

# ╔═╡ 4f192a77-b80e-449e-b4cd-5c8955df4656
dt = MLJ.predict(machn, Xtok)

# ╔═╡ b53c042d-b951-4baa-aea1-a2fe0fec1cd8
md"""
### 提取预测结果
"""

# ╔═╡ 43f0e025-9b01-4946-8031-f2f606fe493c
md"""
上面预测的结果是一个分布， 但我们需要的是这个分布在1上的取值， 本质上是概率密度函数（pdf）在1上的取值。因此， 我们可以通过pdf函数获得。
"""

# ╔═╡ 8e9593b9-82bd-484e-99aa-d915f2212d98
pre = pdf.(dt, 1)

# ╔═╡ c8ac17e6-b852-4f61-88e3-a8344097f6c6
pdf(dt[1], 1)

# ╔═╡ ef12d148-82ab-46b9-9a6c-c2425f307330
md"""
### 构造可以提交的结果
"""

# ╔═╡ 857214e6-9737-4844-9634-a03b5e55a815

subm = DataFrame(policy_id = test.policy_id,fraud = pre)

# ╔═╡ 677367c5-cbea-4b52-b7d1-190ef607bd8d
CSV.write("submit.csv", subm)

# ╔═╡ 19e601ca-375e-4e9f-9887-3ef343be0983
md"""
把上面写入的submit.csv文件提交到竞赛系统， 最终的成绩是 0.7366。 这个结果比在评估时的平均成绩要好， 不过比最大的值（0.777）要低的多。
"""

# ╔═╡ 8ec95f1f-caf5-4941-b1ee-777df154a80f
md"""
# 进一步简化
上面完整的过程包含了特征选择、科学类型变换、编码、训练、预测等过程， 而且在训练集和测试集上要进行相同的操作。 我们能够把所有过程放到一起？

我们可以构建一个[管道](https://alan-turing-institute.github.io/MLJ.jl/dev/linear_pipelines/)。 

一个管道是由组件通过 |> 拼接起来的。 组件可以是普通函数（例如数据类型变换函数）或模型。 一个管道本身也是一个模型， 其包含的组件是该模型的超参数。
"""

# ╔═╡ 84f8e135-ff33-4d92-9cdd-bcdce90b5da6
RFC = (@load RandomForestClassifier pkg = DecisionTree)

# ╔═╡ fa50d080-3f02-478b-952a-ade312845243
md"""
下面构建的管道包含3个组件：
- 科学类型变换函数： x -> coerce(x,  Count => Continuous, Textual => Multiclass)
- 数据编码模型： encode
- 分类模型：rfm

这相当于是将上面的过程融合到了一起。 注意， 函数是匿名函数。 模型也都是前面已经构建的模型实例。 但这些模型并没有训练， 因为训练是需要通过机器去实现的。

管道的3个组件相当于依次对数据进行3种处理。
"""

# ╔═╡ cc7051d3-f120-48e4-a0fd-bca759b0f9e6
pipe = (x -> coerce(x,  Count => Continuous, Textual => Multiclass)) |> encode|> rfm

# ╔═╡ 1676b077-082c-4911-8b43-cc38d746b66d
evaluate(pipe, Xn, y, resampling=CV(nfolds=3), measure=auc)

# ╔═╡ 0b37fd3d-5bb1-48da-8a39-f42a4e6d4607
md"""
上面的管道只能处理经过特征选择之后的数据， 否则出错（可以试一下将上面evaluate中的Xn换为train）。 我们当然希望直接就能处理最原始的train数据。 这只要加一个特征选择的模型就行FeatureSelector()， 可以到[这里](https://alan-turing-institute.github.io/MLJ.jl/dev/transformers/#MLJModels.FeatureSelector)看一下特征选择模型时干什么的。
"""

# ╔═╡ b7eb90fe-84f7-4bd2-9ce3-d8a301a7c640
selected_feats = [:age ,:customer_months , :policy_state , :insured_sex , :insured_education_level ,  :property_claim ,:insured_occupation ,:insured_hobbies]

# ╔═╡ b58b5a65-72f3-49d9-bcfe-4c914350df73
md"""
我们可以直接把上面的特征选择模型跟前面构造的模型拼接起来， 当然你也可以重写一遍。
"""

# ╔═╡ 621ecbe3-b99e-4e26-8049-b24cd6b1c1b0
pip2 = FeatureSelector(features=selected_feats) |> pipe

# ╔═╡ d4b944a0-b738-483f-b839-e28e67504d12
md"""
我们新构建的管道可以直接在用在训练集上了， 下面评估一下模型。
"""

# ╔═╡ 7934f22f-f5a1-4d3b-bcbc-4c5491980931
evaluate(pip2, train, y, resampling=CV(nfolds=3), measure=auc)

# ╔═╡ e3aaee25-302e-4838-8085-34a27b66110f
md"""
看上去， 效果似乎变好了一点， 实际上是因为， 我们新选择的特征中， 没有包含前面构造出来的车辆年龄那个特征。 如果我们想把特征构造这个环节也加入到管道中要怎么做呢？

本质上， 我们是要写一个函数， 对原始数据进行处理。然后再对处理之后的数据选择特征。
"""

# ╔═╡ 41331b5d-417d-4558-a207-be5c92067580
function add_feats(df)
@transform df :autoage = year.(:incident_date) .-  :auto_year
end

# ╔═╡ 386e67b4-1ebf-4d0f-843b-a974b5ebf5e1
md"""
!!! warn "注意："
	这里的函数只是简单的将dataframe的转换操作包裹在一个函数定义里面。 注意， 要使用@transform而不是@select， 因为要确保所有的特征还在， 不然后面的特征选择就选不到了。
"""

# ╔═╡ 436cdaaa-50b8-4bd2-84b9-ca7f57ceb744
md"""
这里增加了一个:autoage， 在train上调用函数add_feats之后， 将新增一个autoage特征。
"""

# ╔═╡ 33d056d5-7770-49b5-9c9e-eed3103400e3
selected_feats2 = [:age ,:autoage, :customer_months , :policy_state , :insured_sex , :insured_education_level ,  :property_claim ,:insured_occupation ,:insured_hobbies]

# ╔═╡ 13c4c06e-b2d8-426e-8d06-984a0f5befd8
pip3 = add_feats |> FeatureSelector(features=selected_feats2) |> pipe

# ╔═╡ 12e8a411-c8c2-410c-adea-7a9171846761
evaluate(pip3, train, y, resampling=CV(nfolds=3), measure=auc)

# ╔═╡ d4a98628-2228-4699-935f-d7a148c50ba9
md"""
现在的管道pip3已经跟前面的完整过程一致了。 虽然最终的评估结果还是有一些差距， 这是采用策略导致的。

接下来， 可能有一个问题。 如果pip3本身也是一个模型， 那如果我们想要对其参数调优， 要怎么做呢？ 比如， 我们要对pip3包含的最后一个模块random_forest_classifier 中的n_trees进行调优， 要怎么做。

这本质上是对一个模型的嵌套超参数（超参数的超参数）进行调优， 只要在指定调优的参数时，加入范围界定就行了。
"""

# ╔═╡ c8d2f8aa-76e3-4ceb-ad99-ef7baa292539
rp = range(pip3, :(random_forest_classifier.n_trees), lower = 10, upper = 100)

# ╔═╡ ed9094e8-0ae0-4f59-9cc9-5c5795759e98
tuning_pip3 = TunedModel(model=pip3,
							  resampling=CV(nfolds=3),
							  tuning=Grid(resolution=15),
							  range=rp,
							  measure=auc)

# ╔═╡ d94cfbb7-f2c3-41fe-b6c6-941117e2054e
pip3

# ╔═╡ a4102337-e061-487f-b877-d74f0750146f
machpip3 = machine(tuning_pip3, train, y)

# ╔═╡ cafaf57d-b429-40fc-aca4-8d859947b98a
MLJ.fit!(machpip3)

# ╔═╡ c89942d3-b00b-43f5-a780-0137121b611d
fitted_params(machpip3).best_model

# ╔═╡ 26515812-5926-4fde-bb79-744fbde21b6f
report(machpip3)

# ╔═╡ 735c9714-42e6-4a80-8fee-cfb1fdfc5df7
md"""
接下来可以直接用于预测了， 我们不再需要对测试集做任何的操作， 因为同样的操作已经包含在了pip3模型中。 我们也不需要对模型在全样本上重新训练， 因为在调优的过程中， 系统会自动将最优结果在全样本上训练。所以， 调优之后包含的最优模型已经是重新训练过的最优模型。
"""

# ╔═╡ 0d4630db-5c06-4fbb-b48e-955fcf295a87
pipre = MLJ.predict(machpip3, test)

# ╔═╡ 3aac04af-a28a-4844-b8c9-80ed380dcb49
subm2 = DataFrame(policy_id = test.policy_id,fraud = pdf.(pipre, 1))

# ╔═╡ 2668992c-8823-40c0-936e-fd8417f9a14d
CSV.write("submit2.csv", subm2)

# ╔═╡ eac7a2db-bf87-4009-99e5-6516b82c18a1
md"""
这次提交结果之后， 成绩是0.7235， 比上次的还差一点。 也就是我们的调优白调了。不仅没起到积极作用，反而削弱了模型效果。 这是为什么呢？ 读者可以自己思考一下。
"""

# ╔═╡ a2eb4a4a-65d6-4131-9c52-cec82f496467
md"""
# 更复杂， 更简单
"""

# ╔═╡ af1ef2da-82b7-4a5d-ac28-451d8268b95e
md"""
定义一个数据预处理的管道， 它实现
1. 将不要的特征删掉
2. 将文本转为类别变量
3. 将类别变量转为记数变量（整数编码）
4. 连续编码

"""

# ╔═╡ 98d0aacf-8f5a-47af-ab19-b3739975832b
md"""
接下来， 可以将上述的数据预处理管道跟其他的模型拼接，形成不同的模型。

我把代码都删了， 我是故意的。因为这个让竞赛的auc直接上到了0.93以上， 只能交给大家去探索。 
"""

# ╔═╡ d6b4fd91-f29e-4f83-92ad-4d723a8af9fb
function submit(fraud, file = "submit.csv", policy_id=test.policy_id)
	subm = DataFrame(policy_id = policy_id,fraud = fraud)
	CSV.write(file, subm)
end

# ╔═╡ 1910bb5e-ee1a-4bd5-aa5b-ceca5f052b86
md"""
# 集成学习
简单的集成学习指的是将同种类型的模型（具有相同的超参数）聚合到一起形成的新模型。 MLJ提供了一个函数构建这种简单的集成学习模型。(需要加载MLJEnsembles包)
```julia
EnsembleModel(model,
              atomic_weights=Float64[],
              bagging_fraction=0.8,
              n=100,
              rng=GLOBAL_RNG,
              acceleration=CPU1(),
              out_of_bag_measure=[])
```

上面的
- model是基模型， 
- bagging\_fraction=0.8， 表示基模型在学习时使用到的训练集样本的比例（默认0.8）。  
- atomic\_weights可以用于给每个基模型一个权重（当预测的是概率值时有效）。 
- n表示基模型的数量。
- out\_of\_bag\_measure如果指定了的话可以用于报告基模型在训练时的评估值。
"""

# ╔═╡ 7be5cfc8-793b-435c-afc1-f10189d07740
md"""
我们用 NaiveBayes 包中的高斯朴素贝叶斯分类模型演示一下如何做集成学习。

首先我们加载模型代码。
"""

# ╔═╡ 212924bf-80a6-4016-8c1c-8dbb538f7a33
md"""
## 单个贝叶斯模型
"""

# ╔═╡ c87d3d4c-d334-4cdb-a437-cb3ec37553c6
bayes = (@load GaussianNBClassifier pkg = NaiveBayes)()

# ╔═╡ 69a90372-e2f0-4b00-a6fa-ab5d8448e427
input_scitype(bayes)

# ╔═╡ f05656f7-3162-4e47-ab75-9effde7901b4
target_scitype(bayes)

# ╔═╡ be0e1201-b1a9-4186-90c2-50abd847d809
datapre = add_feats |>  FeatureSelector(features=selected_feats2) |>  (x -> coerce(x,   Textual => Multiclass)) |> (x -> coerce(x,  Multiclass => Count)) |> ContinuousEncoder()

# ╔═╡ 9716d66e-1e5e-4527-a901-3929377215b2
bm1 = datapre |> bayes

# ╔═╡ f3aecc74-89f8-4c2d-85bf-37808130d2b3
evaluate(bm1, train, y, measure = auc)

# ╔═╡ 3b048af1-cf0c-4fd7-b895-09382b1108d4
md"""
## 集成贝叶斯模型
"""

# ╔═╡ cf80ce08-d7b2-420f-8b89-48832bdb5b1d
ebayes = EnsembleModel(bayes, n = 10)

# ╔═╡ 24f35b88-fe7d-42da-8341-acd15292b7eb
bm2 = datapre |> ebayes

# ╔═╡ f5c8a235-52b7-4d5e-91d1-4e1d046ccdb3
evaluate(bm2, train, y, measure = auc)

# ╔═╡ b32a8bf0-5119-4685-b4ae-52537222e9b5
md"""
上面可以看出， 集成学习效果并没有变好。 可能有各种原因。 大家可以自己探索。
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BetaML = "024491cd-cc6b-443e-8034-08ea7eb7db2b"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
MLJ = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
MLJDecisionTreeInterface = "c6f25543-311c-4c74-83dc-3ea6d1015661"
MLJNaiveBayesInterface = "33e4bacb-b9e2-458e-9a13-5d9a90b235fa"
MLJXGBoostInterface = "54119dfa-1dab-4055-a167-80440f4f7a91"
NearestNeighborModels = "636a865e-7cf4-491e-846c-de09b730eb36"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BetaML = "~0.9.6"
CSV = "~0.10.9"
DataFrames = "~1.5.0"
DataFramesMeta = "~0.14.0"
MLJ = "~0.19.1"
MLJDecisionTreeInterface = "~0.4.0"
MLJNaiveBayesInterface = "~0.1.6"
MLJXGBoostInterface = "~0.3.7"
NearestNeighborModels = "~0.2.2"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "a8271b14b3ac4971ec17b9cefd0b5fcd798e2ce2"

[[deps.ARFFFiles]]
deps = ["CategoricalArrays", "Dates", "Parsers", "Tables"]
git-tree-sha1 = "e8c8e0a2be6eb4f56b1672e46004463033daa409"
uuid = "da404889-ca92-49ff-9e8b-0aa6b4d38dc8"
version = "1.4.1"

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

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["Random"]
git-tree-sha1 = "07591db28451b3e45f4c0088a2d5e986ae5aa92d"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "133a240faec6e074e07c31ee75619c90544179cf"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.10.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BetaML]]
deps = ["AbstractTrees", "CategoricalArrays", "Combinatorics", "DelimitedFiles", "Distributions", "DocStringExtensions", "ForceImport", "JLD2", "LinearAlgebra", "LoopVectorization", "MLJModelInterface", "PDMats", "Printf", "ProgressMeter", "Random", "Reexport", "StableRNGs", "StaticArrays", "Statistics", "StatsBase", "Test", "Zygote"]
git-tree-sha1 = "f0de5cb3b8f61c6701b16d993db0e0447e9a7f94"
uuid = "024491cd-cc6b-443e-8034-08ea7eb7db2b"
version = "0.9.7"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "601f7e7b3d36f18790e2caf83a882d88e9b71ff1"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.4"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.CUDA_Driver_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "dc172b558adbf17952001e15cf0d6364e6d78c2f"
uuid = "4ee394cb-3365-5eb0-8335-949819d2adfc"
version = "0.8.1+0"

[[deps.CUDA_Runtime_jll]]
deps = ["Artifacts", "CUDA_Driver_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "4ca7d6d92075906c2ce871ea8bba971fff20d00c"
uuid = "76a88914-d11a-5bdc-97e0-2f5a05c973a2"
version = "0.12.1+0"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

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

[[deps.CategoricalDistributions]]
deps = ["CategoricalArrays", "Distributions", "Missings", "OrderedCollections", "Random", "ScientificTypes"]
git-tree-sha1 = "926862f549a82d6c3a7145bc7f1adff2a91a39f0"
uuid = "af321ab8-2d2e-40a6-b165-3d674595d28e"
version = "0.1.15"

    [deps.CategoricalDistributions.extensions]
    UnivariateFiniteDisplayExt = "UnicodePlots"

    [deps.CategoricalDistributions.weakdeps]
    UnicodePlots = "b8865327-cd53-5732-bb35-84acbb429228"

[[deps.Chain]]
git-tree-sha1 = "8c4920235f6c561e401dfe569beb8b924adad003"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.5.0"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "SparseInverseSubset", "Statistics", "StructArrays", "SuiteSparse"]
git-tree-sha1 = "e7d1016142a71c980309114ee30a3e4f870902f4"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.65.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "aa51303df86f8626a962fccb878430cdb0a97eee"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.5.0"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "6970958074cd09727b9200685b8631b034c0eb16"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.14.1"

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

[[deps.DecisionTree]]
deps = ["AbstractTrees", "DelimitedFiles", "LinearAlgebra", "Random", "ScikitLearnBase", "Statistics"]
git-tree-sha1 = "526ca14aaaf2d5a0e242f3a8a7966eb9065d7d78"
uuid = "7806a523-6efd-50cb-b5f6-3fa6f1930dbb"
version = "0.12.4"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

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
git-tree-sha1 = "22c595ca4146c07b16bcf9c8bea86f731f7109d2"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.108"

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

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarlyStopping]]
deps = ["Dates", "Statistics"]
git-tree-sha1 = "98fdf08b707aaf69f524a6cd0a67858cefe0cfb6"
uuid = "792122b4-ca99-40de-a6bc-6742525f08b6"
version = "0.3.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

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

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "57f08d5665e76397e96b168f9acc12ab17c84a68"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.10.2"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForceImport]]
deps = ["Test"]
git-tree-sha1 = "7ac07d5194360af910146abd33af89bb69541194"
uuid = "9dda63f9-cce7-5873-89fa-eccbb2fffcde"
version = "0.0.3"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GPUArrays]]
deps = ["Adapt", "GPUArraysCore", "LLVM", "LinearAlgebra", "Printf", "Random", "Reexport", "Serialization", "Statistics"]
git-tree-sha1 = "68e8ff56a4a355a85d2784b94614491f8c900cde"
uuid = "0c68f7d7-f131-5f86-a1c3-88cf8149b2d7"
version = "10.1.0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "ec632f177c0d990e64d955ccc1b8c04c485a0950"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.6"

[[deps.HDF5]]
deps = ["Compat", "HDF5_jll", "Libdl", "Mmap", "Printf", "Random", "Requires", "UUIDs"]
git-tree-sha1 = "114e20044677badbc631ee6fdc80a67920561a29"
uuid = "f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"
version = "0.16.16"

[[deps.HDF5_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "LazyArtifacts", "LibCURL_jll", "Libdl", "MPICH_jll", "MPIPreferences", "MPItrampoline_jll", "MicrosoftMPI_jll", "OpenMPI_jll", "OpenSSL_jll", "TOML", "Zlib_jll", "libaec_jll"]
git-tree-sha1 = "38c8874692d48d5440d5752d6c74b0c6b0b60739"
uuid = "0234f1f7-429e-5d53-9886-15a909be8d59"
version = "1.14.2+1"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "2c3ec1f90bb4a8f7beafb0cffea8a4c3f4e636ab"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.6"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ca0f6bf568b4bfc807e7537f081c81e35ceca114"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.10.0+0"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

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

[[deps.IRTools]]
deps = ["InteractiveUtils", "MacroTools", "Test"]
git-tree-sha1 = "d05027a62b4c9a2223820a9fdeae1110ad3946a5"
uuid = "7869d1d1-7146-5819-86e3-90919afe41df"
version = "0.4.13"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be50fe8df3acbffa0274a744f1a99d29c45a57f4"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "00a19d6ab0cbdea2978fc23c5a6482e02c192501"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.0"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterationControl]]
deps = ["EarlyStopping", "InteractiveUtils"]
git-tree-sha1 = "e663925ebc3d93c1150a7570d114f9ea2f664726"
uuid = "b3c1a2ee-3fec-4384-bf48-272ea71de57c"
version = "0.5.4"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "5ea6acdd53a51d897672edb694e3cc2912f3f8a7"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.46"

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

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

    [deps.JSON3.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "7d703202e65efa1369de1279c162b915e245eed1"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.9"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Requires", "Unicode"]
git-tree-sha1 = "839c82932db86740ae729779e610f07a1640be9a"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "6.6.3"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "88b916503aac4fb7f701bb625cd84ca5dd1677bc"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.29+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LatinHypercubeSampling]]
deps = ["Random", "StableRNGs", "StatsBase", "Test"]
git-tree-sha1 = "825289d43c753c7f1bf9bed334c253e9913997f8"
uuid = "a5e1c1ea-c99a-51d3-a14d-a9a37257b02d"
version = "1.9.0"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "62edfee3211981241b57ff1cedf4d74d79519277"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.15"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

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

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8f6786d8b2b3248d79db3ad359ce95382d5a6df8"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.170"
weakdeps = ["ChainRulesCore", "ForwardDiff", "SpecialFunctions"]

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.LossFunctions]]
deps = ["Markdown", "Requires", "Statistics"]
git-tree-sha1 = "df9da07efb9b05ca7ef701acec891ee8f73c99e2"
uuid = "30fc2ffe-d236-52d8-8643-a9d8f7c094a7"
version = "0.11.1"
weakdeps = ["CategoricalArrays"]

    [deps.LossFunctions.extensions]
    LossFunctionsCategoricalArraysExt = "CategoricalArrays"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "80b2833b56d466b3858d565adcd16a4a05f2089b"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.1.0+0"

[[deps.MLFlowClient]]
deps = ["Dates", "FilePathsBase", "HTTP", "JSON", "ShowCases", "URIs", "UUIDs"]
git-tree-sha1 = "5cc2a5453856e79f4772269fbe6b19fcdcba391a"
uuid = "64a0f543-368b-4a9a-827a-e71edb2a0b83"
version = "0.4.7"

[[deps.MLJ]]
deps = ["CategoricalArrays", "ComputationalResources", "Distributed", "Distributions", "LinearAlgebra", "MLJBase", "MLJEnsembles", "MLJFlow", "MLJIteration", "MLJModels", "MLJTuning", "OpenML", "Pkg", "ProgressMeter", "Random", "Reexport", "ScientificTypes", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "193f1f1ac77d91eabe1ac81ff48646b378270eef"
uuid = "add582a8-e3ab-11e8-2d5e-e98b27df1bc7"
version = "0.19.5"

[[deps.MLJBase]]
deps = ["CategoricalArrays", "CategoricalDistributions", "ComputationalResources", "Dates", "DelimitedFiles", "Distributed", "Distributions", "InteractiveUtils", "InvertedIndices", "LinearAlgebra", "LossFunctions", "MLJModelInterface", "Missings", "OrderedCollections", "Parameters", "PrettyTables", "ProgressMeter", "Random", "ScientificTypes", "Serialization", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "0b7307d1a7214ec3c0ba305571e713f9492ea984"
uuid = "a7f614a8-145f-11e9-1d2a-a57a1082229d"
version = "0.21.14"

[[deps.MLJDecisionTreeInterface]]
deps = ["CategoricalArrays", "DecisionTree", "MLJModelInterface", "Random", "Tables"]
git-tree-sha1 = "90ef4d3b6cacec631c57cc034e1e61b4aa0ce511"
uuid = "c6f25543-311c-4c74-83dc-3ea6d1015661"
version = "0.4.2"

[[deps.MLJEnsembles]]
deps = ["CategoricalArrays", "CategoricalDistributions", "ComputationalResources", "Distributed", "Distributions", "MLJBase", "MLJModelInterface", "ProgressMeter", "Random", "ScientificTypesBase", "StatsBase"]
git-tree-sha1 = "95b306ef8108067d26dfde9ff3457d59911cc0d6"
uuid = "50ed68f4-41fd-4504-931a-ed422449fee0"
version = "0.3.3"

[[deps.MLJFlow]]
deps = ["MLFlowClient", "MLJBase", "MLJModelInterface"]
git-tree-sha1 = "bceeeb648c9aa2fc6f65f957c688b164d30f2905"
uuid = "7b7b8358-b45c-48ea-a8ef-7ca328ad328f"
version = "0.1.1"

[[deps.MLJIteration]]
deps = ["IterationControl", "MLJBase", "Random", "Serialization"]
git-tree-sha1 = "be6d5c71ab499a59e82d65e00a89ceba8732fcd5"
uuid = "614be32b-d00c-4edb-bd02-1eb411ab5e55"
version = "0.5.1"

[[deps.MLJModelInterface]]
deps = ["Random", "ScientificTypesBase", "StatisticalTraits"]
git-tree-sha1 = "d2a45e1b5998ba3fdfb6cfe0c81096d4c7fb40e7"
uuid = "e80e1ace-859a-464e-9ed9-23947d8ae3ea"
version = "1.9.6"

[[deps.MLJModels]]
deps = ["CategoricalArrays", "CategoricalDistributions", "Combinatorics", "Dates", "Distances", "Distributions", "InteractiveUtils", "LinearAlgebra", "MLJModelInterface", "Markdown", "OrderedCollections", "Parameters", "Pkg", "PrettyPrinting", "REPL", "Random", "RelocatableFolders", "ScientificTypes", "StatisticalTraits", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "410da88e0e6ece5467293d2c76b51b7c6df7d072"
uuid = "d491faf4-2d78-11e9-2867-c94bc002c0b7"
version = "0.16.17"

[[deps.MLJNaiveBayesInterface]]
deps = ["LogExpFunctions", "MLJModelInterface", "NaiveBayes"]
git-tree-sha1 = "65c8eb0f1da7380f1660201c7ca14d085602ad90"
uuid = "33e4bacb-b9e2-458e-9a13-5d9a90b235fa"
version = "0.1.6"

[[deps.MLJTuning]]
deps = ["ComputationalResources", "Distributed", "Distributions", "LatinHypercubeSampling", "MLJBase", "ProgressMeter", "Random", "RecipesBase"]
git-tree-sha1 = "02688098bd77827b64ed8ad747c14f715f98cfc4"
uuid = "03970b2e-30c4-11ea-3135-d1576263f10f"
version = "0.7.4"

[[deps.MLJXGBoostInterface]]
deps = ["MLJModelInterface", "SparseArrays", "Tables", "XGBoost"]
git-tree-sha1 = "988c399a352f0b49bc1345c509d8a4800cb468c5"
uuid = "54119dfa-1dab-4055-a167-80440f4f7a91"
version = "0.3.10"

[[deps.MPICH_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "d8a7bf80c88326ebc98b7d38437208c3a0f20725"
uuid = "7cb0a576-ebde-5e09-9194-50597f1243b4"
version = "4.2.1+0"

[[deps.MPIPreferences]]
deps = ["Libdl", "Preferences"]
git-tree-sha1 = "c105fe467859e7f6e9a852cb15cb4301126fac07"
uuid = "3da0fdf6-3ccc-4f1b-acd9-58baa6c99267"
version = "0.1.11"

[[deps.MPItrampoline_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "3f884417b47a96d87e7c6219f8f7b30ce67f4f2c"
uuid = "f1f71cc9-e9ae-5b93-9b94-4fe0e1ad3748"
version = "5.3.3+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MicrosoftMPI_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f12a29c4400ba812841c6ace3f4efbb6dbb3ba01"
uuid = "9237b28f-5490-5468-be7b-bb81f5f5e6cf"
version = "10.1.4+2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NaiveBayes]]
deps = ["Distributions", "HDF5", "Interpolations", "KernelDensity", "LinearAlgebra", "Random", "SparseArrays", "StatsBase"]
git-tree-sha1 = "3e8f66cad75d84820bf146ad3ae3785836497258"
uuid = "9bbee03b-0db5-5f46-924f-b5c9c21b8c60"
version = "0.5.5"

[[deps.NearestNeighborModels]]
deps = ["Distances", "FillArrays", "InteractiveUtils", "LinearAlgebra", "MLJModelInterface", "NearestNeighbors", "Statistics", "StatsBase", "Tables"]
git-tree-sha1 = "e411143a8362926e4284a54e745972e939fbab78"
uuid = "636a865e-7cf4-491e-846c-de09b730eb36"
version = "0.2.3"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded64ff6d4fdd1cb68dfcbb818c69e144a5b2e4c"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.16"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "e64b4f5ea6b7389f6f046d13d4896a8f9c1ba71e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenML]]
deps = ["ARFFFiles", "HTTP", "JSON", "Markdown", "Pkg", "Scratch"]
git-tree-sha1 = "6efb039ae888699d5a74fb593f6f3e10c7193e33"
uuid = "8b6db2d4-7670-4922-a472-f9537c81ab66"
version = "0.3.1"

[[deps.OpenMPI_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "PMIx_jll", "TOML", "Zlib_jll", "libevent_jll", "prrte_jll"]
git-tree-sha1 = "f46caf663e069027a06942d00dced37f1eb3d8ad"
uuid = "fe0851c0-eecd-5654-98d4-656369965a5c"
version = "5.0.2+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3da7367955dcc5c54c1ba4d402ccdc09a1a3e046"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+1"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PMIx_jll]]
deps = ["Artifacts", "Hwloc_jll", "JLLWrappers", "Libdl", "Zlib_jll", "libevent_jll"]
git-tree-sha1 = "360f48126b5f2c2f0c833be960097f7c62705976"
uuid = "32165bc3-0280-59bc-8c0b-c33b6203efab"
version = "4.2.9+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

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

[[deps.PrettyPrinting]]
git-tree-sha1 = "142ee93724a9c5d04d78df7006670a93ed1b244e"
uuid = "54e16d92-306c-5ea0-a30b-337be88ac337"
version = "0.4.2"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "763a8ceb07833dd51bb9e3bbca372de32c0605ad"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

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

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "3aac6d68c5e57449f5b9b865c9ba50ac2970c4cf"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.42"

[[deps.ScientificTypes]]
deps = ["CategoricalArrays", "ColorTypes", "Dates", "Distributions", "PrettyTables", "Reexport", "ScientificTypesBase", "StatisticalTraits", "Tables"]
git-tree-sha1 = "75ccd10ca65b939dab03b812994e571bf1e3e1da"
uuid = "321657f4-b219-11e9-178b-2701a2544e81"
version = "3.0.2"

[[deps.ScientificTypesBase]]
git-tree-sha1 = "a8e18eb383b5ecf1b5e6fc237eb39255044fd92b"
uuid = "30f210dd-8aff-4c5f-94ba-8e64358c1161"
version = "3.0.0"

[[deps.ScikitLearnBase]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "7877e55c1523a4b336b433da39c8e8c08d2f221f"
uuid = "6e75b9c4-186b-50bd-896f-2d2496a4843e"
version = "0.5.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.ShowCases]]
git-tree-sha1 = "7f534ad62ab2bd48591bdeac81994ea8c445e4a5"
uuid = "605ecd9f-84a6-4c9e-81e2-4798472b76a3"
version = "0.1.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

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

[[deps.SparseInverseSubset]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "52962839426b75b3021296f7df242e40ecfc0852"
uuid = "dc90abb0-5640-4711-901d-7e5b23a2fada"
version = "0.1.2"

[[deps.SparseMatricesCSR]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "38677ca58e80b5cad2382e5a1848f93b054ad28d"
uuid = "a0a7dd2c-ebf4-11e9-1f05-cf50bc540ca1"
version = "0.6.7"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "d2fdac9ff3906e27f7a618d47b676941baa6c80c"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.10"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "5d66818a39bb04bf328e92bc933ec5b4ee88e436"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.5.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "30b9236691858e13f167ce829490a68e1a597782"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "3.2.0"

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
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

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
weakdeps = ["Adapt", "GPUArraysCore", "SparseArrays", "StaticArrays"]

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

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

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TranscodingStreams]]
git-tree-sha1 = "71509f04d045ec714c4748c785a59045c3736349"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.7"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "6129a4faf6242e7c3581116fbe3270f3ab17c90d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.67"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "5f24e158cf4cee437052371455fe361f526da062"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.6"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XGBoost]]
deps = ["AbstractTrees", "CEnum", "JSON3", "LinearAlgebra", "OrderedCollections", "SparseArrays", "SparseMatricesCSR", "Statistics", "Tables", "XGBoost_jll"]
git-tree-sha1 = "bacb62e07d104630094c8dac2fd070f5d4b9b305"
uuid = "009559a3-9522-5dbb-924b-0b6ed2b22bb9"
version = "2.5.1"

    [deps.XGBoost.extensions]
    XGBoostCUDAExt = "CUDA"
    XGBoostTermExt = "Term"

    [deps.XGBoost.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    Term = "22787eb5-b846-44ae-b979-8e399b8463ab"

[[deps.XGBoost_jll]]
deps = ["Artifacts", "CUDA_Runtime_jll", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "1c0aa2390a7ebb28a3d6c214f64e57a24091fbd7"
uuid = "a5c6f535-4255-5ca2-a466-0e519f119c46"
version = "2.0.1+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zygote]]
deps = ["AbstractFFTs", "ChainRules", "ChainRulesCore", "DiffRules", "Distributed", "FillArrays", "ForwardDiff", "GPUArrays", "GPUArraysCore", "IRTools", "InteractiveUtils", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NaNMath", "PrecompileTools", "Random", "Requires", "SparseArrays", "SpecialFunctions", "Statistics", "ZygoteRules"]
git-tree-sha1 = "4ddb4470e47b0094c93055a3bcae799165cc68f1"
uuid = "e88e6eb3-aa80-5325-afca-941959d7151f"
version = "0.6.69"

    [deps.Zygote.extensions]
    ZygoteColorsExt = "Colors"
    ZygoteDistancesExt = "Distances"
    ZygoteTrackerExt = "Tracker"

    [deps.Zygote.weakdeps]
    Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
    Distances = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "27798139afc0a2afa7b1824c206d5e87ea587a00"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.5"

[[deps.libaec_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "46bf7be2917b59b761247be3f317ddf75e50e997"
uuid = "477f73a3-ac25-53e9-8cc3-50b2fa2566f0"
version = "1.1.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevent_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "OpenSSL_jll"]
git-tree-sha1 = "f04ec6d9a186115fb38f858f05c0c4e1b7fc9dcb"
uuid = "1080aeaf-3a6a-583e-a51c-c537b09f60ec"
version = "2.1.13+1"

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

[[deps.prrte_jll]]
deps = ["Artifacts", "Hwloc_jll", "JLLWrappers", "Libdl", "PMIx_jll", "libevent_jll"]
git-tree-sha1 = "5adb2d7a18a30280feb66cad6f1a1dfdca2dc7b0"
uuid = "eb928a42-fffd-568d-ab9c-3f5d54fc65b9"
version = "3.0.2+0"
"""

# ╔═╡ Cell order:
# ╠═e3174c82-eb1c-11ed-05cd-b1b3fe800222
# ╠═8fe5ad69-945f-4a7f-86cd-aa2400c02940
# ╠═ecef4cc4-3f66-4459-9cc6-88900b0b49e6
# ╠═05eca293-f707-4f41-8cfe-cf4c1628a56a
# ╠═888371ce-a188-49c6-84a9-37aac25cd6a8
# ╠═05cda491-e45d-4c3f-b099-a792b035d4ed
# ╠═e390a3f0-0d4d-4499-9917-1d4433a9c7ca
# ╠═28ccb6fd-dc31-4ea3-a416-dc6aa45e53e1
# ╟─aa7912e1-f298-412c-a5ee-60a998d86ee7
# ╠═5bedd223-2d0f-4537-ad58-7111f3950762
# ╠═e477c42e-3fd1-4f41-b6fc-d2e682cef0bb
# ╠═67cab88b-dcf2-4ac6-a082-9285f341ecbf
# ╠═2df651e2-d66a-4071-9c8c-2e379abfe334
# ╠═20935091-4d7b-472c-b32b-25d717d37cf7
# ╠═6a4eaadb-beab-46c6-a066-f069f12579a1
# ╠═c465bc4a-06e5-479f-953f-b8578174caca
# ╠═d71dfbee-6d35-4da3-9af9-5d404cd8b824
# ╠═ca1da493-245d-4962-b150-22fce25b4e95
# ╟─5bf4e368-d8ba-4fe5-9033-9f79b74d5651
# ╠═3859e530-0eff-4b0d-b3eb-0821dac00124
# ╠═5eeb8a81-1461-49f0-994f-9eb965861859
# ╟─a236f70b-8e0c-4d3c-855a-0d66222e92b7
# ╠═a3167f7a-374d-4a87-989f-deab4f1302e6
# ╠═f8214d53-51c8-4cb1-baf9-1c6d2a7e81d1
# ╟─c3e7514e-802c-4f3c-ab47-ec57a856d866
# ╠═170cc719-f924-44b9-aa3c-d92d0f946520
# ╟─c65471f5-0579-413e-8173-366d5ddfeee5
# ╠═156eb3ff-964c-4412-b7b9-3b188a7e402b
# ╟─13101220-9fec-4809-884a-bfeef608777a
# ╠═97bba1f9-ccc2-49eb-b924-54fa74093b9c
# ╟─fd762ff7-08ed-48c0-bfd3-846fee87014f
# ╠═2c9fd713-a60e-48f1-b7a7-2b4d16ab3e99
# ╠═1d8e3f90-38e1-4302-ac74-709ff235784b
# ╟─0ee7514e-6f91-4e83-82b8-54cb6cb44deb
# ╠═e10b524f-c25f-4e3b-bac2-1c646b8a6879
# ╟─e50087d7-4449-4aab-b04c-ffe86c97ccb9
# ╠═c07fe7c1-5f2b-4a03-9c3b-5e04eb270e41
# ╠═af001d41-4e03-47dd-a501-c55fbfdf365a
# ╟─b71f529a-a12a-48dd-9481-9e60fa5a934f
# ╠═d4b467a2-0fd7-4044-9fdd-bddd3d31e08b
# ╠═de3ae8f9-20a3-4372-83cf-befb2e3d52b6
# ╠═567b3baa-9dbe-4a4e-94b4-95d7c21a3393
# ╠═0e962366-6eeb-4847-93eb-7f345a870a3e
# ╠═4d3903cc-a9b4-4e5e-96f8-09ea4f5c8779
# ╠═553a527f-bcc1-4bf0-9fc8-739768918b84
# ╠═a79d6ebe-6389-4a79-a575-1716637f9949
# ╟─6952d91d-3a03-4190-a5a0-9514e845dfa8
# ╠═b0983a06-c67e-4c2b-bbc6-41ba87f5414f
# ╠═8e7085a6-d4cf-4bc9-b18c-ff913acda6c4
# ╟─eaec9ada-bec5-4121-86b9-11668c87aa6b
# ╠═e2ae8e73-700b-4dc3-8ca7-ca77487367c8
# ╠═b75de4db-0686-4e5d-8450-5c15eb345800
# ╠═229b00c1-d8b5-43cf-a21c-c8c38615172c
# ╠═db3efefc-179d-49d1-a5ff-e33ea98a5f84
# ╠═905e3990-a015-4a2d-8435-9a4341970529
# ╠═1daca5ef-bfdd-410f-9e51-6489b3ddc0fa
# ╠═c5c9f36f-96bd-4449-adf6-c33fe9304a7f
# ╠═04f5c592-086c-4f89-8727-3c5ff14db366
# ╠═a9ed5add-f537-45be-b893-3ff15db2ba54
# ╠═1f221bb2-fbc6-45dc-89fa-59949aa969da
# ╟─5e7509f4-27b8-4e2c-89d2-f23b81b65793
# ╟─32f83d73-8a90-4651-b435-a9a7ee33681f
# ╠═66ba2f79-eb10-4ea3-8566-8547ee8147df
# ╠═977095fb-c564-48ff-b6e3-c588c6ddd7d0
# ╠═030859b4-ec8b-4167-b994-28c8e723f049
# ╠═ebf4d337-56c5-4f7d-9db8-6ef62778fc18
# ╠═95cd012a-2cd4-426f-81dc-be835f68160c
# ╠═faf553bf-a730-416b-a423-945281337fbc
# ╟─55fdd78b-5b62-46e5-8744-78b3a7bfdc86
# ╠═4f772515-a727-4ed4-937f-147873704687
# ╠═856e731d-4713-484e-8e35-17678eaf5f48
# ╠═632883ce-ac35-42cc-8235-b33c83be9b5c
# ╠═0eeea922-09af-4cf7-99d5-a4b3fa9e7ace
# ╠═e17f2106-b93b-4cab-926a-e8c8143e1df3
# ╠═a9fff7e3-852b-40c7-8e34-b794df35c2ca
# ╟─ae24f188-88e5-45cd-a174-093e972476fe
# ╠═47a5c810-3d48-4272-84ae-f4c6981a062e
# ╠═34c0ce71-aa17-4c86-bdd0-39737e696026
# ╠═2ec39c32-f5fb-41be-a8e6-1b26f94451ea
# ╠═aa3aa791-73f4-4283-b609-9b33b673879c
# ╠═19d34f1f-0f7a-4da2-8bbd-46e5261c9d76
# ╠═5b198b9a-6cde-438c-afe6-26e4e712a0eb
# ╟─8c19e28f-4642-42b8-9f14-641d4425230d
# ╠═0e239f17-04f3-4f15-b21d-afa131002804
# ╟─685ddaa3-3dd5-4bc4-8471-2f378130559d
# ╠═6f6d2c41-41d0-4b7a-8bcc-759979ed89c0
# ╠═731508f9-9389-48b3-85b6-b493dc39fbe9
# ╠═59c5d7b7-c3b0-4261-a3c7-4c8845d161aa
# ╟─838faf88-8f18-42ec-8f0e-b6b43c6312cd
# ╟─f1ab828a-54db-40c0-b75d-734edf118902
# ╠═42f8024d-4a30-4d81-8f27-7072ce2b482a
# ╟─aca9bb94-54aa-4311-967e-b73200ff0830
# ╟─b72d3213-56fe-484e-8b2d-eb0b4d6d158a
# ╠═c1801e55-7539-4276-9f34-913e57884398
# ╟─4932260a-a6e4-4fa8-a166-df6d3b3f05d3
# ╠═a8e10e3d-9be5-4e53-8403-f170248d219a
# ╠═15e0c46d-38ff-49c1-bb11-948a96f8e8bc
# ╟─76cbbbfa-f178-45a8-8415-d1d293b000d1
# ╟─8014496b-e808-451e-8564-73a73c927a01
# ╠═2c7696cd-a3ee-431e-8d67-8af12ec36d9d
# ╟─8d553aec-383d-4440-8fce-810cb75e708c
# ╟─8c17090f-4c7a-49fa-b370-870224fa686e
# ╠═d7961543-1b0c-438b-a006-544c5f4b51cd
# ╟─6949712b-a489-44c5-9e1b-e6dff2d69812
# ╠═7892eebd-4390-4b4b-af61-44c19d364dc9
# ╟─abe26275-ea61-47cc-bfe2-f673f1a4db34
# ╠═ca56fb57-dd93-4b04-a8bc-459cd6bb9f4f
# ╟─8d23b8a6-d4a7-4679-8edb-11f8a3be6e70
# ╟─904e56a6-6251-4706-bf0d-b5da9c34b90f
# ╠═4f192a77-b80e-449e-b4cd-5c8955df4656
# ╟─b53c042d-b951-4baa-aea1-a2fe0fec1cd8
# ╟─43f0e025-9b01-4946-8031-f2f606fe493c
# ╠═8e9593b9-82bd-484e-99aa-d915f2212d98
# ╠═c8ac17e6-b852-4f61-88e3-a8344097f6c6
# ╟─ef12d148-82ab-46b9-9a6c-c2425f307330
# ╠═857214e6-9737-4844-9634-a03b5e55a815
# ╠═677367c5-cbea-4b52-b7d1-190ef607bd8d
# ╟─19e601ca-375e-4e9f-9887-3ef343be0983
# ╟─8ec95f1f-caf5-4941-b1ee-777df154a80f
# ╠═84f8e135-ff33-4d92-9cdd-bcdce90b5da6
# ╟─fa50d080-3f02-478b-952a-ade312845243
# ╠═cc7051d3-f120-48e4-a0fd-bca759b0f9e6
# ╠═1676b077-082c-4911-8b43-cc38d746b66d
# ╟─0b37fd3d-5bb1-48da-8a39-f42a4e6d4607
# ╠═b7eb90fe-84f7-4bd2-9ce3-d8a301a7c640
# ╟─b58b5a65-72f3-49d9-bcfe-4c914350df73
# ╠═621ecbe3-b99e-4e26-8049-b24cd6b1c1b0
# ╟─d4b944a0-b738-483f-b839-e28e67504d12
# ╠═7934f22f-f5a1-4d3b-bcbc-4c5491980931
# ╟─e3aaee25-302e-4838-8085-34a27b66110f
# ╠═41331b5d-417d-4558-a207-be5c92067580
# ╟─386e67b4-1ebf-4d0f-843b-a974b5ebf5e1
# ╟─436cdaaa-50b8-4bd2-84b9-ca7f57ceb744
# ╠═33d056d5-7770-49b5-9c9e-eed3103400e3
# ╠═13c4c06e-b2d8-426e-8d06-984a0f5befd8
# ╠═12e8a411-c8c2-410c-adea-7a9171846761
# ╟─d4a98628-2228-4699-935f-d7a148c50ba9
# ╠═c8d2f8aa-76e3-4ceb-ad99-ef7baa292539
# ╠═ed9094e8-0ae0-4f59-9cc9-5c5795759e98
# ╠═d94cfbb7-f2c3-41fe-b6c6-941117e2054e
# ╠═a4102337-e061-487f-b877-d74f0750146f
# ╠═cafaf57d-b429-40fc-aca4-8d859947b98a
# ╠═c89942d3-b00b-43f5-a780-0137121b611d
# ╠═26515812-5926-4fde-bb79-744fbde21b6f
# ╟─735c9714-42e6-4a80-8fee-cfb1fdfc5df7
# ╠═0d4630db-5c06-4fbb-b48e-955fcf295a87
# ╠═3aac04af-a28a-4844-b8c9-80ed380dcb49
# ╠═2668992c-8823-40c0-936e-fd8417f9a14d
# ╟─eac7a2db-bf87-4009-99e5-6516b82c18a1
# ╟─a2eb4a4a-65d6-4131-9c52-cec82f496467
# ╟─af1ef2da-82b7-4a5d-ac28-451d8268b95e
# ╟─98d0aacf-8f5a-47af-ab19-b3739975832b
# ╠═d6b4fd91-f29e-4f83-92ad-4d723a8af9fb
# ╟─1910bb5e-ee1a-4bd5-aa5b-ceca5f052b86
# ╠═9d1eb86f-6310-4263-9c21-1828dddc2708
# ╟─7be5cfc8-793b-435c-afc1-f10189d07740
# ╟─212924bf-80a6-4016-8c1c-8dbb538f7a33
# ╠═c87d3d4c-d334-4cdb-a437-cb3ec37553c6
# ╠═69a90372-e2f0-4b00-a6fa-ab5d8448e427
# ╠═f05656f7-3162-4e47-ab75-9effde7901b4
# ╠═be0e1201-b1a9-4186-90c2-50abd847d809
# ╠═9716d66e-1e5e-4527-a901-3929377215b2
# ╠═f3aecc74-89f8-4c2d-85bf-37808130d2b3
# ╟─3b048af1-cf0c-4fd7-b895-09382b1108d4
# ╠═cf80ce08-d7b2-420f-8b89-48832bdb5b1d
# ╠═24f35b88-fe7d-42da-8341-acd15292b7eb
# ╠═f5c8a235-52b7-4d5e-91d1-4e1d046ccdb3
# ╟─b32a8bf0-5119-4685-b4ae-52537222e9b5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
