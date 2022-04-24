class Item < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :discounts, through: :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  enum status: { disabled: 0, enabled: 1 }

  def best_sales_date
    date_hash = Invoice.joins(:items)
      .where("items.id=#{id}")
      .select("invoices.created_at AS invoice_created_at, invoice_items.quantity AS quantity")
      .group("date_trunc('day', invoices.created_at)")
      .sum(:quantity)
    return "no sales records available" if date_hash == {}
    max = [{"starter date" => 0}]
    date_hash.each_pair do |date, sum|
      if max[0].values[0] < sum
        max.clear
        max << {"#{date}" => sum}
      elsif max[0].values[0] == sum
        max << {"#{date}" => sum}
      end
    end
    max.sort!{ |a,b| a.keys.first <=> b.keys.first }
    Time.parse(max.last.keys.first).strftime("%Y.%m.%d")
  end

end
