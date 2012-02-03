class CreatePayTypes < ActiveRecord::Migration
  def change
    create_table :pay_types do |t|
      t.string :name

      t.timestamps
    end
  
    PayType.create([{ name: 'Check' }, { name: 'Credit Card' }, { name: 'Purchase Order' }])
  end
end
