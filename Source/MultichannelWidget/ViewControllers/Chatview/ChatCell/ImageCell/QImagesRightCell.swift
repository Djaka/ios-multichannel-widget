//
//  QImagesRightCell.swift
//  BBChat
//
//  Created by qiscus on 14/01/20.
//

#if os(iOS)
import UIKit
#endif
import QiscusCore

class QImagesRightCell: UIBaseChatCell {

    @IBOutlet weak var ivRightBubble: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var ivComment: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var marginLblComment: NSLayoutConstraint!
    @IBOutlet weak var lblStatus: UILabel!
    
    var actionBlock: ((QMessage) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setMenu()
        self.ivComment.isUserInteractionEnabled = true
        let imgTouchEvent = UITapGestureRecognizer(target: self, action: #selector(QImagesRightCell.imageDidTap))
        self.ivComment.addGestureRecognizer(imgTouchEvent)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func present(message: QMessage) {
        self.bindData(message: message)
    }
    
    override func update(message: QMessage) {
        self.bindData(message: message)
    }
    
    func setupBalon(){
        
        self.ivRightBubble.image = self.getBallon()
        self.ivRightBubble.tintColor = ColorConfiguration.rightBubbleColor
        self.ivRightBubble.backgroundColor = ColorConfiguration.rightBubbleColor
        
        self.lblCaption.textColor = ColorConfiguration.rightBubbleTextColor
        self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
        
        self.ivRightBubble.layer.cornerRadius = 5.0
        self.ivRightBubble.clipsToBounds = true
        
        self.ivComment.layer.cornerRadius = 5.0
        self.ivComment.clipsToBounds = true
        
    }
    
    func bindData(message: QMessage) {
        setupBalon()
        status(message: message)
        self.ivComment.image = nil
        self.lblCaption.isHidden = false
        guard let payload = message.payload else { return }
        
        let caption = payload["caption"] as? String
        if (caption ?? "").isEmpty {
            self.marginLblComment.constant = -7
        }
            
        self.lblCaption.text = caption

        if let url = payload["url"] as? String {
            if self.ivComment.image == nil {
                self.ivComment.af.setImage(withURL: URL(string: url)!)
            }
        }
        
        self.lblDate.text = AppUtil.dateToHour(date: message.timestamp)
    }
    
    func status(message: QMessage){
        
        switch message.status {
        case .deleted:
            //            ivStatus.image = UIImage(named: "ic_deleted", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .sending, .pending:
            lblDate.textColor = ColorConfiguration.timeLabelTextColor
            //            ivStatus.tintColor = ColorConfiguration.timeLabelTextColor
            lblDate.text = TextConfiguration.sharedInstance.sendingText
            //            ivStatus.image = UIImage(named: "ic_info_time", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            lblStatus.text = "Sending.."
            lblStatus.textColor = .gray
            break
        case .sent:
            lblDate.textColor = ColorConfiguration.timeLabelTextColor
            //            ivStatus.tintColor = ColorConfiguration.timeLabelTextColor
            //            ivStatus.image = UIImage(named: "ic_sending", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            lblStatus.text = "Sent"
            lblStatus.textColor = .gray
            break
        case .delivered:
            lblDate.textColor = ColorConfiguration.timeLabelTextColor
            //            ivStatus.tintColor = ColorConfiguration.timeLabelTextColor
            //            ivStatus.image = UIImage(named: "ic_read", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            lblStatus.text = "delivered"
            lblStatus.textColor = .gray
            break
        case .read:
            lblDate.textColor = ColorConfiguration.timeLabelTextColor
            //            ivStatus.tintColor = ColorConfiguration.readMessageColor
            //            ivStatus.image = UIImage(named: "ic_read", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            lblStatus.text = "read"
            lblStatus.textColor = .blue
            break
        case . failed:
            lblDate.textColor = ColorConfiguration.failToSendColor
            lblDate.text = TextConfiguration.sharedInstance.failedText
            //            ivStatus.image = UIImage(named: "ic_warning", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            //            ivStatus.tintColor = ColorConfiguration.failToSendColor
            break
        case .deleting:
            //            ivStatus.image = UIImage(named: "ic_deleted", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        }
    }
    
    @objc func imageDidTap() {
        if self.comment != nil && self.actionBlock != nil {
            self.actionBlock!(comment!)
        }
    }
    
}

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
