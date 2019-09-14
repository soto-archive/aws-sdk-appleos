// THIS FILE IS AUTOMATICALLY GENERATED by https://github.com/swift-aws/aws-sdk-swift/blob/master/CodeGenerator/Sources/CodeGenerator/main.swift. DO NOT EDIT.

import Foundation
import AWSSDKSwiftCore
import NIO

public struct KinesisVideo {

    public let client: AWSClient

    public init(accessKeyId: String? = nil, secretAccessKey: String? = nil, sessionToken: String? = nil, region: AWSSDKSwiftCore.Region? = nil, endpoint: String? = nil, middlewares: [AWSServiceMiddleware] = []) {
        self.client = AWSClient(
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey,
            sessionToken: sessionToken,
            region: region,
            service: "kinesisvideo",
            serviceProtocol: ServiceProtocol(type: .restjson),
            apiVersion: "2017-09-30",
            endpoint: endpoint,
            middlewares: middlewares,
            possibleErrorTypes: [KinesisVideoErrorType.self]
        )
    }

    ///  Creates a new Kinesis video stream.  When you create a new stream, Kinesis Video Streams assigns it a version number. When you change the stream's metadata, Kinesis Video Streams updates the version.   CreateStream is an asynchronous operation. For information about how the service works, see How it Works.  You must have permissions for the KinesisVideo:CreateStream action.
    public func createStream(_ input: CreateStreamInput) -> Future<CreateStreamOutput> {
        return client.send(operation: "CreateStream", path: "/createStream", httpMethod: "POST", input: input)
    }

    ///  Deletes a Kinesis video stream and the data contained in the stream.  This method marks the stream for deletion, and makes the data in the stream inaccessible immediately.    To ensure that you have the latest version of the stream before deleting it, you can specify the stream version. Kinesis Video Streams assigns a version to each stream. When you update a stream, Kinesis Video Streams assigns a new version number. To get the latest stream version, use the DescribeStream API.  This operation requires permission for the KinesisVideo:DeleteStream action.
    public func deleteStream(_ input: DeleteStreamInput) -> Future<DeleteStreamOutput> {
        return client.send(operation: "DeleteStream", path: "/deleteStream", httpMethod: "POST", input: input)
    }

    ///  Returns the most current information about the specified stream. You must specify either the StreamName or the StreamARN. 
    public func describeStream(_ input: DescribeStreamInput) -> Future<DescribeStreamOutput> {
        return client.send(operation: "DescribeStream", path: "/describeStream", httpMethod: "POST", input: input)
    }

    ///  Gets an endpoint for a specified stream for either reading or writing. Use this endpoint in your application to read from the specified stream (using the GetMedia or GetMediaForFragmentList operations) or write to it (using the PutMedia operation).   The returned endpoint does not have the API name appended. The client needs to add the API name to the returned endpoint.  In the request, specify the stream either by StreamName or StreamARN.
    public func getDataEndpoint(_ input: GetDataEndpointInput) -> Future<GetDataEndpointOutput> {
        return client.send(operation: "GetDataEndpoint", path: "/getDataEndpoint", httpMethod: "POST", input: input)
    }

    ///  Returns an array of StreamInfo objects. Each object describes a stream. To retrieve only streams that satisfy a specific condition, you can specify a StreamNameCondition. 
    public func listStreams(_ input: ListStreamsInput) -> Future<ListStreamsOutput> {
        return client.send(operation: "ListStreams", path: "/listStreams", httpMethod: "POST", input: input)
    }

    ///  Returns a list of tags associated with the specified stream. In the request, you must specify either the StreamName or the StreamARN. 
    public func listTagsForStream(_ input: ListTagsForStreamInput) -> Future<ListTagsForStreamOutput> {
        return client.send(operation: "ListTagsForStream", path: "/listTagsForStream", httpMethod: "POST", input: input)
    }

    ///  Adds one or more tags to a stream. A tag is a key-value pair (the value is optional) that you can define and assign to AWS resources. If you specify a tag that already exists, the tag value is replaced with the value that you specify in the request. For more information, see Using Cost Allocation Tags in the AWS Billing and Cost Management User Guide.  You must provide either the StreamName or the StreamARN. This operation requires permission for the KinesisVideo:TagStream action. Kinesis video streams support up to 50 tags.
    public func tagStream(_ input: TagStreamInput) -> Future<TagStreamOutput> {
        return client.send(operation: "TagStream", path: "/tagStream", httpMethod: "POST", input: input)
    }

    ///  Removes one or more tags from a stream. In the request, specify only a tag key or keys; don't specify the value. If you specify a tag key that does not exist, it's ignored. In the request, you must provide the StreamName or StreamARN.
    public func untagStream(_ input: UntagStreamInput) -> Future<UntagStreamOutput> {
        return client.send(operation: "UntagStream", path: "/untagStream", httpMethod: "POST", input: input)
    }

    ///   Increases or decreases the stream's data retention period by the value that you specify. To indicate whether you want to increase or decrease the data retention period, specify the Operation parameter in the request body. In the request, you must specify either the StreamName or the StreamARN.   The retention period that you specify replaces the current value.  This operation requires permission for the KinesisVideo:UpdateDataRetention action. Changing the data retention period affects the data in the stream as follows:   If the data retention period is increased, existing data is retained for the new retention period. For example, if the data retention period is increased from one hour to seven hours, all existing data is retained for seven hours.   If the data retention period is decreased, existing data is retained for the new retention period. For example, if the data retention period is decreased from seven hours to one hour, all existing data is retained for one hour, and any data older than one hour is deleted immediately.  
    public func updateDataRetention(_ input: UpdateDataRetentionInput) -> Future<UpdateDataRetentionOutput> {
        return client.send(operation: "UpdateDataRetention", path: "/updateDataRetention", httpMethod: "POST", input: input)
    }

    ///  Updates stream metadata, such as the device name and media type. You must provide the stream name or the Amazon Resource Name (ARN) of the stream. To make sure that you have the latest version of the stream before updating it, you can specify the stream version. Kinesis Video Streams assigns a version to each stream. When you update a stream, Kinesis Video Streams assigns a new version number. To get the latest stream version, use the DescribeStream API.   UpdateStream is an asynchronous operation, and takes time to complete.
    public func updateStream(_ input: UpdateStreamInput) -> Future<UpdateStreamOutput> {
        return client.send(operation: "UpdateStream", path: "/updateStream", httpMethod: "POST", input: input)
    }
}
