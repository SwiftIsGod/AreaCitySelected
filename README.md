# AreaCitySelected
Swift实现封装PickerView，实现数据的三级联动

示例代码实现省市区三级联动

Xcode 版本: Version 7.3 (7D175)   iOS SDK8.0以上 Swift2.2

1 支持在Storyboard中直接使用

2 支持代码初始化
    
用Storyboard使用方法：

准备工作

需要选择的Item必须遵循协议ItemDelegate

例如Item为城市示例代码

  struct City: ItemDelegate {
    
    var name: String
    var itemID: Int32
    var parentID: Int32
}

1 在ViewController 里面添加引用 ，遵循协议SelectedPickerDelegate   

    @IBOutlet weak var picker: SelectedPicker!
   
2 ViewDidLoad方法中
    
    picker.delegate = self
    picker.leftItemDataSource()
    
3 实现协议方法

   三个数据源方法
   
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
  
  选择之后调用的方法
  
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
    
    


    
