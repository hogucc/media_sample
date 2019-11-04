require 'execjs/runtime'

module ExecJS
  class DisabledRuntime < Runtime
    def name
      'Disabled'
    end

    def exec(_source, _options = {})
      raise Error, 'ExecJS disabled'
    end

    def eval(_source, _options = {})
      raise Error, 'ExecJS disabled'
    end

    def compile(_source, _options = {})
      raise Error, 'ExecJS disabled'
    end

    def deprecated?
      true
    end

    def available?
      true
    end
  end
end
