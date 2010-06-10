class BenchmarkArea
  def initialize fac_width, fac_height
    @fac_height = fac_height
    @fac_width = fac_width
  end
  
  def benchmark field
    a = field.to_a
    return -1*(a.size*@fac_width + a[0].size*@fac_height)
  end
end