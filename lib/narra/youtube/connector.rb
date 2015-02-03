#
# Copyright (C) 2014 CAS / FAMU
#
# This file is part of Narra Core.
#
# Narra Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Petr Kubin
#

require 'narra/spi'

module Narra
  module Youtube
    class Connector < Narra::SPI::Connector

      @identifier = :youtube
      @title = 'NARRA YouTube Connector'
      @description = 'Allows NARRA to connects to the YouTube sources'

      def self.valid?(url)
        # regular expression of youtube url - validation test
        /^(http:\/\/|https:\/\/)?(www\.)?(youtube\.[A-Za-z\.]+|youtu.be\.)\/(watch\?v=)?[A-Za-z0-9\-_]{6,12}(&[A-Za-z0-9\-_]+)*=?.*$/.match(url)
      end

      def initialization

      end

      def name
        # vybrat z youtube API nazev
      end

      def type
        'video'
      end

      def metadata
        # author, date, comment, views, likes, dislikes, category, licence
        @author=
        @date=
        @comment=
        @views=
        @likes=
        @dislikes=
        @category=
        @licence=
      end

      def download_url
        # předat url
      end

    end
  end
end
