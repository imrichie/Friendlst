//
//  EmptyStateView.swift
//  Friendlst
//
//  Created by Richie Flores on 1/7/23.
//

import UIKit

class EmptyStateView: UIView {

    @IBOutlet var contentView: EmptyStateView!
    @IBOutlet weak var addNewFriendButton: UIButton!
    
    @IBAction func addNewFriend(_ sender: Any) {
        print(">>> Adding new friend")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(">>> This empty state view is initialized")
        configureButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureEmptyStateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureEmptyStateView()
    }
    
    func configureEmptyStateView() {
        let nib = Bundle.main.loadNibNamed("EmptyStateView", owner: self, options: nil)?.first as! UIView
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nib)
    }
    
    func configureButton() {
        self.addNewFriendButton.layer.cornerRadius = 10
    }
}
