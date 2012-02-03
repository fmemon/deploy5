class RemovePayTypeFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :pay_type
  end
end
