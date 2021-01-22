class ApplicationController < ActionController::API

  before_action :fake_load

  # material-ui(ローディング時の挙動)の実行確認用
  def fake_load
    sleep(1)
  end

end
