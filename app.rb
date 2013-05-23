#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'htmlentities'
require 'xapian-fu'

configure do
  include XapianFu
  DB = XapianDb.new(:dir => 'simple.db', :create => false)
end



get "/" do
  "simple search working"
end

get '/search/' do
  @query = params[:query]
  @search_results = DB.search(@query).map { |x| x.values[:field] }
  erb :search_results
end


