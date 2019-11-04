if !defined?(RUBY_ENGINE) || RUBY_ENGINE == 'ruby' || RUBY_ENGINE == 'rbx'
  Object.send(:remove_const, :FFI) if defined?(::FFI)
  begin
    require RUBY_VERSION.split('.')[0, 2].join('.') + '/ffi_c'
  rescue Exception
    require 'ffi_c'
  end

  require 'ffi/ffi'

elsif defined?(RUBY_ENGINE)
  # Remove the ffi gem dir from the load path, then reload the internal ffi implementation
  $:.delete(File.dirname(__FILE__))
  $:.delete(File.join(File.dirname(__FILE__), 'ffi'))
  unless $".nil?
    $".delete(__FILE__)
    $".delete('ffi.rb')
  end
  require 'ffi.rb'
end
