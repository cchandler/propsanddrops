#! /opt/local/bin/ruby 

require 'rubygems'
require 'couchrest'
require 'hpricot'

COUCHDB = "http://127.0.0.1:5984/twitterprops"
CouchRest::Model.default_database = CouchRest.database!(COUCHDB)
@db = CouchRest::Model.default_database

# http://search.twitter.com/search.atom?q=prop+OR+props+OR+drop+OR+drops

data = File.open("/Users/integrum/Desktop/twitter.xml")
doc = Hpricot(data)

record_set = []

@db.view("messages/by_all")['rows'].each {|n| @db.delete(n['value']) }

(doc/'entry').each do |entry|
  title = (entry/'title').inner_html
  
  next unless title =~ /^@?([pd]rop)s?(?:\sto\s)?\s*@?(\w+)\s*(.*)/i
  record = {:action => $1, :receiver => $2 }
  
  record[:content] = (entry/'content').inner_html
  author = {}
  
  name = (entry/'author'/'name').inner_html
  
  author[:handle] = name.split(" ").first
  author[:name] = name.match(/\((.*)\)/)[1]
  
  record[:author] = author
  record[:published_at] = (entry/'published').inner_html
  record["couchrest-type".to_sym] = "Message"
  
  record[:status_uri] = (entry/'link[@rel="alternate"]').first['href']
  record[:image_uri] = (entry/'link[@rel="image"]').first['href']
  
  record[:tweet_id] = (entry/'id').inner_html.split(":").last
  
  record_set << record
end

p record_set
@db.bulk_save(record_set)