//
//  RandomDogViewModelTests.swift
//  PlayAroundTests
//
//  Created by Szymon Swietek on 03/08/2022.
//

import Combine
import Foundation
import XCTest

@testable import PlayAround

@MainActor
class RandomDogViewModelTests: XCTestCase {
    var sut: RandomDogViewModel!

    static let testImages = [UIImage(), UIImage(), UIImage()]
    static var testScenario: TestScenario = .successfulRequest
    var cancellables = Set<AnyCancellable>()

    enum TestScenario {
        case successfulRequest
        case failedRequest
    }

    @MainActor
    override func setUpWithError() throws {
        let dependenciesMock = AppDependency(dogsApi: DogsApiMock(), otherDependency: OtherDependencyMock())
        sut = RandomDogViewModel(dependencies: dependenciesMock)
    }

    func testViewDidLoad() throws {
        Self.testScenario = .successfulRequest
        sut.viewDidLoad()
        XCTAssert(sut.state == .loading)

        try awaitPublisher(sut.$state.collectNext(1))
        XCTAssert(sut.state == .success(images: Self.testImages))
    }

    func testViewDidLoad_v2() throws {
        Self.testScenario = .successfulRequest

        sut.viewDidLoad()
        XCTAssert(sut.state == .loading)

        let expectation = XCTestExpectation(description: "Awaiting publisher")

        sut.$state.dropFirst().sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)

        _ = XCTWaiter.wait(for: [expectation], timeout: 0.5)
        XCTAssert(sut.state == .success(images: Self.testImages))
    }

    func testFailedRequest() throws {
        Self.testScenario = .failedRequest
        sut.viewDidLoad()
        XCTAssert(sut.state == .loading)

        try awaitPublisher(sut.$state.collectNext(1))
        XCTAssert(sut.state == .failure(error: .couldNotLoadImage))
    }
}

private class DogsApiMock: DogsAPIProvider {
    func fetchRandomDogImage() async throws -> UIImage {
        switch await RandomDogViewModelTests.testScenario {
        case .successfulRequest:
            return UIImage()
        case .failedRequest:
            throw CustomError.couldNotLoadImage
        }
    }

    func fetchRandomDogImages(number _: Int) async throws -> [UIImage] {
        switch await RandomDogViewModelTests.testScenario {
        case .successfulRequest:
            return RandomDogViewModelTests.testImages
        case .failedRequest:
            throw CustomError.couldNotLoadImage
        }
    }
}

private class OtherDependencyMock: OtherDependencyProvider {}
