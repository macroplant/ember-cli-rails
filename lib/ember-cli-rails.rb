require "ember-cli/railtie" if defined?(Rails)

module EmberCLI
  extend self

  autoload :App,           "ember-cli/app"
  autoload :Configuration, "ember-cli/configuration"
  autoload :ViewHelpers,   "ember-cli/view_helpers"
  autoload :Helpers,       "ember-cli/helpers"
  autoload :Middleware,    "ember-cli/middleware"

  def configure
    yield configuration
  end

  def configuration
    Configuration.instance
  end

  def prepare!
    @prepared ||= begin
      # todo - make this work with apps other than just 'frontend'
      # configuration.apps.each{ |name, app| Rails.configuration.assets.paths << root.join("assets/#{name}").to_s }
      Rails.configuration.assets.paths << root.join("assets/frontend").to_s
      at_exit{ cleanup }
      true
    end
  end

  def enable!
    prepare!

    if Helpers.non_production?
      Rails.configuration.middleware.use Middleware
    end
  end

  def run!
    prepare!
    each_app &:run
  end

  def compile!
    prepare!
    each_app &:compile
  end

  def stop!
    each_app &:stop
  end

  def wait!
    each_app &:wait
  end

  def root
    @root ||= Rails.root.join("tmp", "ember-cli-#{uid}")
  end

  private

  def uid
    @uid ||= SecureRandom.uuid
  end

  def cleanup
    root.rmtree if root.exist?
  end

  def each_app
    configuration.apps.each{ |name, app| yield app }
  end
end
