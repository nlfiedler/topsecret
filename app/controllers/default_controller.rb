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
#
# The default controller, shows a list of categories and a form to
# enter new records. Clicking on categories shows the records stored
# under those categories.
#
class DefaultController < ApplicationController
  before_filter :authorize

  #
  # Show the list of available categories.
  #
  def index
    # Show all of the categories on a single page, there won't be many
    # in the majority of cases.
    user = User.find(session[:user_id])
    @categories = user.categories.find(:all, :order => 'name')
    if @categories.empty?
      flash[:notice] = "Please create a category to hold new password entries"
      redirect_to(:controller => :categories, :action => :new)
    end
  end

  #
  # Show the records for the selected category.
  #
  def show
    user = User.find(session[:user_id])
    cat = user.categories.find(params[:id])
    unless cat.nil?
      @records = Record.paginate(:page => params[:page], :order => :system_name,
        :conditions => ["user_id = ?", user.id])
    end
  end
end
