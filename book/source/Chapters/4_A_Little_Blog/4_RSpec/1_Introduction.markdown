## RSpec

When using stubs with RSpec you can roughly categorise the methods you are going to use into two categories. On one side you have the sub! and should_receive methods which refine what methods you expect to be called with what parameters and potentially what they should return in the case of the test being run. On the other side you have assertions which test the output and value or variables. The should method is primarily used when asserting things.

#### What is it?

(TODO) - BDD

#### Why test?

(TODO) benefits of testing

#### What to test?

(TODO) - how to write good test and what should just trust works

### Stories

(TODO) - Stories, more details
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

### mocking

(TODO) - What is it and why mock


