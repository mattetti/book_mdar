# Markdown loader
# Attempts to load RDiscount markdown parser first, if that
# fails then it will try to load PEGMarkdown and if that also
# fails then it will try to load BlueCloth.
#
# This is done because both RDiscount and PEGMarkdown are
# faster and more correct Markdown parsers.

begin
  require 'rdiscount'
  BlueCloth = RDiscount
rescue LoadError
  begin
    require 'peg_markdown'
    BlueCloth = PEGMarkdown
  rescue LoadError
    begin
      require 'maruku'
      BlueCloth = Maruku
    rescue LoadError
      begin
        require 'bluecloth'
      rescue LoadError
        raise "Unable to load Markdown parser. Please install rdiscount, rpeg-markdown or bluecloth."
      end
    end
  end
end
