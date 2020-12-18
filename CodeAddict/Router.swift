//
//  Router.swift
//  CodeAddict
//
//  Created by Дмитрий on 08/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(repo: Repo?)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navController = navigationController {
            guard let repoVC = assemblyBuilder?.createRepoModule(router: self) else { return }
            navController.viewControllers = [repoVC]
        }
    }
    
    func showDetail(repo: Repo?) {
        if let navController = navigationController {
            guard let detailVC = assemblyBuilder?.createDetailModule(repo: repo, router: self) else { return }
            detailVC.modalPresentationCapturesStatusBarAppearance = true
            navController.pushViewController(detailVC, animated: true)
        }
    }
    
    func popToRoot() {
        if let navController = navigationController {
            navController.popToRootViewController(animated: true)
        }
    }
}
