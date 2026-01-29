import SwiftUI

struct MyRents: View {
    @StateObject var viewModel: MyRentsViewModel
    @State private var selectedResidence: Residence? = nil
    @Environment(AuthManager.self) var authManager
    
    init(viewModel: MyRentsViewModel = MyRentsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            if let residence = selectedResidence {
                            ResidenceDetailPopup(
                                residence: residence,
                                isPresented: Binding(
                                    get: { selectedResidence != nil },
                                    set: { if !$0 { selectedResidence = nil } }
                                )
                            )
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.9)),
                                removal: .opacity.combined(with: .scale(scale: 1.1))
                            ))
                            .zIndex(100) 
                        }
            
            if authManager.currentUser?.role == .owner {
                VStack(spacing: 0) {
                    Button(action: {
                        print("Plus button tapped")
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top,16)
                    
                    ScrollView{
                        VStack{
                            AccordionView(text: .constant("Published Properties")) {
                                ResidenceListView(
                                    residences: $viewModel.publishResidences,
                                    isLoading: viewModel.isLoading,
                                    isFetchingMore: viewModel.isFetchingMore,
                                    onLoadMore: { },
                                    onSelect: { residence in
                                                            selectedResidence = residence
                                                        }
                                )
                            }
                            
                            AccordionView(text: .constant("UnPublished Properties")) {
                                ResidenceListView(
                                    residences: $viewModel.publishResidences,
                                    isLoading: viewModel.isLoading,
                                    isFetchingMore: viewModel.isFetchingMore,
                                    onLoadMore: { },
                                    onSelect: { residence in
                                                            selectedResidence = residence
                                                        }
                                )
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            else{
                ScrollView{
                    VStack{
                        Text("My Rents")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .regular, design: .default))
                        Spacer()
                        ResidenceListView(
                            residences: $viewModel.publishResidences,
                            isLoading: viewModel.isLoading,
                            isFetchingMore: viewModel.isFetchingMore,
                            onLoadMore: { },
                            onSelect: { residence in
                                                    selectedResidence = residence
                                                }
                        )
                    }
                }
            }
        
        }
    }
}

#Preview("Owner View") {
    MyRents()
        .environment(AuthManager.mock(role: .owner))
}

#Preview("Renter View") {
    MyRents()
        .environment(AuthManager.mock(role: .renter))
}
