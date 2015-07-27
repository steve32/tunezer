class CommentsController < ApplicationController
  def create
    @commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
    @empty = @commentable.comments.empty? ? true : false
    @comment = @commentable.comments.build
    @comment.assign_attributes(comment_params)
    if @comment.valid?
      @comment.user_id = current_user.id
      # Using the Sanitize gem to strip all markup from the user input.
      #   This will make it safe to display raw, unescaped comments.
      @comment.content = Sanitize.fragment(@comment.content)
      @comment.parse_symbols
      @comment.save!
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @commentable, message: 'Your comment is blank!' }
        format.js { render 'comment_errors' }
      end
    end
  end
  
  def index
    @commentable = params[:commentable_type].constantize.find(params[:commentable_id])
    @concert = @commentable
    @offset = params[:offset].to_i
    @comments = @commentable.comments.limit(10).offset(@offset * 10)
    @offset += 1
    respond_to do |format|
      # TODO: format.html { redirect_to concert_path(id: @concert.id, comments_page: params[:comments_page]) }
      format.js
    end
  end
  
  def show
    @username = params[:username]
    render 'comment_reply'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy!
    @concert = Concert.find(params[:concert_id])
    @comments_count = @concert.comments.count
  end
  
  private # ====================================================================================================
  
  def comment_params
    params.require(:comment).permit(:content, :username)
  end
end