
function report_cat(vec)
    vec = categorical(vec)
    n = length(vec)
    nu = length(levels(vec))
    nur = nu / n
    return string(length(levels(vec))) * 
    " | " * string(nur) * 
    " | " * string(levels(vec)) * 
    " | " * string(countmap(vec))
end

