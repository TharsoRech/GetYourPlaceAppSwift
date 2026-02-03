import SwiftUI

struct ResidenceView: View {
    @Binding var residence: Residence
    @State private var showingDetail = false
    
    var onTap: () -> Void
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let mainImg = residence.mainImageBase64.toSwiftUIImage() {
                        ZStack(alignment: .top) {
                            mainImg
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .clipped()
                            
                            HStack {
                                Text(residence.type)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                                    .background(Capsule().fill(Color.white.opacity(0.9)))
                                
                                Spacer()
                                
                                HeartButton(isLiked: $residence.favorite, likedColor: .red)
                            }
                            .padding()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(residence.name)
                                    .font(.system(size: 22, weight: .bold))
                                
                                Text(residence.formattedLocation)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(residence.formattedPrice)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.right.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.black)
                                }
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .cornerRadius(6)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    HStack(spacing: 0) {
                        ResidenceCharacteristics(text: residence.formattedNumberOfBeds, iconName: "bed.double.fill")
                        ResidenceCharacteristics(text: residence.formattedNumberOfbaths, iconName: "bathtub.fill")
                        ResidenceCharacteristics(text: residence.formattedNumberOfGarages, iconName: "door.garage.closed")
                    }
                    .padding(.vertical, 16)
                }
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                onTap()
                            }
                        }
            }
        }
    }
}

#Preview {
    ResidenceView(residence: .constant(Residence.mock),onTap: {}).environment(AuthManager())
}
