//
//  RepoViewController.swift
//  CodeAddict
//
//  Created by Дмитрий on 08/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class RepoViewController: UIViewController {

    var viewModel: RepoViewModelProtocol!
    var router: RouterProtocol!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    private var isLoading: Bool = false
    private var page: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpSearchController()
        setUpTableView()
        setUpActivityIndicator()
        prepareViewModelObserver()
    }
    
    //MARK: set up UI
    private func setUpSearchController() {
        self.title = "Search"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: "repoCell")
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        activityIndicator.isHidden = true
    }
    
    private func prepareViewModelObserver() {
        viewModel.reposDidChanges = { [weak self] (finished, error) in
            guard let self = self else { return }
            if let error = error {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                self.errorAlert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                guard let errorAlert = self.errorAlert else { return }
                self.present(errorAlert, animated: true)
                self.isLoading = false
                return
            }
            
            if finished {
                guard let text = self.searchController.searchBar.text, !text.isEmpty, text.count != 0 else { return }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
                self.isLoading = false
            }
        }
    }
    
    
}

extension RepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? RepoTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        let repo = viewModel.repos[indexPath.row]
        if let urlString = repo.ownerAvatarUrl, let avatarURL = URL(string: urlString) {
            cell.userImageView.kf.setImage(with: avatarURL, options: [.cacheMemoryOnly])
        }
        cell.titleLabel.text = repo.name
        if let watchers = repo.watchers {
            cell.subtitleLabel.text = "⭐︎ \(watchers)"
        }
        return cell
    }
}

extension RepoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView()
        clearView.backgroundColor = .white
        
        let textLabel = UILabel()
        textLabel.text = "Repositories"
        textLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        clearView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(18)
            maker.width.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(44)
        }
        
        return clearView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let text = searchController.searchBar.searchTextField.text,
            !text.isEmpty,
            !isLoading,
            let totalCount = viewModel.totalCount else { return }
        
        if totalCount > 25,
            indexPath.row == viewModel.repos.count - 1,
            viewModel.repos.count < totalCount {
            isLoading = true
            page += 1
            viewModel.searchRepo(repoName: text, page: page, perPage: 25)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repo = viewModel.repos[indexPath.row]
        router.showDetail(repo: repo)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard page != 1 else { return }
        page = 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.searchTextField.text, !searchText.isEmpty, searchText.count != 0 else {
            viewModel.repos = []
            tableView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        viewModel.searchRepo(repoName: searchText, page: page, perPage: 25)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
    }
}

