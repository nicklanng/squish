require "yaml"
require "pathname"

class TravisSquish

  def self.get_changed_files
    changedFiles = `git diff --name-only $TRAVIS_COMMIT_RANGE`
    return changedFiles.split(/\n+/)
  end

 	def self.run
		begin
	    @config = YAML.load_file(".squish.yml")
	  rescue
	    puts "Missing or malformed .squish.yml in repository root"
			return
		end

    watches = @config["watches"]
    matches = Hash.new

		changedFiles = get_changed_files()
    changedFiles.each do |file|
      path = Pathname.new(file)

      watches.each do |key, value|
        if path.fnmatch?(File.join(key,'**'))
          matches[key] = value
          watches.delete key
        end
      end
    end

    errored = false
    matches.each do |key, value|
      puts "travissquish> Changes seen in " + key + ", running commands:"
      value.each do |cmd|
        puts "travissquish> $ " + cmd
        result = system cmd
        if result == false then
          errored = true
          break
        end
      end
    end
    exit(1) if errored
	end
end
