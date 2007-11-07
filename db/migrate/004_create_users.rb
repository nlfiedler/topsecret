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
class CreateUsers < ActiveRecord::Migration

  def self.up
    # Our users are pretty shallow for the time being.
    create_table :users do |t|
      t.column :name, :string
    end
    # Add foreign keys to the categories and records tables.
    add_column :categories, :user_id, :string
    add_column :records, :user_id, :string
  end

  def self.down
    remove_column :categories, :user_id
    remove_column :records, :user_id
    drop_table :users
  end
end
