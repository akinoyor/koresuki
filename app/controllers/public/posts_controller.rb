class Public::PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      @user = current_user
      @newpost = Post.new
      @posts = Post.all.order(udated_at: :desc)
      render :index
    end
  end

  def index
    @newpost = Post.new
    @user = current_user
    @posts = Post.all.order(updated_at: :desc)
    @newpreset = Preset.new
    @presets = Preset.where(user_id: @user) || none
    @max = Preset.where(user_id: @user).maximum(:number) || 0
    
    # FIXME仮置き↓フォローしているユーザー
    follows = Follow.where(follower_id: params[:id])
    @followe = User.where(id: follows.pluck(:followed_id))

    if @max > 0

      @presets.each do |i|
        @words = i.words.split(/[[:blank:]]+/)

        if i.target = 0
          target_posts = Post.all.order(updated_at: :desc)
        else
          # フォローしているユーザのポストのみ
          target_posts = Post.all
        end

        if @words.empty?
          results = target_posts.all.order(updated_at: :desc)
        else
          # 以下　アンド検索
          if i.option = 0
            @words.each_with_index do |word, i|
              results = target_posts.search(word) if i == 0
              results = results.merge(results.search(word))
            end
          # 以下オア検索
          else
            @words.each do |word|
              results = Post.none
              results = results.or(target_posts.search(word))
            end
          end
        end


        instance_variable_set("@results#{i.number}", results)
      end
    end


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
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿の更新が完了しました。"
      redirect_to post_path(@post.id)
    else
      @post = @post
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
      redirect_to  posts_path
    end
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
end
