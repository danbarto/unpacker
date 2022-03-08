using Random
using Printf

include("utils.jl")
include("common.jl")

function header_word(event::Event)
    begin_tag::UInt64 = 0x0
    start_sequence::UInt64 = 0x3555555 #26 bits
    bcid::UInt64 = event.BCID
    header::UInt64 = bcid | start_sequence << 12
    return (begin_tag << 38) | header
end

function filler_word()
    begin_tag::UInt64 = 0x3
    fill_sequence::UInt64 = 0x0aaaaaaaaa
    return (begin_tag << 38) | fill_sequence
end

function parity(num::UInt64)
    return isodd(count_ones(num))
end

function trailer_word(hits::Int64)
    begin_tag::UInt64 = 0x2
    start_sequence::UInt64 = 0x5555555
    word::UInt64 = (start_sequence << 9) | hits
    word = (begin_tag << 37) | word
    word = (word << 1) | parity(word)
    return word 
end

function pixel_data_word(pixel::Pixel)
    toa::UInt64 = pixel.TOA
    tot::UInt64 = pixel.TOT
    row::UInt64 = pixel.row
    col::UInt64 = pixel.col
    begin_tag::UInt64 = 0x1
    word::UInt64 = (toa << 19) | (tot << 10) | pixel.CAL
    word = (row << 33) | (col << 29) | word
    word = (begin_tag << 37) | word
    word = (word << 1) | parity(word)
    return word
end

function data_frame(event::Event)
    frame::Vector{UInt64} = [header_word(event)]
    pixel_hits = get_pixel_hits(event)
    for h in pixel_hits
        push!(frame, pixel_data_word(h))
    end
    push!(frame, trailer_word(length(pixel_hits)))
    return frame
end

function write_stream(events::Vector{Event}, num_filler::Int=10)
    num_events::Int = length(events)
    remaining_filler::Int = 0
    stream::Vector{UInt64} = UInt64[]
    for evt in events
        filler_before::Int = rand(0:(num_filler//num_events))
        filler_after::Int = (num_filler//num_events) - filler_before
        for f in 1:filler_before
            push!(stream, filler_word())
            remaining_filler += 1
        end
        append!(stream, data_frame(evt)) #add the event
        for f in 1:filler_after
            push!(stream, filler_word())
            remaining_filler += 1
        end
    end
    for f in 1:(num_filler-remaining_filler)
        push!(stream, filler_word())
    end
    return stream
end

function dump_stream(stream::Vector{UInt64})
    word_list = Vector{String}()
    for word in stream
        word_string = string(word, base = 16, pad=10)
        # could assert sth here
        push!(word_list, word_string)
    end

    long_word = join(word_list)
    lines = chunk_string(long_word, 10)  # 5 bytes per line

    open("dump.hex", "w") do file
        for line in lines
            single_bytes = chunk_string(line, 2)
            write(file, join(single_bytes, " ")*"\n")
        end
    end
end
