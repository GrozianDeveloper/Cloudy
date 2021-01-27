//
//  AllVcCell.swift
//  TestSecondsVCCloudy
//
//  Created by Bogdan Grozyan on 13.01.2021.
//

import UIKit

class AllVcCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "AllVcCell"

    static func nib() -> UINib {
        return UINib(nibName: "AllVcCell",
                     bundle: nil)
    }
    
    var style = "HelveticaNeue-Light"
    func configure(with location: String) {
        self.label.text = location
        if UserDefaults.standard.bool(forKey: "style") == true {
            style = ".SFProText-Regular"
        }
        label.textColor = .white
        label.font = UIFont(name: style, size: 20)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

