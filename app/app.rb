require 'bundler'
Bundler.require

$neo = Neography::Rest.new
$queue = []
$count = 0

# Start and Configure RabbitMQ
connection = Bunny.new
connection.start
PREFETCH=100

# Create Channel
channel = connection.create_channel
channel.prefetch(PREFETCH)

# Configure direct exchange
$exchange = channel.direct("writer")

require 'nyny'
class App < NYNY::App
  
  # Baseline
  
  post '/base' do
    'base'
  end
  
  # Nodes
  post '/node' do
    $neo.create_node
    'node created'
  end  

  post '/unique_node' do
    $count += 1
    $neo.create_unique_node("myindex", "mykey", $count, {})
    'node created'
  end  

  post '/nodes' do
    $queue << [:create_node, {}]
      if $queue.size >= 100
        $neo.batch *$queue
        $queue = []
      end
    'nodes created'
  end  

  post '/larger_nodes' do
    $queue << [:create_node, {}]
      if $queue.size >= 10000
        $neo.batch *$queue
        $queue = []
      end
    'nodes created'
  end  


  post '/unique_nodes' do
    $queue << [:create_unique_node, "myindex", "mykey", $count, {}]
      if $queue.size >= 100
        $neo.batch *$queue
        $queue = []
      end
    'unique nodes created'
  end  

  post '/evented_nodes' do
    message = [:create_node, {}]
    $exchange.publish(message.to_msgpack)
    'node created'
  end  

  post '/evented_accumulated_nodes' do
    $queue << [:create_node, {}]
      if $queue.size >= 100
        $exchange.publish($queue.to_msgpack)
        $queue = []
      end
    'nodes created'
  end  


  # Relationships  
  post '/rel' do
    $neo.create_relationship("friends", params[:from], params[:to])
    'relationship created'
  end  

  post '/rels' do
    $queue << [:create_relationship, "friends", params[:from], params[:to], {}]
      if $queue.size >= 100
        $neo.batch *$queue
        $queue = []
      end
    'relationship created'
  end  

  post '/larger_rels' do
    $queue << [:create_relationship, "friends", params[:from], params[:to], {}]
      if $queue.size >= 10000
        $neo.batch *$queue
        $queue = []
      end
    'relationship created'
  end  

  post '/unique_rel' do    
    $neo.execute_query("START from=node:myindex(mykey={from}), to=node:myindex(mykey={to}) CREATE UNIQUE from -[:friends]-> to", 
                      {:from => params[:from].to_i, :to => params[:to].to_i })
    'unique relationship created'
  end  

  post '/unique_rels' do    
    $queue << [:execute_query, 
               "START from=node:myindex(mykey={from}), to=node:myindex(mykey={to}) CREATE UNIQUE from -[:friends]-> to", 
               {:from => params[:from].to_i, :to => params[:to].to_i }]
      if $queue.size >= 100
        $neo.batch *$queue
        $queue = []
      end
    'unique relationships created'
  end  

  
end

App.run!