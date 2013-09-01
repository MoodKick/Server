require 'json'

class ContentObjectScanner
  # scan folder with given path for content objects
  # every content object has it's own folder and should
  # have manifest.json file in it. Name of content object is taken
  # from the name of the folder containing manifest.json
  def scan(path)
    Dir.glob(path + '/*/manifest.json').map do |manifest_file|
      begin
        result = JSON.load(File.open(manifest_file, 'r'))
        result['name'] = File.basename(File.dirname(manifest_file))
        result
      rescue JSON::ParserError => e
      end
    end.reject { |i| i == nil }
  end
end
