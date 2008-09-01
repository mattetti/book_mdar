require 'book_builder/book_builder'

namespace :book do
  desc "compile files from the current directory and publish to all available formats"
  task :publish => ['output:html', 'output:plain'] do
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
    task :html => 'output:html' do
      log 'Done!'
    end
  
    desc "compile files from the current directory into plain text"
    task :text => 'output:plain' do
      log 'Done!'
    end
    
    desc "publish all versions and then deploy"
    task :deploy => ['output:html', 'output:plain'] do
      deploy
    end
  end
  
  desc "prepare a structure for publishing to"
  task :prepare do
    log 'Preparing a publishing structure...'
    book = BookBuilder::Book.new('merb_book','./book/', :markdown)
    book.prepare!
    log 'Done!'
  end
  
  desc "deploy the currently built version to the site"
  task :deploy do
    deploy
  end
  
  namespace :output do
    task :setup do
      output_folder = './book/output/'
      Dir.mkdir(output_folder) unless File.directory?(output_folder)
      
      @book = BookBuilder::Book.new('merb_book','./book/', :markdown)
    end
    
    task :html => :setup do
      @book.html!
    end
    
    task :plain => :setup do
      @book.plain_text!
    end
  end
end
