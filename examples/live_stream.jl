include("../src/common.jl")
include("../src/utils.jl")
include("../src/packer.jl")
include("../src/unpacker.jl")
include("../src/plotting.jl")
include("../src/module.jl")

plot_dir = "./figures"
if !isdir(plot_dir)
    mkdir(plot_dir)
end

function live_stream(nreads::Int)

    events::Vector{Event} = Event[]

    for i = 1:nreads

        println(i)

        test = hex_dump()
        test = convert(Array{UInt}, test)

        stream_from_dump = read_stream(test)

        events = vcat(stream_from_dump, events)

        if sizeof(stream_from_dump)>0

            println("Hit matrix of event 1 after hex dump:")
            print(stream_from_dump[1])
        else
            println("Stream was empty")
        end


        #test_evt = stream_from_dump[1]
        #test_TOT_evt = plot(test_evt, "TOT") #plot the TOT heatmap of a single event
        #plot_name1 = "/TOT.png"
        #plot1 = plot_dir*plot_name1
        #println("Saving plot: %s", plot1)
        #savefig(test_TOT_evt, plot1)
        ##close(test_TOT_evt)

    end

    return events

end

events = live_stream(500)

hit_heatmap = plot(events) #plot the heatmap of all hits from the hex dump file
plot_name2 = "/hit_heatmap.png"
plot2 = plot_dir*plot_name2
println("Saving plot: %s", plot2)
savefig(hit_heatmap, plot2)
#close(hit_heatmap)
