//
//  AppCoordinator.swift
//  PlayAround
//
//  Created by Szymon Swietek on 02/08/2022.
//

import SwiftUI
import UIKit

protocol HasDogApiPrvider {
    var dogsApi: DogsAPIProvider { get }
}

protocol HasOtherDependencyProvider {
    var otherDependency: OtherDependencyProvider { get }
}

struct AppDependency: HasDogApiPrvider, HasOtherDependencyProvider {
    var dogsApi: DogsAPIProvider
    var otherDependency: OtherDependencyProvider
}

@MainActor
class AppCoordinator {
    private var mainNav: UINavigationController!

    private var dependencies: AppDependency!

    func startWith(rootNavController: UINavigationController) {
        mainNav = rootNavController
        dependencies = AppDependency(dogsApi: DogsApi(), otherDependency: OtherDependency())

        let rootViewController = MainViewController(delegate: self)
        mainNav.setViewControllers([rootViewController], animated: false)
    }

    private func pushToRandomDog() {
        let vm = RandomDogViewModel(dependencies: dependencies)
        let vc = RandomDogViewController(viewModel: vm, delegate: self)
        mainNav.pushViewController(vc, animated: true)
    }

    private func pushToSimpleSwiftUI() {
        let vc = UIHostingController(rootView: SimpleSwiftUIView())
        vc.title = "Swift UI"
        mainNav.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: MainViewControllerDelegate {
    func mainViewControllerWantsToShowSwiftUI() {
        pushToSimpleSwiftUI()
    }

    func mainViewControllerWantsToShowRandomDog() {
        pushToRandomDog()
    }
}

extension AppCoordinator: DogsViewControllerDelegate {
    func dogsViewControllerWantsToClose() {
        mainNav.popViewController(animated: true)
    }
}
