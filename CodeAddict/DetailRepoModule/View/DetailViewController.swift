//
//  DetailViewController.swift
//  CodeAddict
//
//  Created by Дмитрий on 09/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    var router: RouterProtocol!
    
    let imageView = UIImageView()
    let browserView = UIView()
    let tableView = UITableView()
    let shareView = UIView()
    
    let clearView = UIView()
    let userNameLabel = UILabel()
    let starsLabel = UILabel()
    
    let repoTitleLabel = UILabel()
    
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        setUpUI()
        setUpRepo()
        
        setUpTableView()
        setUpActivityIndicator()
        
        prepareViewModelObserver()
        
        guard let owner = viewModel.repo?.ownerName, let repo = viewModel.repo?.name else { return }
        viewModel.getCommits(owner: owner, repoTitle: repo)
    }
    
    private func setUpUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.height.equalTo(248)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        imageView.addSubview(clearView)
        clearView.snp.makeConstraints { (maker) in
            maker.height.equalTo(84)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-20)
        }
        
        let repoByLabel = UILabel()
        repoByLabel.text = "REPO BY"
        repoByLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        repoByLabel.font = UIFont.boldSystemFont(ofSize: 16)
        clearView.addSubview(repoByLabel)
        repoByLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(24)
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        clearView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(repoByLabel.snp.bottom)
        }
        
        starsLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        starsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        clearView.addSubview(starsLabel)
        starsLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(userNameLabel.snp.bottom)
        }
        
        view.addSubview(browserView)
        browserView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottom)
            maker.height.equalTo(64)
        }
        
        browserView.addSubview(repoTitleLabel)
        browserView.backgroundColor = .white
        repoTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        repoTitleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.width.equalTo(view.frame.width/2 - 16)
            maker.bottom.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        let showInBrowserButton = UIButton(type: .system)
        browserView.addSubview(showInBrowserButton)
        showInBrowserButton.addTarget(self, action: #selector(showInBrowserButtonDidTapped), for: .touchUpInside)
        showInBrowserButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        showInBrowserButton.setTitle("VIEW ONLINE", for: .normal)
        showInBrowserButton.layer.cornerRadius = 10
        showInBrowserButton.backgroundColor = .systemGray5
        showInBrowserButton.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-16)
            maker.width.equalTo(view.frame.width/3)
            maker.height.equalTo(26)
            maker.centerY.equalToSuperview()
        }
        
        view.addSubview(shareView)
        shareView.snp.makeConstraints { (maker) in
            maker.height.equalTo(88)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        let shareButton = UIButton(type: .roundedRect)
        shareView.addSubview(shareButton)
        shareButton.layer.cornerRadius = 10
        shareButton.backgroundColor = .systemGray6
        shareButton.setTitle("⏍ Share Repo", for: .normal)
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        shareButton.addTarget(self, action: #selector(shareButtonDidTapped), for: .touchUpInside)
        
        shareButton.snp.makeConstraints { (maker) in
            maker.height.equalTo(56)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.top.equalToSuperview()
        }
    }
    
    private func setUpRepo() {
        repoTitleLabel.text = viewModel.repo?.name
        userNameLabel.text = viewModel.repo?.ownerName
        if let stars = viewModel.repo?.watchers {
            starsLabel.text = "★ \(stars)"
        }
        
        if let urlString = viewModel.repo?.ownerAvatarUrl, let avatarURL = URL(string: urlString) {
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: avatarURL, options: [])
        }
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CommitTableViewCell.self, forCellReuseIdentifier: "commitCell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalTo(browserView.snp.bottom)
            maker.trailing.equalToSuperview()
            maker.bottom.equalTo(shareView.snp.top)
        }
    }
    
    private func setUpActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
    private func prepareViewModelObserver() {
        viewModel.commitsDidChanges = { [weak self] (finished, error) in
            guard let self = self else { return }
            if let error = error {
                self.activityIndicator.removeFromSuperview()
                let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true)
                return
            }
            
            if finished {
                self.activityIndicator.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
        ImageCache.default.clearMemoryCache()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
//            self.navigationController?.navigationBar.topItem?.title = "Search"
        }
    }
    
    @objc func showInBrowserButtonDidTapped() {
        guard let repo = viewModel.repo, let urlString = repo.repoUrl, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func shareButtonDidTapped() {
        guard let url = viewModel.repo?.repoUrl else { return }
        let textToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.airDrop, .postToFacebook]

        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as? CommitTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let commit = viewModel.commits[indexPath.row]
        cell.authorNameLabel.text = commit.name
        cell.emailLabel.text = commit.email
        cell.messageLabel.text = commit.message
        cell.commitNumberLabel.text = "\(indexPath.row + 1)"
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView()
        clearView.backgroundColor = .white
        
        let textLabel = UILabel()
        textLabel.text = "Commits History"
        textLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        clearView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.width.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(44)
        }
        
        return clearView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
