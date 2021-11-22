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
test_evt = stream_from_dump[1]
test_TOT_evt = plot(test_evt, "TOT") #plot the TOT heatmap of a single event
savefig(test_TOT_evt, "./figures/TOT.png")
close(test_TOT_evt)
hit_heatmap = plot(stream_from_dump) #plot the heatmap of all hits from the hex dump file
savefig(hit_heatmap, "./figures/hit_heatmap.png")
close(hit_heatmap)
