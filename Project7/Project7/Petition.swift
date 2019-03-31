//
//  Petition.swift
//  Project7
//
//  Created by Allen Whearry on 3/31/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
