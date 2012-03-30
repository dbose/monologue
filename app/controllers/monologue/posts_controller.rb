class Monologue::PostsController < Monologue::ApplicationController
  caches_page :index, :show, :feed , if: Proc.new { current_user.nil? }

  def index
    @page = params[:page].nil? ? 1 : params[:page]
    @posts = Monologue::Post.published.page(@page)
  end
  
  def show
    unless current_user
      post = Monologue::Post.published.where("monologue_posts_revisions.url = :url", {url: root_path + params[:post_url]}).first
    else
      post = Monologue::Post.default.where("monologue_posts_revisions.url = :url", {url: root_path + params[:post_url]}).first
    end
    if post.nil?
      not_found
      return
    end
    @revision = post.posts_revisions.first
  end
  
  def feed
    @posts = Monologue::Post.published.limit(25)
  end
end