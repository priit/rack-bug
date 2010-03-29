module SharedExamples
  shared_examples_for "active toolbar" do
    describe "when toolbar requested" do
      subject { get "/" }
    
      it { should have_the_toolbar }
      it { should have_the_original_content }
    end
    
    describe "when toolbar not requested" do
      before { header 'cookie', "" }
      subject { get "/" }
    
      it { should_not have_the_toolbar }
      it { should have_the_original_content }
    end
  end
  
  shared_examples_for "active panel" do
    subject { get_with_panel }
    
    it "displays the heading" do
      heading = @custom_header || @active_panel.to_s.demodulize.sub("Panel", "")
      should have_heading(heading)
    end
      
    it { should have_panel(@active_panel) }
  end
end
  