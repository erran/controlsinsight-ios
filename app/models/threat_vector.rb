class ThreatVector
  PROPERTIES = [
    :assessment_timestamp,
    :grade,
    :grade_level,
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
end
