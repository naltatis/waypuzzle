class Evolution
  attr_writer :benchmark, :reproduction, :creation, :pieces
  
  def initialize parents=1, kids=1, generations=1
    @num_kids_each = kids
    @num_parents = parents
    @num_generations = generations
  end

  def perform
    parents = create_base(@num_parents)
    
    @num_generations.times do |generation|
      kids = reproduce(parents, @num_kids_each)
      population = kids + parents
      parents = elect(population, @num_parents)
      puts "##{generation}"
      print sort(parents)
      puts best(parents)
      h = Html.new
      h.to_html best(parents), "result.html"
      puts
    end
    best(parents)
  end
  
  private
  
  def print population
    results = []
    population.each do |p|
      results.push(@benchmark.benchmark(p))
    end
    puts "#{results.mean}ø ["+results.join(" ")+"]"
  end
  
  def create_base num
    p = []
    field = nil
    num.times do
      until field && field.full_places.size == 16
        field = @creation.generate(@pieces.deep_clone)
      end
      p.push field
      field = nil
    end
    p
  end
  
  def reproduce parents, num
    r = []
    parents.each do |parent|
      num.times do |i|
        r.push(@reproduction.mutate parent.deep_clone)
      end
    end
    r
  end
  
  def elect population, num
    sort population
    population[0, num]
  end
  
  def best population
    sort population
    population[0]
  end
  
  def sort population
    population.sort! { |x,y| @benchmark.benchmark(x) <=> @benchmark.benchmark(y) }
    population.reverse!
  end
end