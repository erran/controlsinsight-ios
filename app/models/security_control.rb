class SecurityControl < CoverageItem
  # TODO: Add these in CoverageItem directly when configuration items support being enabled/disabled
  PROPERTIES << :enabled
  attr_accessor :enabled

  def initialize(hash)
    super

    @enabled = hash['enabled']
  end
end
