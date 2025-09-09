module MarkableFloats

export MarkableFloat, MarkFloat64, Marked, Unmarked, mark, unmark,
    square, cube

import Base: AbstractFloat, Float64, Float32, Float16

import Base.Checked: add_with_overflow, sub_with_overflow, mul_with_overflow
                     # checked_neg, checked_abs, checked_add, checked_sub, checked_mul,
                     # checked_div, checked_rem, checked_fld, checked_mod, checked_cld,
                     
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
    sqrt, cbrt,
    log, log2, log10, log1p, exp, expm1,
    sin, cos, tan, sec, csc, cot, sinpi, cospi,
    asin, acos, atan, asec, acsc, acot, atan2,
    sinh, cosh, tanh, sech, csch, coth,
    asinh, acosh, atanh, asech, acsch, acoth

include("type.jl")
include("math.jl")

end # MarkableFloats
