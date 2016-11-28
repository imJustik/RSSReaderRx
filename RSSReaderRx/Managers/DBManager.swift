//
//  DBManager.swift
//  RSSReaderRx
//
//  Created by Iliya Kuznetsov on 25.11.16.
//  Copyright © 2016 Iliya Kuznetsov. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

private let _sharedInstance = DBManager()

class DBManager {
    let schemaVersion:UInt64 = 1
    
    class var shared : DBManager {
        return _sharedInstance
    }
    
    var cache = PublishSubject<FindFeedModel>()
    var history: Variable<[FindFeedModel]> = Variable([])
    
    init() {
        _ = cache.asObservable().subscribe(onNext: { feed in
            let cacheModel = CacheFeedModel()
            cacheModel.id = self.getNextId(CacheFeedModel.self)
            cacheModel.url = feed.url
            cacheModel.title = feed.title
            cacheModel.content = feed.content
            self.cacheObject(cacheModel)
        })
        
    }
    
    
    func cacheObject(_ object:Object) { //принимаем сообщения и добавляем их в кеш
        let  configuration = Realm.Configuration(encryptionKey: self.getKey(), schemaVersion: schemaVersion)
        let realm = try! Realm(configuration: configuration)
        try! realm.write {
            realm.add(object)
            print("Записали в Базу")
        }
    }
    
    func loadFeedFromCache(){
        var feeds = [FindFeedModel]()
        let  configuration = Realm.Configuration(encryptionKey: self.getKey(), schemaVersion: schemaVersion)
        let realm = try! Realm(configuration: configuration)
        let savedDB = realm.objects(CacheFeedModel.self)
        if savedDB.count > 0 {
            for db in savedDB {
                feeds.append(FindFeedModel(url: db.url, title: db.title, content: db.content))
            }
        }
        history.value = feeds
    }
}



extension DBManager {
   
    fileprivate func getKey() -> Data {
        let keychainIdentifier = "kuznetsov.realmKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }
        
        var keyData = Data(count: 64)
        
        let result = keyData.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        
        assert(result == 0, "Failed to get random bytes")
        
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: "512" as NSString,
            kSecValueData: NSMutableData(data:keyData)
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData as Data
        
    }
    
    fileprivate func getNextId(_ object: Object.Type) -> Int {
        let  configuration = Realm.Configuration(encryptionKey: self.getKey(), schemaVersion: schemaVersion)
        let realm = try! Realm(configuration: configuration)
        let getNext = realm.objects(object).sorted(byProperty: "id").last
        if getNext != nil {
            let valor = getNext!.value(forKey: "id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
