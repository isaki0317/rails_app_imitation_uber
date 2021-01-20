class Restaurant < ApplicationRecord

  has_many :foods
  has_many :line_foods
  belongs_to :order, optional: true

  validates :name, :fee, :time_required, presence: true
  validates :name, length: { maximum: 30 }
  # 最低でも0、マイナスにならないようなバリデーション
  validates :fee, numericality: { greater_than: 0 }

end