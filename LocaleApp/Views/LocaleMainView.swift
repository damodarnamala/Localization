//
//  LocaleMainView.swift
//  LocaleApp
//
//  Created by Damodar Namala on 08/06/24.
//

import Foundation
import SnapKit
import AppKit

final class LocaleMainView: NSView {
    
    private lazy var stackView: NSStackView = {
        let view = NSStackView()
        view.distribution = .fill
        view.alignment = .centerX
        view.orientation = .vertical
        return view
    }()
    
    private lazy var buttonsStackView: NSStackView = {
        let view = NSStackView()
        view.distribution = .fill
        view.alignment = .centerX
        view.orientation = .horizontal
        return view
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        
        guard let width = NSScreen.main?.frame.width else { return }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.bottom.lessThanOrEqualToSuperview().inset(32)
            make.width.equalTo(width * 0.6)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    func clearViews() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func addArrangedSubview(_ view: NSView) {
        stackView.addArrangedSubview(view)
    }
    
    func addButtons(_ buttons: [NSButton]) {
        buttons.forEach { buttonsStackView.addArrangedSubview($0) }
        stackView.addArrangedSubview(buttonsStackView)
    }
    
    func addTextFields(_ textFields: [NSTextField]) {
        textFields.forEach { stackView.addArrangedSubview($0) }
    }
}

// MARK: - Supporting Types

enum LocaleFormType: Int {
    case add
    case update
    case delete
}

struct LocaleView {
    static func create() -> LocaleViewController {
        let vm = LocaleViewModel()
        return LocaleViewController(viewModel: vm)
    }
}


