//
//  Server.swift
//  maze
//
//  Created by 90304395 on 5/7/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SwiftSocket

class Server{
    let ip = "192.168.0.27"
    let server:TCPServer
    
    var clients = [TCPClient]()
    
    let a = DispatchQueue(label: "accept", qos:.userInteractive, attributes: .concurrent)
    
    var threads = [DispatchQueue]()
    init() {
        self.server = TCPServer(address: ip, port: 2020)
        
    }
    
    func start(){
        a.async {
            while true{
                let client = self.server.accept()!
                self.clients.append(client)
                let t = DispatchQueue(label: String(self.threads.count), qos:.userInteractive, attributes: .concurrent)
                self.threads.append(t)
                t.async {
                    while true{
                        self.reciveAndSend(client: client)
                    }
                }
            }
        }
    }
    
    func reciveAndSend(client: TCPClient){
        guard let data = client.read(8, timeout: 5) else { return  }
        var size = bytes_int(bytes: data)
        let data2 = client.read(size)!
        let cord = String(bytes:data2, encoding: .utf8)!
        
        for c in self.clients{
            var size = cord.count
            let sizeB = int_bytes(num: size)
            c.send(data: sizeB)
            c.send(string: cord)
        }
    }
    
    func int_bytes(num: Int) -> [UInt8]{
        
        let array = withUnsafeBytes(of: num.bigEndian, Array.init)
        return array
    }
    func bytes_int(bytes: [UInt8])-> Int{
        let b = UnsafeRawPointer(bytes).assumingMemoryBound(to: Int.self).pointee.bigEndian
        return b
    }

}
