## RSpec

RSpec is a testing framework  which uses a Domain Specific Language or DSL to
provide more human readable test code.

When using stubs with RSpec you can roughly categorise the methods you are 
going to use into two categories. On one side you have the `stub!` and 
`should_receive` methods which refine what methods you expect to be called 
with what parameters and potentially what they should return in the case of 
the test being run. On the other side you have assertions which test the output 
and value or variables. The `should` method is primarily used when asserting
specific results.


#### What to test?

(TODO) - how to write good test and what should just trust works