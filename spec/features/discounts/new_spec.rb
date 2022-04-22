require 'rails_helper'

RSpec.describe 'discount index' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")
    @merchant2 = Merchant.create!(name: "Loki")

    @discount1 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
    @discount2 = @merchant1.discounts.create!(percentage_discount: 30, quantity_threshold: 5)
    @discount3 = @merchant2.discounts.create!(percentage_discount: 50, quantity_threshold: 8)

    visit new_merchant_discount_path(@merchant1)
  end

  describe 'has form to make new discount' do
    it 'fills in form' do
      expect(page).to have_content("Make New Discount")
      within("#new-discount") do
        fill_in "Percentage discount", with: "10"
        fill_in "Quantity threshold", with: "10"
        click_button "Submit"

        expect(current_path).to eq(merchant_discounts_path(@merchant1))
      end
      within("#discounts") do
        expect(page).to have_content("10% off 10 items")
      end
    end
  end
end
