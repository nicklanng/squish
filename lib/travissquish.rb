class TravisSquish
	def self.changed_files
		changedFiles = `git diff --name-only $TRAVIS_COMMIT_RANGE`
		puts changedFiles
	end
end
