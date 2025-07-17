//
//  ListFoodUseCaseTests.swift
//  OpenFoodTests
//
//  Created by Jonathan Ngabo on 2025-07-17.
//

import XCTest
import Combine
@testable import OpenFood

final class ListFoodUseCaseTests: XCTestCase {
    
    var useCase: ListFoodUseCaseProtocol!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        useCase = ListFoodUseCase(networkManager: mockNetworkManager)
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
    
    
    func testExecuteWithValidFoodList() {
        let currentPage = 0
        let mockFoods = [
            Food(id: 1, name: "Apple", isLiked: true, photoURL: "https://openfood.com/apple.jpg", foodDetails: "A red apple", countryOfOrigin: "US", lastUpdatedDate: "2025-07-17"),
            Food(id: 2, name: "Banana", isLiked: false, photoURL: "https://openfood.com/banana.jpg", foodDetails: "A yellow banana", countryOfOrigin: "EC", lastUpdatedDate: "2025-07-17")
        ]
        let expectedResponse = FoodListResponse(foods: mockFoods, totalCount: 2)
        mockNetworkManager.mockResult = .success(expectedResponse)
        
        let expectation = expectation(description: "Food list should be retrieved successfully")
        var receivedResponse: FoodListResponse?
        var receivedError: NetworkError?
        
        useCase.execute(currentPage: currentPage)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { response in
                    receivedResponse = response
                }
            )
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(receivedResponse)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedResponse?.foodList.count, 2)
        XCTAssertEqual(receivedResponse?.count, 2)
        XCTAssertEqual(receivedResponse?.foodList.first?.name, "Apple")
        XCTAssertEqual(receivedResponse?.foodList.last?.name, "Banana")
        
        let capturedConfig = mockNetworkManager.capturedConfiguration
        XCTAssertNotNil(capturedConfig)
        XCTAssertEqual(capturedConfig?.httpMethod, .get)
        XCTAssertTrue(capturedConfig?.url.contains("food/0") == true)
    }
    
     
}
