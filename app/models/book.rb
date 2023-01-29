class Book < ApplicationRecord
  include PdfUploader::Attachment(:file)
end
