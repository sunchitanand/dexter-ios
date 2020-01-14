//
//  DocumentSerializable.swift
//  Dexter
//
//  Created by Sunchit Anand on 12/28/19.
//  Copyright © 2019 Sunchit Anand. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    /// optional initializer
    init?(documentData: [String: Any])
}
