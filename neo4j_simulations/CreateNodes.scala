import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import akka.util.duration._
import bootstrap._


class CreateNodes extends Simulation {
  val httpConf = httpConfig
    .baseURL("http://localhost:9292")

  val scn = scenario("Create Nodes")
    .repeat(5000) {
    exec(
      http("create nodes")
        .post("/nodes")
        .check(status.is(200)))
      .pause(0 milliseconds, 1 milliseconds)
  }


  setUp(
    scn.users(10).protocolConfig(httpConf)
  )
}

