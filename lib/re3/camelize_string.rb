module Re3
  module CamelizeString
    refine String do
      def camelize
        split("_").map(&:capitalize).join
      end
    end
  end
end
