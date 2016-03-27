module ApplicationHelper
  def nav_link(text, path, options = {})
    li_options = current_page?(path) ? { class: "active" } : {}
    content_tag(:li, li_options) do
      link_to text, path, options
    end
  end
end
