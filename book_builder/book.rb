module BookBuilder
  class Book
    def initialize(name="Book",root_path="./",format="*")
      @name = name
      @format = format
      @root_path = root_path
      @files = FileFinder.new("#{@root_path}source/",format)
    end
    
    def html
      render(:html)
    end
    
    def html!
      save!(self.html,:html)
    end
    
    def plain_text
      render(:txt)
    end
  
    def plain_text!
      save!(self.plain_text,:txt)
    end
    
    def render(format)
      copy_support_files
      template = ERB.new File.open("#{@root_path}templates/#{@name}.#{format}.erb",'r') { |f| f.read }
      template.result(binding)
    end
    
    def save!(txt,format=:txt)
      output_file = "#{@root_path}output/index.#{format}"
      FileUtils.touch(output_file)
      File.open(output_file,'w') { |file| file << txt }
    end
    
    def parse_body_to(format=:plain_text)
      send(:"#{@format}_to_#{format}",body)
    end
    
    def markdown_to_html(text='')
      text = text.to_markdown if text.respond_to? :to_markdown
      doc = Hpricot(BlueCloth::new(text).to_html)
      doc.traverse_element('h1','h2','h3','h4','h5','h6') do |h| 
        Hpricot::Elements[h].set( :id, Book.dom_id_from(h.inner_text) ) 
      end
      doc.to_html
    end
    
    def markdown_to_plain_text(text='')
      text.to_markdown if text.respond_to? :to_markdown
      text
    end
    
    def body
      @files.merged_contents
    end
    
    def toc
      ''
      Toc.from_html(parse_body_to(:html)).send(:"to_#{@format}")
    end
    
    def parse_toc_to(format=:plain_text)
      send(:"#{@format}_to_#{format}",toc)
    end
    
    def prepare!
      if File.exists? @root_path
        puts "Skipping... '#{@root_path}' already exists"
      else
        FileUtils.mkdir_p(@root_path)
        puts "Created... '#{@root_path}'"
      end
      FileUtils.cd(@root_path)
      %w( output templates source ).each do |dir|
        if File.exists? dir
          puts "Skipping... '#{@root_path}#{dir}' already exists"
        else
          FileUtils.mkdir(dir)
          puts "Created... '#{@root_path}#{dir}'"
        end
      end
      FileUtils.cd("./templates/")
      templates = supported_formats.map { |f| "#{@name}.#{f}.erb" }
      templates.each do |template|
        if File.exists? template
          puts "Skipping... '#{@root_path}templates/#{template}' already exists"
        else
          FileUtils.touch(template)
          puts "Created... '#{@root_path}templates/#{template}'"
        end
      end
    end
    
    def supported_formats
      [:html,:txt]
    end
    
    def copy_support_files
      final_asset_path = "#{@root_path}output/Assets/"
      FileUtils.rm_rf(final_asset_path) if File.exists? final_asset_path
      FileUtils.mkdir final_asset_path 
      Dir["#{@root_path}source/Assets/*"].entries.each do |asset|
        FileUtils.cp asset, final_asset_path
      end
    end
    
    def self.dom_id_from(text)
      text.gsub(/\W+/,'_').downcase!
    end
    
    def clear_stale_data
      FileUtils.rm_rf "#{@root_path}output"
      FileUtils.mkdir "#{@root_path}output"
    end
  end
end