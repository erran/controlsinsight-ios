class SecurityControlFinding
  PROPERTIES = [
    :configuration_findings,
    :security_control_name
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

  def configuration_findings
    @configuration_findings ||= []
  end

  def configuration_findings=(findings)
    findings.map do |finding|
      ConfigurationFinding.new(finding)
    end
  end
end
