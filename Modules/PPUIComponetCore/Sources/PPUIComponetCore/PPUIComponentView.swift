//
//  SwiftUIView.swift
//  PPUIComponetCore
//
//  Created by liupenghui on 2025/11/11.
//


import SwiftUI

public struct PPUIComponentView: View {
    @State private var selection: String? = ComponentRegistry.default.components.first?.id
    
    public init(selection: String? = nil) {
        self.selection = selection
    }
    
    public static func hello() {
        print("✅ PPUIComponentCore module loaded successfully!")
    }

    public var body: some View {
        NavigationSplitView {
            List(ComponentRegistry.default.components, selection: $selection) { component in
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(component.displayName).font(.headline)
                        Text(component.description).font(.subheadline).foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: component.iconName).symbolRenderingMode(.multicolor).frame(width: 28, height: 28)
                }
                .tag(component.id)
                .padding(.vertical, 6)
            }
            .listStyle(.automatic)
            .navigationTitle("SwiftUI 组件示例")
        } detail: {
            if let id = selection,
               let component = ComponentRegistry.default.components.first(where: { $0.id == id }) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: component.iconName)
                        Text(component.displayName).font(.title2).bold()
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    Divider()
                    component.makeConfigurator()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(.background)
            } else {
                ContentPlaceholder()
            }
        }
        .frame(minWidth: 640, minHeight: 480)
    }
}

// MARK: - Component Abstractions

private enum NamedColor: String, CaseIterable, Identifiable {
    case primary = "主色"
    case secondary = "次要"
    case accent = "强调"
    case pink = "粉色"
    case green = "绿色"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .accent:
            return .accentColor
        case .pink:
            return .pink
        case .green:
            return .green
        }
    }
}

private protocol UIComponent {
    var id: String { get }
    var displayName: String { get }
    var description: String { get }
    var iconName: String { get }
    func makeConfigurator() -> AnyView
}

private struct AnyComponent: Identifiable {
    let id: String
    let displayName: String
    let description: String
    let iconName: String
    private let builder: () -> AnyView

    init<C: UIComponent>(_ component: C) {
        self.id = component.id
        self.displayName = component.displayName
        self.description = component.description
        self.iconName = component.iconName
        self.builder = component.makeConfigurator
    }

    func makeConfigurator() -> AnyView { builder() }
}

private enum ComponentRegistry {
    @MainActor static let `default` = ComponentRegistryImpl()
}

private struct ComponentRegistryImpl {
    let components: [AnyComponent] = [
        AnyComponent(TextComponent()),
        AnyComponent(TextFieldComponent()),
        AnyComponent(ButtonComponent()),
        AnyComponent(ToggleComponent()),
        AnyComponent(SliderComponent()),
        AnyComponent(PickerComponent()),
        AnyComponent(DatePickerComponent()),
        AnyComponent(StepperComponent()),
        AnyComponent(ProgressComponent()),
        AnyComponent(ColorPickerComponent())
    ]
}

// MARK: - Concrete Components (Metadata + View factory)

private struct TextComponent: UIComponent {
    var id: String { "text" }
    var displayName: String { "Text 文本" }
    var description: String { "展示和调整文本样式" }
    var iconName: String { "textformat" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { TextComponentConfigurator().padding() }) }
}

private struct TextFieldComponent: UIComponent {
    var id: String { "textField" }
    var displayName: String { "TextField 输入框" }
    var description: String { "单行/多行输入与占位、字数限制" }
    var iconName: String { "text.cursor" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { TextFieldComponentConfigurator().padding() }) }
}

private struct ButtonComponent: UIComponent {
    var id: String { "button" }
    var displayName: String { "Button 按钮" }
    var description: String { "配置按钮标题、样式和状态" }
    var iconName: String { "cursorarrow.click" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { ButtonComponentConfigurator().padding() }) }
}

private struct ToggleComponent: UIComponent {
    var id: String { "toggle" }
    var displayName: String { "Toggle 开关" }
    var description: String { "切换开关并设置标签和着色" }
    var iconName: String { "switch.2" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { ToggleComponentConfigurator().padding() }) }
}

private struct SliderComponent: UIComponent {
    var id: String { "slider" }
    var displayName: String { "Slider 滑块" }
    var description: String { "调节数值范围、步长和显示格式" }
    var iconName: String { "slider.horizontal.3" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { SliderComponentConfigurator().padding() }) }
}

private struct PickerComponent: UIComponent {
    var id: String { "picker" }
    var displayName: String { "Picker 选择器" }
    var description: String { "从多选项中选择并设置展示方式" }
    var iconName: String { "list.bullet.rectangle" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { PickerComponentConfigurator().padding() }) }
}

private struct DatePickerComponent: UIComponent {
    var id: String { "datePicker" }
    var displayName: String { "DatePicker 日期选择" }
    var description: String { "选择日期/时间并设置显示组件" }
    var iconName: String { "calendar.badge.clock" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { DatePickerComponentConfigurator().padding() }) }
}

private struct StepperComponent: UIComponent {
    var id: String { "stepper" }
    var displayName: String { "Stepper 计数器" }
    var description: String { "控制计数范围与步长" }
    var iconName: String { "plusminus" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { StepperComponentConfigurator().padding() }) }
}

private struct ProgressComponent: UIComponent {
    var id: String { "progress" }
    var displayName: String { "ProgressView 进度" }
    var description: String { "演示确定/不确定进度" }
    var iconName: String { "chart.bar.fill" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { ProgressComponentConfigurator().padding() }) }
}

private struct ColorPickerComponent: UIComponent {
    var id: String { "colorPicker" }
    var displayName: String { "ColorPicker 颜色选择" }
    var description: String { "选择颜色并预览不透明度效果" }
    var iconName: String { "eyedropper.halffull" }
    func makeConfigurator() -> AnyView { AnyView(ScrollView { ColorPickerComponentConfigurator().padding() }) }
}

// MARK: - Placeholder

private struct ContentPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.split.2x1")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("请选择左侧列表中的组件")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}
private enum FontWeightOption: String, CaseIterable, Identifiable {
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
    case bold = "Bold"

    var id: String { rawValue }

    var weight: Font.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        }
    }
}

private struct TextComponentConfigurator: View {
    @State private var content: String = "SwiftUI 文本演示"
    @State private var size: Double = 28
    @State private var weight: FontWeightOption = .regular
    @State private var color: NamedColor = .accent
    @State private var italic: Bool = false

    var body: some View {
        Form {
            Section("属性设置") {
                TextField("文本内容", text: $content, axis: .vertical)
                VStack(alignment: .leading) {
                    Slider(value: $size, in: 12...64, step: 1) {
                        Text("字体大小")
                    }
                    Text("当前字体大小：\(Int(size))pt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Picker("字重", selection: $weight) {
                    ForEach(FontWeightOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Picker("颜色", selection: $color) {
                    ForEach(NamedColor.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Toggle("斜体", isOn: $italic)
            }
            Section("预览") {
                Text(content.isEmpty ? "请输入文本" : content)
                    .font(.system(size: size, weight: weight.weight))
                    .foregroundStyle(color.color)
                    .italic(italic)
                    .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .animation(.easeInOut, value: size)
                    .animation(.easeInOut, value: weight)
                    .animation(.easeInOut, value: color)
            }
        }
        .formStyle(.grouped)
    }
}

private enum ButtonStyleOption: String, CaseIterable, Identifiable {
    case automatic = "自动"
    case bordered = "边框"
    case borderedProminent = "突出"
    case link = "链接"

    var id: String { rawValue }
}

private struct ButtonComponentConfigurator: View {
    @State private var title: String = "点我试试"
    @State private var disabled: Bool = false
    @State private var showIcon: Bool = true
    @State private var style: ButtonStyleOption = .automatic

    var body: some View {
        Form {
            Section("属性设置") {
                TextField("按钮标题", text: $title)
                Picker("按钮样式", selection: $style) {
                    ForEach(ButtonStyleOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Toggle("显示图标", isOn: $showIcon)
                Toggle("禁用按钮", isOn: $disabled)
            }
            Section("预览") {
                Group {
                    switch style {
                    case .automatic:
                        demoButton
                    case .bordered:
                        demoButton.buttonStyle(.bordered)
                    case .borderedProminent:
                        demoButton.buttonStyle(.borderedProminent)
                    case .link:
                        demoButton.buttonStyle(.link)
                    }
                }
                .disabled(disabled)
            }
        }
        .formStyle(.grouped)
    }

    private var demoButton: some View {
        Button {
            // 模拟点击行为
        } label: {
            if showIcon {
                Label(title.isEmpty ? "按钮" : title, systemImage: "hand.point.up.left.fill")
            } else {
                Text(title.isEmpty ? "按钮" : title)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 12)
    }
}

private struct ToggleComponentConfigurator: View {
    @State private var label: String = "启用高级功能"
    @State private var isOn: Bool = true
    @State private var tint: NamedColor = .accent
    @State private var showStatusText: Bool = true

    var body: some View {
        Form {
            Section("属性设置") {
                TextField("开关标题", text: $label)
                Picker("着色", selection: $tint) {
                    ForEach(NamedColor.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Toggle("显示状态文本", isOn: $showStatusText)
            }
            Section("预览") {
                Toggle(isOn: $isOn) {
                    Text(label.isEmpty ? "未命名开关" : label)
                }
                .tint(tint.color)
                .padding(.vertical, 8)

                if showStatusText {
                    Text(isOn ? "当前状态：开启" : "当前状态：关闭")
                        .font(.subheadline)
                        .foregroundStyle(isOn ? .green : .secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .formStyle(.grouped)
    }
}

private struct SliderComponentConfigurator: View {
    @State private var value: Double = 50
    @State private var minimum: Double = 0
    @State private var maximum: Double = 100
    @State private var step: Double = 1
    @State private var showValueLabel: Bool = true

    var body: some View {
        Form {
            Section("范围与步长") {
                HStack {
                    Text("最小值")
                    Spacer()
                    TextField("最小值", value: $minimum, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }
                HStack {
                    Text("最大值")
                    Spacer()
                    TextField("最大值", value: $maximum, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }
                Picker("步长", selection: $step) {
                    Text("0.1").tag(0.1)
                    Text("0.5").tag(0.5)
                    Text("1").tag(1.0)
                    Text("5").tag(5.0)
                    Text("10").tag(10.0)
                }
                Toggle("显示数值标签", isOn: $showValueLabel)
            }
            Section("预览") {
                Slider(
                    value: $value,
                    in: min(minimum, maximum)...max(minimum, maximum),
                    step: step
                ) {
                    Text("滑块")
                }
                .padding(.vertical, 12)

                if showValueLabel {
                    Text("当前数值：\(value, specifier: "%.2f")")
                        .font(.title2)
                        .monospacedDigit()
                }
            }
        }
        .formStyle(.grouped)
        .onChange(of: minimum) { _ in normalizeValue() }
        .onChange(of: maximum) { _ in normalizeValue() }
    }

    private func normalizeValue() {
        let lower = min(minimum, maximum)
        let upper = max(minimum, maximum)
        value = min(max(value, lower), upper)
    }
}

private enum PickerDisplayOption: String, CaseIterable, Identifiable {
    case menu = "菜单样式"
    case segmented = "分段样式"
    case radioGroup = "单选组"

    var id: String { rawValue }
}

private struct PickerComponentConfigurator: View {
    private let options = ["SwiftUI", "UIKit", "AppKit", "React Native"]

    @State private var selection: String = "SwiftUI"
    @State private var display: PickerDisplayOption = .menu
    @State private var showSummary: Bool = true

    var body: some View {
        Form {
            Section("属性设置") {
                Picker("展示样式", selection: $display) {
                    ForEach(PickerDisplayOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Toggle("显示选择结果", isOn: $showSummary)
            }
            Section("预览") {
                pickerBody
                    .padding(.vertical, 8)

                if showSummary {
                    Text("当前选择：\(selection)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                }
            }
        }
        .formStyle(.grouped)
    }

    @ViewBuilder
    private var pickerBody: some View {
        switch display {
        case .menu:
            Picker("技术栈", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
        case .segmented:
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented)
        case .radioGroup:
            VStack(alignment: .leading, spacing: 8) {
                Text("选择技术栈")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(options, id: \.self) { option in
                    Toggle(isOn: .constant(selection == option)) {
                        Text(option)
                    }
                    .toggleStyle(.automatic)
                    .onTapGesture {
                        selection = option
                    }
                }
            }
        }
    }
}

private enum DatePickerMode: String, CaseIterable, Identifiable {
    case date = "日期"
    case time = "时间"
    case dateAndTime = "日期 + 时间"

    var id: String { rawValue }

    var components: DatePickerComponents {
        switch self {
        case .date:
            return [.date]
        case .time:
            return [.hourAndMinute]
        case .dateAndTime:
            return [.date, .hourAndMinute]
        }
    }
}

private struct DatePickerComponentConfigurator: View {
    @State private var selection: Date = .now
    @State private var mode: DatePickerMode = .dateAndTime
    @State private var useGraphicalStyle: Bool = false

    var body: some View {
        Form {
            Section("属性设置") {
                Picker("选择模式", selection: $mode) {
                    ForEach(DatePickerMode.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Toggle("图形化样式（仅日期）", isOn: $useGraphicalStyle)
                    .disabled(mode != .date)
            }
            Section("预览") {
                if useGraphicalStyle && mode == .date {
                    DatePicker("日期", selection: $selection, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                } else {
                    DatePicker("日期/时间", selection: $selection, displayedComponents: mode.components)
                        .datePickerStyle(.automatic)
                }

                Text(selection.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
            }
        }
        .formStyle(.grouped)
    }
}

private struct StepperComponentConfigurator: View {
    @State private var value: Int = 5
    @State private var lowerBound: Int = 0
    @State private var upperBound: Int = 10
    @State private var step: Int = 1
    @State private var label: String = "数量"

    var body: some View {
        Form {
            Section("属性设置") {
                TextField("标题", text: $label)
                Stepper("最小值：\(lowerBound)", value: $lowerBound, in: 0...upperBound)
                Stepper("最大值：\(upperBound)", value: $upperBound, in: lowerBound...10)
                Picker("步长", selection: $step) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("5").tag(5)
                }
            }
            Section("预览") {
                Stepper("\(label.isEmpty ? "数量" : label)：\(value)", value: $value, in: min(lowerBound, upperBound)...max(lowerBound, upperBound), step: step)
                    .padding(.vertical, 8)

                Text("当前值：\(value)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .formStyle(.grouped)
        .onChange(of: lowerBound) { _ in clampValue() }
        .onChange(of: upperBound) { _ in clampValue() }
    }

    private func clampValue() {
        value = min(max(value, lowerBound), upperBound)
    }
}

private struct ProgressComponentConfigurator: View {
    @State private var progress: Double = 0.4
    @State private var determinate: Bool = true
    @State private var showLabel: Bool = true
    @State private var tint: NamedColor = .accent

    var body: some View {
        Form {
            Section("属性设置") {
                Toggle("确定进度", isOn: $determinate)
                if determinate {
                    Slider(value: $progress, in: 0...1, step: 0.01) {
                        Text("进度")
                    }
                    Text("当前进度：\(progress, format: .percent.precision(.fractionLength(0)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Picker("颜色", selection: $tint) {
                    ForEach(NamedColor.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                Toggle("显示标签", isOn: $showLabel)
            }
            Section("预览") {
                if determinate {
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                        .tint(tint.color)
                } else {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .tint(tint.color)
                }

                if showLabel {
                    Text(determinate ? "正在处理：\(progress, format: .percent.precision(.fractionLength(0)))" : "请稍候…")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 6)
                }
            }
        }
        .formStyle(.grouped)
    }
}

private struct TextFieldComponentConfigurator: View {
    @State private var text: String = ""
    @State private var placeholder: String = "请输入内容"
    @State private var isMultiline: Bool = false
    @State private var characterLimit: Int = 50
    @State private var showCounter: Bool = true
    @State private var showBorder: Bool = true
    
    private var textLimited: Binding<String> {
        Binding(
            get: { text },
            set: { newValue in
                if newValue.count <= characterLimit {
                    text = newValue
                } else {
                    text = String(newValue.prefix(characterLimit))
                }
            }
        )
    }

    var body: some View {
        Form {
            Section("属性设置") {
                TextField("占位提示", text: $placeholder)
                Toggle("多行输入", isOn: $isMultiline)
                Stepper("字数上限：\(characterLimit)", value: $characterLimit, in: 10...500, step: 10)
                Toggle("显示计数器", isOn: $showCounter)
                Toggle("显示边框", isOn: $showBorder)
            }
            Section("预览") {
                VStack(alignment: .leading, spacing: 8) {
                    if isMultiline {
                        TextEditor(text: textLimited)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
                    } else {
                        TextField(placeholder, text: textLimited)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical, 2)
                            .overlay {
                                if !showBorder {
                                    RoundedRectangle(cornerRadius: 6).stroke(.clear, lineWidth: 0)
                                }
                            }
                    }
                    if showCounter {
                        Text("字数：\(text.count)/\(characterLimit)")
                            .font(.caption)
                            .foregroundStyle(text.count > characterLimit ? .red : .secondary)
                    }
                }
                .animation(.easeInOut, value: isMultiline)
            }
        }
        .formStyle(.grouped)
    }

}

private struct ColorPickerComponentConfigurator: View {
    @State private var color: Color = .blue
    @State private var supportsOpacity: Bool = true
    @State private var previewSize: Double = 120
    @State private var showHex: Bool = true

    var body: some View {
        Form {
            Section("属性设置") {
                Toggle("支持不透明度", isOn: $supportsOpacity)
                Slider(value: $previewSize, in: 60...240, step: 10) {
                    Text("预览大小")
                }
                Toggle("显示近似 HEX", isOn: $showHex)
            }
            Section("预览与取色") {
                ColorPicker("选择颜色", selection: $color, supportsOpacity: supportsOpacity)
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .frame(width: previewSize, height: previewSize)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.separator, lineWidth: 1)
                        }
                        .padding(.vertical, 4)
                    if showHex {
                        Text("近似 HEX：\(hexString(from: color))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }

    private func hexString(from color: Color) -> String {
        #if os(macOS)
        let nsColor = NSColor(color)
        guard let rgb = nsColor.usingColorSpace(.deviceRGB) else { return "#------" }
        let r = Int(round(rgb.redComponent * 255))
        let g = Int(round(rgb.greenComponent * 255))
        let b = Int(round(rgb.blueComponent * 255))
        let a = Int(round(rgb.alphaComponent * 255))
        if a < 255 {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
        #else
        return ""
        #endif
    }
}
