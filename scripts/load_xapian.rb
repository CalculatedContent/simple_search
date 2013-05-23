#!/usr/bin/env ruby
require 'rubygems'
require 'logger'
require 'xapian-fu'

log = Logger.new($stderr)

include XapianFu
db = XapianDb.new(:dir => 'data/simple.db', :create => true, :store => [:field])

last_line = ""
$stdin.each do |line|

  begin
    db << { :field => line.chomp }
  rescue => e
    log.error e.msg
  end
  last_line = line
end

# find last line, just be sure we loaded the data

db.flush
db.search(last_line).each do |match|
  puts match.values[:field]
end
