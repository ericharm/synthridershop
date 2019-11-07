class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    # move this into an environment variable
    dev_return_url = 'https://fcf65885.ngrok.io/subscriptions'
    return_url = Rails.env == 'development' ? dev_return_url : subscriptions_path
    
    plan = Plan.find(params[:plan_id])

    payment = PayPal::SDK::REST::Payment.new({
      :intent =>  "sale",
      :payer =>  {
        :payment_method =>  "paypal" 
      },
      :redirect_urls => {
        :return_url => return_url,
        :cancel_url => root_path
      },
      :transactions =>  [{
        :item_list => {
          :items => [{
            :name => "#{plan.name} Subscription",
            :sku => plan.id,
            :price => (plan.price.to_f / 100).to_s, # "5",
            :currency => "USD",
            :quantity => 1
          }]
        },
        :amount =>  {
          :total => (plan.price.to_f / 100).to_s, # "5",
          :currency =>  "USD"
        },
        :description =>  "some kinda description" 
      }]
    })

    if payment.create
      redirect_to payment.links[1].href
    else
      flash[:alert] = 'Error initializing transaction'
      redirect_to root_path
    end
  end
end
