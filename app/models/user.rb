class User < ApplicationRecord
    enum role: [:user_normale, :admin]
    after_initialize :set_default_role, :if => :new_record?

    def set_default_role
      self.role ||= :user_normale
    end

    def getRole
        if(self.admin?)
         return "admin"
        else
         return "user normale"
        end
         
     end
 


    attr_accessor :remember_token, :reset_token
    has_many :achievements
    ratyrate_rater
    ratyrate_rateable "ranking"
    before_save :downcase_email
    validates :username, presence: true, :length => { :maximum => 20 }, uniqueness: true;
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, length: { minimum: 8,maximum:15 }, confirmation: {case_sensitive:true},allow_blank: true; 
    validates :password_confirmation, presence: true,allow_blank: true;

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)    
    end
    
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def award(achievement)
        achievements << achievement.new
    end

    def awarded?(achievement)
        achievements.count(:conditions => { :type => achievement }) > 0
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    private 

        def downcase_email
            self.email = email.downcase
        end
end

class Achievement < ActiveRecord::Base
    belongs_to :user
end

class AchievementSystem < Achievement
    
    def self.check_conditions_for(user)
        #implement condition
    end
end