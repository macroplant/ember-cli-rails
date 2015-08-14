module EmberCLI
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env["PATH_INFO"].to_s

      if path == "/testem.js"
        [ 200, { "Content-Type" => "text/javascript" }, [""] ]
      else
        EmberCLI.process_path path
        @app.call(env)
      end
    end
  end
end

# module EmberCLI
#   class Middleware
#     def initialize(app)
#       @app = app
#     end

#     def call(env)
#       path = env["PATH_INFO"].to_s

# <<<<<<< HEAD
#       @app.call(env)
#     end

#     private

#     def enable_ember_cli
#       @enabled ||= begin
#         if Rails.env.development? || Rails.env.production_local?
#           EmberCLI.run!
#         else
#           EmberCLI.compile!
#         end

#         true
# =======
#         if path == "/testem.js"
#           [ 200, { "Content-Type" => "text/javascript" }, [""] ]
#         else
#           EmberCLI.process_path path
#           @app.call(env)
#         end
# >>>>>>> master
#       end
#     end
#   end
# end
