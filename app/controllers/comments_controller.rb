class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit , :update ]
  before_action :correct_user,   only: :destroy

  def new
    @comment = Comment.new(parent_id: params[:parent_id])
  end

  def create 
    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))
      @comment = parent.children.build(comment_params)
    else
      @comment = Comment.new(comment_params)
    end

    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to post_path(@comment.post_id)
    else
      render :new
    end
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(ajax_comment_params)
        format.html { redirect_to post_path(@comment.post_id), notice: "Comment update!" }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end

  end

  def destroy
    @comment.destroy
    #flash[:success] = "Comment deleted"
    # redirect_to request.referrer || post_path(@comment.post_id)

    respond_to do |format|
    format.html { redirect_to post_path(@comment.post_id), notice: "Comment created!" }
    format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :user_id)
  end

  def ajax_comment_params
    params.require(:comment).permit(:id, :content, :post_id, :user_id)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end

end
