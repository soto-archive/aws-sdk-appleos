# AWSSDK AppleOS

Version of the AWS SDK for the Swift programming language that supports Apple platforms (including iOS) as first class citizens.

[<img src="http://img.shields.io/badge/swift-5.0-brightgreen.svg" alt="Swift 5.0" />](https://swift.org)
[<img src="https://travis-ci.org/swift-aws/aws-sdk-appleos.svg?branch=master">](https://travis-ci.org/swift-aws/aws-sdk-appleos)


## Supported Platforms and Swift Versions

| **Platform** | **Version** |
|---|:---:|
|**iOS**        | v12.2 |
|**macOS** | v10.14 |
|**tvOS** | v12.2 |

## Documentation

Visit the `aws-sdk-swift` [documentation](http://htmlpreview.github.io/?https://github.com/swift-aws/aws-sdk-swift/gh-pages/index.html) for instructions and browsing api references.

## Installation

### Swift Package Manager

AWS SDK Apple OS uses the Swift Package manager. It is recommended you create a swift package that only includes the AWS services you are interested in. The easiest method to do this is create an empty folder, enter this folder and type ```swift package init```. This will create a Package.swift file. Add the services you are using in the dependency list for your target in the Package.swift file. See below for an example. Make sure you add the line indicating the platforms you are targetting. In future versions of XCode it will be possible to include Swift Package files directly into your project. In the meantime the method to add aws-sdk-appleos into your project is as follows.
- Create an xcodeproj file. Run ```swift package generate-xcodeproj``` in the same folder as your Package.swift file.
- Open your project and add the generated xcodeproj in to your project.
- Include the framework for the services you require in the Embedded Binaries for the project.

Example Package.swift

```swift
import PackageDescription

let package = Package(
    name: "MyAWSLib",
    platforms: [.iOS("12.2"), .macOS(.v10_14)],
    dependencies: [
        .package(url: "https://github.com/swift-aws/aws-sdk-appleos.git", from: "0.1.0")
    ],
    targets: [
      .target(
          name: "MyAWSLib",
          dependencies: ["S3", "SES", "CloudFront", "ELBV2", "IAM", "Kinesis"]),
      .testTarget(
          name: "MyAWSToolTests",
          dependencies: ["MyAWSLib"]),
    ]
)
```

### Carthage
Not supported yet

### Cocoapods
Not supported yet

## Contributing

All developers should feel welcome and encouraged to contribute to `aws-sdk-swift`. 

As contributors and maintainers of this project, and in the interest of fostering an open and welcoming community, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.

To contribute a feature or idea to `aws-sdk-swift`, submit an issue and fill in the template. If the request is approved, you or one of the members of the community can start working on it. It is prefereable that pull requests are made in the original swift repositories and not the appleos versions of the code. If you have a change that is specific to apple OS then make a pull request to the appleos branch in repositories `aws-sdk-swift` or `aws-sdk-swift-core`.  

If you find a bug, please submit a pull request with a failing test case displaying the bug or create an issue.

If you find a security vulnerability, please contact <yuki@miketokyo.com> and reach out on the [**#aws** channel on the Vapor Discord](https://discordapp.com/channels/431917998102675485/472522745067077632) as soon as possible. We take these matters seriously.

## Configuring Credentials

Before using the SDK, ensure that you've configured credentials.

### Pass the Credentials to the AWS Service struct directly

All of the AWS Services's initializers accept `accessKeyId` and `secretAccessKey`

```swift
let ec2 = EC2(
    accessKeyId: "YOUR_AWS_ACCESS_KEY_ID",
    secretAccessKey: "YOUR_AWS_SECRET_ACCESS_KEY"
)
```

## Using the `aws-sdk-swift`

AWS Swift Modules can be imported into any swift project. Each module provides a struct that can be initialized, with instance methods to call aws services. See [documentation](http://htmlpreview.github.io/?https://github.com/swift-aws/aws-sdk-swift/gh-pages/index.html) for details on specific services.

The underlying aws-sdk-swift httpclient returns a [swift-nio EventLoopFuture object](https://apple.github.io/swift-nio/docs/current/NIO/Classes/EventLoopFuture.html). An EvenLoopFuture _is not_ the response, but rather a container object that will be populated with the response sometime later. In this manner calls to aws do not block the main thread.

However, operations that require inspection or use of the response require code to be written in a slightly different manner that equivalent synchronous logic. There are numerous references available online to aid in understanding this concept.

The recommended manner to interact with futures is chaining.

```swift
import S3 //ensure this module is specified as a dependency in your package.swift
import NIO

do {
    let bucket = "my-bucket"

    let s3 = S3(
        accessKeyId: "Your-Access-Key",
        secretAccessKey: "Your-Secret-Key",
        region: .uswest2
    )

    // Create Bucket, Put an Object, Get the Object
    let createBucketRequest = S3.CreateBucketRequest(bucket: bucket)

    try s3.createBucket(createBucketRequest).thenThrowing { response -> Future<S3.PutObjectOutput> in
        // Upload text file to the s3
        let bodyData = "hello world".data(using: .utf8)!
        let putObjectRequest = S3.PutObjectRequest(acl: .publicRead, bucket: bucket, contentLength: Int64(bodyData.count), body: bodyData, key: "hello.txt")
        return try s3.putObject(putObjectRequest)
    }.thenThrowing { response -> Future<S3.GetObjectOutput> in
        let getObjectRequest = S3.GetObjectRequest(bucket: bucket, key: "hello.txt")
        return try s3.getObject(getObjectRequest)
    }.whenSuccess { futureResponse in
        futureResponse.whenSuccess { response in
          if let body = response.body {
              print(String(data: body, encoding: .utf8))
          }
        }
    }
} catch {
    print(error)
}
```

Or you can use the nested method


```swift
import S3 //ensure this module is specified as a dependency in your package.swift

do {
    let bucket = "my-bucket"

    let s3 = S3(
        accessKeyId: "Your-Access-Key",
        secretAccessKey: "Your-Secret-Key",
        region: .uswest1
    )

    // Create Bucket, Put an Object, Get the Object
    let createBucketRequest = S3.CreateBucketRequest(bucket: bucket)

    try s3.createBucket(createBucketRequest).whenSuccess { response in
        do {
            let bodyData = "hello world".data(using: .utf8)!
            let putObjectRequest = S3.PutObjectRequest(acl: .publicRead, key: "hello.txt", body: bodyData, contentLength: Int64(bodyData.count), bucket: bucket)

            try s3.putObject(putObjectRequest).whenSuccess { response in
                do {
                    let getObjectRequest = S3.GetObjectRequest(bucket: bucket, key: "hello.txt")
                    try s3.getObject(getObjectRequest).whenSuccess { response in
                        if let body = response.body {
                            print(String(data: body, encoding: .utf8))
                        }
                    }
                } catch { print(error) }
            }

        } catch { print(error) }
     }
} catch { print(error) }
```
## Speed Up Compilation

By specifying only those modules necessary for your application, only those modules will compile which makes for fast compilation.

If you want to create a module for your service, you can try using the module-exporter to build a separate repo for any of the modules.

## License
`aws-sdk-swift` is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). See LICENSE for details.
