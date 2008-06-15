steps_for(:posts) do
  
  Then "I should see a list of posts" do
    response.body.should match_selector('div.posts')
  end
  
  Given "there are posts" do
    Post.create()
  end
  
end