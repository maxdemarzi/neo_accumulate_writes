neo_accumulate_writes
=====================

POC performance improvement of accumulated writes



Instructions:
-------------

Run the app:

    cd app
    bundle install
    rake neo4j:install
    rake neo4j:start
    ruby app.rb

Download and extract Gatling:

    Open a web browser to http://gatling-tool.org/ and download 1.5.2 (zip or tar.gz)
    Extract the file
    Copy the neo4j_simulation folder in this repository to user-files/simulations


Tests:
    run bin/gatling.sh
    Try:   
    Create Node    
    Create Nodes
    Create Relationships
    Create Unique
    etc.
