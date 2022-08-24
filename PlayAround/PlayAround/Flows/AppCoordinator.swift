//
//  AppCoordinator.swift
//  PlayAround
//
//  Created by Szymon Swietek on 02/08/2022.
//

import UIKit
import SwiftUI

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
    
    var mainNav: UINavigationController!
    
    var dependencies: AppDependency!

    func startWith(rootNavController: UINavigationController) {
        mainNav = rootNavController
        dependencies = AppDependency(dogsApi: DogsApi(), otherDependency: OtherDependency())

        let rootViewController = SnapViewController(delegate: self)
        mainNav.setViewControllers([rootViewController], animated: false)
    }

    func pushToRandomDog() {
        let vm = RandomDogViewModel(dependencies: dependencies)
        let vc = RandomDogViewController(viewModel: vm, delegate: self)
        mainNav.pushViewController(vc, animated: true)
    }
    
    func pushToSimpleSwiftUI() {
        let vc = UIHostingController(rootView: SimpleSwiftUIView())
        mainNav.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: SnapViewControllerDelegate {
    func snapViewControllerWantsToShowSwiftUI() {
        pushToSimpleSwiftUI()
    }
    
    func snapViewControllerWantsToShowRandomDog() {
        pushToRandomDog()
    }
}

extension AppCoordinator: DogsViewControllerDelegate {
    func dogsViewControllerWantsToClose() {
        mainNav.popViewController(animated: true)
    }
}
