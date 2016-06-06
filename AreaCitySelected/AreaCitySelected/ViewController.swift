//
//  ViewController.swift
//  AlamofireSourceCode
//
//  Created by GK on 16/5/31.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit
import SelectedPicker

class ViewController: UIViewController,SelectedPickerDelegate {

    @IBOutlet weak var picker: SelectedPicker!
    
    let dataManager = AreaCityDataManager.sharedDataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        picker.delegate = self
        
        
//        let  city1 = City(name: "台湾", itemID: 710000, parentID: 0)
//        let  city2 = City(name: "台南市", itemID: 710300, parentID: 710000)
//        let  city3 = City(name: "北区", itemID: 710304, parentID: 710300)
//
//        picker.selectedArray.append(city1)
//        picker.selectedArray.append(city2)
//        picker.selectedArray.append(city3)

        picker.leftItemDataSource()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    
    func loadRightDataArray(item: ItemDelegate) -> [ItemDelegate]? {
        
        let tempArray = dataManager.cityArrayWithProvinceID(item.itemID)
        
        if tempArray.count > 0 {
            return tempArray
        }else {
            return nil
        }
    }
    
    func loadLeftDataArray() -> [ItemDelegate]? {
        
        let tempArray = dataManager.provinceArray()
        
        if tempArray.count > 0 {
            return tempArray
        }else {
            return nil
        }
    }
    
    func loadMidDataArray(item: ItemDelegate) -> [ItemDelegate]? {
        
        let tempArray = dataManager.cityArrayWithProvinceID(item.itemID)
        
        if tempArray.count > 0 {
            return tempArray
        }else {
            return nil
        }
    }
    
    func selectedPickerArray(itemArray: [ItemDelegate]?) {
        
        var itemString: String = ""
        
        guard let tempArray = itemArray else {
            
            print("没有选择")
            return
        }
        
        for item in tempArray {
            itemString = itemString + item.name
        }
        
        print(itemString)
    }
}


