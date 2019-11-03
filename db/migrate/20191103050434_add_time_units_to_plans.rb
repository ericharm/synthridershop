class AddTimeUnitsToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :unit_of_time, :string
    add_column :plans, :quantity, :integer
  end
end
