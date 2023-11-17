module HackRF
  module Internals
    class RegisterArray
      def initialize(device)
        @device = device.ptr
      end
      def [](register)
        value = FFI::MemoryPointer.new(:uint16)
  
        read(register,value)
  
        return value.read_uint16
      end
  
      def []=(register,value)
        write(register,value)
      end
  
      private
      def read(register,value)
  
      end
  
      def write(register,value)
      end
  
    end

    class MAX2837 < RegisterArray

      private
  
      def read(register,value)
        HackRF.hackrf_max2837_read(@device,register,value)
      end
  
      def write(register,value)
        HackRF.hackrf_max2837_write(@device,register,value)
      end
    end

    class Si5351C < RegisterArray

      private
  
      def read(register,value)
        HackRF.hackrf_si5351c_read(@device,register,value)
      end
  
      def write(register,value)
        HackRF.hackrf_si5351c_write(@device,register,value)
      end
  
    end

    class RFFC5071 < RegisterArray

      private
  
      def read(register,value)
        HackRF.hackrf_rffc5071_read(@device,register,value)
      end
  
      def write(register,value)
        HackRF.hackrf_rffc5071_write(@device,register,value)
      end
  
    end

    class SPIFlash
      def initialize(device)
        @device = device
      end
  
      def erase!
        HackRF.hackrf_spiflash_erase(@device)
      end
  
      def write(address,data)
        HackRF.hackrf_spiflash_write(@device,address,data.bytes.length,data)
      end
  
      def read(address,length)
        buffer = FFI::Buffer.new(:uchar,length)
  
        HackRF.hackrf_spiflash_read(@device,address,buffer,length)
  
        return buffer.read_bytes(length)
      end
    end

    class Transfer < FFI::Struct

      layout :device, :pointer,
              :buffer, :pointer,
              :buffer_length, :int,
              :valid_length,  :int,
              :rx_ctx,        :pointer,
              :tx_ctx,        :pointer
  
      def length
        self[:valid_length]
      end
  
      def buffer
        self[:buffer].read_bytes(length)
      end
  
      def buffer=(data)
        if data.size > self[:buffer_length]
          raise(ArgumentError,"data size #{data.size} cannot fit within the buffer")
        end
  
        self[:buffer].write_bytes(data)
        self[:valid_length] = data.size
  
        return data
      end
  
    end
  end
  
end