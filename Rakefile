require 'book_builder/book_builder'



namespace :book do
  desc "compile files from the current directory and publish to all available formats"
  task :publish do
    html()
    plain_text()
    log 'Done!'
  end
  
  desc "Outstanding TODO's"  
  task :todo do
    FileList["book/source/**/*.markdown"].egrep(/TODO/) do |fn, count, line|
      fn.gsub!(/\D+/, '.').gsub!(/^\.|\.$/,'')
      log "#{line.chomp} (Section #{fn}, Line #{count})"
    end
  end

  namespace :publish do
    desc "compile files from the current directory into html"
    task :html do
      log 'Publishing HTML...'
      html
      log 'Done!'
    end
  
    desc "compile files from the current directory into pain text"
    task :text do
      log 'Publishing plain text...'
      
      plain_text
      log 'Done!'
    end
    
    desc "publish all versions and then deploy"
    task :deploy => [:html,:text] do
      deploy
    end
  end
  
  desc "prepare a structure for publishing to"
  task :prepare do
    log 'Preparing a publishing structure...'
    book = default_book
    book.prepare!
    log 'Done!'
  end
  
  desc "deploy the currently built version to the site"
  task :deploy do
    deploy
  end
end

# create an html output
def html
  create_output_folder
  book = default_book
  log 'Processing HTML format...'
  book.html!
end

# create a plain text output
def plain_text
  create_output_folder
  book = default_book
  log 'Processing Plain Text format...'
  book.plain_text!
end

# move the output to the server
def deploy
  `scp -r book/output/* ninja@4ninjas.org:public_html/merb/`
end


# this is here as a helper so we can send messages somewhere other than stdout at a later date if we want to.
def log(msg='')
  puts msg
end

def default_book
  BookBuilder::Book.new('merb_book','./book/', :markdown)
end

# create the output folder if it doesn't exist yet
def create_output_folder
  output_folder = './book/output/'
  Dir.mkdir(output_folder) unless File.directory?(output_folder)
end


