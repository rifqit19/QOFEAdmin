//
//  Extentions.swift
//  QOFE
//
//  Created by rifqitriginandri on 05/03/23.
//

import Foundation


extension Double{
    
    var clean: String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
