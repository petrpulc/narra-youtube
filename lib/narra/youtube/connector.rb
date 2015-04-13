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

require 'narra/core'
require 'net/http'
#require 'rubygems'
require 'json'
#require 'uri'

module Narra
  module Youtube
    class Connector < Narra::SPI::Connector

      # basic init
      # params: none
      @identifier = :youtube
      @title = 'NARRA YouTube Connector'
      @description = 'Allows NARRA to connects to the YouTube sources'

      # redirection test
      # params: uri_str (string), limit fixed to 20
      # returns new url with 200 status or ArgumentError
      # source: http://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html
      def fetch(uri_str, limit = 20)
        raise ArgumentError, 'too many HTTP redirects' if limit == 0
        response = Net::HTTP.get_response(URI(uri_str))
        case response
          when Net::HTTPSuccess then
            response
          when Net::HTTPRedirection then
            location = response['location']
            warn "redirected to #{location}"
            fetch(location, limit - 1)
          else
            response.value
        end
        location
      end

      # validation
      # params: url (string)
      # returns bool value ( true / false )
      def self.valid?(url)
        # regular expression of youtube url - validation test
        valid = !!(url =~ /^(?:http:\/\/|https:\/\/)?(www\.)?(youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){6,11})(\S*)?$/)
        # doptat se na volání protože to nebude fungovat s self.
        redirectedUrl = fetch(url)
        redirect = !!(redirectedUrl =~ /^(?:http:\/\/|https:\/\/)?(www\.)?(youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){6,11})(\S*)?$/)
        valid || redirect
      end

      # initialize
      # params: url (string)
      # returns @youtube (json object)
      def initialize(url)
        # all description from YouTube API
        pom = url.split('v=')
        @videoid = pom[1].split('&')[0]
        uri = URI("https://www.googleapis.com/youtube/v3/videos?id=#{@videoid}&key=AIzaSyBVYtP85g7VCilGKbzkQqPCf8CxokAfvhU&part=snippet,statistics,contentDetails,status")
        @youtube = Net::HTTP.get(uri)
      end

      # name
      # params: none
      # returns name of video
      def name
        # jmeno video na youtube | title
        my_hash = JSON.parse(@youtube)
        my_hash["items"][0]["snippet"]["title"]
      end

      # type
      # params: none
      # returns :video
      def type
        :video
      end

      # metadata
      # params: none
      # returns Array
      def metadata
        my_hash = JSON.parse(@youtube)
        #channelId
        @channelId = my_hash["items"][0]["snippet"]["channelId"]
        #channelTitle
        @channelTitle = my_hash["items"][0]["snippet"]["channelTitle"]
        #id
        @id = my_hash["items"][0]["snippet"]["id"]
        #publishedAt
        @publishedAt = my_hash["items"][0]["snippet"]["publishedAt"]
        #description
        @my_description = my_hash["items"][0]["snippet"]["description"]
        #categoryId
        @categoryId = my_hash["items"][0]["snippet"]["categoryId"]
        #liveBroadcastContent
        @liveBroadcastContent = my_hash["items"][0]["snippet"]["liveBroadcastContent"]
        #viewCount
        @viewCount = my_hash["items"][0]["statistics"]["viewCount"]
        #likeCount
        @likeCount = my_hash["items"][0]["statistics"]["likeCount"]
        #dislikeCount
        @dislikeCount = my_hash["items"][0]["statistics"]["dislikeCount"]
        #favouriteCount
        @favoriteCount = my_hash["items"][0]["statistics"]["favouriteCount"]
        #commentCount
        @commentCount = my_hash["items"][0]["statistics"]["commentCount"]
        #duration
        @duration = my_hash["items"][0]["contentDetails"]["duration"]
        #dimension
        @dimension = my_hash["items"][0]["contentDetails"]["dimension"]
        #definition
        @definition = my_hash["items"][0]["contentDetails"]["definition"]
        #caption
        @caption = my_hash["items"][0]["contentDetails"]["caption"]

        data = Array[ {name:'channelId', value:"#{@channelId}"},
                      {name:'channelTitle', value:"#{@channelTitle}"},
                      {name:'publishedAt', value:"#{@publishedAt}"},
                      {name:'description', value:"#{@my_description}"},
                      {name:'categoryId', value:"#{@categoryId}"},
                      {name:'liveBroadcastContent', value:"#{@liveBroadcastContent}"},
                      {name:'viewCount', value:"#{@viewCount}"},
                      {name:'likeCount', value:"#{@likeCount}"},
                      {name:'dislikeCount', value:"#{@dislikeCount}"},
                      {name:'favouriteCount', value:"#{@favouriteCount}"},
                      {name:'commentCount', value:"#{@commentCount}"},
                      {name:'duration', value:"#{@duration}"},
                      {name:'dimension', value:"#{@dimension}"},
                      {name:'definition', value:"#{@definition}"},
                      {name:'caption', value:"#{@caption}"}
        ]
      end

      # download_url
      # params: none; must be called after valid? and initialize
      # returns URL for video stream
      def download_url
        "https://www.youtube.com/v/#{@videoid}"
      end

    end
  end
end
