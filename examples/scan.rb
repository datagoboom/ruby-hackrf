require 'hackrf'

HackRF::Device::Radio.open do |hackrf|
  info = HackRF::Device::Info.new(hackrf)
  puts "Starting HackRF Device"
  puts "Board ID: #{info.board_id}"
  serial_no = info.part_id_and_serial_number.serial_no
  puts "Serial Number: #{serial_no}"
  puts "Version: #{info.version_string}"
  freq = 107.3 * (10 ** 6)
  hackrf.frequency   = freq
  puts "Frequency: #{freq}"
  
  hackrf.sample_rate = 44.8 * (10 ** 3)

  while true
    hackrf.rx do |transfer|
      puts transfer.buffer.dump
    end
    sleep 0.5
  end
end
