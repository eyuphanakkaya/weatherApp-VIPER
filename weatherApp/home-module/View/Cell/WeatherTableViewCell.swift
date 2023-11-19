//
//  WeatherTableViewCell.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var humidityImage: UIImageView!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windDirectionImage: UIImageView!
    @IBOutlet weak var windDirectionValueLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedImage: UIImageView!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherValueImage: UIImageView!
    @IBOutlet weak var maxDegreeLabel: UILabel!
    @IBOutlet weak var minDegreeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func style() {
        humidityImage.isHidden = true
        humidityLabel.isHidden = true
        humidityValueLabel.isHidden = true
        windSpeedImage.isHidden = true
        windSpeedLabel.isHidden = true
        windSpeedValueLabel.isHidden = true
        windDirectionImage.isHidden = true
        windDirectionLabel.isHidden = true
        windDirectionValueLabel.isHidden = true
    }

    
}
