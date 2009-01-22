merb_gems_version = "1.0.8.1"
# dm_gems_version   = "0.9.10"
# do_gems_version   = "0.9.11"

dependency "merb-core",       merb_gems_version 
dependency "merb-assets",     merb_gems_version 
# dependency "merb_datamapper", merb_gems_version
dependency "merb-haml",       merb_gems_version

# dependency "dm-core",         dm_gems_version, :immediate => true
# dependency "dm-timestamps",   dm_gems_version, :immediate => true
# 
# dependency "data_objects",    do_gems_version
# dependency "do_sqlite3",      do_gems_version

dependency "couchrest", :require_as => "CouchRest", :immediate => true