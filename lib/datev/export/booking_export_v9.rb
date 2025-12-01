module Datev
  class BookingExportV9 < Export
    self.header_class = BookingHeaderV9
    self.row_class = BookingV9
  end
end
