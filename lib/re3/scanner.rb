require 'strscan'

module Re3
  class Scanner
    def initialize(s)
      @ss = StringScanner.new(s)
    end

    def next_token
      return if @ss.eos?

      scan
    end

    private
    def scan
      if text = @ss.scan(/[*+?()|]/)
        [text, text]
      elsif text = @ss.scan(/[a-zA-Z0-9]/)
        [:CHAR, text]
      elsif text = @ss.scan(/./)
        [:OTHER, text]
      end
    end
  end
end
