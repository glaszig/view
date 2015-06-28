require 'lotus/view/rendering/template_finder'

module Lotus
  module View
    module Rendering
      # Find a partial for the current view context.
      # It's used when a template wants to render a partial.
      #
      # @see Lotus::View::Rendering::Partial
      # @see Lotus::View::Rendering::TemplateFinder
      #
      # @api private
      # @since 0.1.0
      class PartialFinder < TemplateFinder
        # Template file name prefix.
        # By convention a partial file name starts with this prefix.
        #
        # @api private
        # @since 0.1.0
        #
        # @example
        #   "_sidebar.html.erb"
        PREFIX = '_'.freeze

        # Find a template for a partial. Initially it will look for the
        # partial template under the directory of the parent directory 
        # view template, if not found it will search recursivly from 
        # the view root.
        #
        # @return [Lotus::View::Template] the requested template
        #
        # @see Lotus::View::Rendering::TemplateFinder#find
        def find  
          if partial_template_exists_under_view? 
            View::Template.new partial_template_under_view_path
          else
            super
          end
        end

        protected
        def partial_template_exists_under_view?
          File.exists?(partial_template_under_view_path)
        end

        def partial_template_under_view_path
          Dir.glob("#{[root,view_template_dir, template_name].join(separator)}.#{format}.#{engines}").first.to_s 
        end

        def view_template_dir
          *all, last = @view.template.split(separator)
          all.join(separator)
        end

        def template_name
          *all, last = partial_name.split(separator)
          all.push( last.prepend(prefix) ).join(separator)
        end

        def partial_name
          @options[:partial]
        end

        def prefix
          PREFIX
        end
      end
    end
  end
end
