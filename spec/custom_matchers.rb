module CustomMatchers
  def have_row(container, key, value = nil)
    simple_matcher("contain row") do |response|
      if value
        response.should have_selector("#{container} tr", :content => key) do |row|
          row.should contain(value)
        end
      else
        response.should have_selector("#{container} tr", :content => key)
      end
    end
  end
  
  def have_heading(text)
    simple_matcher("have heading") do |response|
      response.should have_selector("#rack_bug_toolbar li") do |heading|
        heading.should contain(text)
      end
    end
  end
  
  def have_the_toolbar
    have_selector("#rack_bug_toolbar")
  end
  
  def have_panel(panel)
    panel = panel.to_s.demodulize.underscore.sub("_panel", "")
    have_selector("##{panel}.panel_content")
  end
end