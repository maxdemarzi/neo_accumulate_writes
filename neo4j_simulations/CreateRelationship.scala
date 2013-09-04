import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import akka.util.duration._
import bootstrap._


class CreateRelationship extends Simulation {
  val httpConf = httpConfig
    .baseURL("http://localhost:9292")

  val nbrNodes = 100000
  val nodesRange = 1 to nbrNodes
  val rnd = new scala.util.Random
  
  val scn = scenario("Create Relationship")
    .repeat(5000) {
      exec(
        http("create relationship")
          .post("/rel")
          .param("from", rnd.nextInt(nodesRange.length).toString())
          .param("to", rnd.nextInt(nodesRange.length).toString())
          .check(status.is(200)))
      .pause(0 milliseconds, 5 milliseconds)
  }

  setUp(
    scn.users(10).protocolConfig(httpConf)
  )
}

