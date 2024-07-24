SitemapGenerator::Sitemap.default_host = "http://yourdomain.com"

SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'weekly', :priority => 1.0
  add '/about', :changefreq => 'monthly', :priority => 0.8
  add '/contact', :changefreq => 'monthly', :priority => 0.8
  # Add more paths here
end
