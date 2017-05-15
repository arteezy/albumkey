module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class='alert alert-danger alert-dismissible' role='alert'>
      <button class='close' type='button' data-dismiss='alert' aria-label: 'Close'>
        <span aria-hidden='true'>×</span>
      </button>
      <ul class='halfpadding'>
        #{messages}
      </ul>
    </div>
    HTML

    html.html_safe
  end
end
