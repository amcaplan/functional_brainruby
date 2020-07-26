# frozen_string_literal: true

require 'erb'

module FunctionalBrainruby
  class Generator
    ONE = "[[]]<=>[]"
    NEGATIVE_ONE = "[]<=>[[]]"
    TEMPLATE = ERB.new(File.read('views/template.erb'))

    def initialize(string)
      @string = string
      @esocode = esostring(string)
    end

    def to_functional_brainruby
      TEMPLATE.result(binding)
    end

    private

    def esostring(string)
      %Q{""#{string.each_char.map { |char| "<<#{esonum_from_char(char)}" }.join}}
    end

    def esonum_from_char(char)
      '__[' + char.ord.to_s(2).reverse.split('').map.with_index { |digit, index|
        if digit == "1"
          if index == 0
            "__[#{ONE}]"
          else
            "#{index.times.map { "_[" }.join}#{ONE}#{index.times.map { ",#{NEGATIVE_ONE}]" }.join}"
          end
        end
      }.compact.join('--') + "]"
    end
  end
end
