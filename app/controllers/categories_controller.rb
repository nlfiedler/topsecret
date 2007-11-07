#--
# Copyright (C) 2007  Nathan Fielder
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
class CategoriesController < ApplicationController
  before_filter :authorize

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @category_pages, @categories = paginate(:categories, :order => :name,
            :conditions => ["user_id = ?", session[:user_id]])
  end

  def show
    user = User.find(session[:user_id])
    @category = user.categories.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    # Associate the user with the category.
    params[:category][:user] = User.find(session[:user_id])
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    user = User.find(session[:user_id])
    @category = user.categories.find(params[:id])
  end

  def update
    user = User.find(session[:user_id])
    @category = user.categories.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'show', :id => @category
    else
      render :action => 'edit'
    end
  end

  def destroy
    user = User.find(session[:user_id])
    user.categories.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
