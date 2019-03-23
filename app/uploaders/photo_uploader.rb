class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def default_url
    ActionController::Base.helpers.asset_path("default_event.png")
  end
end
