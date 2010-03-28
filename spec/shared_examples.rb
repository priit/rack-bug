module SharedExamples
  shared_examples_for "active toolbar" do
    it "inserts the Rack::Bug toolbar" do
      response = get "/"
      response.should have_the_toolbar
    end
    
    it "serves up the original content even if toolbar request" do
      response = get "/"
      response.should have_selector("p", :content => "Hello")
    end
    
    it "does not insert toolbar if not requested" do
      header 'cookie', ""
      response = get "/"
      response.should_not have_the_toolbar
    end
    
    it "serves up original content if toolbar not requested" do
      header 'cookie', ""
      response = get "/"
      response.should have_selector("p", :content => "Hello")
    end
  end
  
  shared_examples_for "active panel" do
    it "displays the heading" do
      #header "rack-bug.panel_classes", [@active_panel]
      heading = @custom_header || @active_panel.to_s.demodulize.sub("Panel", "")
      get_with_panel.should have_heading(heading)
    end
      
    it "displays the #{@active_panel} properties panel" do
      get_with_panel.should have_panel(@active_panel)
    end
  end
end
  