require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")

    @item1 = @merchant1.items.create!(name: "Brush", description: "Brushy", unit_price: 50)
    @item2 = @merchant1.items.create!(name: "Peanut Butter", description: "Yummy", unit_price: 30)

    @customer1 = Customer.create!(first_name: "Loki", last_name: "R")

    @invoice1 = @customer1.invoices.create!(status: "completed")

    @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 10, unit_price: 50)
    @ii2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, status: 1, quantity: 5, unit_price: 30)

    @discount1 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)

    visit merchant_invoice_path(@merchant1, @invoice1)
  end

  it 'has header' do
    expect(page).to have_content("Invoice #{@invoice1.id}")
  end

  it 'shows all invoice attributes' do
    within("#invoice") do
      expect(page).to have_content(@invoice1.id)
      expect(page).to have_content(@invoice1.status)
      expect(page).to have_content(@invoice1.created_at.strftime("%A, %b %d, %Y"))
      expect(page).to have_content(@customer1.first_name)
      expect(page).to have_content(@customer1.last_name)
    end
  end
  it 'has item header' do
    expect(page).to have_content("Invoice Items")
  end

  it 'shows all item attributes' do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content("Quantity:")
      expect(page).to have_content(@ii1.quantity)
      expect(page).to have_content("Price:")
      expect(page).to have_content(@item1.unit_price)
      expect(page).to have_content("Invoice item status:")
      expect(page).to have_content(@ii1.status)
    end
  end

  it 'does not have items from other merchants' do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      select "shipped", from: "Change status"
      click_button "Update Item Status"

      expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice1))
    end
  end

  it 'shows total revenue generated' do
    within("#invoice") do
      expect(page).to have_content("Total revenue generated:")
      expect(page).to have_content("$6.00")
    end
  end

  it 'shows total revenue generated' do
    within("#invoice") do
      expect(page).to have_content("Total revenue generated with discount:")
      expect(page).to have_content("$5.50")
    end
  end

  it 'has link to discount belonging to invoice item' do
    within("#invoice-item-#{@item1.id}-#{@ii1.id}") do
      click_button "Item discount"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/discounts/#{@discount1.id}")
    end
  end
end
