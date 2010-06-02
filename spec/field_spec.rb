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

  it "return 0 if one piece is added to an illegal place" do
    @field.set(1,0,Piece.new("__,__,__,__"))
    @field.full_places.size.should == 0
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

describe Field, "#connections" do
  before(:each) do
    @field = Field.new
  end
  
  it "return 0 for one piece" do
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.connections.should == 0
  end
  
  it "return 1 for two pieces" do
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.set(1,0,Piece.new("__,__,__,__"))
    @field.connections.should == 1
  end
  
  it "return 2 for three pieces" do
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.set(1,0,Piece.new("__,__,__,__"))
    @field.set(0,1,Piece.new("__,__,__,__"))
    @field.connections.should == 2
  end

  it "return 4 for a 2x2 square" do
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.set(1,0,Piece.new("__,__,__,__"))
    @field.set(0,1,Piece.new("__,__,__,__"))
    @field.set(1,1,Piece.new("__,__,__,__"))
    @field.connections.should == 4
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
  
  it "return false if the second piece does not fit" do
    @field.set(0,0,Piece.new("__,rw,__,__"))
    @field.fits?(1,0,Piece.new("__,__,__,__")).should == false    
  end

  it "return true if sides fit" do
    @field.set(0,0,Piece.new("s_,rw,fw,ff"))
    @field.fits?(0,-1,Piece.new("__,__,_s,__")).should == true
    @field.fits?(1,0,Piece.new("__,__,__,wr")).should == true
    @field.fits?(0,1,Piece.new("wf,__,__,__")).should == true
    @field.fits?(-1,0,Piece.new("__,ff,__,__")).should == true
  end

  it "return false if sides don't fit" do
    @field.set(0,0,Piece.new("s_,rw,fw,ff"))
    @field.fits?(0,-1,Piece.new("__,__,__,__")).should == false
    @field.fits?(1,0,Piece.new("__,__,__,__")).should == false
    @field.fits?(0,1,Piece.new("__,__,__,__")).should == false
    @field.fits?(-1,0,Piece.new("__,__,__,__")).should == false
  end
  
end

describe Field, "#to_s" do
  before(:each) do
    @field = Field.new
  end
  
  it "return ascii representation" do
    # first pieces
    @field.set(0,0,Piece.new("__,__,__,__"))
    @field.set(0,1,Piece.new("__,__,__,__"))
    @field.set(1,0,Piece.new("__,__,__,__"))
    
    @field.to_s.should == "xx\nx-\n"
  end
end

describe Field, "#removable_places" do
  before(:each) do
    @field = Field.new
  end
  
  it "return edge places" do
    p1 = Piece.new("__,__,__,__")
    @field.set(0,0, p1)
    @field.set(0,1, p1)
    @field.set(1,0, p1)
    
    @field.removable_places.should == [[0,1],[1,0]]
  end
  
  it "return places that have more than two surrounding places" do
    p1 = Piece.new("__,__,__,__")
    @field.set(0,0, p1)
    @field.set(0,1, p1)
    @field.set(1,0, p1)
    @field.set(1,1, p1)
    
    @field.removable_places.should == [[0,0],[0,1],[1,0],[1,1]]
  end
  
  it "return places that have more than two surrounding places" do
    p1 = Piece.new("__,__,__,__")
    @field.set(0,0, p1)
    @field.set(0,1, p1)
    @field.set(0,2, p1)
    @field.set(1,1, p1)
    @field.set(2,1, p1)
    @field.set(2,0, p1)
    @field.set(2,2, p1)
    
    @field.removable_places.should == [[0,0],[0,2],[2,0],[2,2]]
  end
end

describe Field, "#to_a" do
  before(:each) do
    @field = Field.new
  end
  
  it "return array representation" do
    # first pieces
    p1 = Piece.new("__,__,sr,__")
    p2 = Piece.new("rs,fw,sr,ff")
    p3 = Piece.new("__,__,__,__")
    @field.set(0,0, p1)
    @field.set(0,1, p2)
    @field.set(1,0, p3)
    
    @field.to_a.should == [[p1,p3],[p2,nil]]
  end
end

describe Field, "#to_ascii" do
  before(:each) do
    @field = Field.new
  end

  it "return extensive ascii representation of one piece" do
    # first pieces
    @field.set(0,0,Piece.new("rw,w_,fs,ss"))
    
    @field.to_ascii.should == "|-r-w-| \n" +
                              "|s   w| \n" +
                              "|s   _| \n" +
                              "|-s-f-| \n"
  end
  
  it "return extensive ascii representation of many pieces" do
    # first pieces
    @field.set(0,0,Piece.new("rw,w_,fs,ss"))
    @field.set(0,1,Piece.new("sf,__,rs,ww"))
    @field.set(1,0,Piece.new("rr,rw,fs,_w"))
    
    @field.to_ascii.should == "|-r-w-| |-r-r-| \n" +
                              "|s   w| |w   r| \n" +
                              "|s   _| |_   w| \n" +
                              "|-s-f-| |-s-f-| \n" +
                              "\n" +
                              "|-s-f-| |-----| \n" +
                              "|w   _| |     | \n" +
                              "|w   _| |     | \n" +
                              "|-s-r-| |-----| \n"
  end
end