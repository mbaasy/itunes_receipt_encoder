require 'time'

##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::Utils
  module Utils
    ##
    # ItunesReceiptEncoder::Utils::ClassMethods
    module ClassMethods
      private

      def timestamp_writer(*attrs)
        attrs.each do |attr|
          define_method("#{attr}=".to_sym) do |value|
            instance_variable_set "@#{attr}".to_sym, parse_timestamp(value)
          end
        end
      end

      def timestamp_accessor(*attrs)
        attr_reader(*attrs)
        timestamp_writer(*attrs)
      end
    end

    private

    def self.included(base)
      base.extend(ClassMethods)
    end

    def gmt_time(time)
      time && time.utc.strftime('%F %T Etc/GMT')
    end

    def pst_time(time)
      time && (time + Time.zone_offset('PST'))
        .strftime('%F %T America/Los_Angeles')
    end

    def ms_time(time)
      time && time.to_i * 1000
    end

    def asn1_time(time)
      time && time.utc.strftime('%FT%TZ')
    end

    def parse_timestamp(value)
      if value.is_a?(Time)
        value
      elsif value.is_a?(Integer)
        Time.at(value)
      else
        Time.parse(value)
      end
    end
  end
end
