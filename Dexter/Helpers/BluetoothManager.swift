//
//  BluetoothManager.swift
//  Dexter
//
//  Created by Sunchit Anand on 4/8/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothManagerDelegate : AnyObject {
    func peripheralsDidUpdate()
}

protocol  BluetoothManager {
    var peripherals: Dictionary<UUID, CBPeripheral> { get }
    var delegate: BluetoothManagerDelegate? { get set }
    func startAdvertising(with name: String)
}

