class ConfigurationFinding
  PROPERTIES = [
    :configuration_name,
    :reason,
    :state
  ]

  PROPERTIES.each do |property|
    attr_accessor property
  end

  def initialize(hash)
    hash ||= {}

    hash.each do |key, value|
      key = key.underscore

      if PROPERTIES.include? key.to_sym
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
