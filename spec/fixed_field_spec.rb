require 'fixed_field'
require 'piece'

describe FixedField, "#possible_places" do
  before(:each) do
    @field = FixedField.new(2, 2)
  end
  
  it "return all places if nothing is set" do
    @field.possible_places.size.should == 4
    @field.possible_places.should == [[0,0],[1,0],[0,1],[1,1]]
  end
  
  it "return all places next the set ones that are inside the field" do
    @field.set 0,0,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 2
    @field.possible_places == [[1,0],[0,1]]
    
    @field.set 0,1,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 2
    @field.possible_places == [[0,1],[1,1]]

    @field.set 1,0,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 1
    @field.possible_places == [[1,1]]
    
    @field.set 1,1,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 0
    @field.possible_places == []
  end
end

describe FixedField, "#fits?" do
  before(:each) do
    @field = FixedField.new(2,3)
  end
  
  it "return true if it is the first one" do
    @field.fits?(0,0,Piece.new("__,rw,__,__")).should == true
  end
  
  it "return false if the second piece does not touch the first one" do
    @field.set(0,0,Piece.new("__,rw,__,__"))
    @field.fits?(2,2,Piece.new("__,__,__,wr")).should == false    
  end

  it "return false if the second piece does not fit" do
    @field.set(0,0,Piece.new("__,rw,__,__"))
    @field.fits?(1,0,Piece.new("__,__,__,__")).should == false    
  end
  
  it "return true if sides fit, false if they are outsite" do
    @field.set(0,0,Piece.new("s_,rw,fw,ff"))
    @field.fits?(0,-1,Piece.new("__,__,_s,__")).should == false
    @field.fits?(1,0,Piece.new("__,__,__,wr")).should == true
    @field.fits?(0,1,Piece.new("wf,__,__,__")).should == true
    @field.fits?(-1,0,Piece.new("__,ff,__,__")).should == false
  end
  
end