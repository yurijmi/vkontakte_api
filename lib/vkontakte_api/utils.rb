# frozen_string_literal: true

module VkontakteApi
  #
  # An utility module able to flatten arguments (join arrays into comma-separated strings).
  #
  module Utils
    class << self
      # A multiple version of `#flatten_argument`.
      # It transforms a hash flattening each value and keeping the keys untouched.
      # @param [Hash] arguments The arguments to flatten.
      # @return [Hash] Flattened arguments.
      def flatten_arguments(arguments)
        arguments.transform_values do |arg_value|
          flatten_argument(arg_value)
        end
      end

      # If an argument is an array, it will be joined with a comma;
      # otherwise it'll be returned untouched.
      # @param [Object] argument The argument to flatten.
      def flatten_argument(argument)
        if argument.respond_to?(:join)
          # if argument is an array, we join it with a comma
          argument.join(",")
        else
          # otherwise leave it untouched
          argument
        end
      end
    end
  end
end
