class Public::PresetsController < ApplicationController

  def create
    @user = current_user
    if @user.presets.count < 3 # ユーザーごとのプリセットの最大数が3つ以下の場合に作成を許可
      @preset = @user.presets.build(preset_params)
      @preset.number = @user.presets.maximum(:number).to_i + 1 # ユーザーごとの最後の番号+1を割り当てる
      if @preset.save
        redirect_to posts_path, notice: 'Preset was successfully created.'
      else
        render :new
      end
    else
      redirect_to posts_path, alert: 'You cannot create more than 3 presets.'
    end
  end

  private

  def preset_params
    params.require(:preset).permit(:name,:words,:number,:target,:option)
  end
end
