//
//  ModelBuilder.swift
//  MVPTest
//
//  Created by Дмитрий on 30/11/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createRepoModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(repo: Repo?, router: RouterProtocol) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    func createRepoModule(router: RouterProtocol) -> UIViewController {
        let view = RepoViewController()
        let networkService = NetworkService()
        view.viewModel = RepoViewModel(networkService: networkService)
        view.router = router
        return view
    }
    
    func createDetailModule(repo: Repo?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        view.viewModel = DetailViewModel(networkService: networkService)
        view.viewModel.repo = repo
        view.router = router
        return view
    }
}
