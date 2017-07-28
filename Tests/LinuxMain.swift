#if os(Linux)

import XCTest
@testable import ElasticEmailProviderTests

XCTMain([
    testCase(ElasticEmailProviderTests.allTests),
])

#endif