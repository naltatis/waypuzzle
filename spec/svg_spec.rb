require 'piece'
require 'svg'

describe Svg, "#from_piece" do
  before(:each) do
    @svg = Svg.new
  end
    
  it "return draw lines for facing points" do
    p = Piece.new("wf,rs,fw,sr")
    #@svg.from_piece(p).should == 
    #  ["<path d=\"M 0,1 L 3,1\" class=\"way_r\" />",
    #    "<path d=\"M 0,2 L 3,2\" class=\"way_s\" />",
    #    "<path d=\"M 1,0 L 1,1\" class=\"way_w\" />",
    #    "<path d=\"M 2,3 L 2,0\" class=\"way_f\" />"].sort
  end
end