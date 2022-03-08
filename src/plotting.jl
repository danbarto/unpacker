using Plots
include("utils.jl")
include("common.jl")
include("packer.jl")

function plot(event::Event, type::String="TOT")
    #plot a heatmap of values in each pixel. Type options are "TOA", "TOT", and "hit"
    data = get_matrix(event, type)
    heatmap([1:size(data, 1)], [1:size(data,2)], data, size=(700,700),
            xticks=1:16, yticks=1:16, title=type, xlabel="Column", ylabel="Row") 
end

function plot(stream::Vector{Event})
    #plot a hit heatmap for an event stream
    hits = zeros(16,16)
    for evt in stream
        hits = hits + get_matrix(evt, "hit")
    end
    heatmap([1:size(hits, 1)], [1:size(hits,2)], hits, size=(700,700),
            xticks=1:16, yticks=1:16, title="Hits in Each Pixel", xlabel="Column", ylabel="Row",
            c=:OrRd_9, clim=(0,100))
end
