module ApplicationHelper
  def current_class?(test_path)
    return 'active' if request.path == test_path

    ''
  end

  def show_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end

  # def embedded_svg(filename, options = {})
  #   assets = Rails.application.assets
  #   file = assets.find_asset(filename).source.force_encoding("UTF-8")
  #   doc = Nokogiri::HTML::DocumentFragment.parse file
  #   svg = doc.at_css "svg"
  #   if options[:class].present?
  #     svg["class"] = options[:class]
  #   end
  #   raw doc
  # end
end
