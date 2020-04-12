//
//  CoreBluetoothManager.swift
//  Dexter
//
//  Created by Sunchit Anand on 4/8/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import Foundation
import CoreBluetooth

class CoreBluetoothManager: NSObject, BluetoothManager {
    
    // MARK: - Private properties
    private var peripheralManager: CBPeripheralManager?
    private var centralManager: CBCentralManager?
    private var uid: String?
    
    // MARK: - Public properties
    weak var delegate: BluetoothManagerDelegate?
    private(set) var peripherals = Dictionary<UUID, CBPeripheral>() {
        didSet {
            delegate?.peripheralsDidUpdate()
        }
    }
    
    func startAdvertising(with uid: String) {
        self.uid = uid
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension CoreBluetoothManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            if peripheral.isAdvertising {
                peripheral.stopAdvertising()
            }

            var advertisingData: [String : Any] = [
                CBAdvertisementDataServiceUUIDsKey: [TransferService.serviceUUID]
            ]

            if let uid = self.uid {
                advertisingData[CBAdvertisementDataLocalNameKey] = uid
            }
            print("Starting advertising")
            self.peripheralManager?.startAdvertising(advertisingData)
        } else {
            #warning("handle other states")
        }
    }
}

extension CoreBluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {

            if central.isScanning {
                central.stopScan()
            }

            central.scanForPeripherals(withServices: [TransferService.serviceUUID])
        } else {
            #warning("Error handling")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered")
        peripherals[peripheral.identifier] = peripheral
    }
}
