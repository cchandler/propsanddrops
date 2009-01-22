# run very flat apps with merb -I <app file>.

################################################################################
# CONFIG
################################################################################
require 'config/dependencies.rb'

use_test :rspec
use_template_engine :haml

Merb::Config.use { |c|
  c[:framework]         = { :public => [Merb.root / "public", nil] }
  c[:session_store]     = 'none'
  c[:exception_details] = true
  c[:log_level]         = :debug # or error, warn, info or fatal
  c[:log_stream]        = STDOUT
  c[:log_file]          = Merb.root / "log" / "merb.log"
  c[:reload_classes]    = true
  c[:reload_templates]  = true
}

COUCHDB = "http://10.0.40.99:5984/twitterprops"
CouchRest::Model.default_database = CouchRest.database!(COUCHDB)

################################################################################

################################################################################
# ROUTES
################################################################################
Merb::Router.prepare do
  match('/').to(:controller => 'users', :action =>'index')
  match('/:user').to(:controller => 'users', :action => 'show')
end
################################################################################

################################################################################
# CONTROLLERS
################################################################################
class Users < Merb::Controller
  def index
    rows = CouchRest::Model.default_database.view('messages/by_totals')['rows'].first['value'].collect {|n| TempSort.new(n)}
    %w(totals props drops).each do |term|
      self.instance_variable_set("@#{term}", rows.sort {|a,b| b.send(term) <=> a.send(term) } )
    end
    
    render
  end
  
  def show
    render
  end
end

################################################################################
# MODELS
################################################################################
class User < CouchRest::Model
end

class TempSort
  def initialize(values)
    values.keys.each {|key| TempSort.class_eval("attr_accessor :#{key}"); self.send("#{key}=", values[key]) }
  end
end

class Message < CouchRest::Model
  key_accessor :author, :receiver, :content, :published_at, :status_uri, :image_uri, :tweet_id
  
  timestamps!
end