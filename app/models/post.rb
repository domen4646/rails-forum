class Post < ApplicationRecord
    validates_presence_of :title
    validates_presence_of :content
    belongs_to :user
    has_one_attached :post_image
    has_many :comments, :dependent => :destroy

    # Validate post image
    validate :validate_post_image

    def is_owner?(owner)
        !self.user.nil? && self.user == owner
    end

    def set_deleted
        if self.post_image.attached?
            self.post_image.purge
        end
        self.content = "[deleted]"
        self.is_deleted = true
    end

    def marked_deleted?
        self.is_deleted
    end

    private
        def validate_post_image
            err = check_zaic_img(self.post_image)
            unless err.nil?
                self.post_image.purge
                errors.add(:post_image, err)
            end
        end

end
