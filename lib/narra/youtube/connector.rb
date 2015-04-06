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
      @self_description = 'Allows NARRA to connects to the YouTube sources'

      def self.valid?(url)
        # regular expression of youtube url - validation test
        !!(url =~ /^(http:\/\/|https:\/\/)?(www\.)?(youtube\.[A-Za-z\.]+|youtu.be\.)\/(watch\?v=)?[A-Za-z0-9\-_]{6,12}(&[A-Za-z0-9\-_]+)*=?.*$/)
      end

      def initialization(url)
        # all description from YouTube API
        pom = url.split('v=')
        @videoid = pom[1].split('&')[0]

        @youtube = get 'https://www.googleapis.com/youtube/v3/videos?id=#{@videoid}&key=AIzaSyBVYtP85g7VCilGKbzkQqPCf8CxokAfvhU&part=snippet,statistics,contentDetails'

      end

      def name
        # jmeno video na youtube | title
        pom = @youtube.split('"title": "')[1]
        @name = pom.split("\",\n")[0]
      end

      def type
        :video
      end

      # zeptat se na přetížení methody a parametrizaci
      def metadata
        # parse youtube_json_object with variables bellow
        #channelId
        pom = @youtube.split('"channelId": "')[1]
        @channelId = pom.split("\",\n")[0]
        #channelTitle
        pom = @youtube.split('"channelTitle": "')[1]
        @channelTitle = pom.split("\",\n")[0]
        #id
        pom = @youtube.split('"id": "')[1]
        @id = pom.split("\",\n")[0]
        #publishedAt
        pom = @youtube.split('"publishedAt": "')[1]
        @publishedAt = pom.split("\",\n")[0]
        #description
        pom = @youtube.split('"description": "')[1]
        @description = pom.split("\",\n")[0]
        #categoryId
        pom = @youtube.split('"categoryId": "')[1]
        @categoryId = pom.split("\",\n")[0]
        #liveBroadcastContent
        pom = @youtube.split('"liveBroadcastContent": "')[1]
        @liveBroadcastContent = pom.split("\",\n")[0]
        #viewCount
        pom = @youtube.split('"viewCount": "')[1]
        @viewCount = pom.split("\",\n")[0]
        #likeCount
        pom = @youtube.split('"likeCount": "')[1]
        @likeCount = pom.split("\",\n")[0]
        #dislikeCount
        pom = @youtube.split('"dislikeCount": "')[1]
        @dislikeCount = pom.split("\",\n")[0]
        #favouriteCount
        pom = @youtube.split('"favoriteCount": "')[1]
        @favoriteCount = pom.split("\",\n")[0]
        #commentCount
        pom = @youtube.split('"commentCount": "')[1]
        @commentCount = pom.split("\"\n")[0]
        #duration
        pom = @youtube.split('"duration": "')[1]
        @duration = pom.split("\",\n")[0]
        #dimension
        pom = @youtube.split('"dimension": "')[1]
        @dimension = pom.split("\",\n")[0]
        #definition
        pom = @youtube.split('"definition": "')[1]
        @definition = pom.split("\",\n")[0]
        #caption
        pom = @youtube.split('"caption": "')[1]
        @caption = pom.split("\",\n")[0]

        data = Array[ {name:'channelId', value:'#{@channelId}'},
                      {name:'channelTitle', value:'#{@channelTitle}'},
                      {name:'publishedAt', value:'#{@publishedAt}'},
                      {name:'description', value:'#{@descriprion}'},
                      {name:'categoryId', value:'#{@categoryId}'},
                      {name:'liveBroadcastContent', value:'#{@liveBroadcastContent}'},
                      {name:'viewCount', value:'#{@viewCount}'},
                      {name:'likeCount', value:'#{@likeCount}'},
                      {name:'dislikeCount', value:'#{@dislikeCount}'},
                      {name:'favouriteCount', value:'#{@favouriteCount}'},
                      {name:'commentCount', value:'#{@commentCount}'},
                      {name:'duration', value:'#{@duration}'},
                      {name:'dimension', value:'#{@dimension}'},
                      {name:'definition', value:'#{@definition}'},
                      {name:'caption', value:'#{@caption}'}
                    ]
      end

      def download_url
        "https://www.youtube.com/v/#{@videoid}"
      end

    end
  end
end
