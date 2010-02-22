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
    @field.set(1,1,Piece.new("_w,rw,sr,sr"))
    @field.full_places.size.should == 1
  end
  
  it "return 1 if two pieces are set to the same position" do
    @field.set(1,1,Piece.new("_w,rw,sr,sr"))
    @field.set(1,1,Piece.new("_w,rw,sr,sr"))
    @field.full_places.size.should == 1
  end
  
  it "return 0 if a piece is placed out of bound" do
    @field.set(1,6,Piece.new("_w,rw,sr,sr"))
    @field.full_places.size.should == 0        
  end
end

describe Field, "#free_places" do
  before(:each) do
    @field = Field.new(2,2)
  end
  
  it "return all places if no piece is set" do
    @field.free_places.size.should == 4
    @field.free_places.should == [[1,1],[1,2],[2,1],[2,2]]
  end
end