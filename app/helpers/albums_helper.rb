module AlbumsHelper
  def toggle_button(name, value)
    active = true if params[name] == value

    haml_tag :div, class: "btn btn-primary #{name} #{'active' if active}" do
      haml_tag :input, type: 'radio', name: name, id: "#{name}_#{value}", value: value, checked: active
      haml_tag :span, class: "glyphicon glyphicon-sort-by-attributes#{'-alt' if value == 'asc'}"
    end
  end
end
