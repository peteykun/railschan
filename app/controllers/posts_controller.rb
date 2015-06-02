class PostsController < ApplicationController
  def index
    @new_post = Post.new
    @posts = Post.all.where(parent: nil).order('id DESC')
  end

  def create
    @new_post = ::Post.new(post_params)

    parents = @new_post.comment.gsub("\r", "").scan(/^>>([0-9]+)$/).flatten.map { |x| x.to_i }
    error = ""

    if parents.size != 0
      mismatch = false
      parent   = nil

      begin
        if Post.find(parents[0]).parent_id == nil
          parent = parents[0]
        else
          parent = Post.find(parents[0]).parent_id
        end

        (1..parents.size-1).each do |i|
          this_parent = nil

          if Post.find(parents[i]).parent_id == nil
            this_parent = parents[i]
          else
            this_parent = Post.find(parents[i]).parent_id
          end

          if this_parent != parent
            mismatch = true
            break
          end
        end

        unless mismatch
          @new_post.parent_id = parent
        else
          error = "Your may post a reply to only one thread."
        end

      rescue
        error = "Invalid thread specified to reply to."

      end
    else
      if @new_post.file_file_name.nil?
        error = "Image file required"
      end
    end

    puts (error + ":") * 100

    if (error == "") and @new_post.save
      flash[:notice] = 'Successfully posted'
      redirect_to action: 'index'
    elsif error != ""
      flash[:notice] = "<b>Error:</b> #{error}"
      redirect_to action: 'index'
    else
      flash[:notice] = "Fill out all fields."
      redirect_to action: 'index'
    end
  end

  private
    def post_params
      params.require(:post).permit(:name, :subject, :comment, :file)
    end
end
