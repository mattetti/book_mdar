namespace :book do
  namespace :output do
    task :html => ['book:setup:output_dir', 'book:setup:book'] do
      @book.html!
    end

    task :plain => ['book:setup:output_dir', 'book:setup:book'] do
      @book.plain_text!
    end
  end
end
