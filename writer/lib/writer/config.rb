$neo = Neography::Rest.new
TIME_TO_WAIT=5
MAX_BUFFER=100

# Setup Timers
$timers = Timers.new

# Setup Variables
$cnt = 0
$messages = []
$last = nil
$last_time = Time.now
$three_second_timer = $timers.every(TIME_TO_WAIT) { puts "***********triggered by timer*********" ; WriterConsumer.process_messages }

# Start the log over whenever the log exceeds 100 megabytes in size.  
$LOG = Logger.new('writer.log', 0, 100 * 1024 * 1024) 

