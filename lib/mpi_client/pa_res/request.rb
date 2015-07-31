module MPIClient
  module PaRes
    class Request < MPIClient::BaseRequest
      PARAMS_MAP = {
        'PARes' => :pa_res,
        'MD'    => :md
      }

      REQUEST_TYPE = 'pares'

      attr_reader :options

      def initialize(options)
        @options = options
        super()
      end

      def process
        Response.parse(post(build_xml))
      end

      private
      def post(xml_request)
        connection.post(xml_request).body
      end

      def build_xml
        xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')

        xml.REQUEST(type: REQUEST_TYPE) do |xml|
          xml.Transaction do |xml|
            PARAMS_MAP.each_pair do |key, value|
              xml.send(key, options[value])
            end
          end
        end

        xml.to_xml
      end
    end
  end
end
