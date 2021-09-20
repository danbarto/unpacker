using Random
using Printf

include("utils.jl")
include("common.jl")
include("packer.jl")

function read_data_frame(card::Vector{UInt64}) #cannot read a datacard with filler
    # FIXME we should define the data format somewhere else, and not hard code it here.
    head::UInt64 = card[1]
    @assert (head >> 12) == 0x3555555 #check that header is correct
    pixels = Vector{Pixel}(undef, 256)
    reset_pixelarray!(pixels)
    num_hits::UInt64 = length(card) - 2
    bcid::UInt16 = head & 0xfff #first 12 bits
    for hit in 2:(num_hits+1)
        word::UInt64 = card[hit]
        @assert !parity(word) #parity check
        @assert (word >> 38) == 0x1 #bits 38-40 must be 0x1
        CAL::UInt16 = (word >> 1)  & 0x3ff #bits 2-11
        TOT::UInt16 = (word >> 11) & 0x1ff #bits 12-20
        TOA::UInt16 = (word >> 20) & 0x3ff #bits 21-30
        col::UInt16 = (word >> 30) & 0x00f #bits 31-34
        row::UInt16 = (word >> 34) & 0x00f #bits 35-38
        pixels[(row << 4) | col] = Pixel(row, col, 1, TOA, TOT, CAL)
    end
    trail::UInt64 = card[end]
    @assert !parity(trail) #parity check
    #bits 11-38 = 0x5555555, bits 39-40 = 0x2
    @assert (trail >> 10) == 0x25555555
    @assert ((trail >> 1) & 0x1ff) == num_hits #bits 2-10 are num_hits
    return Event(bcid, pixels)
end

function read_stream(stream::Vector{UInt64}) #read a continuous stream of words
    num_filler::Int = 0
    num_events::Int = 0
    num_hits::Int = 0
    bcid::UInt16 = 0
    events::Vector{Event} = Event[]
    pixels = Vector{Pixel}(undef, 256)
    reset_pixelarray!(pixels)
    in_event::Bool = false
    for word in stream
        if word == filler_word()
            @assert !in_event
            num_filler::Int += 1
        elseif (word >> 12) == 0x3555555 #tag for a header word
            @assert !in_event
            num_events::Int += 1
            num_hits = 0
            bcid = word & 0xfff #first 12 bits
            in_event = true
        elseif (word >> 38) == 0x1 #tag for a data word
            @assert(in_event) #make sure that we are in the middle of an event (after a header, before a trailer)
            @assert !parity(word) #parity check
            CAL::UInt16 = (word >> 1)  & 0x3ff #bits 2-11
            TOT::UInt16 = (word >> 11) & 0x1ff #bits 12-20
            TOA::UInt16 = (word >> 20) & 0x3ff #bits 21-30
            col::UInt16 = (word >> 30) & 0x00f #bits 31-34
            row::UInt16 = (word >> 34) & 0x00f #bits 35-38
            pixels[((row << 4) | col)+1] = Pixel(row, col, 1, TOA, TOT, CAL)
            num_hits += 1
        elseif (word >> 10) == 0x25555555 #tag for a trailer word
            @assert !parity(word) #parity check
            @assert ((word >> 1) & 0x1ff) == num_hits #bits 2-10 are num_hits
            @assert in_event
            in_event = false
            num_hits = 0
            push!(events, Event(bcid, copy(pixels))) #copy to prevent deleting contents when we reset the array
            bcid = 0
            reset_pixelarray!(pixels)
        else
            @printf("A word in the data stream was not recognized: %d", word)
        end
    end
    @printf("Number of Events: %d\nNumber of filler words: %d\n", num_events, num_filler)
    return events
end

function load_stream(infile::String)
    f = open(infile, "r")
    lines = readlines(f)
    stream = chunk_string(join(split(join(lines), " ")), 10)
    close(f)
    out = Vector{UInt64}()
    for word in stream
        push!(out, parse(Int, word, base = 16))
    end
    return out
end
