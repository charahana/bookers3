class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy

  attr_writer :login

  def login
    @login || self.name || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    login = warden_conditions[:login].downcase
    where("lower(name) = :value OR lower(email) = :value", { value: login }).first
  end

  has_one_attached :profile_image

  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
