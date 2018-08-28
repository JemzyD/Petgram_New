class CommentsController < ApplicationController
    before_action :set_post

    def create
        @comment = @post.comments.build(comment_params)
        @comment.user_id = current_user.id

        respond_to do |format|
            if @comment.save
                create_notification @post, @comment
                format.html { redirect_to @post, notice: 'Comment was successfully created.' }
                format.json { render :show, status: :created, location: @post }
                # flash[:success] = "You commented the hell out of that post!"
                # redirect_to :back
            else
                format.html { redirect_to root_path, notice: "Error with creating comments!" }
                format.json { head :no_content }
                # flash[:alert] = "Check the comment form, something went horribly wrong."
                # render root_path
            end
        end
    end

    def destroy
        @comment = @post.comments.find(params[:id])
      
        @comment.destroy
        respond_to do |format|
            format.html { redirect_to root_path, notice: 'Comment was successfully deleted.' }
            format.json { head :no_content}
            # flash[:success] = "Comment deleted :("
            # redirect_to root_path
        end
    end

    private

    def comment_params
        params.require(:comment).permit(:content)
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

    def create_notification(post, comment)
        return if post.user.id == current_user.id
        Notification.create(user_id: post.user.id,
                            notified_by_id: current_user.id,
                            post_id: post.id,
                            identifier: comment.id,
                            notice_type: 'comment')
    end
end
