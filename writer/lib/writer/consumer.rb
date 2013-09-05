class WriterConsumer
  
    def self.process_messages
    if !$messages.empty? || self.times_up?
      puts "Batching #{$messages.size} messages at #{Time.now}."
      batch_results = $neo.batch *$messages 
      
      # Acknowledge message
      $channel.acknowledge($last, true)
      self.reset_variables
    end
  end

  def self.reset_variables
    $cnt = 0
    $messages = []  
    $last = nil
    $last_time = Time.now  
    $three_second_timer.reset
  end  
  
  def self.times_up?
    ($last_time + TIME_TO_WAIT) > Time.now
  end  
  
end
