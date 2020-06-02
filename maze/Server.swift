//
//  Server.swift
//  maze
//
//  Created by 90304395 on 5/7/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SwiftSocket

class Server{
    let ip:String
    
    let server:TCPServer
    
    var clients = [TCPClient]()
    
    let a = DispatchQueue(label: "accept", qos:.background, attributes: .concurrent)
    //IP was 192.168.0.49
    var threads = [DispatchQueue]()
    var names = [String]()
    var gameStarts = false
    var startup = false
    init(ip: String="192.168.0.49") {
        self.ip = ip
        self.server = TCPServer(address: ip, port: 8009)
        switch self.server.listen(){
        case .success:
            startup = true
        
        case .failure:
            startup = false
        }
        
        
    }
    
    func start(){
        
        a.async {
            
            while true{
                var client = self.server.accept()!
                self.clients.append(client)
                
                var t = DispatchQueue(label: String(self.threads.count), qos:.userInitiated, attributes: .concurrent)
                if self.gameStarts{
                    break
                }
                self.threads.append(t)
                t.async {
                    while true{
                        self.active(client:client)
                        
                    }
                }
                
            }
    }
    }
    
    func reciveAndSend(client: TCPClient){
        
        guard let data = client.read(8) else { return  }
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
    func active(client:TCPClient){
        if gameStarts{
            reciveAndSend(client: client)
            
        }
        else{
            guard let data = client.read(8, timeout: 1) else { return  }
            var size = bytes_int(bytes: data)
            let data2 = client.read(size)!
            let name = String(bytes:data2, encoding: .utf8)!
            
            self.names.append(name)
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
    func sendMaze(maze: [[Bool]]){
        
        var s = ""
        for r in maze{
            for i in r{
                if i{
                    s = s + "T"
                }
                else{
                    s = s + "F"
                }
            }
            s = s + ";"
        }
        for c in self.clients{
            c.send(data: int_bytes(num: s.count))
            c.send(string: s)
            
        }
    }
}



