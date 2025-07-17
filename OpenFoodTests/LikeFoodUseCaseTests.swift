//
//  LikeFoodUseCaseTests.swift
//  OpenFoodTests
//
//  Created by Jonathan Ngabo on 2025-07-17.
//

import XCTest
import Combine
@testable import OpenFood

final class LikeFoodUseCaseTests: XCTestCase {
    
    var useCase: LikeFoodUseCaseProtocol!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        useCase = LikeFoodUseCase(networkManager: mockNetworkManager)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        useCase = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    deinit {
        cancellables.removeAll()
    }
        
    func testExecuteWhenLikingFoodShouldReturnTrue() {
        let foodId = 10
        let isLiked = true
        let expectedResponse = FoodLikeResponse(success: true)
        mockNetworkManager.mockResult = .success(expectedResponse)
        
        let expectation = expectation(description: "Like food should succeed")
        var receivedResult: Bool?
        var receivedError: NetworkError?
        
        useCase.execute(foodId: foodId, isLiked: isLiked)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { result in
                    receivedResult = result
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(receivedResult, true)
        XCTAssertNil(receivedError)
        
        let capturedConfig = mockNetworkManager.capturedConfiguration
        XCTAssertNotNil(capturedConfig)
        XCTAssertEqual(capturedConfig?.httpMethod, .put)
        XCTAssertTrue(capturedConfig?.url.contains("food/10/like") == true)
    }
     
    
     
}

