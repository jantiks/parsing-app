//
//  Petition.swift
//  project7
//
//  Created by Tigran on 12/1/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
