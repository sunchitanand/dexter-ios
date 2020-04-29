//
//  TransferService.swift
//  Dexter
//
//  Created by Sunchit Anand on 4/7/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import Foundation
import CoreBluetooth

struct TransferService {
    static let serviceUUID = CBUUID(string: "cd63c727-19a8-492d-a334-b167a53c1c98")
    static let characteristicUUID = CBUUID(string: "4728751f-6a3c-4ea0-bb52-fbe73d3fce67")
}
