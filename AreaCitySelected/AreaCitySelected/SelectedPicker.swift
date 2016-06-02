//
//  SelectedPicker.swift
//  AlamofireSourceCode
//
//  Created by GK on 16/5/31.
//  Copyright © 2016年 GK. All rights reserved.
//

import UIKit

protocol ItemDelegate {
    
    var itemID: Int32 { get }
    var name: String {get set }
    var parentID: Int32{get}
    
}

protocol SelectedPickerDelegate: class {
    
    func loadMidDataArray(item:ItemDelegate) -> [ItemDelegate]?
    func loadLeftDataArray() -> [ItemDelegate]?
    func loadRightDataArray(item:ItemDelegate) -> [ItemDelegate]?

    func selectedPickerArray(itemArray:[ItemDelegate]?);
    
}
@IBDesignable class SelectedPicker: UIView {
    
    @IBOutlet weak var picker: UIPickerView!
    
    private var leftDataArray: Array = [ItemDelegate]()
    private var midDataArray: Array  = [ItemDelegate]()
    private var rightDataArray: Array  = [ItemDelegate]()

    private var selectedLeftItem: ItemDelegate?
    private var selectedMidItem: ItemDelegate?
    private var selectedRightItem: ItemDelegate?

    var selectedArray = [ItemDelegate]()
    
    var rowTitleAttributes: Dictionary<String,AnyObject>?
    
    weak var delegate: SelectedPickerDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SelectedPicker", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        self.addSubview(view)
        
    }
    
}
extension SelectedPicker {
    
    func midItemDataSource() {
        
        guard let leftItem = selectedLeftItem else {
            
            print("左边没有选择")
            return
        }
        
        guard let midData = self.delegate?.loadMidDataArray(leftItem) else {
            print("load 中间数据失败")
            midDataArray.removeAll()
            picker.reloadComponent(1)
            
            return
        }
        
        midDataArray.removeAll()
        
        midDataArray.appendContentsOf(midData)
        
        picker.reloadComponent(1)
        
        guard  let item = midDataArray.first else {
            print("中间数据源为空")
            
            return
        }
        
        if let selectedItem = selectedMidItem where selectedItem.itemID > 0 {
            
            var index = 0
            
            for itemData in midDataArray {
                
                if itemData.itemID == selectedMidItem?.itemID {
                    
                   if let tempIndex = midDataArray.indexOf({ (item) -> Bool in
                        item.itemID == itemData.itemID
                    }){
                        index = tempIndex
                    
                    break
                    }
                }
            }
            picker.selectRow(index, inComponent: 1, animated: true)
            rightItemDataSource()
        } else {
           
            selectedMidItem = item
            selectedRightItem = nil
            
            picker.selectRow(0, inComponent: 1, animated: true)
            rightItemDataSource()
        }
        
    }
    
    func leftItemDataSource() {
        
        for index in 0 ..< selectedArray.count {
            
            switch index {
            case 0:
                selectedLeftItem = selectedArray[0]
            case 1:
                selectedMidItem = selectedArray[1]
            case 2:
                selectedRightItem = selectedArray[2]
            default:
                selectedRightItem = nil
                selectedMidItem = nil
                selectedLeftItem = nil
            }
        }
        
        guard let leftData = self.delegate?.loadLeftDataArray() else {
            print("load 左边数据失败")
            leftDataArray.removeAll()
            picker.reloadComponent(0)

            return
        }
        
        leftDataArray.removeAll()
        
        leftDataArray.appendContentsOf(leftData)
        
        picker.reloadComponent(0)
        
        guard  let item = leftDataArray.first else {
            print("左边数据源为空")
            return
        }
        
        if let selectedItem = selectedLeftItem where selectedItem.itemID > 0 {
            
            var index = 0
            
            for itemData in leftDataArray {
                
                if itemData.itemID == selectedLeftItem?.itemID {
                    
                    if let tempIndex = leftDataArray.indexOf({ (item) -> Bool in
                        item.itemID == itemData.itemID
                    }){
                        index = tempIndex
                        
                        selectedLeftItem?.name = itemData.name
                        
                        break
                    }
                }
            }
            picker.selectRow(index, inComponent: 0, animated: true)
            midItemDataSource()
            
        } else {
            
            selectedLeftItem = item
            selectedMidItem = nil
            
            picker .selectRow(0, inComponent: 1, animated: true)
            midItemDataSource()
        }
    }
    
    func rightItemDataSource() {
        
        guard let midItem = selectedMidItem else {
            
            print("中间没有选择")
            return
        }
        
        guard let rightData = self.delegate?.loadRightDataArray(midItem) else {
            print("load 右边数据失败")
            
            rightDataArray.removeAll()
            picker.reloadComponent(2)
            return
        }
        
        rightDataArray.removeAll()
        
        rightDataArray.appendContentsOf(rightData)
        
        picker.reloadComponent(2)
        
        guard  let item = rightDataArray.first else {
            print("右边数据源为空")
            return
        }
        
        if let selectedItem = selectedRightItem where selectedItem.itemID > 0 {
            
            var index = 0
            
            for itemData in rightDataArray {
                
                if itemData.itemID == selectedRightItem?.itemID {
                    
                    if let tempIndex = rightDataArray.indexOf({ (item) -> Bool in
                        item.itemID == itemData.itemID
                    }){
                        index = tempIndex
                        
                        break
                    }
                }
            }
            picker.selectRow(index, inComponent: 2, animated: true)
        } else {
            
            selectedRightItem = item
            picker.selectRow(0, inComponent: 2, animated: true)
        }
    }
}
extension SelectedPicker: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 3;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return leftDataArray.count
        case 1:
            return midDataArray.count
        case 2:
            return rightDataArray.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var item: ItemDelegate?
        
        switch component {
        case 0:
            item = leftDataArray[row]
        case 1:
            item = midDataArray[row]
        case 2:
            item = rightDataArray[row]
        default:
            item = nil
        }
        
        let label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        
        guard let rowItem = item  where rowItem.itemID > 0 && rowItem.name.characters.count > 0 else {
            return label
        }
        
        let titleAttributes: Dictionary<String,AnyObject> = rowTitleAttributes ?? [NSForegroundColorAttributeName: UIColor(red: 1, green: 0, blue: 0, alpha: 1),NSFontAttributeName: UIFont.systemFontOfSize(18)]

        label.attributedText = NSAttributedString(string: rowItem.name, attributes: titleAttributes)

        return label
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return  bounds.size.width / 3.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            selectedLeftItem = self.leftDataArray[row]
            selectedMidItem = nil
            midItemDataSource()
        case 1:
            selectedMidItem = self.midDataArray[row]
            selectedRightItem = nil
            rightItemDataSource()
        case 2:
            selectedRightItem = self.rightDataArray[row]
        default:
            print("咦，没有选择任何东西")
        }

        selectedPickerView()

    }
    
    func selectedPickerView()  {
        
        selectedArray.removeAll()
        
        if let leftItem = selectedLeftItem {
            selectedArray.append(leftItem)
        }
        if let midItem = selectedMidItem {
            selectedArray.append(midItem)
        }
        if let rightItem = selectedRightItem {
            selectedArray.append(rightItem)
        }
        
        self.delegate?.selectedPickerArray(selectedArray)
    }

}
    
