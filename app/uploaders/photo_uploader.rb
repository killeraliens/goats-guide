class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def default_profile_url
    ActionController::Base.helpers.asset_path("/images/default_profile.jpg")
  end

  def default_event_url
    ActionController::Base.helpers.asset_path("/images/default_event.jpg")
  end
end
