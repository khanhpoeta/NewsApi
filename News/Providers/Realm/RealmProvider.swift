//
//  RealmProvider.swift
//  News
//
//  Created by Kent Nguyen on 9/16/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import RxSwift


enum RealmError: Error {
    case realmIsNotAvailable
}

extension RealmError:LocalizedError{
    var localizedDescription: String{
        get {
            return "Realm is not available"
        }
    }
}

class RealmProvider {
    
    private var mocDBConnectFailed = false
    private let queue:DispatchQueue?
    init(shouldConnectFailed:Bool) {
        self.queue = nil
        mocDBConnectFailed = shouldConnectFailed
    }
    
    init(queue:DispatchQueue? = nil) {
        self.queue = queue
    }
    
    /*
     Get realm object if it available
     */
    
    private lazy var realm:Realm? = {
        if mocDBConnectFailed
        {
            return nil
        }
        do {
            return try Realm.init(configuration: Realm.Configuration.defaultConfiguration, queue: self.queue)
        } catch (let error) {
            return nil
        }
    }()
    
    var isEmpty:Bool{
        get{
            return self.realm?.isEmpty ?? true
        }
    }
    
    
    /*
     realm set db name
     */
    public static func setRealmDB(name:String)
    {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
    }
    
    /*
     realm configuration
     */
    public static func configureRealm(realmPath:String?) {
        
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 15,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                
        },
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                // totalBytes refers to the size of the file on disk in bytes (data + free space)
                // usedBytes refers to the number of bytes used by data in the file
                
                // Compact if the file is less than 70% 'used'
                let compact = (Double(usedBytes) / Double(totalBytes)) < 0.7
                
                return compact
        })
        
        if let _ = realmPath, let url = URL.init(string: realmPath!)
        {
            config.fileURL = url
        }
        // config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func refreshRealm() {
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let defaultParentURL = defaultURL.deletingLastPathComponent()
        let compactedURL = defaultParentURL.appendingPathComponent("default-compact.realm")

        guard FileManager.default.fileExists(atPath: defaultURL.path) else{
            let _ = FileManager.default.createFile(atPath: defaultURL.path, contents: nil, attributes: nil)
            return
        }
        
        do {
            if FileManager.default.fileExists(atPath: compactedURL.path)
            {
                try FileManager.default.removeItem(atPath: compactedURL.path)
            }
            autoreleasepool {
                let realm = try! Realm()
                try! realm.writeCopy(toFile: compactedURL)
            }
            
            try FileManager.default.removeItem(at: defaultURL)
            try FileManager.default.moveItem(at: compactedURL, to: defaultURL)
        }
        catch {
        
        }
    }
    
    /*
     * Returns the same object as the one referenced when the `ThreadSafeReference` was first
     created, but resolved for the current Realm for this thread. Returns `nil` if this object was
     deleted after the reference was created.
     */
    public func resolve<Confined>(_ reference: ThreadSafeReference<Confined>) -> Confined? {
        return realm?.resolve(reference)
    }
    
    /*
     Query realm object by predicate
     */
    func objects<T: RealmBaseEntity>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        return autoreleasepool { () -> Results<T>? in
            guard let realm = self.realm else {
                return nil
            }
            return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
        }
    }
    
    /*
     Get query object by key
     */
    func object<T: RealmBaseEntity>(_ type: T.Type, key: String) -> T? {
        return autoreleasepool { () -> T? in
            guard let realm = self.realm else {
                return nil
            }
            return realm.object(ofType: type, forPrimaryKey: key)
        }
    }
    
    /*
     Update entity if it exits. Create a new one if not
     */
    func save<T: RealmBaseEntity>(_ data: [T])->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    realm.beginWrite()
                    realm.add(data, update: .all)
                    try realm.commitWrite()
                    observer.onNext(true)
                }
                catch (let error){
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
    
    func insert<T: RealmBaseEntity>(_ data: T)->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    realm.beginWrite()
                    realm.add(data)
                    try realm.commitWrite()
                    observer.onNext(true)
                }
                catch (let error){
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Update list of entity if it exits. Create a new one if not
     */
    func save<T: RealmBaseEntity>(_ data: T)->Observable<Bool>  {
        return save([data])
    }
    
    /*
     Save entity with block
     */
    func save<T: RealmBaseEntity>( blockEntity:@escaping ()->T)-> Observable<T>?
    {
        return autoreleasepool { () -> Observable<T>? in
            return Observable<T>.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try realm.write({
                        let entity = blockEntity()
                        realm.add(entity, update: .all)
                        observer.onNext(entity)
                        observer.onCompleted()
                    })
                }
                catch let error as NSError{
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
    
    func create<T: RealmBaseEntity>( blockEntity:@escaping ()->T)-> Observable<T>?
    {
        return autoreleasepool { () -> Observable<T>? in
            return Observable<T>.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try realm.write({
                        let entity = blockEntity()
                        realm.create(T.self, value: entity, update: Realm.UpdatePolicy.all)
                        observer.onNext(entity)
                        observer.onCompleted()
                    })
                }
                catch let error as NSError{
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Save list of entity with block
     */
    func save<T: RealmBaseEntity>( blockEntities:@escaping ()->List<T> )-> Observable<List<T>>?
    {
        return autoreleasepool { () -> Observable<List<T>>? in
            return Observable<List<T>>.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try realm.write({
                        let entities = blockEntities()
                        realm.add(entities, update: .all)
                        observer.onNext(entities)
                        observer.onCompleted()
                    })
                }
                catch let error as NSError{
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Delete list of entity
     */
    func delete<T: RealmBaseEntity>(_ data: [T])->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try? realm.write {
                        realm.delete(data)
                    }
                    observer.onNext(true)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Delete list of entity
     */
    func delete<T: RealmBaseEntity>(_ data: Results<T>)->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try? realm.write {
                        realm.delete(data)
                    }
                    observer.onNext(true)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Delete list of entity
     */
    func delete<T: RealmBaseEntity>(_ data: List<T>)->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try? realm.write {
                        realm.delete(data)
                    }
                    observer.onNext(true)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Save entity with block
     */
    func save(block:@escaping()->Void)->Observable<Bool>{
        return autoreleasepool { () -> Observable<Bool> in
            return Observable<Bool>.create({ (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    realm.beginWrite()
                    block()
                    try realm.commitWrite()
                    observer.onNext(true)
                    observer.onCompleted()
                }
                catch let error as NSError{
                    observer.onError(error)
                }
                return Disposables.create()
            })
        }
    }
    
    /*
     Delete an entity
     */
    func delete<T: RealmBaseEntity>(_ data: T)->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try? realm.write {
                        if let object = self.object(T.self, key: data.id)
                        {
                            realm.delete(object)
                        }
                    }
                    observer.onNext(true)
                }
                return Disposables.create()
            }
        }
    }
    
    /*
     Delete an entity
     */
    func delete<T: RealmBaseEntity>(type: T.Type, key:String)->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try? realm.write {
                        if let object = self.object(T.self, key:key)
                        {
                            realm.delete(object)
                        }
                    }
                    observer.onNext(true)
                }
                return Disposables.create()
            }
        }
    }
    
    func invalidate(){
        guard let realm = self.realm else {
            return
        }
        realm.invalidate()
    }
    
    /*
     Reset database
     */
    func clearAllData()->Observable<Bool> {
        return autoreleasepool { () -> Observable<Bool> in
            return Observable.create { (observer) -> Disposable in
                guard let realm = self.realm else {
                    observer.onError(RealmError.realmIsNotAvailable)
                    return Disposables.create()
                }
                do {
                    try? realm.write {
                        realm.deleteAll()
                    }
                    observer.onNext(true)
                }
                return Disposables.create()
            }
        }
    }
}
