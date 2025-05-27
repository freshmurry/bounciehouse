# config/initializers/paperclip_uri_escape_fix.rb
module URI
  def self.escape(*args)
    # Use CGI.escape or Addressable::URI.encode instead if you want more control
    # Here, we simply use CGI.escape, but beware it encodes spaces as +, etc.
    require 'cgi'
    CGI.escape(args.first.to_s)
  end
end
