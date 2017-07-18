# CryptoWithSwift
Wrapped CommonCrypto(CommonCrypto/CommonCrypto.h) with swift
- Encryption algorithm: AES
- Encryption mode: CBC
- Padding method: PKCS7Padding
- Key length: 256

## Installation
To install CryptoWithSwift, add it as a submodule to your project

## Usage
```swift
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
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

TODO: Write history

## Credits

TODO: Write credits

## License
MIT
