//
//  SecondVC.swift
//  maze
//
//  Created by 90307332 on 6/2/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import Foundation
import SpriteKit

class SecondVC : UIViewController {
    
    // MAKE STATIC VARS SO THAT YOU CAN PASS DATA FROM STARTVC AND TO GAME
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var playersInLobbyLabel: UILabel!
    
    
    @IBAction func startGameClicked(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is psuedo-code for removing the start game button if the user is not the host
        
        // if client {
            startGameButton.removeFromSuperview()
        //}
    }
    
    func goToNextVC() {
        performSegue(withIdentifier: "toGame", sender: nil)
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
}

