include("../src/common.jl")
include("../src/utils.jl")
include("../src/packer.jl")
include("../src/unpacker.jl")
include("../src/plotting.jl")

plot_dir = "./figures"
if !isdir(plot_dir)
    mkdir(plot_dir)
end

#events::Vector{Event} = Event[]

Random.seed!(1234)  # make it reproducible
num_events = 5000


stream_to_dump = Vector{Event}()
for i = 1:num_events
    n_hits = rand(1:4)
    tmp_event = Event(n_hits)
    push!(stream_to_dump, tmp_event)
#    events = vcat(stream_to_dump, events)
end

dump_stream(write_stream(stream_to_dump, 2*num_events))  # currently need more fillers than actual data

stream_from_dump = read_stream(load_stream("dump.hex"))

println("Hit matrix of event 10 before hex dump:")
get_hit_matrix(stream_to_dump[1])

println("Hit matrix of event 10 after hex dump:")
get_hit_matrix(stream_from_dump[1])

hit_heatmap = plot(stream_from_dump) #plot the heatmap of all hits from the hex dump file
plot_name = "/hit_heatmap_test.png"
hit_plot = plot_dir*plot_name
println("Saving plot: %s", hit_plot)
savefig(hit_heatmap, hit_plot)
