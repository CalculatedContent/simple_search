#!/usr/bin/env ruby

require 'json'

(0...10).each do |i|
  hsh= { :title => "title#{i}", :description => "desc for #{i}", :link => "http://www.num.#{i}", :image => "", :video => "", :score => i }
  puts hsh.to_json
end

