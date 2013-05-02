require 'dimensions-rails/version'
require 'active_support/ordered_options'
require 'rails/railtie'
require 'dimensions'

module Dimensions
  module Rails

    module Helper

      # Use dimensions by @sstephenson to add automatic images size and improve browser rendering.
      #
      # How this improves browser rendering?
      # https://developers.google.com/speed/docs/best-practices/rendering#SpecifyImageDimensions
      #
      def image_tag source, options = {}
        unless options[:size]
          fs_path = ::Rails.application.assets.find_asset(source).pathname.to_s
          options[:width], options[:height] = ::Dimensions.dimensions(fs_path)
        end
        super
      end

    end

    class Railtie < ::Rails::Railtie
      config.dimensions = ActiveSupport::OrderedOptions.new
      config.dimensions.add_size_by_default = true


      initializer 'dimensions.initialize' do
        ActiveSupport.on_load(:action_view) do
          include ::Dimensions::Rails::Helper
        end
      end
    end
  end
end
