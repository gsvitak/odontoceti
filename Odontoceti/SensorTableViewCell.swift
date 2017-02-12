//
//  SensorTableViewCell.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/12/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit

protocol SensorTableViewCellDataSource {
  var sensorTitle: String {get}
  var sensorData: NSNumber {get}
  public func startDataCapture
}

class SensorTableViewCell: UITableViewCell {
  
  public class var reuseIdentifier: String {
    return "SensorTableViewCell"
  }
  
  lazy var titleLabel: UILabel = {
    let _titleLabel = UILabel()
    _titleLabel.textColor = .white
    _titleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
    return _titleLabel
  }()
  
  lazy var dataLabel: UILabel = {
    let _dataLabel = UILabel()
    _dataLabel.textColor = .white
    _dataLabel.font = UIFont.systemFont(ofSize: 25.0)
    return _dataLabel
  }()
  
  public var dataSource: SensorTableViewCellDataSource? {
    get {
      fatalError("You cannot read from this object.")
    }
    set {
      self.titleLabel.text = newValue?.sensorTitle
      self.dataLabel.text = newValue?.sensorData.stringValue
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let margin: CGFloat = 20.0
    titleLabel.frame = CGRect(x: margin,
                              y: margin,
                              width: width/2.0 - margin * 2,
                              height: height - margin * 2)
    
    dataLabel.frame = CGRect(x: margin + width / 2.0,
                             y: margin,
                             width: width/2.0 - margin * 2,
                             height: height - margin * 2)
    addSubview(titleLabel)
    addSubview(dataLabel)
    backgroundColor = .clear
  }
}
