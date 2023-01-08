//
//  EmptyStateView.swift
//  Friendlst
//
//  Created by Richie Flores on 1/7/23.
//

import UIKit

class EmptyStateView: UIView {

    @IBOutlet var contentView: EmptyStateView!
    @IBAction func addNewFriendButton(_ sender: Any) {
        print(">>> Adding new friend")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    func initSubViews() {
        let nib = Bundle.main.loadNibNamed(Constants.CustomViewNames.emptyStateView, owner: self, options: nil)![0] as! UIView
        nib.frame = bounds
        addSubview(contentView)
    }
}
