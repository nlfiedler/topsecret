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
require File.dirname(__FILE__) + '/../test_helper'
require 'categories_controller'

# Re-raise errors caught by the controller.
class CategoriesController; def rescue_action(e) raise e end; end

class CategoriesControllerTest < Test::Unit::TestCase
  fixtures :categories, :users

  def setup
    @controller = CategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = categories(:first).id
    @john_id = users(:john).id
  end

  def test_index_without_user
    get :index
    assert_redirected_to :controller => 'login'
    assert_equal 'Please log in', flash[:notice]
  end

  def test_index
    get :index, {}, { :user_id => @john_id }
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list, {}, { :user_id => @john_id }
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:categories)
  end

  def test_show
    get :show, { :id => @first_id }, { :user_id => @john_id }
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:category)
    assert assigns(:category).valid?
  end

  def test_new
    get :new, {}, { :user_id => @john_id }
    assert_response :success
    assert_template 'new'
    assert_not_nil assigns(:category)
  end

  def test_create
    num_categories = Category.count
    post :create, { :category => { :name => 'Third' } }, { :user_id => @john_id }
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_equal num_categories + 1, Category.count
  end

  def test_edit
    get :edit, { :id => @first_id }, { :user_id => @john_id }
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:category)
    assert assigns(:category).valid?
  end

  def test_update
    post :update, { :id => @first_id }, { :user_id => @john_id }
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Category.find(@first_id)
    }
    post :destroy, { :id => @first_id }, { :user_id => @john_id }
    assert_response :redirect
    assert_redirected_to :action => 'list'
    assert_raise(ActiveRecord::RecordNotFound) {
      Category.find(@first_id)
    }
  end
end
