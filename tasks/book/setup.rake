namespace :book do
  namespace :setup do
    task :output_dir do
      output_folder = './book/output/'
      Dir.mkdir(output_folder) unless File.directory?(output_folder)
    end
    
    task :book do
      @book = BookBuilder::Book.new('merb_book','./book/', :markdown)
    end
  end
end
