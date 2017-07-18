//
//  ViewController.swift
//  Demo
//
//  Created by iosdev on 2017/07/18.
//  Copyright © 2017年 iosdev. All rights reserved.
//

import UIKit
import CryptoWithSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testText = "Hello. CryptoWithSwfit"
        let key = "D8DDA1ED-BFFC-47E6-8393-2941F8FB0E6D"    //UUID().uuidString
        let iv =  "Rhm9BB36QA8="                            //CryptoWithSwift.generateRandomBytes(byteCount: 8)
        var afterEncryption: String?
        
        // Encryption
        if let retEncryption = CryptoWithSwift.AES256CBCEncryption(target: testText, key: key, iv: iv) {
            print("encryption success: \(retEncryption)")
            afterEncryption = retEncryption
        } else {
            print("encryption failure.")
        }
        
        // Decrypt
        if let encryption = afterEncryption {
            if let retDecrypt = CryptoWithSwift.AES256CBCDecrypt(target: encryption, key: key, iv: iv) {
                print("decrypt success: \(retDecrypt)")
            } else {
                print("decrypt failure.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

