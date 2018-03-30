module MarkableFloats.jl

export MarkableFloat, MarkableFloat64,
    square, cube

import Base: AbstractFloat, Float64, float,

import Base: @pure, promote_type, promote_rule, convert,
    mark, unmark, ismarked,
    typemax, typemin, realmax, realmin,
    string, show,
    (<=), (<), (==), (!=), (>=), (>), isless, isequal,
    (~), (&), (|), (⊻),
    findall

import Base.Math: zero, one, iszero, isone, isinteger, 
    isodd, iseven, sign, signbit, abs, copysign, flipsign,
    (+), (-), (*), (/), (\), (^),
    round, trunc, ceil, floor,
    div, fld, cld, mod, rem,
    sqrt, cbrt

include("type.jl")

end # MarkableFloats
