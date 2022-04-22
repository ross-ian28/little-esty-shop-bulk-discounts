class DiscountsController < ApplicationController
  def index
    @discounts = Discount.all
  end

  def show

  end
end
