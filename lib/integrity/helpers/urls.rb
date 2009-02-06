module Integrity
  module Helpers
    module Urls
      
      def path_prefix
        env['SCRIPT_NAME']
      end
      
      def url(path)
        url = "#{request.scheme}://#{request.host}"

        if request.scheme == "https" && request.port != 443 ||
            request.scheme == "http" && request.port != 80
          url << ":#{request.port}"
        end

        url << "/" unless path.index("/").zero?
        url << path
      end

      def login_path
        "#{path_prefix}/login"
      end

      def home_path
        "#{path_prefix}/"
      end

      def root_url
        url(home_path)
      end

      def project_path(project, *path)
        "#{path_prefix}/" << [project.permalink, *path].join("/")
      end

      def project_url(project, *path)
        url project_path(project, *path)
      end

      def push_url_for(project)
        Addressable::URI.parse(project_url(project, "push")).tap do |url|
          if Integrity.config[:use_basic_auth]
            url.user     = Integrity.config[:admin_username]
            url.password = Integrity.config[:hash_admin_password] ?
              "<password>" : Integrity.config[:admin_password]
          end
        end.to_s
      end

      def build_path(build)
        "#{path_prefix}/#{build.project.permalink}/builds/#{build.commit_identifier}"
      end

      def build_url(build)
        url build_path(build)
      end
    end
  end
end