using RandomNumbers.MersenneTwisters

function randnum(r)
    return rand(r, Float64, 1)
end

function main()
    r = MT19937()
    open("./Files/randnum.txt", "w") do f
        for i = 1:1000000
            write(f, "$(randnum(r)) \n")
        end
    end
end

rm("./Files/randnum.txt")
@time main()
