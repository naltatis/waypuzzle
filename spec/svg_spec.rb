require 'piece'
require 'svg'

describe Svg, "#from_piece" do
  before(:each) do
    @svg = Svg.new
  end
  
  it "draw ending lines one step in" do
    "r_,__,__,__".should convert_to ['<path d="M 1,0 Q 1,0.5 1.5,1" class="way_r" />']
    "_r,__,__,__".should convert_to ['<path d="M 2,0 Q 2,0.5 1.5,1" class="way_r" />']
    "__,r_,__,__".should convert_to ['<path d="M 3,1 Q 2.5,1 2,1.5" class="way_r" />']
    "__,_r,__,__".should convert_to ['<path d="M 3,2 Q 2.5,2 2,1.5" class="way_r" />']
    "__,__,r_,__".should convert_to ['<path d="M 2,3 Q 2,2.5 1.5,2" class="way_r" />']
    "__,__,_r,__".should convert_to ['<path d="M 1,3 Q 1,2.5 1.5,2" class="way_r" />']
    "__,__,__,r_".should convert_to ['<path d="M 0,2 Q 0.5,2 1,1.5" class="way_r" />']
    "__,__,__,_r".should convert_to ['<path d="M 0,1 Q 0.5,1 1,1.5" class="way_r" />']
  end
    
  it "draw lines straight vertical lines" do
    "r_,__,_r,__".should convert_to ['<path d="M 1,0 L 1,3" class="way_r" />']
    "_r,__,r_,__".should convert_to ['<path d="M 2,0 L 2,3" class="way_r" />']
    "__,r_,__,_r".should convert_to ['<path d="M 3,1 L 0,1" class="way_r" />']
    "__,_r,__,r_".should convert_to ['<path d="M 3,2 L 0,2" class="way_r" />']
  end
  
  it "draw turn" do
    "rr,__,__,__".should convert_to ['<path d="M 1,0 C 1,1 2,1 2,0" class="way_r" />']
    "__,rr,__,__".should convert_to ['<path d="M 3,1 C 2,1 2,2 3,2" class="way_r" />']
    "__,__,rr,__".should convert_to ['<path d="M 2,3 C 2,2 1,2 1,3" class="way_r" />']
    "__,__,__,rr".should convert_to ['<path d="M 0,2 C 1,2 1,1 0,1" class="way_r" />']
  end

  it "draw small corners" do
    "r_,__,__,_r".should convert_to ['<path d="M 1,0 Q 1,1 0,1" class="way_r" />']
    "_r,r_,__,__".should convert_to ['<path d="M 2,0 Q 2,1 3,1" class="way_r" />']
    "__,_r,r_,__".should convert_to ['<path d="M 3,2 Q 2,2 2,3" class="way_r" />']
    "__,__,_r,r_".should convert_to ['<path d="M 1,3 Q 1,2 0,2" class="way_r" />']
  end

  it "draw large corners" do
    "r_,_r,__,__".should convert_to ['<path d="M 1,0 Q 1,2 3,2" class="way_r" />']
    "_r,__,__,r_".should convert_to ['<path d="M 2,0 Q 2,2 0,2" class="way_r" />']
    "__,__,r_,_r".should convert_to ['<path d="M 2,3 Q 2,1 0,1" class="way_r" />']
    "__,r_,_r,__".should convert_to ['<path d="M 3,1 Q 1,1 1,3" class="way_r" />']
  end

  it "draw diagonals" do
    "r_,__,r_,__".should convert_to ['<path d="M 1,0 C 1,1.5 2,1.5 2,3" class="way_r" />']
    "_r,__,_r,__".should convert_to ['<path d="M 2,0 C 2,1.5 1,1.5 1,3" class="way_r" />']
    "__,r_,__,r_".should convert_to ['<path d="M 3,1 C 1.5,1 1.5,2 0,2" class="way_r" />']
    "__,_r,__,_r".should convert_to ['<path d="M 3,2 C 1.5,2 1.5,1 0,1" class="way_r" />']
  end
  
  it "draw long ending corners" do
    "r_,r_,__,__".should convert_to ['<path d="M 1,0 Q 1,1 2,1 L 3,1" class="way_r" />']
    "_r,__,__,_r".should convert_to ['<path d="M 2,0 Q 2,1 1,1 L 0,1" class="way_r" />']
    "__,r_,r_,__".should convert_to ['<path d="M 3,1 Q 2,1 2,2 L 2,3" class="way_r" />']
    "__,__,r_,r_".should convert_to ['<path d="M 2,3 Q 2,2 1,2 L 0,2" class="way_r" />']
  end

  it "draw long starting corners" do
    "r_,__,__,r_".should convert_to ['<path d="M 1,0 L 1,1 Q 1,2 0,2" class="way_r" />']
    "_r,_r,__,__".should convert_to ['<path d="M 2,0 L 2,1 Q 2,2 3,2" class="way_r" />']
    "__,_r,_r,__".should convert_to ['<path d="M 3,2 L 2,2 Q 1,2 1,3" class="way_r" />']
    "__,__,_r,_r".should convert_to ['<path d="M 1,3 L 1,2 Q 1,1 0,1" class="way_r" />']
  end
  
  it "draw three points to center" do
    "_r,_r,r_,__".should convert_to [
      '<path d="M 2,0 Q 2,1 1.5,1.5" class="way_r" />',
      '<path d="M 3,2 Q 2,2 1.5,1.5" class="way_r" />',
      '<path d="M 2,3 Q 2,2 1.5,1.5" class="way_r" />']
  end
  
end

Spec::Matchers.define :convert_to do |expected|
  match do |actual|
    to_svg(actual) == expected
  end

  def to_svg(actual)
    Svg.new.from_piece(Piece.new(actual))
  end
  
  failure_message_for_should do |actual|
     "wrong result for #{actual}:\n#{expected} [expected]\n#{to_svg(actual)} [got]"
  end
end