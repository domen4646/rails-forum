class CommentsController < ApplicationController

    before_action :authenticate_user!, only: [:create]
    before_action :check_post, only: [:create]

    def comment_params
        params.require(:comment).permit(:content)
    end

    def create
        @comment = Comment.new(comment_params)
        @comment.user = current_user
        @comment.post = @post

        respond_to do |format|
            if @comment.save
                format.html { redirect_to @comment.post, notice: "Komentar je bil uspešno objavljen." }
            else
                format.html { redirect_to @comment.post, notice: "Prišlo je do napake pri objavljanju komentarja" }
            end
        end
    end

    private
    
        def check_post
            @post = Post.find(params[:post_id])
            redirect_to @post, notice: "Ta objava je izbrisana, zato komentiranje ni mogoče." if @post.marked_deleted?
        end

end
