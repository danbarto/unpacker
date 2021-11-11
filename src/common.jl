using Random
using Printf
using Crayons

struct Pixel
    row::UInt16 #4 bits
    col::UInt16 #4 bits
    hit::Bool
    TOA::UInt16 #10 bits
    TOT::UInt16 #9 bits
    CAL::UInt16 #10 bits
end
#outer constructor
Pixel(row, col) = Pixel(row, col, 0, 0, 0, 0)

struct Event
    BCID::UInt16 #12 bits
    pixels::Vector{Pixel} #array of pixel objects
end

struct HitMatrix
    vals::Array{Integer}
end

function Base.show(io::IO, pixel::Pixel)
    print(io, "Pixel (", pixel.row, ",", pixel.col, ") Data:\n")
    print(io, "Hit: ", pixel.hit, "\nTOA: ", pixel.TOA, "\n")
    print(io, "TOT: ", pixel.TOT, "\nCAL: ", pixel.CAL, "\n")
end

function Base.show(io::IO, event::Event, show_map::Bool=false)
    print(io, "Event Data:\n")
    print(io, "BCID:", event.BCID, "\n")
    print(io, "Number of hits:", length(get_pixel_hits(event)), "\n")
    get_hit_matrix(event)
end

function Base.show(io::IO, hm::HitMatrix)
    for i = 1:size(hm.vals)[1]
        for j = 1:size(hm.vals)[2]
            if hm.vals[i,j] == 0
                print(io, Crayon(foreground = :green, bold=false), "O  ")
            elseif hm.vals[i,j] == 1
                print(io, Crayon(foreground = :red, bold=true), "X  ")
            end
            
        end
        println(Crayon(foreground = :default, bold=false))
    end
end

function pixel_hit(row, col)
    return Pixel(row, col, 1, rand(0:(2^10-1)), rand(0:(2^9-1)), rand(0:(2^10-1)))
end

function reset_pixelarray!(pixelarray::Vector{Pixel})
    for i = 0:255 #initialize all pixels to zero
        pixelarray[i+1] = Pixel((i >> 4), (i & 0x0f))
    end
end

function get_pixel_hits(event::Event)
    hit_pixels::Vector{Pixel} = []
    for i = 1:256
        if event.pixels[i].hit
            push!(hit_pixels, event.pixels[i])
        end
    end
    return hit_pixels
end

function get_hit_matrix(event::Event)
    print("Map of hits:\n")
    hitmap = zeros(16,16)
    for h in get_pixel_hits(event)
        hitmap[h.row+1, h.col+1] = 1
    end
    HM = HitMatrix(hitmap)
    print(HM)
end

function Event()
    pixels = Vector{Pixel}(undef, 256)
    for i = 0:255
        pixels[i+1] = Pixel((i >> 4), (i & 0x0f))
    end
    BCID = rand(0:(2^12-1))
    return Event(BCID, pixels)
end

function Event(num_hits::Int) #generate event with given number of random hits 
    pixels = Vector{Pixel}(undef, 256)
    #toa = zeros(16,16)  # TOA array
    for i = 0:255 #fill all pixels
        pixels[i+1] = Pixel((i >> 4), (i & 0x0f))
    end
    BCID = rand(0:(2^12-1))
    #generate hits
    @assert num_hits <= 256
    empty_pixels = Set(0:255)
    for i = 1:num_hits
        pix = rand(empty_pixels)
        setdiff!(empty_pixels, pix) #remove hit pixel from set
        row = pix >> 4
        col = pix & 0x0f
        pixels[pix+1] = pixel_hit(row, col)
        #toa[row][col] = pixels[pix+1].TOA
    end
    return Event(BCID, pixels)   
end

function get_DataFrame(event::Event)
    df = DataFrame(row=UInt[], col = UInt[], TOA=UInt[], TOT=UInt[], CAL=UInt[])
    for i = 1:256
        pix = event.pixels[i]
        if pix.hit
            push!(df, (pix.row, pix.col, pix.TOA, pix.TOT, pix.CAL))
        else
            push!(df, (pix.row, pix.col, 0, 0, 0))
        end
    end
    return df
end
