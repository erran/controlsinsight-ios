class Relations < Hash
  def initialize(hash)
    hash ||= {}

    hash.each do |key, value|
      define_method(key) do
        value
      end
    end
  end

  def [](key)
    if respond_to? key.to_sym
      send(key)
    else
      super
    end
  end
end
