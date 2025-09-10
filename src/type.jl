abstract type RemarkableFloat <: AbstractFloat end

abstract type RemarkableFloat16 <: RemarkableFloat end
abstract type RemarkableFloat32 <: RemarkableFloat end
abstract type RemarkableFloat64 <: RemarkableFloat end

primitive type Float14 <: RemarkableFloat16 16 end
primitive type Float15 <: RemarkableFloat16 16 end

primitive type Float30 <: RemarkableFloat32 32 end
primitive type Float31 <: RemarkableFloat32 32 end

primitive type Float62 <: RemarkableFloat64 64 end
primitive type Float63 <: RemarkableFloat64 64 end

const NaN14    = reinterpret(Float14, NaN16)
const PosInf14 = reinterpret(Float14, Inf16)
const NegInf14 = reinterpret(Float14, -Inf16)

function Float14(x::Float16)
    uint16x = reinterpret(UInt16, x)
    uint16y, ovf = add_with_overflow(uint16x, 0x0002)
    uint14y = (uint16y & ~0x0003)
    ovf && return ((uint16y & 0x8000) === 0x8000) ? PosInf14 : NegInf14
    reinterpret(Float14, uint14y)
end

function Base.Float16(x::Float14)
    uint16x = reinterpret(UInt16, x)
    uint14y = uint16x & ~0x0003
    reinterpret(Float16, uint14y)
end

Base.show(io::IO, x::Float14) = show(io, MIME"text/plain"(), string("Float14(",reinterpret(Float16,x),")"))
Base.show(io::IO, mimme, x::Float14) = show(io, mime(), string("Float14(",reinterpret(Float16,x),")"))

const NaN15    = reinterpret(Float15, NaN16)
const PosInf15 = reinterpret(Float15, Inf16)
const NegInf15 = reinterpret(Float15, -Inf16)

function Float15(x::Float16)
    uint16x = reinterpret(UInt16, x)
    uint16y, ovf = add_with_overflow(uint16x, 0x0001)
    uint14y = (uint16y & ~0x0001)
    ovf && return ((uint16y & 0x8000) === 0x8000) ? PosInf15 : NegInf15
    reinterpret(Float15, uint14y)
end

function Base.Float16(x::Float15)
    uint16x = reinterpret(UInt16, x)
    uint15y = uint16x & ~0x0001
    reinterpret(Float16, uint15y)
end

Base.show(io::IO, x::Float15) = show(io, MIME"text/plain"(), string("Float15(",reinterpret(Float16,x),")")) 

    
#=
function Float14(x::Float16)
   uint16x = reinterpret(UInt16, x)
   uint16y, ovf = add_with_overflow(uint16x, 0x0002)
   ovf && return signbit(x) ? NegInf14 : PosInf14
   uint14y = uint16y & ~0x0003
   reinterpret(Float14, uint14y)
end
=#

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



