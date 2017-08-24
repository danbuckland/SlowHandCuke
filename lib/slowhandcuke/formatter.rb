require 'cucumber/formatter/pretty'
module Slowhandcuke
  class Formatter < Cucumber::Formatter::Pretty
    def before_step(step)
      @io.printf "#{step.keyword}#{step.name}".indent(@scenario_indent + 2)
      unless step.multiline_arg.nil?
        @io.printf "#{step.multiline_arg}".indent(@scenario_indent + 2)
      end
      @io.flush
    end

    def before_step_result( *args )
      @io.printf "\r"
      super
    end
  end
end
