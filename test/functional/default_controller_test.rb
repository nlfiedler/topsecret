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
require 'default_controller'

# Re-raise errors caught by the controller.
class DefaultController; def rescue_action(e) raise e end; end

class DefaultControllerTest < Test::Unit::TestCase
  fixtures :categories, :users

  def setup
    @controller = DefaultController.new
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
    assert_template 'index'
  end

  def test_show
    get :show, { :id => @first_id }, { :user_id => @john_id }
    assert_response :success
    assert_template 'show'
  end
end
