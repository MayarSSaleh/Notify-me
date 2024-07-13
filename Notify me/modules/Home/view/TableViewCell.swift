//
//  TableViewCell.swift
//  Notify me
//
//  Created by mayar on 07/07/2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var repeatValueWithInterval: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(titleOfNotification:String,contentOfNotification:String,isTime:Bool ,isLocation:Bool ,repeatValue:String = "", location:String =  "" ,showingMessangeAfterTime:String = "", dateAndTime: String = "" ){
        
         title.text = titleOfNotification
         content.text = contentOfNotification
        
        if isLocation{
            print( " loacation ")
            type.text = location
        }else {
            if isTime{
                print( " is time true")

                type.text = showingMessangeAfterTime
            }else{
                let modified = dateAndTime.dropLast(20)
                print("m \(modified)")
                type.text = String(modified)
            }
        }
        
       //  repeatValueWithInterval.text = repeatValue
    }

  

    
}
