class Api::V1::PostsController < ApplicationController
  def show
    @post = Post.all
    render 'index', formats: [:json], handlers: [:jbuilder]
  end
end
