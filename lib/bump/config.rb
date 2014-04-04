module Bump
  module Config
    class << self
      #Path to the file containing the version variable
      attr_accessor :version_path
      #Regex for the format the version is in the file
      attr_accessor :version_regex
    end
  end
end