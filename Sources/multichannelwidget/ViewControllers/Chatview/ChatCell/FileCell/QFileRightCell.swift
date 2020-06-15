//
//  QFileRightCell.swift
//  BBChat
//
//  Created by qiscus on 27/01/20.
//

import UIKit
import QiscusCoreApi

class QFileRightCell: UIBaseChatCell {

    @IBOutlet weak var lblExtension: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblFilename: UILabel!
    @IBOutlet weak var ivRightBubble: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setMenu()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.setMenu()
    }
    
    override func present(message: CommentModel) {
        self.bind(message: message)
    }
    
    override func update(message: CommentModel) {
        self.bind(message: message)
    }
    
    func setupBubble() {
        self.ivRightBubble.image = self.getBallon()
        self.ivRightBubble.tintColor = ColorConfiguration.rightBubbleColor
        self.ivRightBubble.backgroundColor = ColorConfiguration.rightBubbleColor
        
        self.lblFilename.textColor = ColorConfiguration.rightBubbleTextColor
        self.lblExtension.textColor = ColorConfiguration.rightBubbleTextColor
        self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
        
        self.ivRightBubble.layer.cornerRadius = 5.0
        self.ivRightBubble.clipsToBounds = true
    }
    
    func bind(message: CommentModel) {
        self.setupBubble()
        self.status(message: message)
        
        guard let payload = message.payload else { return }
        
        self.ivIcon.image = UIImage(named: "ic_file_white", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
        let url = payload["url"] as? String
        
        self.lblFilename.text = payload["file_name"] as? String
        self.lblDate.text = AppUtil.dateToHour(date: message.date())
        self.lblExtension.text = ("\(message.fileExtension(fromURL: url!)) file")
    }
    
    func status(message: CommentModel){
        
        switch message.status {
        case .deleted:
            self.ivStatus.image = UIImage(named: "ic_deleted", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .sending, .pending:
            self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
            self.ivStatus.tintColor = ColorConfiguration.sentOrDeliveredColor
            self.lblDate.text = TextConfiguration.sharedInstance.sendingText
            self.ivStatus.image = UIImage(named: "ic_info_time", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .sent:
            self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
            self.ivStatus.tintColor = ColorConfiguration.sentOrDeliveredColor
            self.ivStatus.image = UIImage(named: "ic_sending", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .delivered:
            self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
            self.ivStatus.tintColor = ColorConfiguration.sentOrDeliveredColor
            self.ivStatus.image = UIImage(named: "ic_read", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case .read:
            self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
            self.ivStatus.tintColor = ColorConfiguration.readMessageColor
            self.ivStatus.image = UIImage(named: "ic_read", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            break
        case . failed:
            self.lblDate.textColor = ColorConfiguration.timeLabelTextColor
            self.lblDate.text = TextConfiguration.sharedInstance.failedText
            self.ivStatus.image = UIImage(named: "ic_warning", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            self.ivStatus.tintColor = ColorConfiguration.failToSendColor
            break
        case .deleting:
            self.ivStatus.image = UIImage(named: "ic_deleted", in: MultichannelWidget.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            
            break
        }
    }
    
}
