## RSpec

way of writing human readable tests, build it mocking stubing not important, changes the language and syntax to its more readble. works fine no change in merb.

When using stubs with RSpec you can roughly categorise the methods you are going to use into two categories. On one side you have the sub! and should_receive methods which refine what methods you expect to be called with what parameters and potentially what they should return in the case of the test being run. On the other side you have assertions which test the output and value or variables. The should method is primarily used when asserting things.



#### What to test?

(TODO) - how to write good test and what should just trust works