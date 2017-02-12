//
//  style.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/12/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit

extension UIColor {
  public class var odo_blue: UIColor {
    return UIColor(red: 0.02745098039, green: 0.003921568627, blue: 0.1411764706, alpha: 1)
  }
}

extension UIView {
  public var width: CGFloat {
    return self.bounds.width
  }
  
  public var height: CGFloat {
    return self.bounds.height
  }
  
  public var y: CGFloat {
    return self.frame.origin.y
  }
  
  public var x: CGFloat {
    return self.frame.origin.x
  }
}
