class User < ActiveRecord::Base
  has_many :inverse_contact, :class_name => "Contact", :foreign_key => "user_id"
  has_many :contacts, :through => :inverse_contact
  has_many :results

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
          :presence => {:message => "Enter your email address!" },
          :format => { :with => VALID_EMAIL_REGEX, :message => "Enter a valid Email address !"},
          :uniqueness => {:case_sensitive => false, :message => "Email already exists!"}

  VALID_NAME_REGEX = /\A[a-z ,.'-]+\z/i
  validates :name,
            :presence => true,
            :allow_blank => false,
            :format => { :with => VALID_NAME_REGEX, :message => "Enter a valid name!"}

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      # must move this; just a test. do it on click (ajax call?)
      # # I need to grab user from controller
      # FollowUpEmailJob.new(auth["info"]["email"]).enqueue(wait: 10.seconds)
    end
  end

  def first_name
    self.name.split(" ").first
  end

  def last_name
    self.name.split(" ").second
  end

  def person_info
    {
      first_name: self.first_name,
      last_name: self.last_name,
    }
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
