require 'book_builder/book_builder'

namespace :book do
  desc "Outstanding TODO's"
  task :todo do
    FileList["book/source/**/*.markdown"].egrep(/TODO/) do |fn, count, line|
      fn.gsub!(/\D+/, '.').gsub!(/^\.|\.$/,'')
      log "#{line.chomp} (Section #{fn}, Line #{count})"
    end
  end

  desc "prepare a structure for publishing to"
  task :prepare => ['book:setup:book'] do
    announce('Preparing a publishing structure...') do
      @book.prepare!
    end
  end
end
