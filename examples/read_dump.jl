include("../src/common.jl")
include("../src/utils.jl")
include("../src/packer.jl")
include("../src/unpacker.jl")
include("../src/plotting.jl")


stream_from_dump = read_stream(load_stream("../data/multiple.hex"))

println("Hit matrix of event 1 after hex dump:")
# print("BCID: ", stream_from_dump[1].BCID, "\n")
# print("number of hits: ", length(get_pixel_hits(stream_from_dump[1])), "\n")
#get_hit_matrix(stream_from_dump[1])
print(stream_from_dump[1])
test_evt = stream_from_dump[3]
plot(test_evt, "TOT")
