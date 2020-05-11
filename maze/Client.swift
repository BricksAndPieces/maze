//
//  Client.swift
//  maze
//
//  Created by 90304395 on 5/7/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SwiftSocket
class Client{
    let ip = "192.168.0.49"
    
    let client:TCPClient
    let name:String
    
    var cords = [(String, String, String)]()
    
    let a = DispatchQueue(label: "accept", qos:.background, attributes: .concurrent)
    
    init(name: String) {
        self.client = TCPClient(address: ip, port: 8009)
        switch self.client.connect(timeout: 20){
        case.success:
            print("suses")
            
        case.failure:
            print("fail")
        }
        self.name = name
        
        a.async {
            while true{
                self.reciveCords()
            }
        }
        
    }
    
    func sendCords(x: CGFloat, y: CGFloat){
        let data = self.name+x.description+"/"+y.description
        print(data)
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
        
        let num = "1234567890"
        var i = 0
        for c in cord{
            if num.contains(c){
                break
            }
            i+=1
        }
        var name = cord[cord.startIndex ..< cord.index(cord.startIndex, offsetBy: i)]
        
        
        var j = 0
        
        for c in cord{
            if c == "/"{
                break
            }
            j+=1
        }
        var x = cord[cord.index(cord.startIndex, offsetBy: i) ..< cord.index(cord.startIndex, offsetBy: j)]
        
        
        var y = cord[cord.index(cord.startIndex, offsetBy: j + 1)..<cord.endIndex]
        
        var final = (String(name), String(x), String(y))
        
        var found = false
        var spot = 0
        for c in self.cords{
            if c.0 == final.0{
                found = true
                self.cords[spot] = final
                break
            }
            spot+=1
        }
        if found == false{
            self.cords.append(final)
        }
        print(self.cords)

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
