module DescriptionHelper
  def description(description)
    if description
      with_links = description.gsub(/[\s](http[^\s]*)/) { |m| "<a href=\"#{m}\">#{m}</a>" }
      with_line_breaks = with_links.gsub(/\n\r/, "<br/>")
      raw(with_line_breaks.gsub(/\n/, "<br/>"))
    else
      ''
    end
  end
end
