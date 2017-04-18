class Lender < ActiveRecord::Base
  has_secure_password
  validates :first_name, :last_name, :email, :password, :money, presence:true
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message:"Invalid email" }
  before_validation :down_email
  has_many :agreements, dependent: :destroy
  has_many :borrowers, through: :agreements

  def amount_lent
    return agreements.sum(:amount) * -1
  end
  def amount_left
    return money - agreements.sum(:amount)
  end
  def full_name
    return first_name + " " + last_name
  end
  def down_email
    email.downcase!
  end
end
