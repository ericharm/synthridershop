module DescriptionHelper
  def description(description)
    if description
      with_links = description.gsub(/[\s](http[^\s]*)/) { |m| "<a href=\"#{m}\">#{m}</a>" }
      raw(with_links.gsub(/[\n\r]+/, "<br/>"))
    else
      ''
    end
  end
end
