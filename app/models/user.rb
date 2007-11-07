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
class User < ActiveRecord::Base
  FAKE_AUTH = $secret_config['auth']['fake']
  LDAP_HOST = $secret_config['ldap']['host']
  LDAP_PORT = $secret_config['ldap']['port']
  LDAP_SCHEME = $secret_config['ldap']['format']
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :categories
  has_many :records

  #
  # Authenticate the user (via LDAP), and if successful ensure the
  # corresponding entry exists in the users table.
  #
  # Returns the user instance, or nil if failed to authenticate.
  #
  def self.authenticate(name, password)
    unless FAKE_AUTH
      auth = LDAP::Auth.new(LDAP_HOST, LDAP_PORT)
      scheme = eval('"' + LDAP_SCHEME + '"')
      unless auth.authenticate(scheme, password)
        return nil
      end
    end
    # Either the authentication succeeded, or this is fake-auth.
    user = self.find_by_name(name)
    if user.nil?
      user = User.new
      user.name = name
      user.save
    end
    user
  end
end
