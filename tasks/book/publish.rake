namespace :book do
  desc "compile files from the current directory and publish to all available formats"
  task :publish => ['publish:html', 'publish:text']
  
  desc "deploy the currently built version to the site"
  task :deploy => 'publish:deploy'
  
  namespace :publish do
    desc "compile files from the current directory into html"
    task :html do
      announce('Publishing HTML...') do
        invoke_task 'book:output:html'
      end
    end
  
    desc "compile files from the current directory into plain text"
    task :text do
      announce('Publishing Plain Text...') do
        invoke_task 'book:output:plain'
      end
    end
    
    desc "publish all versions and then deploy"
    task :deploy => ['book:output:html', 'book:output:plain'] do
      `scp -r book/output/* ninja@4ninjas.org:public_html/merb/`
    end
  end
end
