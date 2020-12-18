//
//  CommitCell.swift
//  CodeAddict
//
//  Created by Дмитрий on 09/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit

class CommitTableViewCell: UITableViewCell {
    
    let mainView = UIView()
    let roundedView = UIImageView()
    let commitNumberLabel = UILabel()
    let authorNameLabel = UILabel()
    let emailLabel = UILabel()
    let messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainView)
        mainView.layer.cornerRadius = 10
        mainView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.leading.equalToSuperview().offset(8)
            maker.trailing.equalToSuperview().offset(-8)
        }
        
        mainView.addSubview(roundedView)
        mainView.addSubview(authorNameLabel)
        mainView.addSubview(emailLabel)
        mainView.addSubview(messageLabel)
        
        roundedView.layer.cornerRadius = 20
        roundedView.backgroundColor = .systemGray6
        
        roundedView.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.leading.equalToSuperview().offset(12)
            maker.centerY.equalToSuperview()
        }
        
        roundedView.addSubview(commitNumberLabel)
        commitNumberLabel.textAlignment = .center
        commitNumberLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        authorNameLabel.font = UIFont.systemFont(ofSize: 14)
        authorNameLabel.textColor = .systemBlue
        authorNameLabel.adjustsFontSizeToFitWidth = false
        authorNameLabel.lineBreakMode = .byTruncatingTail
        
        authorNameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(roundedView.snp.trailing).offset(16)
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(4)
        }
        
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.lineBreakMode = .byTruncatingTail
        emailLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(roundedView.snp.trailing).offset(16)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(authorNameLabel.snp.bottom).offset(2)
        }
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textColor = .systemGray2
        
        messageLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(emailLabel.snp.bottom).offset(4)
            maker.leading.equalTo(roundedView.snp.trailing).offset(16)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorNameLabel.text = ""
        emailLabel.text = ""
        messageLabel.text = ""
    }
}
