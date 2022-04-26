class Invoice < ApplicationRecord

  validates_presence_of :status
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: {"in progress" => 0, "completed" => 1, "cancelled" => 2}

  def self.pending_invoices
    where(status: 0)
    .order(:created_at)
  end

  def format_time
    created_at.strftime('%A, %B %e, %Y')
  end

  def total_rev
    invoice_items.sum("quantity * unit_price")
  end

  def discount_rev(merchant)
    discount = merchant.invoice_items
    .joins(:discounts)
    .where("invoice_items.quantity >= discounts.quantity_threshold")
    .select("invoice_items.*, (sum(invoice_items.quantity * invoice_items.unit_price)) * (discounts.percentage_discount / 100.0) AS rev")
    .group("invoice_items.id")
    .group("discounts.id")
    .sum(&:rev)

    total_rev - discount
  end

  def total_discount_rev
    discount = invoice_items.joins(:discounts)
    .where("invoice_items.quantity >= discounts.quantity_threshold")
    .select("invoice_items.*, (sum(invoice_items.quantity * invoice_items.unit_price)) * (discounts.percentage_discount / 100.0) AS rev")
    .group("invoice_items.id")
    .group("discounts.id")
    .sum(&:rev)

    total_rev - discount
  end
end
