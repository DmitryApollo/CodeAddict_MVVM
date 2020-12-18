//
//  Commit.swift
//  CodeAddict
//
//  Created by Дмитрий on 09/12/2020.
//  Copyright © 2020 Дмитрий. All rights reserved.
//

import Foundation

struct Commit: Decodable {
    var message: String?
    
    var name: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case commit

    }
    
    enum AuthorCodingKeys: String, CodingKey {
        case name
        case email
    }
    
    enum CommitCodingKeys: String, CodingKey {
        case message
        case author
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commitContainer = try container.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        
        let authorContainer = try commitContainer.nestedContainer(keyedBy: AuthorCodingKeys.self, forKey: .author)
        self.name = try authorContainer.decode(String?.self, forKey: .name)
        self.email = try authorContainer.decode(String?.self, forKey: .email)
        
        self.message = try commitContainer.decode(String?.self, forKey: .message)
    }
}

