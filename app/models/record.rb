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
class Record < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :old_passwords
  validates_presence_of :system_name, :username, :password
  encrypt(:password)

  def after_update
    # Save old password to separate table.
    if @old_password
      old = OldPassword.new
      old.record = self
      # No sense encrypting old passwords, just save as-is.
      old.password = @old_password
      old.save!
      @old_password = nil
    end
  end

  def password=(passwd)
    current = read_attribute('password')
    unless current == passwd
      @old_password = current
    end
    super
  end

  def update_attributes(attributes)
    # If password is changing, save the old one for posterity.
    current = read_attribute('password')
    unless current == attributes['password']
      @old_password = current
    end
    super
  end
end
