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
require 'json'

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
      def self.fetch(uri_str, limit = 20)
        # You should choose a better exception.
        raise ArgumentError, 'too many HTTP redirects' if limit == 0
        raise ArgumentError, 'Invalid url passed' if uri_str.nil?
        # vytvořit pole
        redirect_history = []
        # nekonečkou smyčku
        unless uri_str.start_with?('http://','https://')
          uri_str.prepend('http://')
        end
        for i in 0..limit
          return uri_str if redirect_history.include? uri_str
          response = Net::HTTP.get_response(URI(uri_str))
          return uri_str if response.is_a? Net::HTTPSuccess
          raise StandardError, 'Error code between 4xx and 5xx' unless response.is_a? Net::HTTPRedirection
          redirect_history << uri_str
          uri_str = response['location']
        end
      end

      # validation
      # params: url (string)
      # returns bool value ( true / false )
      def self.valid?(url)
        url = fetch(url)
      rescue ArgumentError => a
        raise ArgumentError, 'Invalid url passed'
      rescue StandardError => e
        raise StandardError, 'Error code between 4xx and 5xx'
      else
        # this runs only when no exception was raised
        # regular expression of youtube url - validation test
        !!(url =~ /^(?:http:\/\/|https:\/\/)?(www\.)?(youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){6,11})(\S*)?$/)
      end

      # getId
      # params: url (string)
      # returns @videoid (string)
      def getId(url)
        pom = url.split('v=')
        pom[1].split('&')[0]
      end

      # initialize
      # params: url (string)
      # returns @youtube (json object)
      def initialize(url, key = '')
        unless key != ''
            @mykey = "AIzaSyBVYtP85g7VCilGKbzkQqPCf8CxokAfvhU"
          else
            @mykey = key
        end
        # all description from YouTube API
        url = self.class.fetch(url)
        @videoid = getId(url)
        uri = URI("https://www.googleapis.com/youtube/v3/videos?id=#{@videoid}&key=#{@mykey}&part=snippet,statistics,contentDetails,status")
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
        # snippet part
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

        # statistics part
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

        # content details part
        #duration
        @duration = my_hash["items"][0]["contentDetails"]["duration"]
        #dimension
        @dimension = my_hash["items"][0]["contentDetails"]["dimension"]
        #definition
        @definition = my_hash["items"][0]["contentDetails"]["definition"]
        #caption
        @caption = my_hash["items"][0]["contentDetails"]["caption"]
        #licensedContent
        @licensedContent = my_hash["items"][0]["contentDetails"]["licensedContent"]
        #regionRestriction
        @regionRestriction = my_hash["items"][0]["contentDetails"]["licensedContent"]["blocked"][0]

        # status part
        @uploadStatus = my_hash["items"][0]["status"]["processed"]
        @privacyStatus = my_hash["items"][0]["status"]["privacyStatus"]
        @license = my_hash["items"][0]["status"]["license"]
        @embeddable = my_hash["items"][0]["status"]["embeddable"]
        @publicStatsViewable = my_hash["items"][0]["status"]["publicStatsViewable"]

        #time when the metadata were added
        @time = Time.now.getutc

        data = Array[ {name:'videoId', value:"#{@videoid}"},
                      {name:'channelId', value:"#{@channelId}"},
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
                      {name:'caption', value:"#{@caption}"},
                      {name:'licensedContent', value:"#{@licensedContent}"},
                      {name:'regionRestriction', value:"#{@regionRestriction}"},
                      {name:'uploadStatus', value:"#{@uploadStatus}"},
                      {name:'privacyStatus', value:"#{@privacyStatus}"},
                      {name:'license', value:"#{@license}"},
                      {name:'embeddable', value:"#{@embeddable}"},
                      {name:'publicStatsViewable', value:"#{@publicStatsViewable}"},
                      {name:'timestamp', value:"#{@time}"}
        ]
      end

      # download_url
      # params: none; must be called after valid? and initialize
      # returns URL for video stream
      def download_url
        raise StandardError, 'Non existing video passed' if @videoid == nil
        rescue StandardError => e
          raise StandardError, 'Non existing video passed'
        else
          "https://www.youtube.com/v/#{@videoid}"
      end

      # download_url
      # params: none; must be called after valid? and initialize
      # returns URL for downloading video; login required!!
      def download_captions
        raise StandardError, 'This video has no title' if @caption == "false"
        rescue StandardError => e
          raise StandardError, 'This video has no title'
        else
          "https://www.googleapis.com/youtube/v3/captions/#{@videoid}"
      end

    end
  end
end
