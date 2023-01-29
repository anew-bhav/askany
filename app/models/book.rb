class Book < ApplicationRecord
  include PdfUploader::Attachment(:file)

  has_many :questions
end
