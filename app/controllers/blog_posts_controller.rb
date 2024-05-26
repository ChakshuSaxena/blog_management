class BlogPostsController < ApplicationController

  def index
    access_key = '2oD7ETB5EsN69WCDoYyFMZIgaMQoViR07wMXxAfMwTg'
    @unsplash_service = UnsplashService.new(access_key)

    @posts = BlogPost.order(created_at: :desc)
    @post_images = {}

    @posts.each do |post|
      images = @unsplash_service.search_photos(post.title)
      @post_images[post.id] = images.first unless images.empty?
    end
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = current_user.blog_posts.new(blog_post_params)
    if @blog_post.save
      redirect_to(blog_posts_path, notice: "Post created successfully!")
    else
      render(:new)
    end
  end

  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  def update
    blog_post = BlogPost.find(params[:id])
    if blog_post.update(blog_post_params)
      redirect_to(blog_posts_path, notice: "Post updated successfully!")
    else
      render(:edit)
    end
  end

  def destroy
    blog_post = BlogPost.find(params[:id])
    if blog_post.destroy
      redirect_to(blog_posts_path, notice: "Page deleted successfully!")
    else
      redirect_to(blog_posts_path, error: "Something went wrong, please try later!")
    end
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :content)
  end
end
