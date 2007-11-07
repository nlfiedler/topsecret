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

#
# Ensure passwords are migrated to old_passwords table appropriately.
#
class OldPasswordsTest < Test::Unit::TestCase
  fixtures :old_passwords, :records

  #
  # Change the password for a record, observe that a new entry is
  # saved in old_passwords collection.
  #
  def test_with_change
    count = OldPassword.count
    google = records(:google)
    google.password = 'whazzup'
    google.save!
    assert OldPassword.count == (count + 1)
  end

  #
  # Change the username for a record, observe that there is no change
  # to the old_passwords collection.
  #
  def test_without_change
    count = OldPassword.count
    yahoo = records(:yahoo)
    yahoo.username = 'dude'
    yahoo.save!
    assert OldPassword.count == count
  end
end
