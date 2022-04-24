class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
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

    discount.save
    redirect_to merchant_discounts_path(@merchant)
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])

    discount.update(discount_params)
    redirect_to merchant_discount_path(discount.merchant, discount)
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])

    discount.destroy
    redirect_to merchant_discounts_path(@merchant)
  end

  private
  def discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end
