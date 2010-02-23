require 'field'
require 'piece'

describe Field, "#full_places" do
  before(:each) do
    @field = Field.new
  end
    
  it "return 0 if no piece is added" do
    @field.full_places.size.should == 0
  end

  it "return 1 if one piece is added" do
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.full_places.size.should == 1
  end
  
  it "return 1 if two pieces are set to the same position" do
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.full_places.size.should == 1
  end
end

describe Field, "#possible_places" do
  before(:each) do
    @field = Field.new
  end
  
  it "return 0,0 if nothing is set" do
    @field.possible_places.should == [[0,0]]
    @field.possible_places.size.should == 1
  end
  
  it "return all places next the set ones" do
    @field.set 0,0,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 4
    
    @field.set 0,1,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 6

    @field.set 0,2,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 8
  end
end

describe Field, "#fits?" do
  before(:each) do
    @field = Field.new
  end
  
  it "return true if it is the first one" do
    @field.fits?(0,0,Piece.new("__,rw,__,__")).should == true
  end
  
  it "return false if the second piece does not touch the first one" do
    @field.set(0,0,Piece.new("__,rw,__,__"))
    @field.fits?(2,2,Piece.new("__,__,__,wr")).should == false    
  end

  it "return true if sides fit" do
    @field.set(2,2,Piece.new("s_,rw,fw,ff"))
    @field.fits?(2,1,Piece.new("__,__,_s,__")).should == true
    @field.fits?(3,2,Piece.new("__,__,__,wr")).should == true
    @field.fits?(2,3,Piece.new("wf,__,__,__")).should == true
    @field.fits?(1,2,Piece.new("__,ff,__,__")).should == true
  end

  it "return false if sides don't fit" do
    @field.set(2,2,Piece.new("s_,rw,fw,ff"))
    @field.fits?(2,1,Piece.new("__,__,__,__")).should == false
    @field.fits?(3,2,Piece.new("__,__,__,__")).should == false
    @field.fits?(2,3,Piece.new("__,__,__,__")).should == false
    @field.fits?(1,2,Piece.new("__,__,__,__")).should == false
  end
  
end

describe Field, "#to_s" do
  before(:each) do
    @field = Field.new
  end
  
  it "return ascii representation" do
    # first pieces
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.set(1,2,Piece.new("__,__,__,__"))

    # will be rejected
    @field.set(3,1,Piece.new("__,__,__,ww"))
    
    @field.to_s.should == "---\n-xx\n"
  end
end