steps_for(:posts) do
  
  Then "I should see a list of posts" do
    response.body.should match_selector('div.posts')
  end
  
  Given "there are posts" do
    2.times do 
      post = Post.new(valid_post_attrs)
      post.save
    end
  end
  
end