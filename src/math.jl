for F in (:(+), :(-), :(*), :(/), :(\), :(^))
  @eval begin
    function $F(a::MarkFloat64, b::MarkFloat64)
        c = $F(Float64(a), Float64(b))
        d = reinterpret(UInt64, c) 
        d |= marker(a)
        d |= marker(b)
        z = reinterpret(MarkFloat64, d)
        return z
    end
  end
end

for F in (:(-), :abs, :log, :log2, :log10, :log1p, :exp, :expm1,
          :sin, :cos, :tan, :sec, :csc, :cot, :sinpi, :cospi,
          :asin, :acos, :atan, :asec, :acsc, :acot,
          :sinh, :cosh, :tanh, :sech, :csch, :coth,
          :asinh, :acosh, :atanh, :asech, :acsch, :acoth)                   
  @eval begin
    function $F(a::MarkFloat64)
        c = Float64(a)
        c = $F(c)
        d = UInt64(c) | marker(a)
        z = MarkFloat64(d)
        return z
    end
  end
end
# log(reinterpret(Float64,MarkableFloats.unmark(c)))
