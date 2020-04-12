//
//  Theme.swift
//  Dexter
//
//  Created by Sunchit Anand on 1/25/20.
//  Copyright © 2020 Sunchit Anand. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    struct Color {
        static let buttonBlue = UIColor.init(red: 7/255, green: 30/255, blue: 125/255, alpha: 1)
        static let switchOnBlue = UIColor.init(red: 131/255, green: 195/255, blue: 255/255, alpha: 1)
        static let title = UIColor.init(red: 40/255, green: 60/255, blue: 79/255, alpha: 1)
        static let greenOn = UIColor.init(red: 147/255, green: 215/255, blue: 174/255, alpha: 1)
        static let redOff = UIColor.init(red: 215/255, green: 147/255, blue: 147/255, alpha: 1)
        static let cardBg = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        
        static let darkBg = UIColor.init(red: 28/255, green: 26/255, blue: 29/255, alpha: 1)
        static let dGreen = UIColor.init(red: 106/255, green: 255/255, blue: 156/255, alpha: 1)
        static let dRed = UIColor(red: 255/255, green: 106/255, blue: 106/255, alpha: 1)
        static let separator = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 0.18)
    }
    
    struct Font {
        static let buttonTitle = "AvenirNext-Bold"
        static let systemDefault = "AvenirNext-DemiBold"
        
        static let sansSerifSemiBold = "SFProDisplay-Semibold"
        static let sansSerifRegular = "SFProDisplay-Regular"
        static let sansSerifMedium = "SFProDisplay-Medium"
        static let sansSerifHeavy = "SFProDisplay-Heavy"
        static let sansSerifRegularItalic = "SFProDisplay-RegularItalic"
        
        static let serifHeavy = "NewYorkMedium-Heavy"
        static let serifSemiBold = "NewYorkExtraLarge-Semibold"
        
    }
    
    static func showFonts() {
        for family: String in UIFont.familyNames {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
}
