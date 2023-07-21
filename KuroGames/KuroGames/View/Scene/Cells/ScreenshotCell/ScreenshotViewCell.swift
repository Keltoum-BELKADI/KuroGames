//
//  ScreenshotViewCell.swift
//  KuroGames
//
//  Created by Kel_Jellysh on 22/06/2023.
//

import UIKit

class ScreenshotViewCell: UICollectionViewCell {

    @IBOutlet private var screenshotImage: UIImageView?

    override func awakeFromNib(){
        super.awakeFromNib()
       setupUI()
    }

    func setupUI() {
        guard let image = screenshotImage else { return }
        image.layer.cornerRadius = 10
    }

    func setup(screenshot: ShortScreenshot){
        guard let image = screenshotImage else { return }
        guard let imageUrl = screenshot.image else { return }
        image.downloaded(from: imageUrl)
        self.frame.size = CGSize(width: 270, height: 250)
    }

}
