# To be included for models with attached vertical video
module BackgroundPhotoAttachment
  extend ActiveSupport::Concern
  extend Paperclip::Glue

  included do
    has_attached_file :background_photo, styles: {
      medium: { geometry: '2048x1152#' },
      small: { geometry: '1024x576#' }
    }

    validates_attachment_content_type :background_photo,
                                      content_type:
                                        %w(image/jpeg image/gif image/png)
  end
end
