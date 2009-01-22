# run very flat apps with merb -I <app file>.

################################################################################
# CONFIG
################################################################################
require 'config/dependencies.rb'

use_orm :datamapper
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

DataMapper.setup(
  :default,
  :adapter  => 'sqlite3',
  :database => 'production.db'
)

################################################################################

################################################################################
# ROUTES
################################################################################
Merb::Router.prepare do
  match('/').to(:controller => 'users', :action =>'index')
  resources :users
end
################################################################################

################################################################################
# CONTROLLERS
################################################################################
class Users < Merb::Controller
  def index
    @prop_users = @drop_users = User.all
    render
  end
end

################################################################################
# MODELS
################################################################################
class User
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String
  property :handle,  String
  property :img_url, String
  timestamps :at
  
  has n, :props, :conditions => { :prop => true }
  has n, :drops, :conditions => { :prop => false }
end

class Message
  include DataMapper::Resource

  property :id,         Serial
  property :user_id,    Integer
  property :sender_id,  Integer
  property :message_id, Integer
  property :body,       String
  property :prop,       Boolean
end

class Prop < Message
  def initialize(args)
    super(args)
    self.prop ||= true
  end
end

class Drop < Message
  def initialize(args)
    super(args)
    self.prop ||= false
  end
end
