//
//  AddReviewView.swift
//  Taskero
//
//  Created by Intravision on 2026-01-25.
//

import SwiftUI
import PhotosUI

struct AddReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    let orderDetail: OrderDetail
    
    @State private var rating: Int = 0
    @State private var selectedFeedback: Set<String> = []
    @State private var reviewComment: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    
    let feedbackOptions = ["Communication", "Worker's attitude", "Delivery time", "Finding location", "Worker's skill"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                header
                
                VStack(spacing: 25) {
                    // Service Info
                    serviceInfoCard
                    
                    // Rating Section
                    ratingSection
                    
                    // Feedback Tags
                    feedbackSection
                    
                    // Comment Section
                    commentSection
                    
                    // Image Upload Section
                    imageUploadSection
                    
                    // Submit Button
                    submitButton
                    
                    Spacer().frame(height: 30)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Order Summary")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            // Placeholder for symmetry
            Image(systemName: "arrow.left")
                .font(.title2)
                .opacity(0)
        }
        .padding()
        .padding(.top, 40)
    }
    
    // MARK: - Service Info Card
    private var serviceInfoCard: some View {
        HStack(spacing: 12) {
            // Service Image
            if let imageName = orderDetail.booking.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            Text(orderDetail.booking.serviceName)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Completed Badge
            Text("Completed")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.brandGreen.opacity(0.2))
                .foregroundColor(.brandGreen)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.brandGreen.opacity(0.1))
        .cornerRadius(16)
    }
    
    // MARK: - Rating Section
    private var ratingSection: some View {
        VStack(spacing: 15) {
            Text("How was the Hoverman")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("(1 is disappointing, 5 is awesome)")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 15) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .font(.system(size: 40))
                        .foregroundColor(index <= rating ? .orange : .gray.opacity(0.3))
                        .onTapGesture {
                            rating = index
                        }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    // MARK: - Feedback Section
    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What went great ?")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 0) {
                FlowLayout(spacing: 10) {
                    ForEach(feedbackOptions, id: \.self) { option in
                        Button(action: {
                            if selectedFeedback.contains(option) {
                                selectedFeedback.remove(option)
                            } else {
                                selectedFeedback.insert(option)
                            }
                        }) {
                            Text(option)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedFeedback.contains(option) ? .white : .black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(selectedFeedback.contains(option) ? Color.brandGreen : Color.gray.opacity(0.1))
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Comment Section
    private var commentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Additional Comments (Optional)")
                .font(.headline)
                .fontWeight(.bold)
            
            TextEditor(text: $reviewComment)
                .frame(height: 100)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    // MARK: - Image Upload Section
    private var imageUploadSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Add Photos (Optional)")
                .font(.headline)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Add Photo Button
                    Button(action: {
                        showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.brandGreen)
                        }
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.brandGreen, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                    
                    // Selected Images
                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Button(action: {
                                selectedImages.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .background(Color.white.clipShape(Circle()))
                            }
                            .offset(x: 5, y: -5)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        Button(action: {
            // Submit review action
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Done")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.brandGreen)
                .cornerRadius(24)
        }
        .padding(.top, 10)
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize
        var positions: [CGPoint]
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var positions: [CGPoint] = []
            var size: CGSize = .zero
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)
                
                if currentX + subviewSize.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, subviewSize.height)
                currentX += subviewSize.width + spacing
                size.width = max(size.width, currentX - spacing)
            }
            
            size.height = currentY + lineHeight
            self.size = size
            self.positions = positions
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddReviewView(orderDetail: OrderDetail(
        orderId: "HOV01203450",
        booking: Booking(
            serviceName: "Cleaning on-demand",
            category: "Cleaning",
            providerName: "Andrew Sirolin",
            date: Date(),
            time: "10:00 AM",
            status: .completed,
            price: 76.00,
            imageName: "cleaning_service",
            imageColor: .brandGreen
        ),
        status: .done,
        customerName: "Mark Robinson",
        customerPhone: "(201) ****** 82",
        customerAddress: "Washington Ave, Manchester, Kentucky 39495",
        worker: Worker(name: "Andrew Sirolin", rating: 4.9, reviewCount: 890, profileImage: nil),
        subtotal: 75.00,
        serviceFee: 1.00,
        paymentMethod: "Mastercard",
        orderDateTime: Date(),
        paymentDateTime: Date(),
        duration: "2 hours, 09:00 to 12:00 AM",
        workload: "55m²/2100ft²",
        addOnService: "Ironing",
        houseWithPet: "Dog",
        taskerGender: "Male",
        noteForWorker: nil
    ))
}
