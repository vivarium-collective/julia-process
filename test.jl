abstract type A end

struct B <: A
    x::Int
end

struct C <: A
    x::Int
end

function merge(m::A, n)
    m.x + n.x
end

function merge(m::B, n)
    m.x * n.x
end

function merge(m::C, n)
    m.x - n.x
end

function call_merge(m::A, n::A)
    merge(m, n)
end

b = call_merge(B(5), B(6))
c = call_merge(C(5), C(6))

println("B merge 5,6 -> $b")
println("C merge 5,6 -> $c")
