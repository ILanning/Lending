class Agreement < ActiveRecord::Base
  validates :amount, presence:true, numericality: { only_integer: true , greater_than: 0 }
  validate :lender_broke, :lender_overdraw, :borrower_overpay
  belongs_to :lender
  belongs_to :borrower

  def lender_broke
    if lender.amount_left == 0
      errors.add(:amount, "lender is out of money")
    end
  end

  def lender_overdraw
    if lender.amount_left < amount
      errors.add(:amount, "lender doesn't have that much")
    end
  end

  def borrower_overpay
    if borrower.amount_left < amount
      errors.add(:amount, "borrower doesn't need that much")
    end
  end
end
