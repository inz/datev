module Datev
  class IntegerField < Field
    def limit
      options[:limit]
    end

    def maximum
      options[:maximum]
    end

    def minimum
      options[:minimum]
    end

    def validate!(value)
      super

      if value
        raise ArgumentError.new("Value given for field '#{name}' is not an Integer") unless value.is_a?(Integer)
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too long") if limit && value.to_s.length > limit
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too large") if maximum && value > maximum
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too small") if minimum && value < minimum
      end
    end

    def output(value, _context=nil)
      # Return empty string for nil values (required for DATEV reserved fields)
      return '' if value.nil?

      # Return bare integer value without quotes (DATEV CSV format requirement)
      value.to_s
    end
  end
end
