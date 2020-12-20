//
//  RepoViewModel.swift
//  CodeAddict
//
//  Created by Дмитрий on 08/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import Foundation

protocol RepoViewModelProtocol: class {
    var networkService: NetworkServiceProtocol! { get set }
    var repos: [Repo] { get set }
    var totalCount: Int? { get set }
    
    init(networkService: NetworkServiceProtocol)
    var reposDidChanges: ((Bool, Error?) -> Void)? { get set }
    func searchRepo(repoName: String, page: Int, perPage: Int)
}

final class RepoViewModel: RepoViewModelProtocol {
    var reposDidChanges: ((Bool, Error?) -> Void)?
    
    var networkService: NetworkServiceProtocol!
    var repos: [Repo] = [] {
        didSet {
            self.reposDidChanges!(true, nil)
        }
    }
    var totalCount: Int?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func searchRepo(repoName: String, page: Int = 1, perPage: Int = 25) {
        networkService.searchRepo(repoName: repoName, page: page, perPage: perPage) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    if let list = list {
                        self.totalCount = list.totalCount
                        if page == 1 {
                            self.repos = list.items
                        } else {
                            self.repos.append(contentsOf: list.items)
                        }
                    }
                case .failure(let error):
                    self.reposDidChanges!(false, error)
                }
            }
        }
    }
}
