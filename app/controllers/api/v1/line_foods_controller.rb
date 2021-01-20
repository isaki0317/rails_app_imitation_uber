module Api
  module V1
    class LineFoodsController < ApplicationController
      # onlyの前にのみset_foodを実行可能
      before_action :set_food, only: %i[create, replace]

      def index
        # scopeで選択して取得
        line_foods = LineFood.active.all
        # 仮注文が空でもアクセスできるため、条件分岐で処理
        if line_foods.exists?
          render json: {
            # idを取得して返す
            line_food_ids: line_foods.map { |line_food| line_food.id },
            # 仮注文は一店舗までなので、配列の最初の商品から店名を取得(.first.restaurantと同義)
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum { |line_food| line_food[:count] },
            # インスタンスメソッドで計算して返す(数量x単価)
            amount: line_foods.sum { |line_food| line_food.total_amount },
          }, status: :ok
        else
          render json: {}, status: :no_content
        end
      end

      def create
        # 他店舗での仮注文がすでにあるかの条件分岐
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable
        end
        #privateのメソッドで処理
        set_line_food(@ordered_food)

        # 更新or新規で準備した値を保存する
        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end
      
      def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
          line_food.update_attribute(:active, false)
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      private

      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        # 既に存在する場合
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end