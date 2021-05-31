//
//  FavoriteViewCell.swift
//  Weather Application
//
//  Created by Rituraj Singh on 5/29/21.
//

import Foundation
import UIKit

class FavoriteViewCell: UITableViewCell {
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var time: UILabel!
}

class StaticViewCell: UITableViewCell {
    @IBOutlet weak var title: UIButton!
}
