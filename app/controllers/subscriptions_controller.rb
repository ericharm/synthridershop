class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    puts "current_user: #{current_user.username}"
    payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
    if payment.execute(payer_id: params[:PayerID])
      plan = Plan.find(payment.transactions.first.item_list.items.first.sku)
      current_user.subscriptions.create(plan_id: plan.id, payment_id: payment.id)
    else
      flash[:alert] = payment.error
    end
    redirect_to root_path
  end

  def new
    @plans = Plan.all
  end
end
