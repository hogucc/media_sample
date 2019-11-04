# frozen_string_literal: true

module ActionView
  module Helpers
    module Tags # :nodoc:
      class SearchField < TextField # :nodoc:
        def render
          options = @options.stringify_keys

          if options['autosave']
            options['autosave'] = request.host.split('.').reverse.join('.') if options['autosave'] == true
            options['results'] ||= 10
          end

          if options['onsearch']
            options['incremental'] = true unless options.key?('incremental')
          end

          @options = options
          super
        end
      end
    end
  end
end
