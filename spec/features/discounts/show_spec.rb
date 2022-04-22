require 'rails_helper'

RSpec.describe 'discount index' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")
    @merchant2 = Merchant.create!(name: "Loki")

    @discount1 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
    @discount2 = @merchant1.discounts.create!(percentage_discount: 30, quantity_threshold: 5)
    @discount3 = @merchant2.discounts.create!(percentage_discount: 50, quantity_threshold: 8)

    visit merchant_discount_path(@merchant1, @discount1)
  end

  describe 'shows specific bulk discount' do
    it 'lists discount attributes' do
      expect(page).to have_content("Discount #{@discount1.id}")
      within("#discount") do
        expect(page).to have_content("Percentage discount:")
        expect(page).to have_content(@discount1.percentage_discount)
        expect(page).to have_content("Quantity threshold:")
        expect(page).to have_content(@discount1.quantity_threshold)
        expect(page).to_not have_content(@discount2.percentage_discount)
        expect(page).to_not have_content(@discount2.quantity_threshold)
      end
    end
  end
end
