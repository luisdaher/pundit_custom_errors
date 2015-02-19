module PunditCustomErrors
  module Generators
    class InitializeGenerator < ::Rails::Generators::Base
      desc 'Copy accesstage.yml file to your application config directory.'

      def self.source_root
        @source_root ||= File.expand_path(
          File.join(File.dirname(__FILE__), 'templates')
        )
      end

      def copy_config_file
        template 'config/locales/pundit_custom_errors.en.yml'
      end
    end
  end
end
