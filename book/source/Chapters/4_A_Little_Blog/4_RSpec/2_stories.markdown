## Stories

(TODO) - finish stories section

RSpec Stories are use to replace the specification phase in requirements 
gathering, in the form of scenarios. So we have both a spec and a integration 
tests.

Add this line to your app's test environment:

	dependency "merb_stories"
	
Now generate your story:

	merb-gen story mystory

Now run your story:

	MERB_ENV=test rake story[mystory]
  
Yes, you must include the square brackets.

Now fill out your story. There are some differences to Rails' versions. 
The best places to look for help are in the Merb code itself:

	spec/public/test/controller _matchers _spec.rb
	lib/merb-core/test/helpers
	lib/merb-core/test/matchers
	To start you off, here are the steps for a simple integration test:

	steps_for(:homepage) do
	  When("I visit the root") do
	    @mycontroller = get("/")
	  end
	  Then("I should see the home page") do
	    @mycontroller.should respond_successfully
	    @mycontroller.body.should contain("Hello") 
	  end    
	end


