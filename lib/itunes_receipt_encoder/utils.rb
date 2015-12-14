##
# ItunesReceiptEncoder
module ItunesReceiptEncoder
  ##
  # ItunesReceiptEncoder::Receipt
  module Utils
    def gmt_time(time)
      time.utc.strftime('%F %T') + ' Etc/GMT'
    end

    def pst_time(time)
      (time + Time.zone_offset('PST'))
        .strftime('%F %T') + ' America/Los_Angeles'
    end

    def ms_time(time)
      (time.to_i * 1000).to_s
    end
  end
end
