module AlbumsHelper
  def toggle_button(name, value)
    active = true if params[name] == value

    content_tag :div, class: "btn btn-primary #{name} #{'active' if active}" do
      concat content_tag :input, nil, type: 'radio', name: name, id: "#{name}_#{value}", value: value, checked: active
      concat content_tag :span, nil, class: "glyphicon glyphicon-sort-by-attributes#{'-alt' if value == 'asc'}"
    end
  end
end
