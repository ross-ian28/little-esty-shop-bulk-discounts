require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status}
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
     it { should belong_to :customer }
     it { should have_many :transactions }
  end

  describe 'instance methods' do
    before :each do
      @merchant1 = Merchant.create!(name: "Pabu")
      @merchant2 = Merchant.create!(name: "Thor")

      @item1 = Item.create!(name: "Brush", description: "Brushy", unit_price: 10, merchant_id: @merchant1.id)
      @item2 = Item.create!(name: "Peanut Butter", description: "Yummy", unit_price: 12, merchant_id: @merchant1.id)
      @item3 = Item.create!(name: "Peanut Butter", description: "Yummy", unit_price: 30, merchant_id: @merchant2.id)

      @customer1 = Customer.create!(first_name: "Loki", last_name: "R")

      @invoice1 = @customer1.invoices.create!(status: "completed")
      @invoice2 = @customer1.invoices.create!(status: "in progress")

      @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 20, unit_price: 10)
      @ii2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, status: 1, quantity: 5, unit_price: 12)
      @ii3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item3.id, status: 1, quantity: 15, unit_price: 30)

      @discount1 = @merchant1.discounts.create!(percentage_discount: 50, quantity_threshold: 10)
    end
    it "returns total revenue from all items in invoice" do
      expect(@invoice1.total_rev).to eq(260)
    end

    it "#pending_invoices" do
      expect(Invoice.pending_invoices).to eq([@invoice2])
    end

    it "#format_time" do
      expect(@invoice1.format_time).to eq(Time.now.strftime('%A, %B %e, %Y'))
    end

    it "returns total revenue from all items in invoice for a merchant" do
      expect(@invoice1.discount_rev(@merchant1)).to eq(160)
    end

    it "returns total revenue from all items" do
      expect(@invoice1.total_discount_rev).to eq(160)
    end
  end
end
