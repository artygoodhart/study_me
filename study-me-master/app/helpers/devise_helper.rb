module DeviseHelper
  # A simple way to show error messages for the current devise resource. If you need
  # to customize this method, you can either overwrite it in your application helpers or
  # copy the views to your application.
  #
  # This method is intended to stay simple and it is unlikely that we are going to change
  # it to add more behavior or options.
  def devise_error_messages!
    return "" if resource.errors.empty?

    html = <<-HTML
    <div class="flash error">#{resource.errors.full_messages.first}#{image_tag asset_path("icons/close.png"), id: "close_flash"}</div>
    HTML

    html.html_safe
  end
end
