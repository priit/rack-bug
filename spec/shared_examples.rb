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
    it_should_behave_like "active toolbar"
    
    it "displays the #{@active_panel} properties panel" do
      response = get "/", {}, {"rack-bug.panel_classes" => [@active_panel]}
      response.should have_panel(@active_panel)
    end
  end
end
  