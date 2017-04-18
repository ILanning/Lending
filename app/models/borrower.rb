class Borrower < ActiveRecord::Base
  has_secure_password
  validates :first_name, :last_name, :email, :password, :reason, :discription, :amount, presence:true
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message:"Invalid email" }
  before_validation :down_email
  has_many :agreements, dependent: :destroy
  has_many :lenders, through: :agreements

  def amount_recieved
    return agreements.sum(:amount)
  end
  def amount_left
    return amount - agreements.sum(:amount)
  end
  def full_name
    return first_name + " " + last_name
  end
  def down_email
    email.downcase!
  end
end
