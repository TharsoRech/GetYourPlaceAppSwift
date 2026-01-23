import SwiftUI

struct MyRents: View {
    @StateObject var viewModel: MyRentsViewModel
    
    init(viewModel: MyRentsViewModel = MyRentsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
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
                                onLoadMore: { }
                            )
                        }
                        
                        AccordionView(text: .constant("UnPublished Properties")) {
                            ResidenceListView(
                                residences: $viewModel.publishResidences,
                                isLoading: viewModel.isLoading,
                                isFetchingMore: viewModel.isFetchingMore,
                                onLoadMore: { }
                            )
                        }
                    }
                }

            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

// Ensure you have a mock for the preview to work
#Preview {
    MyRents()
}
