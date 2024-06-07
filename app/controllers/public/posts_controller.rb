class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path, notice: '投稿しました。'
    else
      error_messages = @post.errors.full_messages.join('</br>')
      flash[:alert] = "#{error_messages}".html_safe
      flash[:notice] = "'投稿に失敗しました。"
      redirect_to request.referer, params:{post_record: post_params}
    end
  end

  def index
    @newpost = Post.new
    @posts = Post.order(updated_at: :desc)
    @newpreset = Preset.new
    @presets = Preset.where(user_id: current_user) || []
    if user_signed_in?
      follow_users = User.where(id: Follow.where(follower_id: current_user.id).pluck(:followed_id))

      @presets.each do |preset|
        words = preset.words.split(/[[:blank:]]+/)
        if preset.target == "following_user" # フォローしているユーザーのみ
          posts = @posts.where(user_id: follow_users.ids)
        else
          posts = @posts
        end

        results = Post.none # resultsに空のPostを用意する
        if preset.option == "katu" # AND
          words.each_with_index do |word, i|
            results = posts.search(word) if i == 0
            results = results.merge(posts.search(word))
          end
        else # OR
          words.each do |word|
            results = results.or(posts.search(word))
          end
        end
        instance_variable_set("@results#{preset.id}", results)
      end
    end
  end

  def partial_ajax
    @posts = Post.order(updated_at: :desc)
    @preset = Preset.find_by(id: params[:id])
    if user_signed_in? && !@preset.nil?
      follow_users = User.where(id: Follow.where(follower_id: current_user.id).pluck(:followed_id))

      words = @preset.words.split(/[[:blank:]]+/)
      if @preset.target == "following_user" # フォローしているユーザーのみ
        posts = @posts.where(user_id: follow_users.ids)
      else
        posts = @posts
      end

      results = Post.none # resultsに空のPostを用意する
      if @preset.option == "katu" # AND
        words.each_with_index do |word, i|
          results = posts.search(word) if i == 0
          results = results.merge(posts.search(word))
        end
      else # OR
        words.each do |word|
          results = results.or(posts.search(word))
        end
      end
      @posts = results
    end
    render layout: false
  end

  def show
     @newpost = Post.new
     @user = current_user
     @newcomment = Comment.new
     @post = Post.find(params[:id])

  end

  def edit
    @newpost = Post.new
    @user = current_user
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿の更新が完了しました。"
      redirect_to post_path(@post.id)
    else
      @post = @post
      @newpost = Post.new
      @user = current_user
      flash[:notice] = "投稿の更新ができませんでした。"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to  posts_path, notice: '投稿を削除しました。'
  end

  def search
    @newpost = Post.new
    @user = current_user
    @posts_results = Post.all.order(updated_at: :desc)
  end

  def search_words
    @keywords = params[:keywords].split(/[[:blank:]]+/)
    @type = params[:type]
    @posts_results = Post.none
    @users_results = User.none

    if @keywords.empty?
      @posts_results = Post.all.order(updated_at: :desc)
    else
      @keywords.each_with_index do |keyword, i|
        @users_results = User.search(keyword) if i == 0
        @users_results = @users_results.merge(@users_results.search(keyword))
      end

      if @type == 'AND'
       @keywords.each_with_index do |keyword, i|
         @posts_results = Post.search(keyword) if i == 0
         @posts_results = @posts_results.merge(@posts_results.search(keyword))
       end
      else
        @keywords.each do |keyword|

          @posts_results = @posts_results.or(Post.search(keyword))
        end
      end
    end
    @newpost = Post.new
    @user = current_user
    render :search
  end


  private

  def post_params
    params.require(:post).permit(:body,:image)
  end

  def check_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path,alert: '投稿者のみ編集可能です。'
    end
  end
end
