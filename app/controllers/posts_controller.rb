class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    if params[:title]
      @post = Post.where('title LIKE ?', "%#{params[:title]}%")
    else
      @posts = Post.paginate(page: params[:page], :per_page => 10)
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comments = @post.comments.paginate(page: params[:page], :per_page => 20)
    @comment = @post.comments.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  private

    def post_params
      params.require(:post).permit(:content, :picture, :title)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
