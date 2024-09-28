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
        
            if isTime{
                print( " is time true")
                print( " showingMessangeAfterTime \(showingMessangeAfterTime)")

                type.text = showingMessangeAfterTime
            }else{
// drop last 20 as is about leapmonth, i do not want to show it
                let modified = dateAndTime.dropLast(20)
                print(" dateAndTime atset up function  \(modified)")
                type.text = String(modified)
            }
                
      //   repeatValueWithInterval.text = " here repeat value "
    }

  

    
}
