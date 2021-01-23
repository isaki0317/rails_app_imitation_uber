class Order < ApplicationRecord

  has_many :line_foods
  has_one :restaurant, through: :line_food

  validates :total_price, numericality: { greater_than: 0 }

  # LineFoodデータの更新と、Orderデータの保存を一括りに
  def save_with_update_line_foods!(line_foods)
    #ApplicationRecord::Base.transaction do
      line_foods.each do |line_food|
        line_food.update_attributes!(active: false, order: self)
      end
      self.save!
    #end
  end

end