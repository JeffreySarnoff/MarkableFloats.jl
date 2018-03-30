for F in (:(+), :(-), :(*), :(/), :(\), :(^))
  @eval begin
    function $F(a::MarkFloat64, b::MarkFloat64)
        marking = marker(a) | marker(b)
        c = reinterpret(UInt64, $F(Float64(a), Float64(b)))
        c |= marking
        z = reinterpret(MarkFloat64, c)
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
        c = reinterpret(UInt64, $F(Float64(a)))
        c |= marker(a)
        z = reinterpret(MarkFloat64, c)
        return z
    end
  end
end