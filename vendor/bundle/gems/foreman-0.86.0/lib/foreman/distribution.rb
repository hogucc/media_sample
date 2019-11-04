module Foreman
  module Distribution
    def self.files
      Dir[File.expand_path('../../{bin,data,lib}/**/*', __dir__)].select do |file|
        File.file?(file)
      end
    end
  end
end
