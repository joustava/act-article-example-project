const { Verifier } = require("@pact-foundation/pact")
const chai = require("chai")
const chaiAsPromised = require("chai-as-promised")
chai.use(chaiAsPromised)
const { app } = require("../src/service.js")
const path = require("path")

const providerBaseUrl = "http://localhost:8081"

app.listen(8081, () => {
  console.log("Greeting Service listening on " + providerBaseUrl)
})

// Verify that the provider meets all consumer expectations
describe("Pact Verification", () => {
  it("validates the expectations of Greeting Client", () => {
    let opts = {
      provider: "Greeting Provider",
      logLevel: "DEBUG",
      providerBaseUrl: providerBaseUrl,

      // Local pacts as we don't use the broker at this time.
      pactUrls: [
          "/tmp/pacts/greeting_service_client-greeting_provider.json"
      ]
    }

    return new Verifier(opts).verifyProvider().then(output => {
      console.log("Pact Verification Complete!")
      console.log(output)
    }).catch(function(error) {
      console.error(error);
    });
  })
})