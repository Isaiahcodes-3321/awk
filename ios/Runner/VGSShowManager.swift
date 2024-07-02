import UIKit
import Flutter
import VGSShowSDK

@objc class VGSShowManager: NSObject {
    private let vgsShow: VGSShow
    private var cardNumberLabel = VGSLabel()
    private var expDateLabel = VGSLabel()

    override init() {
        self.vgsShow = VGSShow(id: "tntpaxvvvet", environment: .sandbox) // Replace <VAULT_ID>
        super.init()
        self.setupLabels()
    }

    private func setupLabels() {
        cardNumberLabel.contentPath = "<CONTENT_PATH_CARD_NUMBER>" // Replace <CONTENT_PATH_CARD_NUMBER>
        expDateLabel.contentPath = "<CONTENT_PATH_EXP_DATE>" // Replace <CONTENT_PATH_EXP_DATE>

        vgsShow.subscribe(cardNumberLabel)
        vgsShow.subscribe(expDateLabel)

        cardNumberLabel.delegate = self
        expDateLabel.delegate = self
    }

    @objc func revealData(cardToken: String) {
        let payload = ["<CONTENT_PATH_CARD_NUMBER>": cardToken, "<CONTENT_PATH_EXP_DATE>": cardToken]

        vgsShow.request(path: "<YOUR_PATH>", method: .post, payload: payload) { (requestResult) in
            switch requestResult {
            case .success(let code):
                print("VGSShow success, code: \(code)")
            case .failure(let code, let error):
                print("VGSShow failed, code: \(code), error: \(error)")
            }
        }
    }
}

extension VGSShowManager: VGSLabelDelegate {
    func labelRevealDataDidFail(_ label: VGSLabel, error: VGSShowError) {
        print("Error \(error) in label with \(label.contentPath)")
    }

    func labelTextDidChange(_ label: VGSLabel) {
        print("Label text changed for \(label.contentPath)")
    }
}
