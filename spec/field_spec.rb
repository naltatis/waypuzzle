require 'field'
require 'piece'

describe Field, "#dimension" do
  it "return 25 on a 5x5 field" do
    Field.new(5,5).total_places.should == 25
  end

  it "return 27 on a 9x3 field" do
    Field.new(9,3).total_places.should == 27
  end
end

describe Field, "#full_places" do
  before(:each) do
    @field = Field.new(5,5)
  end
    
  it "return 0 if no piece is added" do
    @field.full_places.size.should == 0
  end

  it "return 1 if one piece is added" do
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.full_places.size.should == 1
  end
  
  it "return 1 if two pieces are set to the same position" do
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.full_places.size.should == 1
  end
  
  it "return 0 if a piece is placed out of bound" do
    @field.set(1,6,Piece.new("__,__,__,__"))
    @field.full_places.size.should == 0        
  end
end

describe Field, "#free_places" do
  before(:each) do
    @field = Field.new(1,2)
  end
  
  it "return all places if no piece is set" do
    @field.free_places.size.should == 2
    @field.free_places.should == [[1,1],[1,2]]
  end
  
  it "return no if all places are set" do
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.set(1,2,Piece.new("__,__,__,__"))
    @field.free_places.size.should == 0
    @field.free_places.should == []
  end

  it "return one if the other is set" do
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.free_places.size.should == 1
    @field.free_places.should == [[1,2]]
  end
end

describe Field, "#possible_places" do
  before(:each) do
    @field = Field.new(3,3)
  end
  
  it "return all places if nothing is set" do
    @field.possible_places.size.should == 9
  end
  
  it "return all places next the set ones" do
    @field.set 1,1,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 2
    
    @field.set 1,2,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 3

    @field.set 1,3,Piece.new("__,__,__,__")
    @field.possible_places.size.should == 3
  end
end

describe Field, "#fits?" do
  before(:each) do
    @field = Field.new(3,3)
  end
  
  it "return true if it is the first one" do
    @field.fits?(1,1,Piece.new("__,rw,__,__")).should == true
  end
  
  it "return false if the second piece does not touch the first one" do
    @field.set(1,1,Piece.new("__,rw,__,__"))
    @field.fits?(3,3,Piece.new("__,__,__,wr")).should == false    
  end

  it "return false if it is placed outside" do
    @field.fits?(4,1,Piece.new("__,rw,__,__")).should == false
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
    @field = Field.new(3,3)
  end
  
  it "return ascii representation" do
    # first pieces
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.set(1,2,Piece.new("__,__,__,__"))

    # will be rejected
    @field.set(3,1,Piece.new("__,__,__,ww"))
    
    @field.to_s.should == "x--\nx--\n---\n"
  end
end