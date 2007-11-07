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
# Included in environment.rb to define trivial database encryption
# for model attributes, such as user password. This is merely to
# prevent casual observance of private values.
#
# Stolen from Agile Web Development with Rails, Dave Thomas, et. al.
#
class Encrypter

  def initialize(attrs_to_manage)
    @attrs_to_manage = attrs_to_manage
  end

  def before_save(model)
    # Apply trivial encryption to stored values using ROT47.
    @attrs_to_manage.each do |field|
      model[field].tr!('!-~', 'P-~!-O')
    end
  end

  def after_save(model)
    @attrs_to_manage.each do |field|
      # ROT47 is easily reversible.
      model[field].tr!('!-~', 'P-~!-O')
    end
  end

  alias_method :after_find, :after_save
end

class ActiveRecord::Base

  #
  # Define support for encrypting values in the database.
  #
  def self.encrypt(*attr_names)
    encrypter = Encrypter.new(attr_names)

    before_save encrypter
    after_save encrypter
    after_find encrypter

    define_method(:after_find) { }
  end
end
