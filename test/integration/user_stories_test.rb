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
require "#{File.dirname(__FILE__)}/../test_helper"

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :users

  def setup
    @john_id = users(:john).id
  end

  def test_add_record
    get '/'
    assert_redirected_to :controller => 'login'
#    follow_redirect!
    get '/login', { :user_id => @john_id }
    assert_response :success
    #
    # TODO: show the list of records
    # TODO: get the new record form
    # TODO: create a new record
    # TODO: verify that the database contains the new record
    # TODO: log out
    #
  end
end
