#=
fr,ex=frexp(realmax(Float64)); ldexp(fr, ex>>1)
1.3407807929942596e154

fr,ex=frexp(realmin(Float64)); ldexp(fr, ex>>1)
7.458340731200207e-155
=#

realmax(::Type{MarkFloat64}) = Unmarked(1.3407807929942596e154)
realmin(::Type{MarkFloat64}) = Unmarked(7.458340731200207e-155)

markable(x::Float64) = 7.458340731200207e-155 <= x <= 1.3407807929942596e154

@inline function ismarkable(x::Float64)
   !markable(x) && throw(DomainError("$x"))
   true
end

Unmarked(x::Float64) = markable(x) && reinterpret(MarkFloat64, x)
Marked(x::Float64) = markable(x) && mark(reinterpret(MarkFloat64, x))

@inline Float64(x::MarkFloat64) = reinterpret(Float64, unmark(x))
@inline MarkFloat64(x::Float64) = Unmarked(x)

@inline unmark(x::MarkFloat64) = reinterpret(MarkFloat64, (reinterpret(UInt64,x) & ~0x1000000000000000))
@inline mark(x::MarkFloat64) = reinterpret(MarkFloat64, (reinterpret(UInt64,x) | 0x1000000000000000))

@inline ismarked(x::MarkFloat64) = (reinterpret(UInt64,x) & 0x1000000000000000) === 0x1000000000000000
@inline isunmarked(x::MarkFloat64) = (reinterpret(UInt64,x) & 0x1000000000000000) === 0x0000000000000000

@inline marker(x::MarkFloat64) = (reinterpret(UInt64,x) & 0x1000000000000000)

