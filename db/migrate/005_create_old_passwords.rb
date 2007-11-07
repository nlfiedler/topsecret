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
class CreateOldPasswords < ActiveRecord::Migration

  def self.up
    create_table :old_passwords do |t|
      t.column :password, :string
      t.column :record_id, :integer
      t.column :created_at, :datetime
      # These rows won't get updated, so leave out 'updated_at'
    end
  end

  def self.down
    drop_table :old_passwords
  end
end
