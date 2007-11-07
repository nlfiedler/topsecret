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
#
# Prerequisites:
# * Install ruby-net-ldap Ruby gem, also available on RubyForge
#   (http://rubyforge.org/projects/net-ldap/).
# * See the Net::LDAP rdoc for usage information.
#
require 'rubygems'
require 'net/ldap'

#
# Simple LDAP authentication support using Net::LDAP library.
#
module LDAP

  class Auth

    def initialize(host = 'localhost', port = 389)
      @host = host
      @port = port
    end

    # Authenticate the given username and password. The username must be in
    # DN format for the LDAP directory (e.g. uid=blah,dc=company,dc=com).
    #
    # Returns true if authenticated, false otherwise.
    #
    def authenticate(username, password)
      ldap = Net::LDAP.new
      ldap.host = @host
      ldap.port = @port
      ldap.auth username, password
      return ldap.bind
    end
  end
end
