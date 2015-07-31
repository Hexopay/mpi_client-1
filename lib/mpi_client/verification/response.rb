module MPIClient
  module Verification
    class Response
      attr_reader :xml, :error_code, :error_message, :status, :url, :md, :acs_url, :pa_req

      def initialize(xml)
        @xml = xml
      end

      def successful?
        !(error_message || error_code)
      end

      def parse
        doc = Nokogiri::XML(xml)

        unless (doc.xpath("//Transaction")).empty?
          @status = doc.xpath("//Transaction").attr('status').value
          @url    = doc.xpath("//Transaction/URL").text
          @md     = doc.xpath("//Transaction/MD").text
          @acs_url= doc.xpath("//Transaction/ACSUrl").text
          @pa_req = doc.xpath("//Transaction/PaReq").text
        else
          get_error(doc)
        end
      end

      def self.parse(xml)
        response = self.new(xml)
        response.parse
        response
      end

      private
      def get_error(doc)
        unless (error = doc.xpath("//Error")).empty?
          @error_message = error.text
          @error_code    = error.attr('code').value
        else
          @error_message = 'Unknown response was received from MPI'
          @error_code    = ''
        end
      end
    end
  end
end
