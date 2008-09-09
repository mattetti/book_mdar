# Required to do just about anything with the book.
require 'book_builder/book_builder'

# The book tasks are loaded first, then any
# additional tasks are loaded. This should
# allow you to override the book tasks with
# your own.
Dir["tasks/book/*.rake"].each { |ext| load ext }
Dir["tasks/*.rake"].each { |ext| load ext }

def log(msg = '')
  puts msg
end

def announce(msg)
  log msg
  yield
  log 'Done!'
end

def invoke_task(*names)
  names.each do |name|
    Rake::Task[name].invoke
  end
end
