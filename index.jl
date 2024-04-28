### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 85cba6b0-1078-495b-9888-6943353b034c
using Box

# ╔═╡ c053c944-c600-4d6c-9b10-b3af15eb4392
maketoc()

# ╔═╡ 6f509f57-9574-405a-9eaa-890249b603e3
md"""
设置仓库路径`DEPOT_PATH`， 主要通过`JULIA_DEPOT_PATH`环境变量设置 

# 安装如下的包

```julia
add Plots, CSV , CategoricalArrays ,DataFrames ,DataFramesMeta ,FreqTables ,PlutoUI ,StatsBase ,StatsPlots ,AlgebraOfGraphics ,CairoMakie ,ScientificTypes ,Unicode ,MultivariateStats ,Clustering ,Distances ,MLBase ,DecisionTree ,MLJ ,MLJDecisionTreeInterface ,MLJModels ,BetaML ,Dates ,MLJNaiveBayesInterface ,MLJXGBoostInterface ,NearestNeighborModels , MLJModelInterface, MLJMultivariateStatsInterface ,ARules ,OutlierDetectionNeighbors,OutlierDetection


using Pkg
Pkg.Registry.add(RegistrySpec(url = "https://github.com/mathutopia/Wlreg.git"))
```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Box = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"

[compat]
Box = "~1.0.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "68906de5f775ed1434647dc50131d3c40655f579"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Box]]
deps = ["HypertextLiteral", "Markdown"]
git-tree-sha1 = "905f28f8e56e7a117d741cf586b011dd68c498d4"
uuid = "247ae7ab-d1b9-4f88-8529-b44b862cffa0"
version = "1.0.13"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"
"""

# ╔═╡ Cell order:
# ╠═85cba6b0-1078-495b-9888-6943353b034c
# ╟─c053c944-c600-4d6c-9b10-b3af15eb4392
# ╟─6f509f57-9574-405a-9eaa-890249b603e3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
