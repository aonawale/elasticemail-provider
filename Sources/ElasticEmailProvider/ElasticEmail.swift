import HTTP
import SMTP
import Vapor

public final class ElasticEmail: MailProtocol {
    let clientFactory: ClientFactoryProtocol
    let apiKey: String

    public init(_ clientFactory: ClientFactoryProtocol, apiKey: String) throws {
        self.apiKey = apiKey
        self.clientFactory = clientFactory
    }

    private func build(email: Email) throws -> Node {
        var json = Node([:])
        try json.set("apikey", apiKey)
        try json.set("subject", email.subject)
        try json.set("from", email.from.address)
        try json.set("to", email.to.reduce("", { result, email -> String in
            return result.isEmpty ? email.address : "\(result);\(email.address)"
        }))
        if email.body.type == .html {
            try json.set("bodyHtml", email.body.content)
        } else {
            try json.set("bodyText", email.body.content)
        }
        return json
    }

    public func send(_ emails: [Email]) throws {
        try emails.forEach { email in
            let request = Request(
                method: .post,
                uri: "https://api.elasticemail.com/v2/email/send",
                headers: [
                    "Content-Type": "application/json"
                ]
            )
            request.query = try build(email: email)
            let response = try clientFactory.respond(to: request)
            let success = response.json?["success"]?.bool ?? false
            if !success {
                let error = response.json?["error"]?.string ?? "Unknown Error"
                throw Abort(response.status, reason: error)
            }
        }
    }

}

extension ElasticEmail: ConfigInitializable {
    public convenience init(config: Config) throws {
        guard let elasticemail = config["elasticemail"] else {
            throw ConfigError.missingFile("elasticemail")
        }
        guard let apiKey = elasticemail["apiKey"]?.string else {
            throw ConfigError.missing(key: ["apiKey"], file: "elasticemail", desiredType: String.self)
        }
        let client = try config.resolveClient()
        try self.init(client, apiKey: apiKey)
    }
}
