//
//  Repo.swift
//  CodeAddict
//
//  Created by Дмитрий on 08/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import Foundation

struct RepoListResponse: Decodable {
    var totalCount: Int?
    let items: [Repo]
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }

}

struct Repo: Decodable {
    var watchers: Int?
    var name: String?
    
    var repoUrl: String?
    
    var ownerAvatarUrl: String?
    var ownerName: String?

    enum CodingKeys: String, CodingKey {
        case watchers
        case name
        case owner
        
        case repoUrl = "html_url"
    }
    
    enum OwnerCodingKeys: String, CodingKey {
        case ownerAvatarUrl = "avatar_url"
        case ownerName = "login"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.watchers = try container.decode(Int?.self, forKey: .watchers)
        self.name = try container.decode(String?.self, forKey: .name)
        
        self.repoUrl = try container.decode(String?.self, forKey: .repoUrl)

        let ownerContainer = try container.nestedContainer(keyedBy: OwnerCodingKeys.self, forKey: .owner)
        self.ownerAvatarUrl = try ownerContainer.decode(String?.self, forKey: .ownerAvatarUrl)
        self.ownerName = try ownerContainer.decode(String?.self, forKey: .ownerName)
    }
}

