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
class EncryptPasswords < ActiveRecord::Migration

  def self.up
    records = Record.find(:all)
    records.each do |r|
      # At this point, the plain-text passwords have been encrypted
      # rather than decrypted, so we must reverse that, then save again.
      r.password = r.password.tr('!-~', 'P-~!-O')
      r.save!
      # Now the password is stored as encrypted.
    end
  end

  def self.down
    # It is not safe to reverse this migration, as we would mangle any
    # passwords stored after the migration had been performed.
  end
end
