import SnapKit
import AppKit
import Combine

final class LocaleViewController: NSViewController {
    private var viewModel: LocaleViewModelProtocol
    private var bag = Set<AnyCancellable>()
    
    private lazy var segmentedControl: NSSegmentedControl = {
        let control = NSSegmentedControl(labels: [strings.common.segment.segmentAddNewKeyTitle,
                                                  strings.common.segment.segmentUpdateTitle,
                                                  strings.common.segment.segmentDeleteTitle],
                                         trackingMode: .selectOne,
                                         target: self,
                                         action: #selector(segmentAction(_:)))
        return control
    }()
    
    private let strings = StringConfiguration()
    
    private lazy var selectFolderButton: NSButton = makeButton(title: strings.common.buttonTile.selectFolder, action: #selector(buttonActionSelectPath))
    private lazy var sortStringsButton: NSButton = makeButton(title: strings.common.buttonTile.sortButtonTitle, action: #selector(sort))
    private lazy var localeActionButton: NSButton = makeButton(action: #selector(buttonActionLocaleAction))
    private lazy var inputKeyTextField: NSTextField = makeTextField(placeholder: strings.common.placeholder.addKeyPlaceholderText)
    private lazy var inputValueTextField: NSTextField = makeTextField(placeholder: strings.common.placeholder.addValuePlaceholderText)
    
    private lazy var mainView = LocaleMainView()
    
    init(viewModel: LocaleViewModelProtocol = LocaleViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegment = 0
        setupBindings()
        refreshView()
    }
    
    private func setupBindings() {
        inputKeyTextField.textPublisher()
            .sink { [weak self] text in
                self?.viewModel.keyText = text
            }
            .store(in: &bag)
        
        inputValueTextField.textPublisher()
            .sink { [weak self] text in
                self?.viewModel.valueText = text
            }
            .store(in: &bag)
        
        viewModel.pathSelectionSubject
            .sink { [weak self] _ in
                self?.refreshView()
            }
            .store(in: &bag)
    }
    
    private func refreshView() {
        mainView.clearViews()
        if viewModel.checkPathSaved() {
            mainView.addArrangedSubview(segmentedControl)
            setupFormView()
            mainView.addButtons([localeActionButton, selectFolderButton, sortStringsButton])
        } else {
            mainView.addArrangedSubview(selectFolderButton)
        }
    }
    
    private func setupFormView() {
        switch LocaleFormType(rawValue: segmentedControl.selectedSegment) ?? .add {
        case .add:
            setupAddView()
        case .update:
            setupUpdateView()
        case .delete:
            setupDeleteView()
        }
    }
    
    private func setupAddView() {
        inputKeyTextField.placeholderString = strings.common.placeholder.addKeyPlaceholderText
        inputValueTextField.placeholderString = strings.common.placeholder.addValuePlaceholderText
        localeActionButton.title = strings.common.buttonTile.addActionButtonTitle
        mainView.addTextFields([inputKeyTextField, inputValueTextField])
    }
    
    private func setupUpdateView() {
        inputKeyTextField.placeholderString = strings.common.placeholder.updateKeyPlaceholderText
        inputValueTextField.placeholderString = strings.common.placeholder.updateValuePlaceholderText
        localeActionButton.title = strings.common.buttonTile.updateActionButtonTitle
        mainView.addTextFields([inputKeyTextField, inputValueTextField])
    }
    
    private func setupDeleteView() {
        inputKeyTextField.placeholderString = strings.common.placeholder.updateKeyPlaceholderText
        localeActionButton.title = strings.common.buttonTile.deleteActionButtonTitle
        mainView.addArrangedSubview(inputKeyTextField)
    }
    
    @objc private func buttonActionSelectPath(_ sender: NSButton) {
        viewModel.selectPath()
    }
    
    @objc private func sort(_ sender: NSButton) {
         viewModel.sort()
            .sink(receiveCompletion: handleError(_:), receiveValue: {})
            .store(in: &bag)
    }
    
    @objc private func buttonActionLocaleAction(_ sender: NSButton) {
        let action: AnyPublisher<Void, FileOperationError>
        switch LocaleFormType(rawValue: segmentedControl.selectedSegment) ?? .add {
        case .add:
            action = viewModel.addKeyValue()
        case .delete:
            action = viewModel.deleteKey()
        case .update:
            action = viewModel.updateValue()
        }
        action
            .sink(receiveCompletion: handleError(_:), receiveValue: {})
            .store(in: &bag)
    }
    
    @objc private func segmentAction(_ segment: NSSegmentedControl) {
        refreshView()
    }
    
    private func makeButton(title: String = "", action: Selector) -> NSButton {
        let button = NSButton()
        button.title = title
        button.target = self
        button.action = action
        return button
    }
    
    private func makeTextField(placeholder: String) -> NSTextField {
        let textField = NSTextField()
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        textField.placeholderString = placeholder
        return textField
    }
    
    private func handleError(_ completion: Subscribers.Completion<FileOperationError>) {
        if case let .failure(error) = completion {
            print(error)
        }
    }
}
