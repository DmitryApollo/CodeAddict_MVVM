//
//  DetailViewModel.swift
//  MVPTest
//
//  Created by Дмитрий on 09/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol: class {
    var commitsDidChanges: ((Bool, Error?) -> Void)? { get set }
    func getCommits(owner: String, repoTitle: String)
}

final class DetailViewModel: DetailViewModelProtocol {
    var commitsDidChanges: ((Bool, Error?) -> Void)?
    
    let networkService: NetworkServiceProtocol!
    var repo: Repo?
    
    var commits: [Commit] = [] {
        didSet {
            self.commitsDidChanges!(true, nil)
        }
    }
    var totalCount: Int?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getCommits(owner: String, repoTitle: String) {
        networkService.getCommits(owner: owner, repoTitle: repoTitle) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let array):
                    if var array = array {
                        if array.count > 3 {
                            array.removeSubrange(3...array.count - 1)
                        }
                        self.commits = array
                    }
                case .failure(let error):
                    self.commitsDidChanges!(false, error)
                }
            }
        }
    }
}
