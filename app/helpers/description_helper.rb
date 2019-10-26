module DescriptionHelper
  include ActionView::Helpers::SanitizeHelper
  def description(description)
    if description
      sanitized = strip_tags(description)
      with_line_breaks = sanitized.gsub(/\n\r/, "<br/>")
      with_more_line_breaks = with_line_breaks.gsub(/\n/, "<br/>")
      with_links = with_more_line_breaks.gsub(URI.regexp) do |*m|
        "<a href=\"#{$&}\">#{$&}</a>" if $&.include?('http')
      end
      raw(with_links)
    else
      ''
    end
  end
end
