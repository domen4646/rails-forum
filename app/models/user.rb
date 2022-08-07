class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  validates_presence_of :email
  validates_presence_of :username
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  has_one_attached :avatar

  attr_readonly :email

  # Validate user's profile image
  validate :validate_avatar
  
  # If user owns a particular post
  def owns?(post)
    !post.nil? && !post.user.nil? && post.user == self
  end

  # If the user is banned
  def banned?
    self.role == 0
  end

  # If the user is a regular user (not a mod, banned, or admin)
  def regular?
    self.role == 1
  end

  # If a user is a mod
  def mod?
    self.role == 2
  end

  # If a user is an admin
  # The only difference between mods and admins is
  # that admins can remove or add mods
  def admin?
    self.role == 3
  end

  # If a user has the authority over other users
  # for example, if a user can be banned, posts deleted, or hidden ...
  def has_authority?
    self.role >= 2
  end

  def has_authority_over?(target)
    has_authority? && (target.nil? || self.role > target.role)
  end

  # Returns a string representation of a role
  def role_str
    case self.role
    when 0
      'banned'
    when 1
      'regular user'
    when 2
      'mod'
    when 3
      'admin'
    else
      'unknown'
    end
  end

  # Returns a color of a particular role
  def role_color
    case self.role
    when 0
      'text-danger'
    when 2
      'text-success'
    when 3
      'text-warning'
    else
      'text-black'
    end
  end

  # Prevent user from authenticating if banned
  def active_for_authentication?
    super && !banned?
  end

  # Show message for banned users
  def inactive_message
    banned? ? "Your account is banned" : super
  end

  def has_post_authority?(post)
    !post.nil? && (self == post.user || has_authority_over?(post.user))
  end

  private
    def validate_avatar
      err = check_zaic_img(self.avatar)
      unless err.nil?
        self.avatar.purge
        errors.add(:avatar, err)
      end
    end

end
