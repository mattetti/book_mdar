## Using X-Accel-Redirect and nginx\_send\_file

In your usual merb application, most of your assets (images, stylesheets etc.)
can cheerfully sit in the public folder of the application, ready to be served
up quickly and efficiently by nginx (or whatever webserver you're using) without
having to trouble mongrel or thin or whatever is running the merb part of the
application.  There's no need for merb to see the request, because they're
public files, ready to be given to everybody.

Right?

Most of the time, that's fine, but sometimes, you want to protect some premium
content.  Perhaps premium users get more themes, or perhaps you have to register
before you can see some images or download pdfs.  Now requests like those are
going to have to hit merb, so that you can check the user has sufficient
privileges to do so.  These might be as simple as 'is a user' or as complex as
you can imagine them to be.

### The Simple Way

Just use `send_file`.  I'm assuming in this example there are some pdf reports,
which only appropriately authenticated users can access, which is what the
before filter does.  All the important stuff happens in the `download_report`
action, so I'm ignoring the rest of the controller.  I'm also assuming the
appropriate MIME type for pdfs has been set up.

    class Reports < Application

      before :check_authentication, :only => :download_report

      def download_report
        only_provides :pdf

        @report = Report.first(:name => params[:name])
        send_file(@report.file_path, :type => 'application/pdf')
      end
    end

Assuming that `full_path` returns the full path to the report file, perhaps
located in the `private/reports` subdirectory of the merb application (_NOT_ in
the public folder) then the file will be sent to the client with the appropriate
headers and they'll download it.  Since you're probably using mongrel or thin,
this won't actually tie the whole application up, it will be run in a separate
thread or EventMachine connection.  Everything's good, right?

Well, not entirely.  First, there's a small delay whilst the file is read into
memory.  Second, there's the fact that the file is read into memory and has to
remain there whilst it's sent.  Not so much of an issue for a 50kb image, but
when you start to get a couple of dozen users wanting to download a 10 or 20mb pdf
report, all that memory usage starts to become quite noticeable.

### X-Accel-Redirect

This is where nginx comes in.  Nginx offers a facility which it calls
[X-Accel-Redirect](http://wiki.codemongers.com/NginxXSendfile), which works
quite simply.  When appropriate headers are set by the application, nginx will
read files outside the normal web root, and send them to the user.

There are two parts to this.  The first is a section in the nginx config file.

    location /private/ {
        internal; # only the server can make requests here, a client will get a 404
        alias /path/to/merb/root/private/; # note trailing slash
    }

This snippet goes inside the nginx server block.  `internal` is the directive
which gives us our protection, since a direct request to the url will just give
a 404 error, not serve the file.

For the second part, we re-write our action from earlier:


    def download_report
      only_provides :pdf

      @report = Report.first(:name => params[:name])
      headers['Content-Type'] = ''
      nginx_send_file(@report.file_path)
    end

We have to (at the time of writing) set the content type to blank, to let nginx
set it appropriately, although we could also set it accurately ourselves.  All
that's left is to make sure the file path is correct. This path should begin
with `/private/` and should be the path of the file in the private directory.
Something like `/private/reports/secret_report.pdf`.  The nginx_send_file method
takes care of setting the `X-Accel-Redirect` header appropriately.

Assuming the file exists, nginx will send it to the client, without merb needing
to load it into memory and with nginx's trademark speed and efficiency.
