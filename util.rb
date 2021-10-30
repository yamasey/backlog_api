require 'json'

class Util
  def self.load_secret_file
    File.open('secret.json') do |file|
      JSON.load(file)
    end
  end
end
