require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :invoice_id }
  end
  describe "relationships" do
     it { should belong_to :item }
     it { should belong_to :invoice }
  end

  describe 'instance methods' do
    describe 'example 1' do
      it 'applied discount' do
        merchant1 = Merchant.create!(name: "Pabu")

        item1 = merchant1.items.create!(name: "Brush", description: "Brushy", unit_price: 50)
        item2 = merchant1.items.create!(name: "Peanut Butter", description: "Yummy", unit_price: 30)

        customer1 = Customer.create!(first_name: "Loki", last_name: "R")

        invoice1 = customer1.invoices.create!(status: "completed")

        ii1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, status: 1, quantity: 5, unit_price: 50)
        ii2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, status: 1, quantity: 5, unit_price: 30)

        discount1 = merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)

        expect(ii1.applied_discount).to eq(nil)
      end
    end

    describe 'example 2' do
      it '#applied discounts' do
        merchant1 = Merchant.create!(name: "Pabu")

        item1 = merchant1.items.create!(name: "Brush", description: "Brushy", unit_price: 50)
        item2 = merchant1.items.create!(name: "Peanut Butter", description: "Yummy", unit_price: 30)

        customer1 = Customer.create!(first_name: "Loki", last_name: "R")

        invoice1 = customer1.invoices.create!(status: "completed")

        ii1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, status: 1, quantity: 10, unit_price: 50)
        ii2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, status: 1, quantity: 5, unit_price: 30)

        discount1 = merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)

        expect(ii1.applied_discount).to eq(discount1)
      end
    end

    describe 'example 3' do
      it '#applied discounts' do
        merchant1 = Merchant.create!(name: "Pabu")

        item1 = merchant1.items.create!(name: "Brush", description: "Brushy", unit_price: 50)
        item2 = merchant1.items.create!(name: "Peanut Butter", description: "Yummy", unit_price: 30)

        customer1 = Customer.create!(first_name: "Loki", last_name: "R")

        invoice1 = customer1.invoices.create!(status: "completed")

        ii1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, status: 1, quantity: 12, unit_price: 50)
        ii2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, status: 1, quantity: 15, unit_price: 30)

        discount1 = merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount2 = merchant1.discounts.create!(percentage_discount: 30, quantity_threshold: 15)

        expect(ii1.applied_discount.id).to eq(discount1.id)
        expect(ii2.applied_discount.id).to eq(discount2.id)
      end
    end

    describe 'example 4' do
      it '#applied discount' do
        merchant1 = Merchant.create!(name: "Pabu")

        item1 = merchant1.items.create!(name: "Brush", description: "Brushy", unit_price: 50)
        item2 = merchant1.items.create!(name: "Peanut Butter", description: "Yummy", unit_price: 30)

        customer1 = Customer.create!(first_name: "Loki", last_name: "R")

        invoice1 = customer1.invoices.create!(status: "completed")

        ii1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, status: 1, quantity: 12, unit_price: 50)
        ii2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, status: 1, quantity: 15, unit_price: 30)

        discount1 = merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
        discount2 = merchant1.discounts.create!(percentage_discount: 15, quantity_threshold: 15)

        expect(ii1.applied_discount.id).to eq(discount1.id)
        expect(ii2.applied_discount.id).to eq(discount1.id)
      end
    end
  end
end
