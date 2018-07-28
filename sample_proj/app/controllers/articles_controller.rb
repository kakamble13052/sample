class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles = current_user.articles.all
  end

  def all
    @articles = Article.all
  end

  def all_admin
    @articles = Article.all
  end

  def add_comment
    respond_to do |format|
      format.js
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      flash[:alert] = "Article Created!"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = current_user.articles.find(params[:id])
  end

  def update
    @article = current_user.articles.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy

    @article = Article.find(params[:id])
    @article.destroy
    flash[:alert] = "Article Destroyed!"
    redirect_to articles_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
