class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title
  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  # Rails Play Time - Ch.7 Depot_b
  validates :title, uniqueness: true, length: { :minimum => 10, :message => :too_short }
  validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)$}i,
    message: 'は、gif,jpg,png画像のURLでなければなりません'
  }
  # Rails Play Time - Ch.10 Depot_e
  validates :image_url, uniqueness: true
  validates :price, numericality: {less_than_or_equal_to: 1000}

  private

  # この商品を参照している品目がないことを確認する
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, '品目が存在します')
      return false
    end
  end

end
