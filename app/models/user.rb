class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  before_create :create_key

  def create_key
    self.key = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Api.exists?(key: random_token)
    end
  end

  def to_json(with_key)
    data = Jbuilder.encode do |json|
      json.birthday birthday
      json.first_name first_name
      json.last_initial last_initial
      json.gender gender
      json.avatar

      if with_key
        json.key = key
      end
    end

    JSON.parse(data)
  end
end
