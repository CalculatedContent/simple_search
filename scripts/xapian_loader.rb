#!/usr/bin/env ruby
require 'rubygems'
require 'logger'
require 'xapian-fu'
require 'trollop'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'json'
require 'cloud_loader'

#require 'bundler/setup'

include XapianFu

opts = Trollop::options do
  opt :database, "database file name", :short => "-d", :default => CloudLoader::DEFAULT_DB
  opt :create, "create new database", :short => "-c", :default => true
  opt :bucket, "bucket", :short => "-b", :default => "simple-search"
  opt :path, "path on bucket", :short => "-p",  :default => ""
  opt :schema, "xapian schema", :short => "-s", :default => ""
  opt :pattern, "file patterns", :short => "-f", :default => "*" #, :multi => true
  opt :credentials_file, "s3cfg file", :short => "-r", :default => "~/.s3cfg"
  opt :test, "test", :short => "-t", :default => nil
  opt :verbose, "verbose", :short => "-v", :default => nil
  opt :limit, "limit", :limit => "-l", :default => nil
end

log = Logger.new('logs/xapian.log')
opts[:database] ||= "#{opts[:bucket]}-#{opts[:path]}"

# load fog credentials...for now, hack from reading .s3cfg
# specify a test path
# load

cfg_hsh = {}
File.open(File.expand_path(opts[:credentials_file])) do |f|
  f.each_line do |line|
    toks = line.split(/\s/)
    cfg_hsh[toks.first]=toks.last
  end
end

opts[:credentials] = { :provider => 'AWS',
  :aws_access_key_id => cfg_hsh["access_key"],
  :aws_secret_access_key => cfg_hsh["secret_key"],
  :region =>  "us-west-1" }

loader = CloudLoader::Loader.new(opts)

# load xapian schema
# if not present,  get line of first file and infer the fields
#  from the fields in hash
fields = []
if opts[:schema].nil? or opts[:schema].size==0 then
fields = loader.first.first.symbolize_keys.keys
else
# n/a yet
end

#TODO: how get fields for xapian gui

# opts = { :bucket=>"cloud-crawler", :path=>"crawl-pages", :pattern=>/40UTC/  }
# p
db = XapianDb.new(:dir => opts[:database], :create => opts[:create], :store => fields)

loader.each do |hsh|
  begin
    db << hsh.symbolize_keys
  rescue => e
  log.error  e.message
  log.error  e.backtrace
  end
end

db.flush
# db.reindex?

#TODO:  load from s3 bucket or local
# similar code wil be used to load redis
# wil eventually need tracker and redis caches gem

# similar to s3 caches
# would i ever use xapian without the web app?
# lets NOT do this ... just keep here for now

#  change log to specific log file for loaded
# specify the bucket name, and n patterns to load
# specify the xapian schema, local or on s3
# specify name of database

# get list of all s3 files ?  try fog api
# over all files
# pull file, stream using gzip and/or tar
#  load each line of each file
#  log file has been loaded
#  add load time to file
#  reindex data

# can i do a live update?

# s3_xapoan_loader
#
# can i implement as a rack migration?

#  see
#  http://stackoverflow.com/questions/15955991/how-to-list-all-files-in-an-s3-folder-using-fog-in-ruby

#TODO:
#  1. test locally , then write some tests
#  2. fix all livestrong titles
#  3. test that loader can read s3cfg, fields = title
#  4. test that fielda are indexed?
#  5. load...does it even work off s3?
#  6. set up some patterns for 1-5 chunks, and check
#  7. set up the config in the simple_search buckets and autoload on spoolup, or from cmd line on login
#     or maybe on reboot?  does xapian save itself?  how can we recover?
#  8. test update index from n more patterns
# 9 deploy the livestrong crawl
# 10. add some sane formatting / html
# 11.  test killing the node.  replication?

# 12.  mock tests:  can we set up mock tests that store formatted files?
#     this would be ideal ...

#  13. vagrant -- can we test the cloud locally ?  how?

# TODAY:  taks list...clean it all up and get this rolling
#  gotta finish tim and carl's prototypes   + relevance

# end of the day:  crawl -> xapian -> searchable index
#  test with carl's data

# add buttons: / different dbs
#   related queries
#   related titles
#  related videos / content  (subsearch)
#   scored suggestions
#  related products?

# build the CC front end using bootstrap, angular?
#  buidl the demo...get it Done

# what about tim?
#  query dispersion, panda hits?

#  add bootstrap buttons
#  ad seo predictions...enter a title, get a score
#   breka down the score into competition, price, and relevance
#   panda hit?
#
