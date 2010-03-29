require 'spec/spec_helper'

describe Rack::Bug::MemoryPanel do
  before { @active_panel = Rack::Bug::MemoryPanel }
  subject { get_with_panel }
  
  
  it "displays the total memory" do
    should have_heading(/\d+ KB total/)
  end
  
  it "displays the memory change during the request" do
    should have_heading(/\d+ KB Δ/)
  end
end