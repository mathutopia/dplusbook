cd(@__DIR__)
using Pkg
Pkg.activate(".")
# pushfirst!(DEPOT_PATH, "D:/.julia")
"Pluto" ∈ keys(Pkg.project().dependencies) && Pkg.add("Pluto")

if !isdir(joinpath(DEPOT_PATH[1],"registries","dplus")) 
    Pkg.Registry.add(RegistrySpec(url = "https://gitee.com/mathutopia/dplusreg.git"))
end

using Pluto
Pluto.run()
#Pluto.run(host="0.0.0.0",port=1234, require_secret_for_access=false,require_secret_for_open_links = false)