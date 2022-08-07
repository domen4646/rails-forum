class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :user_owns_post, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = @post.comments.build
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Objava je bila uspešno ustvarjena." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Objava je bila uspešno posodobljena." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.set_deleted
    @post.save

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Objava je bila uspešno izbrisana." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def user_owns_post
      redirect_to posts_path, notice: "Nimate potrebnih pravic za spreminjanje te objave." unless user_signed_in? && current_user.has_post_authority?(@post)
      redirect_to posts_path, notice: "Ta objava je izbrisana, zato je ni mogoče spremeniti." if @post.marked_deleted?
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :post_image)
    end
end
