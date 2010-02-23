require 'piece'

describe Piece, "#sides" do
  before(:each) do
    @p = Piece.new("fr,_s,rs,ww")
  end
  
  it "return side values for north" do
    @p.should have_sides("fr","_s","rs","ww")
  end
  
  it "return clockwise shifted values if direction is east" do
    @p.direction = :east
    @p.should have_sides("ww","fr","_s","rs")
  end

  it "return 2x clockwise shifted values if direction is south" do
    @p.direction = :south
    @p.should have_sides("rs","ww","fr","_s")
  end

  it "return 3x clockwise shifted values if direction is south" do
    @p.direction = :west
    @p.should have_sides("_s","rs","ww","fr")
  end
end


Spec::Matchers.define :have_sides do |top,right,bottom,left|
  match do |p|
    (p.top == top &&
    p.right == right &&
    p.bottom == bottom &&
    p.left == left)
  end
end

describe Piece, "#fits***?" do
  before(:each) do
    @p1 = Piece.new("fr,_s,rs,ww")
  end
  
  it "return always false for unfitting pieces" do
    p = Piece.new("__,__,__,__")
    p.should fit_at_sides([false,false,false,false],@p1)
  end

  it "return always true for perfectly fitting pieces" do
    p = Piece.new("sr,ww,rf,s_")
    p.should fit_at_sides([true,true,true,true],@p1)
  end

  it "return true once for a onesize fitting piece in correct orientation" do
    p = Piece.new("__,rf,__,__")
    p.should fit_at_sides([false,false,false,false],@p1)
    p.direction = :east
    p.should fit_at_sides([true,false,false,false],@p1)
  end
end

Spec::Matchers.define :fit_at_sides do |sides,p_base|
  match do |p_test|
    (p_base.fits_top?(p_test) == sides[0] &&
    p_base.fits_right?(p_test) == sides[1] &&
    p_base.fits_bottom?(p_test) == sides[2] &&
    p_base.fits_left?(p_test) == sides[3])
  end
end
