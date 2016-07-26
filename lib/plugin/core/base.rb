module Plugin
  class Base

    def self.inherited(subclass)
      Manager.register_plugin(subclass)
    end

  end
end
