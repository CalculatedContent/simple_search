#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'htmlentities'
require 'xapian-fu'

include XapianFu

configure do
 DB = XapianDb.new(:dir => 'simple.db', :create => false)
end

get "/" do
  "simple search working"
end


get '/:field' do
  @query = params[:q]
  @search_results = DB.search(@query).map { |x| x.values[params[:field].to_sym] }
  erb :search_results
end

