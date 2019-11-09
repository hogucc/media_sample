class Api::V1::PostsController < ApplicationController
  def index
    @posts = Post.all
    render 'index', formats: [:json], handlers: [:jbuilder]
  end

  def show
    @post = Post.find(params[:id])
    render 'show', formats: [:json], handlers: [:jbuilder]
  end
end
