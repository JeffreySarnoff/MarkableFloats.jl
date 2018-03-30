
abstract type MarkableFloat <: AbstractFloat end

primitive type MarkFloat64 <: MarkableFloat 64 end




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

Base.UInt64(x::MarkFloat64) = Base.reinterpret(UInt64, x)
Base.UInt64(x::Float64) = Base.reinterpret(UInt64, x)
Base.Float64(x::MarkFloat64) = Base.reinterpret(Float64, (0xefffffffffffffff & UInt64(x)))
MarkFloat64(x::UInt64) = Base.reinterpret(MarkFloat64, x)
MarkFloat64(x::Float64) = markable(x) ? Base.reinterpret(Float64, UInt64(x)) : throw(DomainError("$x"))
MarkFloat64(x::UInt64, marking::UInt64) = MarkFloat64(x | marking)
MarkFloat64(x::Float64, marking::UInt64) = MarkFloat64(UInt64(x) | marking)


Unmarked(x::Float64) = markable(x) && reinterpret(MarkFloat64, x)
Marked(x::Float64) = markable(x) && mark(reinterpret(MarkFloat64, x))

@inline Float64(x::MarkFloat64) = reinterpret(Float64, unmark_raw(x))
@inline MarkFloat64(x::Float64) = ismarkable(x) && reinterpret(MarkFloat64, reinterpret(UInt64, x))

@inline unmark_raw(x::MarkFloat64) =
    reinterpret(UInt64,x) & 0xefffffffffffffff
@inline mark_raw(x::MarkFloat64) =
    reinterpret(UInt64,x) | 0x1000000000000000

@inline unmark(x::MarkFloat64) =
    reinterpret(MarkFloat64, (reinterpret(UInt64,x) & 0xefffffffffffffff))
@inline mark(x::MarkFloat64) =
    reinterpret(MarkFloat64, (reinterpret(UInt64,x) | 0x1000000000000000))

@inline ismarked(x::MarkFloat64) =
    (reinterpret(UInt64,x) & 0x1000000000000000) === 0x1000000000000000
@inline isunmarked(x::MarkFloat64) =
    (reinterpret(UInt64,x) & 0x1000000000000000) === 0x0000000000000000

@inline marker(x::MarkFloat64) = (reinterpret(UInt64,x) & 0x1000000000000000)

function string(x::MarkFloat64)
   x = unmark(x)
   z = reinterpret(Float64, reinterpret(UInt64,x))
   return string(z)
end
show(io::IO, x::MarkFloat64) = print(io, string(x))
