require 'rails_helper'

RSpec.describe 'Admin invoice show page' do
  before :each do
    @merchant1 = Merchant.create!(name: "Pabu")

    @item1 = @merchant1.items.create!(name: "Brush", description: "Brushy", unit_price: 500)
    @item2 = @merchant1.items.create!(name: "Peanut Butter", description: "Yummy", unit_price: 300)

    @customer1 = Customer.create!(first_name: "Loki", last_name: "R")

    @invoice1 = @customer1.invoices.create!(status: "completed")

    @ii1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, status: 0, quantity: 10, unit_price: 500)
    @ii2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, status: 0, quantity: 5, unit_price: 300)

    @discount1 = @merchant1.discounts.create!(percentage_discount: 20, quantity_threshold: 10)

    visit "/admin/invoices/#{@invoice1.id}"
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

  it 'shows all item attributes on the invoice' do
    within("#invoice_item-#{@ii1.id}") do
      expect(page).to have_content(@ii1.item.name)
      expect(page).to have_content(@ii1.quantity)
      expect(page).to have_content("Sale price: $5.00")
      expect(page).to have_content(@ii1.status)
    end
  end

  it 'shows total revenue for the invoice' do
    visit "/admin/invoices/#{@invoice1.id}"

    expect(page).to have_content("Total revenue generated:")
    expect(page).to have_content("$65.00")
  end

  it 'shows the invoice status as a select field that is editable, with a submit button' do
    expected = find_field(:update_status).value

    expect(expected).to eq("completed")
  end

  it 'shows discount total revenue for the invoice' do
    save_and_open_page
    expect(page).to have_content("Total revenue generated with discount:")
    expect(page).to have_content("$55.0")
  end
end
