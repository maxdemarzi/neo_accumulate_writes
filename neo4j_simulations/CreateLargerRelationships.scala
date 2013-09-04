import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import akka.util.duration._
import bootstrap._


class CreateLargerRelationships extends Simulation {
  val httpConf = httpConfig
    .baseURL("http://localhost:9292")

  val nbrNodes = 100000
  val nodesRange = 1 to nbrNodes
  val rnd = new scala.util.Random
  
  val scn = scenario("Create Larger Relationships")
    .repeat(5000) {
      exec(
        http("create larger relationships")
          .post("/larger_rels")
          .param("from", rnd.nextInt(nodesRange.length).toString())
          .param("to", rnd.nextInt(nodesRange.length).toString())
          .check(status.is(200)))
      .pause(0 milliseconds, 5 milliseconds)
  }

  setUp(
    scn.users(10).protocolConfig(httpConf)
  )
}

