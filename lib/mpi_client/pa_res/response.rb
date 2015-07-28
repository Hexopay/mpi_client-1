module MPIClient
  module PaRes
    class Response
      attr_reader :xml, :error_code, :error_message, :eci, :xid, :cavv, :cavv_algorithm, :signature

      def initialize(xml)
        @xml = xml
      end

      def successful?
        !(error_message || error_code)
      end

      def parse
        doc = Nokogiri::XML(xml)

        unless (doc.xpath("//Transaction")).empty?
          @eci  = doc.xpath("//Transaction/ECI").text
          @xid  = doc.xpath("//Transaction/XID").text
          @cavv = doc.xpath("//Transaction/CAVV").text
          @cavv_algorithm = doc.xpath("//Transaction/CAVV_ALGORITHM").text
          @signature = doc.xpath("//Transaction/SIGNATURE").text
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
