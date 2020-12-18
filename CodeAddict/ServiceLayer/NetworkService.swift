//
//  NetworkService.swift
//  CodeAddict
//
//  Created by Дмитрий on 07/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func searchRepo(repoName: String, page: Int, perPage: Int, completion: @escaping (Result<RepoListResponse?, Error>) -> Void)
    func getCommits(owner: String, repoTitle: String, completion: @escaping (Result<[Commit]?, Error>) -> Void)
}

extension NetworkServiceProtocol {
    func searchRepo(repoName: String, page: Int, perPage: Int, completion: @escaping (Result<RepoListResponse?, Error>) -> Void) {}
    func getCommits(owner: String, repoTitle: String, completion: @escaping (Result<[Commit]?, Error>) -> Void) {}
}

class NetworkService: NetworkServiceProtocol {
    func searchRepo(repoName: String, page: Int, perPage: Int, completion: @escaping (Result<RepoListResponse?, Error>) -> Void) {
        let correctString = repoName.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://api.github.com/search/repositories?q=\(correctString)&page=\(page)&per_page=\(perPage)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "No support this title", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode(RepoListResponse.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getCommits(owner: String, repoTitle: String, completion: @escaping (Result<[Commit]?, Error>) -> Void) {
        let urlString = "https://api.github.com/repos/\(owner)/\(repoTitle)/commits"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "No support this title", code: 404, userInfo: nil)
            completion(.failure(error))
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                guard let data = data else {
                    let error = NSError(domain: "data not found", code: 404, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                let obj = try JSONDecoder().decode([Commit].self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

