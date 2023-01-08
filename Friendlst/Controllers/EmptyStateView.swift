//
//  EmptyStateView.swift
//  Friendlst
//
//  Created by Richie Flores on 1/7/23.
//

import UIKit

class EmptyStateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureEmptyStateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureEmptyStateView()
    }
    
    func configureEmptyStateView() {
        let nib = Bundle.main.loadNibNamed(Constants.CustomViewNames.emptyStateView, owner: self, options: nil)?.first as! UIView
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nib)
    }
}
