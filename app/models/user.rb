class User <ApplicationRecord

  scope :active, -> { where(active: 'true') }
  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates_confirmation_of :password
  validates_presence_of :password_digest

  validates_presence_of :name, :address, :city, :state, :zip
  validates_numericality_of :zip, { only_integer: true }

  belongs_to :merchant, optional: true
  has_many :orders, dependent: :destroy

  has_secure_password

  enum role: %w(user merchant_employee merchant_admin admin_user)


end
