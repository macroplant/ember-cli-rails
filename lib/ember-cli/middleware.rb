module EmberCLI
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      enable_ember_cli
      EmberCLI.wait!

      @app.call(env)
    end

    private

    def enable_ember_cli
      @enabled ||= begin
        if Rails.env.development? || Rails.env.production_local?
          EmberCLI.run!
        else
          EmberCLI.compile!
        end

        true
      end
    end
  end
end
