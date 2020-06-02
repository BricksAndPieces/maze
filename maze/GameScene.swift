//
//  GameScene.swift
//  maze
//
//  Created by 90304395 on 5/6/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let wallSize = 27
    private let scale = 20
    var qwe = SKLabelNode(text:"")
    var h = SKSpriteNode()
    var c = SKSpriteNode()
    var m = SKSpriteNode()
    var s:Server?
    
    var lobby = SKLabelNode()
    
    var nameEntry = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
    var ip = UITextField(frame: CGRect(x: 100, y: 30, width: 200, height: 50))
    
    override func didMove(to view: SKView) {
        
       qwe.position  = CGPoint(x: 0, y: 0)
       addChild(qwe)
        
        h = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        h.addChild(SKLabelNode(text: "host"))
        h.position = CGPoint(x: 200, y: 200)
        h.color = UIColor.blue
        
        c = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        c.addChild(SKLabelNode(text: "client"))
        c.position = CGPoint(x: 100, y: 200)
        c.color = UIColor.red
        addChild(c)
        addChild(h)
        
        
        m = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        m.addChild(SKLabelNode(text: "Start Game!"))
        m.position = CGPoint(x: 0, y: 200)
        m.color = UIColor.red
        
        
        nameEntry.backgroundColor = UIColor.black
        self.view!.addSubview(nameEntry)
        nameEntry.text = "Enter a Unique name"
        nameEntry.textColor = UIColor.white
        
        ip.backgroundColor = UIColor.black
        self.view!.addSubview(ip)
        ip.text = getWiFiAddress()
        ip.textColor = UIColor.white
        
        var directions = SKLabelNode(text: "Server IP in top black box. Current Ip is devices Ip")
        directions.position = CGPoint(x: 0, y: -200)
        addChild(directions)
        
        lobby = SKLabelNode(text: "")
        lobby.position = CGPoint(x: 0, y: 0)
        
        

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var t = touches.first?.location(in: self) as! CGPoint
        
        if h.contains(t){
            
            s = Server(ip: ip.text!)
           
            
            if s!.startup{
                lobby.numberOfLines = 20
                s!.start()
                qwe.removeFromParent()
                nameEntry.removeFromSuperview()
                ip.removeFromSuperview()
                c.removeFromParent()
                h.removeFromParent()
                addChild(lobby)
                var loop = DispatchQueue(label: "lobby", qos:.background, attributes: .concurrent)
                loop.async{
                    while !self.s!.gameStarts{
                        var n = ""
                        for i in self.s!.names{
                            n = n + "\n" + i
                        }
                        self.lobby.text = n
                    }
            }
            var cli = Client(name: nameEntry.text!, ip: ip.text!)
            cli.sendName()
            addChild(m)
            let n = DispatchQueue(label: "recive maze", qos:.userInitiated, attributes: .concurrent)
            
            n.async{
                
                
                var thing = cli.reciveMaze()
                print(thing)
                var scene = gameplay(size: self.size)
                scene.c = cli
                scene.mazeLayout = thing
                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene)
                
                
            }
                    
                
                
            }
            else{
                qwe.text = "Server start up failed"
            }
            
            
            
            
        }
        else if c.contains(t){
            
            
            
            
            
            var cli = Client(name: nameEntry.text!, ip: ip.text!)
            
            if cli.connected{
                cli.sendName()
                qwe.text = "Waiting for the host to start the game"
                h.removeFromParent()
                c.removeFromParent()
                nameEntry.removeFromSuperview()
                ip.removeFromSuperview()
                let n = DispatchQueue(label: "recive maze", qos:.userInitiated, attributes: .concurrent)

                n.async{
                    
                    
                    var thing = cli.reciveMaze()
                    print(thing)
                    var scene = gameplay(size: self.size)
                    scene.c = cli
                    scene.mazeLayout = thing
                    scene.scaleMode = .aspectFit
                    self.view?.presentScene(scene)
                    
                }
                
            }
            else{
                qwe.text = "Failed to connect!"
            }
            
            
            
            
        }
        
        else if m.contains(t){
            nameEntry.removeFromSuperview()
            ip.removeFromSuperview()
            let mazeGen = MazeGenerator()
            let layout = mazeGen.generateMaze(width: wallSize, height: wallSize, centerSize: 3)
            s!.sendMaze(maze: layout)
            s!.gameStarts = true
        }
        
    }
     //function below found on stack overflow by Martin R
    //https://stackoverflow.com/users/1187415/martin-r
    //https://stackoverflow.com/questions/30748480/swift-get-devices-wifi-ip-address?rq=1
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
