//
//  CommonCrypto.swift
//  MailAssistant
//
//  Created by Dung Vu on 6/30/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import CommonCrypto

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(_ algorithm: CryptoAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0,
                                     count: Int(algorithm.digestLength))
        CCHmac(algorithm.HMACAlgorithm, cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData:NSData = NSData(bytes: result, length: algorithm.digestLength)
        
        
        let hmacBase64 = hmacData.base64EncodedString(options: [])
     
        return hmacBase64
        
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = algorithm.digestLength
//        let result = UnsafeMutablePointer<CUnsignedChar>.init(allocatingCapacity: digestLen)
//        
//        let keyStr = key.cString(using: String.Encoding.utf8)
//        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
//        
//        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
//        
//        let digest = stringFromResult(result: result, length: digestLen)
//        
//        result.deallocateCapacity(digestLen)
//        
//        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return hash as String
    }
    
}


