module SubscriptionHelper
  def inactive_since(sub)
    sub ? expiration_string(sub) : 'Never Subscribed'
  end

  def subscription_expires(sub)
    sub ? expiration_string(sub) : 'Not Subscribed'
  end

  def subscription_started(sub)
    sub ? began_string(sub) : 'Not Subscribed'
  end

  def expiration_string(sub)
    exp = sub.expires_at
    subscription_string(exp)
  end

  def began_string(sub)
    begins = sub.begins_at
    subscription_string(begins)
  end

  def subscription_string(time)
    date = Date.new(time.year,time.month, time.day)
    date.strftime('%b %e, %Y')
  end
end
