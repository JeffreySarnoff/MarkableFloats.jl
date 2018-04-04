abstract type MarkableFloat <: AbstractFloat end

struct MarkableFloat64{M} <: MarkableFloat
   value::Float64
end

struct MarkableFloat32{M} <: MarkableFloat
   value::Float32
end

value(x::MarkableFloat64{M}) where {M} = x.value
value(x::MarkableFloat32{M}) where {M} = x.value

MarkableFloat64(x::Float64) = MarkableFloat64{0}(x)
MarkableFloat32(x::Float32) = MarkableFloat32{0}(x)

ismarked(x::MarkableFloat64{0}) = false
ismarked(x::MarkableFloat32{0}) = false
ismarked(x::MarkableFloat64{M}) where {M} = true
ismarked(x::MarkableFloat32{M}) where {M} = true

isunmarked(x::MarkableFloat64{0}) = true
isunmarked(x::MarkableFloat32{0}) = true
isunmarked(x::MarkableFloat64{M}) where {M} = false
isunmarked(x::MarkableFloat32{M}) where {M} = false

marking(x::MarkableFloat64{0}) = nothing
marking(x::MarkableFloat32{0}) = nothing
marking(x::MarkableFloat64{M}) = M
marking(x::MarkableFloat32{M}) = M



