require 'hackrf/internals'
require 'hackrf/bindings'

require 'ffi'

module HackRF
  module Device
    class Radio
      attr_reader :spiflash, :max2837, :si5351c, :rffc5071, :ptr

      def initialize(ptr)
        @ptr  = ptr
        @mode = nil

        @spiflash = HackRF::Internals::SPIFlash.new(self)
        @max2837  = HackRF::Internals::MAX2837.new(self)
        @si5351c  = HackRF::Internals::Si5351C.new(self)
        @rffc5071 = HackRF::Internals::RFFC5071.new(self)
      end

      def self.open
        ptr = FFI::MemoryPointer.new(:pointer)

        HackRF.hackrf_open(ptr)

        device = new(ptr.read_pointer)

        if block_given?
          yield device
          device.close
        else
          return device
        end
      end

      def self.finalize(device)
        HackRF
      end

      def baseband_filter_bandwidth=(bandwidth)
        HackRF.hackrf_set_baseband_filter_bandwidth(self,bandwidth)
      end
  
      def frequency=(freq)
        HackRF.hackrf_set_freq(self,freq)
      end
  
      alias freq= frequency=
  
      def sample_rate=(rate)
        HackRF.hackrf_set_sample_rate(self,rate)
      end
  
      def amp=(value)
        HackRF.hackrf_set_amp_enable(self,value)
      end
  
      def lna_gain=(gain)
        HackRF.hackrf_set_lna_gain(self,gain)
      end
  
      def vga_gain=(gain)
        HackRF.hackrf_set_vga_gain(self,gain)
      end
  
      def txvga_gain=(gain)
        HackRF.hackrf_set_txvga_gain(self,gain)
      end
  
      def antenna=(value)
        HackRF.hackrf_set_antenna_enable(self,value)
      end
  
      def streaming?
        HackRF.hackrf_is_streaming(self) == :true
      end
  
      def rx(&block)
        @mode = :rx
        @rx_callback = callback(&block)
  
        HackRF.hackrf_start_rx(self,@rx_callback,nil)
  
        @rx_callback = nil
        @mode = nil
      end
  
      def tx(&block)
        @mode = :tx
        @tx_callback = callback(&block)
  
        HackRF.hackrf_start_tx(self,@tx_callback,nil)
  
        @tx_callback = nil
        @mode = nil
      end
  
      def stop
        case @mode
        when :rx then HackRF.hackrf_stop_rx(self)
        when :tx then HackRF.hackrf_stop_tx(self)
        end
      end
  
      def closed?
        @ptr.nil?
      end
  
      def close
        ret = HackRF.hackrf_close(self)
        @ptr = nil
  
        return ret
      end
  
      def to_ptr
        @ptr
      end
  
      private
  
      def callback(&block)
        lambda { |transfer| block.call(Transfer.new(transfer)) }
      end
    end

    class Info
      def initialize(device)
        @device = device.ptr
      end
      def board_id
        ptr = FFI::MemoryPointer.new(:uint8)
  
        HackRF.hackrf_board_id_read(@device,ptr)
  
        return ptr.read_uint8
      end
  
      def version_string
        buffer = FFI::Buffer.new(255)
  
        HackRF.hackrf_version_string_read(@device,buffer,buffer.size)
  
        return buffer.get_string(0)
      end
  
      def part_id_and_serial_number
        part_id_serial_number = PartIDSerialNumber.new
  
        HackRF.hackrf_board_partid_serialno_read(@device,part_id_serial_number)
  
        return part_id_serial_number
      end
    end

    private 

    class PartIDSerialNumber < FFI::Struct

      layout :part_id,   [:uint32, 2],
              :serial_no, [:uint32, 4]
  
      def part_id
        (self[:part_id][0] << 32) | self[:part_id][1]
      end
  
      def serial_no
        (self[:serial_no][0] << (32 * 3)) |
        (self[:serial_no][1] << (32 * 2)) |
        (self[:serial_no][2] << 32)       |
          self[:serial_no][3]
      end
  
    end
  end
end
