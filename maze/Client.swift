//
//  Client.swift
//  maze
//
//  Created by 90304395 on 5/7/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SwiftSocket
class Client{
    let ip = "192.168.0.27"
    let client:TCPClient
    let name:String
    
    var cords = [(String, String, String)]()
    init(name: String) {
        self.client = TCPClient(address: ip, port: 2020)
        self.client.connect(timeout: 20)
        self.name = name
    }
    
    func sendCords(x: CGFloat, y: CGFloat){
        let data = self.name+x.description+"/"+y.description
        let size = data.count
        let sizeB = self.int_bytes(num: size)
        self.client.send(data: sizeB)
        self.client.send(string: data)
        
    }
    func reciveCords(){
        guard let sizeB = self.client.read(8, timeout: 5) else { return }
        let size = bytes_int(bytes: sizeB)
        let data = self.client.read(size, timeout: 5)!
        let cord = String(bytes:data, encoding: .utf8)!
        
        var index = 0
        let nums = "1234567890"
        for c in cord{
            if nums.contains(c){
                
                break
            }
            else{
               index+=1
            }
            var r = cord.index(cord.startIndex, offsetBy: index)
            var name = cord[cord.startIndex..<r]
            var index2 = 0
            
            for c in cord{
                if c == "/"{
                    break
                }
                else{
                   index2+=1
                }
            var r = cord.index(cord.startIndex, offsetBy: index)
            var r2 = cord.index(cord.startIndex, offsetBy: index2)
            var x = cord[r..<r2]
            
            r = cord.index(cord.startIndex, offsetBy: index2 + 1)
            var y = cord[r..<cord.endIndex]
            
            var finalData = (String(name), String(x), String(y))
            
            self.cords.append(finalData)
        }
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
