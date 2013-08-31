# Rails Play Time - Ch.10 Depot_e
# Add price to line item
# http://intertwingly.net/projects/AWDwR4/checkdepot-187-30/section-10.4.html
class AddProductPriceToLineItem < ActiveRecord::Migration
  def self.up
    add_column :line_items, :price, :decimal
    LineItem.all.each do |line|
      line.price = line.product.price
    end
  end

  def self.down
    remove_column :line_items, :price
  end
end
