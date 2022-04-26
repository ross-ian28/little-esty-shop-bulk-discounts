class InvoiceItem < ApplicationRecord

  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status
  validates_presence_of :item_id
  validates_presence_of :invoice_id

  belongs_to :item
  belongs_to :invoice
  has_many :discounts, through: :item

  enum status: {pending: 0, packaged: 1, shipped: 2}

  def applied_discount
    found_discount = discounts
    .where("quantity_threshold <= ?", self.quantity)
    .order(percentage_discount: :desc)
    .first

    if found_discount.nil?
      nil
    else
      found_discount
    end
  end
end
