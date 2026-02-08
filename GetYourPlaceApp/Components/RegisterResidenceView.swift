import SwiftUI
import PhotosUI

struct RegisterResidenceView: View {
    @Environment(\.dismiss) var dismiss
    
    var residenceToEdit: Residence?
    var onSave: (Residence) -> Void
    
    @State private var name = ""
    @State private var description = ""
    @State private var address = ""
    @State private var location = ""
    @State private var type = "House"
    @State private var priceText = ""
    @State private var rooms = 1
    @State private var beds = 1
    @State private var baths = 1
    @State private var sqft: Double = 0.0
    @State private var hasGarage = false
    @State private var numberOfGarages = 0
    @State private var acceptPets = false // Added State
    @State private var isPublished = false
    
    @State private var mainImageItem: PhotosPickerItem?
    @State private var mainImageBase64: String = ""
    @State private var galleryItems: [PhotosPickerItem] = []
    @State private var galleryBase64: [String] = []
    
    let propertyTypes = ["House", "Apartment", "Villa", "Studio"]
    let customDark = Color(red: 0.1, green: 0.1, blue: 0.1)

    var body: some View {
        NavigationStack {
            Form {
                Section("Media") {
                    PhotosPicker(selection: $mainImageItem, matching: .images) {
                        Label("Select Main Photo", systemImage: "photo.badge.plus").foregroundColor(.white)
                    }
                    if let main = decode(mainImageBase64) {
                        Image(uiImage: main).resizable().scaledToFill().frame(height: 160).cornerRadius(12)
                    }
                    PhotosPicker(selection: $galleryItems, maxSelectionCount: 12, matching: .images) {
                        Label("Add Gallery Images", systemImage: "square.grid.3x1.below.line.grid.1x2").foregroundColor(.white)
                    }
                }
                .listRowBackground(Color.white.opacity(0.05))

                Section("Property Information") {
                    TextField("Property Name", text: $name)
                    TextField("Description", text: $description, axis: .vertical).lineLimit(3...6)
                    TextField("Address", text: $address)
                    TextField("Location (City, State)", text: $location)
                    Picker("Type", selection: $type) {
                        ForEach(propertyTypes, id: \.self) { Text($0) }
                    }
                }
                .listRowBackground(Color.white.opacity(0.05))
                
                Section("Pricing & Details") {
                    HStack {
                        Text("Price")
                        TextField("e.g. 1200", text: $priceText)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    Stepper("Rooms: \(rooms)", value: $rooms, in: 1...50)
                    Stepper("Beds: \(beds)", value: $beds, in: 1...50)
                    Stepper("Baths: \(baths)", value: $baths, in: 1...20)
                    
                    Toggle("Has Garage", isOn: $hasGarage)
                    if hasGarage {
                        Stepper("Garages: \(numberOfGarages)", value: $numberOfGarages, in: 1...10)
                    }
                    
                    // ADDED PET TOGGLE
                    Toggle(isOn: $acceptPets) {
                        Label("Accept Pets", systemImage: "pawprint.fill").foregroundColor(.white)
                    }
                    
                    Toggle("Visible to Public", isOn: $isPublished).tint(.green)
                }
                .listRowBackground(Color.white.opacity(0.05))
                
                Section {
                    Button(action: save) {
                        Text(residenceToEdit == nil ? "Register Property" : "Save Changes")
                            .frame(maxWidth: .infinity).padding(.vertical, 10).bold().foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent).tint(.white)
                    .disabled(name.isEmpty || mainImageBase64.isEmpty)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle(residenceToEdit == nil ? "New Property" : "Edit Property")
            .scrollContentBackground(.hidden)
            .background(customDark)
            .preferredColorScheme(.dark)
            .onAppear { if let res = residenceToEdit { populateFields(from: res) } }
            // Image handling tasks (same as original)
            .onChange(of: mainImageItem) { _, newItem in
                Task { if let data = try? await newItem?.loadTransferable(type: Data.self) { mainImageBase64 = data.base64EncodedString() } }
            }
        }
    }
    
    private func populateFields(from res: Residence) {
        name = res.name
        description = res.description
        address = res.address
        location = res.location
        type = res.type
        priceText = "\(Int(res.price))"
        rooms = res.numberOfRooms
        beds = res.numberOfBeds
        baths = res.baths
        sqft = res.squareFootage
        hasGarage = res.hasGarage
        numberOfGarages = res.numberOfGarages
        acceptPets = res.acceptPets // Populate logic
        isPublished = res.isPublished
        mainImageBase64 = res.mainImageBase64
        galleryBase64 = res.galleryImagesBase64
    }

    func save() {
        let cleanPrice = priceText.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces)
        let finalPrice = Double(cleanPrice) ?? 0.0
        
        let newResidence = Residence(
            name: name, description: description, address: address, location: location, type: type, price: finalPrice,
            numberOfRooms: rooms, numberOfBeds: beds, baths: baths, squareFootage: sqft,
            hasGarage: hasGarage, numberOfGarages: numberOfGarages,
            acceptPets: acceptPets, // Save logic
            rating: residenceToEdit?.rating ?? 0.0, createdAt: residenceToEdit?.createdAt ?? Date(),
            mainImageBase64: mainImageBase64, galleryImagesBase64: galleryBase64,
            favorite: residenceToEdit?.favorite ?? false, isPublished: isPublished
        )
        onSave(newResidence)
        dismiss()
    }
    
    func decode(_ str: String) -> UIImage? {
        guard let data = Data(base64Encoded: str) else { return nil }
        return UIImage(data: data)
    }
}

#Preview("Register New") {
    RegisterResidenceView(
        residenceToEdit: nil,
        onSave: { updatedResidence in
            print("Saved: \(updatedResidence.name)")
        }
    )
}

#Preview("Edit Existing") {
    RegisterResidenceView(
        residenceToEdit: Residence.mock,
        onSave: { updatedResidence in
            print("Updated: \(updatedResidence.name)")
        }
    )
}
