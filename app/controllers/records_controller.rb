#--
# Copyright (C) 2007-2008  Nathan Fielder
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
class RecordsController < ApplicationController
  before_filter :authorize

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    user = User.find(session[:user_id])
    @categories = user.categories.find(:all, :order => 'name')
    @records = Record.paginate(:page => params[:page], :order => :system_name,
            :conditions => ["user_id = ?", session[:user_id]])
    true
  end

  def show
    user = User.find(session[:user_id])
    @record = user.records.find(params[:id])
  end

  def new
    @record = Record.new
    user = User.find(session[:user_id])
    @categories = user.categories.find(:all, :order => 'name')
  end

  def create
    # Associate the user with the record.
    user = User.find(session[:user_id])
    params[:record][:user] = user
    # Replace the category id with the actual Category.
    params[:record][:category] = user.categories.find(params[:record][:category_id])
    @record = Record.new(params[:record])
    if @record.save
      flash[:notice] = 'Record was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    user = User.find(session[:user_id])
    @record = user.records.find(params[:id])
    @categories = user.categories.find(:all, :order => 'name')
  end

  def update
    user = User.find(session[:user_id])
    @record = user.records.find(params[:id])
    # Replace the category id with the actual Category.
    params[:record][:category] = user.categories.find(params[:record][:category_id])
    if @record.update_attributes(params[:record])
      flash[:notice] = 'Record was successfully updated.'
      redirect_to :action => 'show', :id => @record
    else
      render :action => 'edit'
    end
  end

  def destroy
    user = User.find(session[:user_id])
    user.records.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
