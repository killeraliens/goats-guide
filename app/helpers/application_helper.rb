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

end
