function chunk_string(word::String, max_n::Int=2)
    out = Vector{String}()
    j = 1
    for i = 1:max_n:length(word)
        push!(out, word[i:min(i+max_n-1,length(word))])
        j+=1
    end
    return out
end
