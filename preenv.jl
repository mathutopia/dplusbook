#= 
1.  创建一个.julia文件夹，设置环境变量JULIA_DEPOT_PATH为该文件夹
2. 下载Plots,Pluto, 等到默认的路径下：
3. 在相关文件夹下激活一个环境，安装Pluto即可
4. 安装自己的注册表
5. 是否设置一个bat文件的超链接？

=#
#= 安装如下的包
add Plots, CSV , CategoricalArrays ,DataFrames ,DataFramesMeta ,FreqTables ,PlutoUI ,StatsBase ,StatsPlots ,
AlgebraOfGraphics ,CairoMakie ,ScientificTypes ,Unicode ,MultivariateStats ,Clustering ,Distances ,MLBase ,
DecisionTree ,MLJ ,MLJDecisionTreeInterface ,MLJModels ,BetaML ,Dates ,MLJNaiveBayesInterface ,MLJXGBoostInterface ,
NearestNeighborModels , MLJModelInterface, MLJMultivariateStatsInterface ,ARules ,OutlierDetectionNeighbors,OutlierDetection
using Pkg
Pkg.Registry.add(RegistrySpec(url = "https://github.com/mathutopia/Wlreg.git"))
=#