class User < ActiveRecord::Base

  before_save { email.downcase! }
  before_create :create_remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :character_id, presence: true, uniqueness: true
  validates :character_name, presence: true, uniqueness: true
  has_secure_password

  def User.new_remember_token
      SecureRandom.urlsafe_base64
    end

    def User.hash(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    private

      def create_remember_token
          self.remember_token = User.hash(User.new_remember_token)
      end
end
