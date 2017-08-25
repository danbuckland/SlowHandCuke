require 'cucumber/formatter/pretty'
module Slowhandcuke
  class Formatter < Cucumber::Formatter::Pretty
    def before_step(step)
      @io.printf "#{step.keyword}#{step.name}".indent(@scenario_indent + 2)
      unless step.multiline_arg.nil?
        @io.printf step.multiline_arg.to_s
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

    def table_cell_value(value, status)
      return if !@table || @hide_this_step
      status ||= @status || :passed
      width = @table.col_width(@col_index)
      cell_text = escape_cell(value.to_s || '   ')
      padded = cell_text + (' ' * (width - cell_text.unpack('U*').length))
      prefix = cell_prefix(status)
      # Print table with extra padding to match the strange table supplied by
      # step.multiline_arg
      @io.print(' ' + format_string("#{prefix}    #{padded}", status) +
                ::Cucumber::Term::ANSIColor.reset(' |'))
      @io.flush
    end
  end
end
