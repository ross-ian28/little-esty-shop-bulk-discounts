require 'rails_helper'

RSpec.describe 'discount edit' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")
    @merchant2 = Merchant.create!(name: "Loki")

    @discount1 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
    @discount2 = @merchant1.discounts.create!(percentage_discount: 30, quantity_threshold: 5)
    @discount3 = @merchant2.discounts.create!(percentage_discount: 50, quantity_threshold: 8)

    visit edit_merchant_discount_path(@merchant1, @discount1)
  end

  describe 'has form to edit discount' do
    it 'fills in form' do
      expect(page).to have_content("Edit Discount")
      within("#edit-discount") do
        fill_in "Percentage discount", with: "10"
        fill_in "Quantity threshold", with: "10"
        click_button "Submit"

        expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
      end
      within("#discount") do
        expect(page).to have_content("Percentage discount: 10")
        expect(page).to have_content("Quantity threshold: 10")
      end
    end
  end
end
