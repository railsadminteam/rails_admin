

def file_path(*paths)
  File.expand_path(File.join(File.dirname(__FILE__), '../fixtures', *paths))
end
