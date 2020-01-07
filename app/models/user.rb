class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    before_save do 
        self.email.downcase! 
        self.name.downcase!
    end
    validates :name, presence: true, length: { maximum: 20   }
    validates :email, presence: true, length: { maximum: 244 }, 
                                format: { with: VALID_EMAIL_REGEX },
                                uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }

    # Returns the has digest of a given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
end



