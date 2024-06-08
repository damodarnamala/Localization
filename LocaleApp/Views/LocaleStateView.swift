//
//  LocaleStateView.swift
//  LocaleApp
//
//  Created by Damodar Namala on 08/06/24.
//

import Foundation
import AppKit

final class LocaleStateView: NSView {
    
    private lazy
    var stackView: NSStackView = {
        let view = NSStackView()
        view.distribution = .fill
        view.alignment = .centerX
        view.orientation = .vertical
        return view
    }()
    
    private
    lazy var imageView:  NSImageView  = {
        let iv = NSImageView()
        return iv
    }()
    
    
    private
    lazy var titleText: NSText = {
        let text = NSText()
        text.font = .boldSystemFont(ofSize: 16)
        return text
    }()
    
    private
    lazy var descriptionText: NSText = {
        let text = NSText()
        text.font = .boldSystemFont(ofSize: 12)
        return text
    }()
    
    private
    lazy var suggessionText: NSText = {
        let text = NSText()
        text.font = .boldSystemFont(ofSize: 12)
        return text
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func show(result: LocaleResult) {
        switch result {
        case .success(let s):
            print(s)
        case .error(let fileOperationError):
            let title = fileOperationError.errorMessage.title
            let description = fileOperationError.errorMessage.description
            let suggession = fileOperationError.errorMessage.suggestion
            let image = NSImage(symbolName: "exclamationmark.triangle.fill", variableValue: 2)
            
            [imageView, titleText, descriptionText, suggessionText]
                .forEach{self.stackView.addArrangedSubview($0)}
            // Values
            imageView.image = image
            titleText.string = title
            descriptionText.string = description
            suggessionText.string = suggession
        }
    }
}

extension LocaleStateView {
    enum LocaleResult {
        case success(Success)
        case error(FileOperationError)
        enum Success {
            case addedKey
            case updatedKey
            case deletedKey
        }
    }
}
