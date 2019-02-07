#
module PDFAttachment
  extend ActiveSupport::Concern
  extend Paperclip::Glue

  included do
    has_attached_file :pdf_attachment

    validates_attachment_content_type :pdf_attachment,
                                      content_type: %w(application/pdf)
  end
end
