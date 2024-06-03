class Public::PresetsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user,only: [:update]

  def create
    @user = current_user
    if @user.presets.count < 3 # ユーザーごとのプリセットの最大数が3つ以下の場合に作成を許可
      @preset = @user.presets.build(preset_params)
      @preset.number = @user.presets.maximum(:number).to_i + 1 # ユーザーごとの最後の番号+1を割り当てる
      if @preset.save
        redirect_to posts_path, notice: 'プリセットが追加されました。'
      else
        redirect_to posts_path, notice: 'プリセットの追加に失敗しました。'
      end
    else
      redirect_to posts_path, notice: 'プリセット作成上限数は3個です。'
    end
  end

  def update
    @preset = Preset.find(params[:id])
    if @preset.update(preset_params)
      redirect_to posts_path, notice: 'プリセットが更新されました。'
    else
      redirect_to posts_path, alert: 'プリセットの更新ができませんでした。'
    end
  end

  private

  def preset_params
    params.require(:preset).permit(:name,:words,:number,:target,:option)
  end

  def check_user
    @preset = Preset.find(params[:id])
    unless @preset.user_id = current_user.id
      redirect_to posts_path, alert: '本人のみ編集可能です。'
    end
  end
end
