class Plan < ApplicationRecord
  def length
    quantity.send(unit_of_time.to_sym)
  end
end
