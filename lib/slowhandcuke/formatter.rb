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

    def before_step_result(*args)
      is_table = args[2].is_a?(Cucumber::Ast::Table)
      table_rows = is_table ? args[2].raw.length : 0

      # If there was a table in the step, go up the required number of lines and
      # print the table result over the top.
      if is_table
        @io.printf "\033[#{table_rows + 1}A"
      end
      @io.printf "\r\033[K"
      super
    end
  end
end
