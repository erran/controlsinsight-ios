class Assets
  PROPERTIES = [
    :first_url,
    :last_url,
    :next_url,
    :page,
    :per_page,
    :previous_url,
    :resources,
    :sort,
    :total_available
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

  def resources
    @resources ||= []
  end

  def resources=(assets)
    assets.map do |asset|
      Asset.new(asset)
    end
  end

  alias_method :assets, :resources
  alias_method :assets=, :resources=
end
