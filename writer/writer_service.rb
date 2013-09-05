# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require 'lib/writer'

writer = WriterConsumer.new

# Start Timers
timer_thread = Thread.new do
  loop do
    loop { $timers.wait }
  end
end
timer_thread.abort_on_exception = true

# Start and Configure RabbitMQ
connection = Bunny.new
connection.start
PREFETCH=100

# Create Channel
$channel = connection.create_channel
$channel.prefetch(PREFETCH)

# Configure direct exchange
exchange = $channel.direct("writer")

queue = $channel.queue("write", :durable => true, :auto_delete => false)

queue.bind(exchange).subscribe(:ack => true, :block => true) do |delivery_info, metadata, payload|
  begin
    message = MessagePack.unpack(payload)
    $last = delivery_info.delivery_tag
    if message.first.kind_of?(Array)
      message.each do |m|
        $messages << m
      end
    else
      $messages << message
    end
    $cnt += 1
    
    if $cnt >= MAX_BUFFER
      puts "***********triggered by buffer*********"
      WriterConsumer.process_messages
    end
    
  rescue Exception => e
    $LOG.error $messages.to_s + " could not be written. Error: \n #{e} \n Backtrace:\n #{e.backtrace}"
    # Acknowledge message
    $channel.acknowledge(delivery_info.delivery_tag, false)
    # Requeue the message
    #channel.reject(delivery_info.delivery_tag, true)
  end
end

# Close connection
trap("INT"){ conn.close }