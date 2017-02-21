//
//  BAUITableViewCell.swift
//  BuildersAccess
//
//  Created by April on 4/11/16.
//  Copyright © 2016 eloveit. All rights reserved.
//

import UIKit

class BAUITableViewCell: UITableViewCell {
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let v = UIView()
//        self.contentView.addSubview(v)
//        v.backgroundColor =  UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
//        let leadingConstraint = NSLayoutConstraint(item:v,
//                                                   attribute: .LeadingMargin,
//                                                   relatedBy: .Equal,
//                                                   toItem: self.contentView,
//                                                   attribute: .LeadingMargin,
//                                                   multiplier: 1.0,
//                                                   constant: 0);
//        let trailingConstraint = NSLayoutConstraint(item:v,
//                                                    attribute: .TrailingMargin,
//                                                    relatedBy: .Equal,
//                                                    toItem: self.contentView,
//                                                    attribute: .TrailingMargin,
//                                                    multiplier: 1.0,
//                                                    constant: 60);
//        
//        let bottomConstraint = NSLayoutConstraint(item: v,
//                                                  attribute: .BottomMargin,
//                                                  relatedBy: .Equal,
//                                                  toItem: self.contentView,
//                                                  attribute: .BottomMargin,
//                                                  multiplier: 1.0,
//                                                  constant: 3);
//        
//        let heightContraint = NSLayoutConstraint(item: v,
//                                                 attribute: .Height,
//                                                 relatedBy: .Equal,
//                                                 toItem: nil,
//                                                 attribute: .NotAnAttribute,
//                                                 multiplier: 1.0,
//                                                 constant: 1.0 / (UIScreen.mainScreen().scale));
//        v.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activateConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightContraint])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        let v = UIView()
//        self.contentView.addSubview(v)
//        v.backgroundColor =  UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
//        let leadingConstraint = NSLayoutConstraint(item:v,
//                                                   attribute: .LeadingMargin,
//                                                   relatedBy: .Equal,
//                                                   toItem: self.contentView,
//                                                   attribute: .LeadingMargin,
//                                                   multiplier: 1.0,
//                                                   constant: 0);
//        let trailingConstraint = NSLayoutConstraint(item:v,
//                                                    attribute: .TrailingMargin,
//                                                    relatedBy: .Equal,
//                                                    toItem: self.contentView,
//                                                    attribute: .TrailingMargin,
//                                                    multiplier: 1.0,
//                                                    constant: 0);
//        
//        let bottomConstraint = NSLayoutConstraint(item: v,
//                                                  attribute: .BottomMargin,
//                                                  relatedBy: .Equal,
//                                                  toItem: self.contentView,
//                                                  attribute: .BottomMargin,
//                                                  multiplier: 1.0,
//                                                  constant: 0);
//        
//        let heightContraint = NSLayoutConstraint(item: v,
//                                                 attribute: .Height,
//                                                 relatedBy: .Equal,
//                                                 toItem: nil,
//                                                 attribute: .NotAnAttribute,
//                                                 multiplier: 1.0,
//                                                 constant: 1.0 / (UIScreen.mainScreen().scale));
//        v.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activateConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightContraint])
        
    }
}
