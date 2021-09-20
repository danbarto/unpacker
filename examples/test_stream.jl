include("../src/common.jl")
include("../src/utils.jl")
include("../src/packer.jl")
include("../src/unpacker.jl")


stream_to_dump = Vector{Event}()
for i = 1:100
    n_hits = rand(1:4)
    tmp_event = Event(n_hits)
    push!(stream_to_dump, tmp_event)
end

dump_stream(write_stream(stream_to_dump, 200))

stream_from_dump = read_stream(load_stream("dump.hex"))

println("Hit matrix of event 10 before hex dump:")
get_hit_matrix(stream_to_dump[10])

println("Hit matrix of event 10 after hex dump:")
get_hit_matrix(stream_from_dump[10])

