abstract type RemarkableFloat <: AbstractFloat end

abstract type RemarkableFloat16 <: RemarkableFloat end
abstract type RemarkableFloat32 <: RemarkableFloat end
abstract type RemarkableFloat64 <: RemarkableFloat end

primitive type Float14 <: RemarkableFloat16 16 end
primitive type Float15 <: RemarkableFloat16 16 end

primitive type Float30 32 <: RemarkableFloat32 end
primitive type Float31 32 <: RemarkableFloat32 end

primitive type Float62 64 <: RemarkableFloat64 end
primitive type Float63 64 <: RemarkableFloat64 end

function Float14(x::Float16)
   uint16x = reinterpret(UInt16, x)
   uint16y = uint16 + 0x0002
   
   uint14 = ((uint16 + 0x0002) >> 0x02) << 0x02
   reinterpret(Float14, uint14)
end

function Base.Float16(x::Float14)
   reinterpret(Float16, x)
end


Float14(x::Float15) = reinterpret(Float15, x)

Base.show(io::IO, x::Float14) = show(io, MIME"text/plain"(), string("Float14(",reinterpret(Float16,x),")"))

Base.reinterpret(::Type{Float16}, x::Float14) = reinterpret(Float16, convert(UInt16, x))
Base.convert(::Type{UInt16}, x::Float14) = reinterpret(UInt16, x)

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

Markable64s = Union{MarkableFloat64{0}, MarkableFloat64{1}, MarkableFloat64{2}}
Markable32s = Union{MarkableFloat32{0}, MarkableFloat32{1}, MarkableFloat32{2}}



