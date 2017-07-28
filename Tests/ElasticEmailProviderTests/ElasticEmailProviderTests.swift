import XCTest
import ElasticEmailProvider
import SMTP
@testable import Vapor

class ElasticEmailProviderTests: XCTestCase {
    static let allTests = [
        ("testDroplet", testDroplet),
        ("testSend", testSend),
    ]

    let apiKey = "YOUR_API_KEY" // Set here, but don't commit to git!
    func testDroplet() throws {
        let config: Config = try [
            "droplet": [
                "mail": "elasticemail"
            ],
            "elasticemail": [
                "apiKey": apiKey
            ],
        ].makeNode(in: nil).converted()
        try config.addProvider(Provider.self)
        let drop = try Droplet(config)
        guard let _ = drop.mail as? ElasticEmail else {
            XCTFail("drop.mail is \(drop.mail)")
            return
        }
    }

    func testSend() throws {
        if apiKey == "YOUR_API_KEY" {
            print("*** Not testing ElasticEmail as no API Key is set")
            return
        }
        let config: Config = try [
            "elasticemail": [
                "apiKey": apiKey
            ],
        ].makeNode(in: nil).converted()
        let elasticemail = try ElasticEmail(config: config)
        let email = Email(from: "vapor-elasticemail-from@mailinator.com",
                          to: "vapor-elasticemail@mailinator.com",
                          subject: "Email Subject",
                          body: "Hello Email")

        try elasticemail.send(email)
    }

}
