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
# Authors: Petr Kubín
#

require 'spec_helper'

describe Narra::Youtube::Connector do
  before(:each) do
    # test url
    @url = 'https://www.youtube.com/watch?v=qM9f01YYDJ4'
  end

  it 'can be instantiated' do
    expect(Narra::Youtube::Connector.new(@url)).to be_an_instance_of(Narra::Youtube::Connector)
  end

  it 'should have accessible fields' do
    expect(Narra::Youtube::Connector.identifier).to match(:youtube)
    expect(Narra::Youtube::Connector.title).to match('NARRA YouTube Connector')
    expect(Narra::Youtube::Connector.description).to match('Allows NARRA to connects to the YouTube sources')
  end

  it 'should validate url' do
    expect(Narra::Youtube::Connector.valid?('https://www.youtube.com/watch?v=qM9f01YYDJ4')).to match(true)
    expect(Narra::Youtube::Connector.valid?('https://www.youtube.com/watch?f=qM9f01YYDJ4')).to match(false)
    expect(Narra::Youtube::Connector.valid?('www.youtube.com/watch?v=tDyeiePort0')).to match(true)
    expect(Narra::Youtube::Connector.valid?('https://www.youtube.com/watch?v=tDyeiePort0&spfreload=10')).to match(true)
    expect(Narra::Youtube::Connector.valid?('https://www.youtube.com/watch?v=qM9f01YYDJ4asdasdasdadasdasdasdasdaasdasdad')).to match(true) #redirect na spravnou
    expect(Narra::Youtube::Connector.valid?('www.youtube.com/watchv=tDyeiePort0')).to match(false)
    expect(Narra::Youtube::Connector.valid?('https://www.youtube.com/watch?vtDyeiePort0')).to match(false)
    expect(Narra::Youtube::Connector.valid?('http://www.youtube.com/watch?v=tDyeiePort0')).to match(true)    #redirect https://
    expect(Narra::Youtube::Connector.valid?('https:www.youtube.youtu.be.com/watch?v=tDyeiePort0')).to match(false)
    expect(Narra::Youtube::Connector.valid?('https://www.youtube.com/watch?v=2gz3DSiSymE&feature=iv&src_vid=VxlQ2gqiZ7k&annotation_id=annotation_620965849')).to match(true)
  end
end


describe 'object_youtube_connector' do

  before(:each) do
    @test1 = Narra::Youtube::Connector.new("https://www.youtube.com/watch?v=5IvlcZyjJvU")
    @test2 = Narra::Youtube::Connector.new("https://www.youtube.com/watch?v=2ndeBBsQZqQ")
    @test3 = Narra::Youtube::Connector.new("https://www.youtube.com/watch?v=U0jH2-VF00Y")
    @test4 = Narra::Youtube::Connector.new("https://www.youtube.com/watch?v=2gz3DSiSymE&feature=iv&src_vid=VxlQ2gqiZ7k&annotation_id=annotation_620965849")
    # jak z  {name:'channelId', value:'#{@channelId}'},
    # udělat {'channelId'=>'#{@channelId}'}
    @data = {}
    @data1 = {}
    @data2 = {}
    @data3 = {}
    @test1.metadata.each { |i| @data[i[:name]] = i[:value] }
    @test2.metadata.each { |i| @data1[i[:name]] = i[:value] }
    @test3.metadata.each { |i| @data2[i[:name]] = i[:value] }
    @test4.metadata.each { |i| @data3[i[:name]] = i[:value] }
  end

  it 'test top gear video test1' do
    expect(@test1.name).to match('Top Gear   Season 12 Episode 4 --  Series 12 Episode 4')
    expect(@test1.type).to match(:video)
    expect(@test1.metadata).to be_instance_of(Array)

    #test channelId
    expect(@data['channelId']).to match('UCsKSU2Og2vyMk-E6GgNH4-A')
    #test channelTitle
    expect(@data['channelTitle']).to match('Top Gear 12 Full HD')
    #test publishedAt
    expect(@data['publishedAt']).to match('2015-02-01T21:45:24.000Z')
    #test description
    expect(@data['description']).to match("Tags:\nTop Gear   Season 12 Episode 4 --  Series 12 Episode 4\nTop Gear   Season 12 Full HD\n================================================Top Gear is a British television series about motor vehicles, primarily cars, and is the most widely watched factual television programme in the world.[2] It began in 1977 as a conventional motoring magazine programme. Over time, and especially since a relaunch in 2002, it has developed a quirky, humorous and sometimes controversial[3][4] style. The programme is currently presented by Jeremy Clarkson, Richard Hammond and James May, and has featured at least three different test drivers known as The Stig. The programme is estimated to have around 350 million views per week in 170 different countries.")
    #test categoryId
    expect(@data['categoryId']).to match('1')
    #test liveBroadcastContent
    expect(@data['liveBroadcastContent']).to match('none')
    #test viewCount
    expect(@data['viewCount']).to match('50350')
    #test likeCount
    expect(@data['likeCount']).to match('120')
    #test dislikeCount
    expect(@data['dislikeCount']).to match('8')
    #test favouriteCount
    expect(@data['favouriteCount']).to match('')
    #test commentCount
    expect(@data['commentCount']).to match('7')
    #test duration
    expect(@data['duration']).to match('PT1H5M47S')
    #test dimension
    expect(@data['dimension']).to match('3d')
    #test definition
    expect(@data['definition']).to match('hd')
    #test caption
    expect(@data['caption']).to match('false')
  end


  it 'test Kanalgratis video test2' do
    expect(@test2.name).to match('Kanalgratis Live - Danish Record Pike 21,1 kg, 46lb 8oz - Interview with Finn Sloth Hansen')
    expect(@test2.type).to match(:video)
    expect(@test2.metadata).to be_instance_of(Array)

    #test channelId
    expect(@data1['channelId']).to match('UCwTrHPEglCkDz54iSg9ss9Q')
    #test channelTitle
    expect(@data1['channelTitle']).to match('kanalgratisdotse')
    #test publishedAt
    expect(@data1['publishedAt']).to match('2015-03-02T20:13:23.000Z')
    #test description
    expect(@data1['description']).to match('')
    #test categoryId
    expect(@data1['categoryId']).to match('17')
    #test liveBroadcastContent
    expect(@data1['liveBroadcastContent']).to match('none')
    #test viewCount
    expect(@data1['viewCount']).to match('9609')
    #test likeCount
    expect(@data1['likeCount']).to match('84')
    #test dislikeCount
    expect(@data1['dislikeCount']).to match('17')
    #test favouriteCount
    expect(@data1['favouriteCount']).to match('')
    #test commentCount
    expect(@data1['commentCount']).to match('935')
    #test duration
    expect(@data1['duration']).to match('PT1H3M')
    #test dimension
    expect(@data1['dimension']).to match('2d')
    #test definition
    expect(@data1['definition']).to match('hd')
    #test caption
    expect(@data1['caption']).to match('false')
  end

  it 'test description' do
    expect(@data2['description']).to match('I do not own this video. Nevlastním toto video. Majitel je TV Nova.')
  end


  it 'test Kanalgratis video test2' do
    expect(@test4.name).to match('Kawasaki zx-10r vs Honda cbr 1000 rr | RAW VIDEO" to match "Kanalgratis Live - Danish Record Pike 21,1 kg, 46lb 8oz - Interview with Finn Sloth Hansen')
    expect(@test4.type).to match(:video)
    expect(@test4.metadata).to be_instance_of(Array)

    #test channelId
    expect(@data3['channelId']).to match('UCIlh_cFLNl_Q4xQtZ2cSKmg')
    #test channelTitle
    expect(@data3['channelTitle']).to match('Meddesuncut')
    #test publishedAt
    expect(@data3['publishedAt']).to match('2014-08-15T11:53:20.000Z')
    #test description
    expect(@data3['description']).to match('Some RAW footage of us, just me and Stoffel up the hill.')
    #test categoryId
    expect(@data3['categoryId']).to match('2')
    #test liveBroadcastContent
    expect(@data3['liveBroadcastContent']).to match('none')
    #test viewCount
    expect(@data3['viewCount']).to match('13223')
    #test likeCount
    expect(@data3['likeCount']).to match('270')
    #test dislikeCount
    expect(@data3['dislikeCount']).to match('4')
    #test favouriteCount
    expect(@data3['favouriteCount']).to match('')
    #test commentCount
    expect(@data3['commentCount']).to match('22')
    #test duration
    expect(@data3['duration']).to match('PT1M33S')
    #test dimension
    expect(@data3['dimension']).to match('2d')
    #test definition
    expect(@data3['definition']).to match('hd')
    #test caption
    expect(@data3['caption']).to match('false')
  end
end

