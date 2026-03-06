//
//  AddEditServiceView.swift
//  Taskero
//

import SwiftUI
import PhotosUI

struct AddEditServiceView: View {
    @Environment(\.presentationMode) var presentationMode

    let existingService: WorkerService?
    let onSave: (WorkerService) -> Void

    // Form fields
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var basePriceText: String = ""
    @State private var category: ServiceType = .cleaning
    @State private var isActive: Bool = true

    // Photo picker
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    // Validation
    @State private var showValidationAlert = false

    let mainColor = Color.brandGreen

    private var isEditing: Bool { existingService != nil }
    private var basePrice: Double { Double(basePriceText) ?? 0 }

    init(existingService: WorkerService?, onSave: @escaping (WorkerService) -> Void) {
        self.existingService = existingService
        self.onSave = onSave
        if let svc = existingService {
            _title = State(initialValue: svc.title)
            _description = State(initialValue: svc.description)
            _basePriceText = State(initialValue: String(Int(svc.basePrice)))
            _category = State(initialValue: svc.category)
            _isActive = State(initialValue: svc.isActive)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Photos Section
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader(icon: "photo.on.rectangle.angled", title: "Service Photos")
                        Text("Add up to 5 photos to showcase your work.")
                            .font(.caption)
                            .foregroundColor(.gray)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                // Photo picker button
                                PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 5, matching: .images) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(mainColor)
                                        Text("Add Photo")
                                            .font(.caption2)
                                            .foregroundColor(mainColor)
                                    }
                                    .frame(width: 80, height: 80)
                                    .background(mainColor.opacity(0.08))
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(mainColor.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [4])))
                                }
                                .onChange(of: selectedPhotoItems) { items in
                                    loadPhotos(from: items)
                                }

                                ForEach(0..<selectedImages.count, id: \.self) { i in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: selectedImages[i])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        Button(action: { selectedImages.remove(at: i) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Color.black.opacity(0.5))
                                                .clipShape(Circle())
                                                .font(.system(size: 18))
                                        }
                                        .offset(x: 6, y: -6)
                                    }
                                }

                                // Placeholder slots
                                let remaining = max(0, 3 - selectedImages.count)
                                ForEach(0..<remaining, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.08))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .foregroundColor(.gray.opacity(0.4))
                                                .font(.system(size: 22))
                                        )
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.15), lineWidth: 1))
                                }
                            }
                            .padding(.horizontal, 1)
                        }
                    }
                    .settingsCard()

                    // Service Info
                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader(icon: "text.alignleft", title: "Service Details")

                        formField(label: "Service Title", hint: "e.g. Deep Home Cleaning") {
                            TextField("Enter title", text: $title)
                                .padding()
                                .background(Color.gray.opacity(0.06))
                                .cornerRadius(10)
                        }

                        formField(label: "Description", hint: "Describe what you offer, your experience, and what's included.") {
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("e.g. Full cleaning service including kitchen, bathrooms...")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(12)
                                }
                                TextEditor(text: $description)
                                    .frame(height: 100)
                                    .padding(8)
                            }
                            .background(Color.gray.opacity(0.06))
                            .cornerRadius(10)
                        }
                    }
                    .settingsCard()

                    // Pricing & Category
                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader(icon: "tag.fill", title: "Pricing & Category")

                        formField(label: "Starting Price (USD)", hint: "Customers see this as the base price.") {
                            HStack {
                                Text("$")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                TextField("e.g. 50", text: $basePriceText)
                                    .keyboardType(.decimalPad)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.06))
                            .cornerRadius(10)
                        }

                        formField(label: "Service Category", hint: nil) {
                            Menu {
                                ForEach(ServiceType.allCases, id: \.self) { type in
                                    Button(type.rawValue) { category = type }
                                }
                            } label: {
                                HStack {
                                    Text(category.rawValue)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.06))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .settingsCard()

                    // Availability
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader(icon: "eye.fill", title: "Visibility")
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("List as Active")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Customers can find and book this service.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Toggle("", isOn: $isActive)
                                .toggleStyle(SwitchToggleStyle(tint: mainColor))
                                .labelsHidden()
                        }
                    }
                    .settingsCard()

                    Spacer().frame(height: 20)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.04).ignoresSafeArea())
            .navigationTitle(isEditing ? "Edit Service" : "Add Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Add") {
                        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
                              basePrice > 0 else {
                            showValidationAlert = true
                            return
                        }
                        var svc = WorkerService(
                            title: title.trimmingCharacters(in: .whitespaces),
                            description: description.trimmingCharacters(in: .whitespaces),
                            basePrice: basePrice,
                            category: category,
                            imageNames: [],
                            isActive: isActive
                        )
                        if let existing = existingService {
                            svc.id = existing.id
                        }
                        onSave(svc)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(mainColor)
                }
            }
            .alert("Missing Info", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enter a service title and a valid starting price.")
            }
        }
    }

    // MARK: - Helpers

    private func loadPhotos(from items: [PhotosPickerItem]) {
        selectedImages = []
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedImages.append(uiImage)
                        }
                    }
                case .failure: break
                }
            }
        }
    }

    @ViewBuilder
    private func sectionHeader(icon: String, title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(mainColor)
                .font(.system(size: 14, weight: .semibold))
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }

    @ViewBuilder
    private func formField<Content: View>(label: String, hint: String?, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            content()
            if let hint = hint {
                Text(hint)
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
    }
}

// MARK: - View Modifier

private extension View {
    func settingsCard() -> some View {
        self
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.04), radius: 5, y: 2)
    }
}

#Preview {
    AddEditServiceView(existingService: nil) { _ in }
}
