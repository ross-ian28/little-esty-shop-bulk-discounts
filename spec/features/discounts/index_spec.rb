require 'rails_helper'

RSpec.describe 'discount index' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")
    @merchant2 = Merchant.create!(name: "Loki")

    @discount1 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
    @discount2 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 5)
    @discount3 = @merchant2.discounts.create!(percentage_discount: 50, quantity_threshold: 8)

    visit merchant_discounts_path(@merchant1)
  end

  describe 'shows all bulk_discounts' do
    it 'lists all discount attributes' do
      expect(page).to have_content("Bulk Discounts")
      expect(page).to have_content("All discounts")
      within("#discounts") do
        expect(page).to have_content(@discount1.percentage_discount)
        expect(page).to have_content(@discount1.quantity_threshold)
        expect(page).to have_content(@discount2.percentage_discount)
        expect(page).to have_content(@discount2.quantity_threshold)
        expect(page).to have_content(@discount3.percentage_discount)
        expect(page).to have_content(@discount3.quantity_threshold)
      end
    end
    it 'has link to show pages' do
      within("#discounts") do
        click_link "#{@discount1.percentage_discount}% off #{@discount1.quantity_threshold} items"
        expect(current_path).to eq(merchant_discount_path(@merchant1, @discount1))
      end
    end
    it 'has link to new page' do
      within("#links") do
        click_link "Create new discount"
        expect(current_path).to eq(new_merchant_discount_path(@merchant1))
      end
    end
    it 'has link to delete discount' do
      within("#discounts") do
        click_button "Delete discount #{@discount1.id}"

        expect(current_path).to eq(merchant_discounts_path(@merchant1))

        expect(page).to_not have_content("20% off 10 items")
      end
    end
  end
end
