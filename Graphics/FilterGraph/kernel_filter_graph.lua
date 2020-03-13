
local kernel = {}

kernel.language = "glsl"
kernel.category = "filter"
kernel.name = "graphDemo"

kernel.graph = 
{
	nodes = {
		swirl = { effect="filter.swirl", input1="paint1" },
		scatter = { effect="filter.scatter", input1="swirl" },
	},
	output = "scatter",
}

return kernel
