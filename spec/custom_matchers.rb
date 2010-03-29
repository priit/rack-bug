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
    simple_matcher("have the toolbar") do |response|
      response.body.include? 'id="rack_bug_toolbar"'
    end
  end
  
  def have_the_original_content
    simple_matcher("have the original content") do |response|
      response.body.include? '<p>Hello</p>'
    end
  end
  
  def have_panel(panel)
    simple_matcher("have the #{panel} properties panel") do |response|
      panel = panel.to_s.demodulize.underscore.sub("_panel", "")
      response.body.include? %Q{<div class="panel_content" id="#{panel}">}
    end
  end
end