class Assessment
  PROPERTIES = [
    :assessing,
    :high_risk_asset_count,
    :id,
    :low_risk_asset_count,
    :medium_risk_asset_count,
    :overall_risk_score,
    :timestamp,
    :total_asset_count
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
