module Features
  module ContentOrder
    RSpec::Matchers.define :appear_before do |later_content|
      match do |earlier_content|
        page.body.index(earlier_content) < page.body.index(later_content)
      end
    end

    RSpec::Matchers.define :appear_after do |later_content|
      match do |earlier_content|
        page.body.index(earlier_content) > page.body.index(later_content)
      end
    end
  end
end
