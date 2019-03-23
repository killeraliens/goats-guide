class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def default_url(*args)
    ActionController::Base.helpers.asset_path("fallback/2_default.png")
  end
end
