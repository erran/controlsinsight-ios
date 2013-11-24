class Asset
  PROPERTIES = [
    :assessment_timestamp,
    :host_name,
    :ipaddress,
    :name,
    :operating_system,
    :operating_system_certainty,
    :owner,
    :risk_level,
    :risk_score,
    :security_control_findings,
    :uuid
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

  def security_control_findings
    @security_control_findings ||= []
  end

  def security_control_findings=(findings)
    findings.map do |finding|
      SecurityControlFinding.new(finding)
    end
  end
end
