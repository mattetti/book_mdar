### Spec'ing Controllers

#### Getting started

Testing controllers typically involves stubbing out some methods, making a fake request and then ensuring the right variables are assigned, exceptions are raised and views rendered.

A good start is testing the show action in our Posts controller.

    class Posts < Application
      provides :html
  
      def show(id)
        @post = Post[id]
        render @post
  
        rescue DataMapper::ObjectNotFoundError
        raise NotFound
      end
    end

Our first test will ensure that Post[1] is called when /posts/1 is visited, and when the post exists the response code is 200 OK.

    describe Posts, "show action" do
      it "should find post and render show view" do
        Post.should_receive(:[]).with("1")
        get('/posts/1', :yields => :controller) do
          controller.stub!(:render)
        end
        status.should == 200
      end
    end

The first should_receive ensures that Post[1] is called, we could mock out a Post instance to return here, but in this case we're only interested in it being called and not raising an exception.

Next we use the get method to make a request to the controller, the :yields option allows us to set what the get request returns. Here we want to grab the controller and then stub out the render method before the request is made. Anything inside you get method's block will be executed before the request is dispatched.

After the request has been dispatched, several methods are available to return the results from the request: body, status, params, cookies, headers, session, response and route. Note that these all just call the same method on controller (so status is the same as controller.status).

This test was fairly simple, and it's likely you won't need to such tests if your controllers are as simple as ours. But once you have more than a few lines in your controller, simple response status checks can be useful for ensuring the overall integrity of your app.

A more important test would be ensuring that a 404 is returned when the post cannot be found in the database. When Datamapper cannot find a record is raises Datamapper::ObjectNotFoundError. Merb has several useful exception classes which will set the correct status and then call the relevant action in your Exceptions controller. Raising NotFound will set the status to 404 and then call the not_found action, which can return a much nicer.

    it "should return 500 if post doesn't exist" do
      post = mock(Post)
      Post.should_receive(:[]).with("1").and_raise(DataMapper::ObjectNotFoundError)
      get('/posts/1')
      status.should == 404
    end

Unlike the last test there was no need for us to stub the render method because DataMapper::ObjectNotFoundError is raised before it is reached.

#### Testing multipart forms

(TODO: Make and example of uploading assets in the simple blog)

The multipart_post method allows you to include files in a fake request. There must however be an actual file to be opened and submitted. If you put the file in the same directory as your spec, use File.dirname(__FILE__) to ensure the full path is used.

If you are going to open the tempfile which is uploaded, remember to stub out File.open. Watch out though, if you use simply open instead of File.open it won't be the File.open you stubbed out. The other issue here is within the spec we have no way of knowing what the filename of the tempfile is, so we have to assume it's correct and use an_instance_of(String) so any filename is accepted.

(TODO: test code)

    describe Posts, "create action" do 
        it "should receive file" do
          File.should_receive(:open).with(an_instance_of(String))
          multipart_post("/posts", {:image => File.open(File.join( File.dirname(__FILE__), "picture.jpg"))})
          controller.assigns(:filename).should == "picture.jpg"
        end
    end

Your controller would look something like this.

    class Posts < Application
        def create
            fp = File.open(params[:image][:tempfile].path)
            @filename = params[:image][:filename]
        end
    end

#### More ways to dispatch a request

There are several other ways to dispatch a request in your test. 
Look at [Merb's Wiki](http://wiki.merbivore.com/pages/controller-specs) for more information