class Admin::DashboardsController < ApplicationController
  def index
    @users = User.all
  end
end
