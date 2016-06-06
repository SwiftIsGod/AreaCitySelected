//
//  AreaCityDataManager.swift
//  AlamofireSourceCode
//
//  Created by GK on 16/6/1.
//  Copyright © 2016年 GK. All rights reserved.
//

import Foundation
import SelectedPicker

struct City: ItemDelegate {
    
    var name: String
    var itemID: Int32
    var parentID: Int32
}

class AreaCityDataManager: NSObject {
    
    static let sharedDataManager = AreaCityDataManager()
    
    var dataBase: COpaquePointer = nil
    
    override init() {
        
        super.init()
        
        let path = NSBundle.mainBundle().pathForResource("CityArea", ofType: "db")
        
        if sqlite3_open(path!, &dataBase) != SQLITE_OK {
            print("Failed to Open database")
        }
    }
    
    
    deinit {
        sqlite3_close(dataBase)
    }
    
    func locationCityWithString(cityString: String) -> City? {
        
        var city: City? = nil
        
        let queryString = "SELECT id, name,parent_id FROM city Where (name like '\(cityString)%%') and parent_id > 0 ORDER BY _id "
        
        var statement :COpaquePointer = nil
        
        if sqlite3_prepare_v2(dataBase, queryString, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let uniqueID = sqlite3_column_int(statement, 0)
                let nameChar = sqlite3_column_text(statement, 1)
                let parentID = sqlite3_column_int(statement, 2)
                
                let nameStr = String.fromCString(UnsafePointer<Int8>(nameChar))
                
                guard let name = nameStr where uniqueID > 0 && parentID > 0 else {
                     continue
                }
                
                city = City(name:name , itemID: uniqueID, parentID: parentID)
                
            }
            
            sqlite3_finalize(statement)
        }
        
        return city
    }
    
    func provinceArray() -> [ItemDelegate] {
        
        var tempArray = [ItemDelegate]()
        
        let queryString = "SELECT id, name ,parent_id FROM city  Where level=0 ORDER BY _id "  //level = 0 一级节点
        
        var statement :COpaquePointer = nil
        
        if sqlite3_prepare_v2(dataBase, queryString, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let uniqueID = sqlite3_column_int(statement, 0)
                let nameChar = sqlite3_column_text(statement, 1)
                let parentID = sqlite3_column_int(statement, 2)

                let nameStr = String.fromCString(UnsafePointer<Int8>(nameChar))
                
                guard let name = nameStr where uniqueID  > 0 else {
                    continue
                }
                
                let city = City(name:name , itemID: uniqueID, parentID:parentID)
                tempArray.append(city)
            }
            
            sqlite3_finalize(statement)
        }
        
        return tempArray
    }
    
    func cityArrayWithProvinceID(cityID: Int32) -> [ItemDelegate] {
        
        var tempArray = [ItemDelegate]()
        
        let queryString = "SELECT id, name,parent_id FROM city Where parent_id=\(cityID) ORDER BY _id "  //level = 0 一级节点
        
        var statement :COpaquePointer = nil
        
        if sqlite3_prepare_v2(dataBase, queryString, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                let uniqueID = sqlite3_column_int(statement, 0)
                let nameChar = sqlite3_column_text(statement, 1)
                let parentID = sqlite3_column_int(statement, 2)
                
                let nameStr = String.fromCString(UnsafePointer<Int8>(nameChar))
                
                guard let name = nameStr where uniqueID  > 0 else {
                    continue
                }
                
                let city = City(name:name , itemID: uniqueID, parentID:parentID)
                tempArray.append(city)
            }
            
            sqlite3_finalize(statement)
        }
        
        return tempArray
    }
}
