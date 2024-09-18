### A Pluto.jl notebook ###
# v0.19.41

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

# ╔═╡ d889eaaa-749f-11ef-3ea7-d33611cd7569
begin
	# 如果当前目录下，有Project， 那就用当前目录的，否则就用父目录的工程文件。
	import Pkg
	env = ifelse(isfile("Project.toml"), ".", joinpath(@__DIR__,".."))
	Pkg.activate(env)
end

# ╔═╡ 8e704de9-8522-4dcb-b84a-069d10daf340
using Tidier

# ╔═╡ 2646c5a4-05a2-4691-9976-cc70052a20e9
using PlutoUI

# ╔═╡ 596406bb-ccd6-4032-8931-63a936b5b9ed
df = DataFrame(a = rand('a':'z', 1000), b = rand(1000), c=rand('a':'d', 1000))

# ╔═╡ 9efae5d1-2184-4fc2-9c3a-4a71624af138
@bind col Select(names(df))

# ╔═╡ df3a6ff5-648a-4a81-a63e-21a7cc404360
is_string(df[:, string(col)])

# ╔═╡ 99b88146-3b2e-49f2-8c9e-11a7ffcca1ac
if is_string(df[:, string(col)])
	@bind m TextField()
end

# ╔═╡ 7e94e501-291c-49a6-86fe-7d56070b5533
dfn = DataFrame()

# ╔═╡ 797b1d71-59a1-453f-8c22-2fde0a33d613
function generate_code()
    return println("""
	# 这是可以不管
	a = sin(x)
	b = sdf # 这是注释
	""")
end
	

# ╔═╡ 8d7fe8fb-b5b3-4071-931c-2e563f6aee91
generate_code()

# ╔═╡ be8bfb10-ce79-4c34-a301-23e19575b0ab
println(generate_code())

# ╔═╡ a489b88c-d39a-42da-87f1-bdb8a2ae76b2
md"""
println("Hello, World!")
x = 10
y = 20
println("Sum of x and y is ", x + y)
"""

# ╔═╡ 5164b9a4-9d32-4042-b171-4cef1d23ceb8
println(output)

# ╔═╡ 4786b927-5e3a-446d-a369-f09e41e24dd6
test()

# ╔═╡ 28abf1da-4552-48b4-af69-cada8ecac447
md"""
# 这是注释\nx = sin(x)\ny = sin(y)\n\n
"""

# ╔═╡ Cell order:
# ╠═d889eaaa-749f-11ef-3ea7-d33611cd7569
# ╠═8e704de9-8522-4dcb-b84a-069d10daf340
# ╠═2646c5a4-05a2-4691-9976-cc70052a20e9
# ╠═596406bb-ccd6-4032-8931-63a936b5b9ed
# ╠═9efae5d1-2184-4fc2-9c3a-4a71624af138
# ╠═df3a6ff5-648a-4a81-a63e-21a7cc404360
# ╠═99b88146-3b2e-49f2-8c9e-11a7ffcca1ac
# ╠═7e94e501-291c-49a6-86fe-7d56070b5533
# ╠═797b1d71-59a1-453f-8c22-2fde0a33d613
# ╠═8d7fe8fb-b5b3-4071-931c-2e563f6aee91
# ╠═be8bfb10-ce79-4c34-a301-23e19575b0ab
# ╠═a489b88c-d39a-42da-87f1-bdb8a2ae76b2
# ╠═5164b9a4-9d32-4042-b171-4cef1d23ceb8
# ╠═4786b927-5e3a-446d-a369-f09e41e24dd6
# ╠═28abf1da-4552-48b4-af69-cada8ecac447
