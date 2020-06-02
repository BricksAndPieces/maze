//
//  StartVC.swift
//  maze
//
//  Created by 90307332 on 6/2/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import Foundation
import SpriteKit

class StartVC : UIViewController {
    
    @IBOutlet weak var ipTextBox: UITextField!
    
    @IBAction func createGameClicked(_ sender: UIButton) {
        let server = Server(ip: ipTextBox.text!)
        
        if server.startup {
            server.start()
            
            // idk what to put here
        }
        
    }
    
    @IBAction func joinGameClicked(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipTextBox.text = getWiFiAddress()
        
    }
    
    func goToNextVC() {
        // MAKE STATIC VARS IN SECONDVC SO THAT YOU CAN PASS DATA TO IT
        self.performSegue(withIdentifier: "toSecondVC", sender: nil)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getWiFiAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
}

