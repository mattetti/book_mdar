steps_for(:general) do
  
  ## Webrat specific

  When "I enter $value in $field" do |value,field|
    fills_in field,:with=>value
  end

  When "I click the link $foo" do |link_name|
    clicks_link link_name
  end
  
  When "I click the button $button_name" do |button_name|
    clicks_button button_name
  end
  
  When "I select $option from $field" do |option, field|
    selects option, :from => field
  end
  
  When "I check $checkbox" do |checkbox|
    checks checkbox
  end
  
  When "I visit $url" do |url|
    visits url
  end
  
  ## text helpers
  
  Then("I should see the text $text") do |text|
    response.body.should have_text(text)
  end
  
  Then("I should not see the text $text") do |text|
    response.body.should_not have_text(text)
  end
  
  ## match message divs
  Then "I should see an error message" do
    response.body.should match_selector("div.error")
  end
  
  Then "I should see a notice message" do
    response.body.should match_selector("div.notice")
  end
  
  Then "I should see a success message" do
    response.body.should match_selector("div.success")
  end
  
end