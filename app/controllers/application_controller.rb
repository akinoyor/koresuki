class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, if: :admin_controller?
  before_action :set_new_post
  def set_new_post
    @newpost = Post.new
  end

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private
    def admin_controller?
      self.class.module_parent_name == "Admin"
    end

    def _render_404(e = nil)
      logger.info "Rendering 404 with excaption: #{e.message}" if e

      if request.format.to_sym == :json
        render json: { error: "404 Not Found" }, status: :not_found
      else
        render template: "errors/404", status: :not_found
      end
    end

    def _render_500(e = nil)
      logger.error "Rendering 500 with excaption: #{e.message}" if e

      if request.format.to_sym == :json
        render json: { error: "500 Internal Server Error" }, status: :internal_server_error
      else
        render template: "errors/500", status: :internal_server_error
      end
    end
end
