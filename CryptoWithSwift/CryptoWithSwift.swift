//
//  CryptoWithSwift.swift
//  CryptoWithSwift
//
//  Created by iosdev on 2017/07/18.
//  Copyright © 2017年 iosdev. All rights reserved.
//

import Foundation
import CommonCrypto

public class CryptoWithSwift {
    private static func hexStringToBytes(hexString: String) -> Data? {
        var hex = hexString
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    private static func dataTohexString(data: Data) -> String? {
        var str = ""
        data.enumerateBytes { buffer, index, stop in
            for byte in buffer {
                str.append(String(format:"%02x",byte))
            }
        }
        return str
    }
    
    public static func generateRandomBytes(byteCount: Int = 32) -> String? {
        var keyData = Data(count: byteCount)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, $0)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            return nil
        }
    }
    
    // AEC + KEY(Length 256) + CBC + PKCS7Padding or PKCS5Padding
    public static func AES256CBCEncryption(target: String, key: String, iv: String) -> String? {
        let data = (target as NSString).data(using: String.Encoding.utf8.rawValue) as NSData!
        let dataBytes = UnsafeMutableRawPointer(mutating: data?.bytes)
        let dataLength = size_t(data?.length ?? 0)
        
        let keyData = (key as NSString).data(using: String.Encoding.utf8.rawValue) as NSData!
        let keyBytes = UnsafeMutableRawPointer(mutating: keyData?.bytes)
        
        let ivData = (iv as NSString).data(using: String.Encoding.utf8.rawValue) as NSData!
        let ivBytes = UnsafeMutableRawPointer(mutating: ivData?.bytes)
        
        let keyLength = size_t(kCCKeySizeAES256)
        let cryptData =  NSMutableData(length: (data?.length)! + kCCBlockSizeAES128 )
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength = size_t(cryptData!.length)
        
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  keyBytes, keyLength,
                                  ivBytes,
                                  dataBytes, dataLength,
                                  cryptPointer, cryptLength,
                                  &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData?.length = Int(numBytesEncrypted)
            let convertData = cryptData?.copy()
            let hexString = dataTohexString(data: convertData as! Data)
            return hexString
        }
        return nil
    }
    
    public static func AES256CBCDecrypt(target: String, key: String, iv: String) -> String? {
        let data = hexStringToBytes(hexString: target) as NSData!
        let dataLength = size_t(data?.length ?? 0)
        let dataBytes = UnsafeMutableRawPointer(mutating: data?.bytes)
        
        let keyData = (key as NSString).data(using: String.Encoding.utf8.rawValue) as NSData!
        let keyBytes = UnsafeMutableRawPointer(mutating: keyData?.bytes)
        
        let ivData = (iv as NSString).data(using: String.Encoding.utf8.rawValue) as NSData!
        let ivBytes = UnsafeMutableRawPointer(mutating: ivData?.bytes)
        
        let cryptData = NSMutableData(length: Int(dataLength) + kCCBlockSizeAES128)
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength = size_t(cryptData!.length)
        
        let keyLength = size_t(kCCKeySizeAES256)
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
        let options: CCOptions = UInt32(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  keyBytes, keyLength,
                                  ivBytes,
                                  dataBytes, dataLength,
                                  cryptPointer, cryptLength,
                                  &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData?.length = Int(numBytesEncrypted)
            let convertData = cryptData?.copy()
            let hexString  = String(data: convertData as! Data, encoding: .utf8)
            return hexString
        } else {
            return nil
        }
    }
    
}
