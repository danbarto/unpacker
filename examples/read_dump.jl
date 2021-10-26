include("../src/common.jl")
include("../src/utils.jl")
include("../src/packer.jl")
include("../src/unpacker.jl")


stream_from_dump = read_stream(load_stream("multiple.hex"))

println("Hit matrix of event 1 after hex dump:")
get_hit_matrix(stream_from_dump[1])

