class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  protected
    # Validate image uploads
    def check_zaic_img(img)
      return nil unless img.attached?
      if !img.image?
        return "must be an image"
      elsif img.blob.byte_size > Rails.application.config.zaic_max_file_size
        return "file too large"
      end
      return nil
    end
end
