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
        !!(url =~ /^(http:\/\/|https:\/\/)?(www\.)?(youtube\.[A-Za-z\.]+|youtu.be\.)\/(watch\?v=)?[A-Za-z0-9\-_]{6,12}(&[A-Za-z0-9\-_]+)*=?.*$/)
      end

      def initialization(url)
        # vysekat pomocí RE video id a dát do proměnné
        pom = url.split('=')
        videoid = pom[1].split('&')

        @youtube_json_object = get 'https://www.googleapis.com/youtube/v3/videos?id=#{videoid}&key=AIzaSyBVYtP85g7VCilGKbzkQqPCf8CxokAfvhU&part=snippet'

      end

      def name
        # jmeno video na youtube | title
        pom = @youtube_json_object.split('"title": "')[1]
        title = pom.split("\",")[0]
      end

      def type
        'youtube#video'
      end

      def metadata
        # parse youtube_json_object with variables bellow

        #channelTitle
        pom = @youtube_json_object.split('"channelTitle": "')[1]
        @channelTitle = pom.split("\",")[0]
        #id
        pom = @youtube_json_object.split('"id": "')[1]
        @id = pom.split("\",")[0]
        #publishedAt
        pom = @youtube_json_object.split('"publishedAt": "')[1]
        @publishedAt = pom.split("\",")[0]
        #description
        pom = @youtube_json_object.split('"description": "')[1]
        @description = pom.split("\",")[0]
        #categoryId
        pom = @youtube_json_object.split('"categoryId": "')[1]
        @categoryId = pom.split("\",")[0]
        #liveBroadcastContent
        pom = @youtube_json_object.split('"liveBroadcastContent": "')[1]
        @liveBroadcastContent = pom.split("\",")[0]

        @date=""

        @comment=""

        @views=""

        @likes=""

        @dislikes=""

        @category=""

        @licence=""
      end

      def download_url
        url
      end

    end
  end
end
