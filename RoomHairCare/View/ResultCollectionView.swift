//
//  ResultView.swift
//  RoomDentist
//
//  Created by LDH on 2021/10/09.
//

import Foundation
import UIKit
import Firebase

class ResultCollectionView: UICollectionViewCell {
    lazy var resultImageView: UIImageView = {
        let resultImageView = UIImageView()
        resultImageView.layer.cornerRadius = 10
        resultImageView.contentMode = .scaleAspectFill
        resultImageView.layer.masksToBounds = true
        return resultImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(self.resultImageView)
        
        self.resultImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(0)
//            $0.size.width.height.equalTo(200)
            $0.size.width.height.equalTo(self.safeAreaLayoutGuide.snp.width)
        }
    }
}
