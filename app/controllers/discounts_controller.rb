class DiscountsController < ApplicationController
  def index
    @discounts = Discount.all
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.discounts.new(discount_params)

    if discount.save
      redirect_to merchant_discounts_path(@merchant)
      flash.notice = "Succesfully Created Discount"
    else
      redirect_to new_merchant_discount_path(@merchant)
      flash.notice = "All fields must be completed"
    end
  end

  private
  def discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end
