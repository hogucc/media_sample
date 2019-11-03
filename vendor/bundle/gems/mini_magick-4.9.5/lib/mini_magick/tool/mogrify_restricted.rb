require 'mini_magick/tool/mogrify'

module MiniMagick
  class Tool
    ##
    # @see http://www.imagemagick.org/script/mogrify.php
    #
    class MogrifyRestricted < Mogrify
      def format(*_args)
        raise NoMethodError,
              'you must call #format on a MiniMagick::Image directly'
      end
    end
  end
end
