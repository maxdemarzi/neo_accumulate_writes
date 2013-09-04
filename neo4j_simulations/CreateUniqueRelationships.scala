//package request-bodies

import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import akka.util.duration._
import bootstrap._
import util.parsing.json.{JSON, JSONArray}


class CreateUniqueRelationships extends Simulation {
  val httpConf = httpConfig
    .baseURL("http://localhost:9292")

  val nbrNodes = 100000
  val nodesRange = 1 to nbrNodes
  val rnd = new scala.util.Random
  
  val scn = scenario("Create Unique Relationships")
    .repeat(5000) {
      exec(
        http("create Unique relationships")
          .post("/unique_rels")
          .param("from", rnd.nextInt(nodesRange.length).toString())
          .param("to", rnd.nextInt(nodesRange.length).toString())
          .check(status.is(200)))
      .pause(0 milliseconds, 5 milliseconds)
  }

  setUp(
    scn.users(10).protocolConfig(httpConf)
  )
}

