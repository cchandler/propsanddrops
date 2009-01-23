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
  c[:exception_details] = false
  c[:log_level]         = :error # or error, warn, info or fatal
  c[:log_file]          = Merb.root / "log" / "merb.log"
  c[:reload_classes]    = false
  c[:reload_templates]  = false
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
  def index(key=nil)
    %w(totals props drops).each do |term|
      rows = CouchRest::Model.default_database.view("messages/by_#{term}")["rows"].first['value'].collect {|n| TempSort.new(n)}
      self.instance_variable_set("@#{term}", rows.sort {|a,b| b.send(term) <=> a.send(term) } )
    end
    render
  end

  def show
    @messages = CouchRest::Model.default_database.view("messages/by_handle", :key => params[:user] )["rows"].collect {|n| TempSort.new(n['value']) }.sort {|a,b| b.published_at <=> a.published_at }
    @stats = TempSort.new((CouchRest::Model.default_database.view("messages/by_receiver_totals", :key => params[:user] )["rows"].first || {'value' => {'totals' => 0, 'props' => 0, 'drops' => 0}})['value'])
    render
  end
end

################################################################################
# MODELS
################################################################################
class TempSort
  def initialize(values)
    (values.keys - ["_id", "_rev","couchrest-type"] ).each {|key| TempSort.class_eval("attr_accessor :\"#{key}\""); self.send("#{key}=", values[key]) }
  end
end

class Message < CouchRest::Model
  key_accessor :author, :receiver, :content, :published_at, :status_uri, :image_uri, :tweet_id
  timestamps!
end