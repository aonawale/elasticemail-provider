# ElasticEmail Provider for Vapor

Adds a mail backend for ElasticEmail to the Vapor web framework. Send simple emails.

## Setup

Add the dependency to Package.swift:

```swift
.Package(url: "https://github.com/aonawale/elasticemail-provider.git")
```

## Add a configuration file named elasticemail.json with the following format:

```
{
    "apiKey": "YOUR_API_KEY"
}
```

Register the provider with the configuration system:

```swift
import ElasticEmailProvider

extension Config {
    /// Configure providers
    private func setupProviders() throws {
        ...
        try addProvider(ElasticEmailProvider.Provider.self)
    }
}

```

And finally, change the Droplet's mail implementation by editing droplet.json:

```
{
  "mail": "elasticemail",
  // other configuration keys redacted for brevity
}

```

## Sending simple emails

ElasticEmail can act as a drop-in replacement for Vapor's built-in SMTP support. Simply make use of drop.mail:

```swift
import SMTP

let email = Email(from: …, to: …, subject: …, body: …)
try drop.mail.send(email)
```

Don't forget to import SMTP if you need to work with Email or EmailAddress objects.
