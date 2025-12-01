module Datev
  class StringField < Field
    def limit
      options[:limit]
    end

    def regex
      options[:regex]
    end

    def validate!(value)
      super

      if value
        raise ArgumentError.new("Value given for field '#{name}' is not a String") unless value.is_a?(String)
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too long") if limit && value.length > limit
        raise ArgumentError.new("Value '#{value}' for field '#{name}' does not match regex") if regex && value !~ regex
      end
    end

    def output(value, context = self)
      unless context&.respond_to?(:quote_empty_strings) && context.quote_empty_strings
        # If value is nil or empty, return empty string (no quotes)
        # This is required for DATEV's reserved fields which MUST be completely empty
        return '' if value.nil? || (value.respond_to?(:empty?) && value.empty?)
      end

      # Original behavior for non-empty values
      value = value.slice(0, limit || 255) if value

      quote(value)
    end

  private

    def quote(value)
      # Existing quotes have to be doubled
      value = value.gsub('"','""') if value

      "\"#{value}\""
    end
  end
end
