## Stories

(TODO) - finish stories section

RSpec Stories are use to replace the specification phase in requirements gathering, in the form of scenarios. so we have both a spec and a integration tests. human/customer readable.

Add this line to your app's `init.rb`:

	dependency "merb_stories" if Merb.environment == "test"
	
Now generate your story:

	merb-gen story mystory

Now run your story:

	rake story\[mystory\]

Yes, you must include the square brackets, and you have to escape them.

Now fill out your story. There are some differences to Rails' versions. The best places to look for help are in the Merb code itself:

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


