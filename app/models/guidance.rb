class NSString
  def underscore
    acronym_regex = /(?=a)b/

    word = gsub('::', '/')
    word.gsub!(/(?:([A-Za-z\d])|^)(#{acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!('-', '_')
    word.downcase!
    word
  end
end

class Guidance
  PROPERTIES = [
    :assessment_timestamp,
    :domain,
    :dsd_reference,
    :improvement_delta,
    :improvement_grade,
    :name,
    :nist_reference,
    :references, # TODO: Create a model for references?
    :sans_reference,
    :sections,
    :target_grade,
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
