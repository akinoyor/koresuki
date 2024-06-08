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
        error_messages = @preset.errors.full_messages.join('</br>')
        flash[:alert] = "#{error_messages}".html_safe
        flash[:notice] = "プリセットの追加に失敗しました"
        render 'layouts/flashs'
      end
    else
      flash[:notice] = "プリセット作成上限数は3個です。"
      render 'layouts/flashs'
    end
  end

  def update
    @preset = Preset.find(params[:id])
    if @preset.update(preset_params)
      redirect_to posts_path, notice: 'プリセットが更新されました。'
    else
      error_messages = @preset.errors.full_messages.join('</br>')
      flash[:alert] = "#{error_messages}".html_safe
      flash[:notice] = "プリセットの更新ができませんでした"
      render 'layouts/flashs'
    end
  end

  private

  def preset_params
    params.require(:preset).permit(:name,:words,:number,:target,:option)
  end

  def check_user
    @preset = Preset.find(params[:id])
    unless @preset.user_id = current_user.id
      redirect_to posts_path, notice: '本人のみ編集可能です。'
    end
  end
end
