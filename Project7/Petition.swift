//
//  Petition.swift
//  Project7
//
//  Created by Daniel O'Leary on 3/6/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
