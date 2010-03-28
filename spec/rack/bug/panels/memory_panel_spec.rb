require 'spec/spec_helper'

describe Rack::Bug::MemoryPanel do
  before do 
    @active_panel = Rack::Bug::MemoryPanel
  end
  
  it "displays the total memory" do
    get_with_panel.should have_heading(/\d+ KB total/)
  end
  
  it "displays the memory change during the request" do
    get_with_panel.should have_heading(/\d+ KB Δ/)
  end
end