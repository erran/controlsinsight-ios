class CoverageItem
  PROPERTIES = [
    :assessment_timestamp,
    :coverage,
    :name,
    :title
  ]

  PROPERTIES.each do |property|
    attr_accessor property
  end

  def initialize(hash)
    hash.each do |key, value|
      key = key.underscore

      if PROPERTIES.include? key.to_sym
        instance_variable_set("@#{key}", value)
      end
    end
  end

  def coverage
    @coverage ||= Coverage.new({})
  end

  def coverage=(coverage)
    Coverage.new(coverage)
  end
end
