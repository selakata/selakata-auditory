import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isModalVisible: Bool = false
    @Published var modalData: ModalData = ModalData()

    func showModal(
        image: Image? = nil,
        title: String,
        description: String,
        ctaText: String
    ) {
        modalData = ModalData(
            image: image,
            title: title,
            description: description,
            ctaText: ctaText
        )
        isModalVisible = true
    }

    func hideModal() {
        isModalVisible = false
    }

    func getModalData() -> ModalData {
        return modalData
    }
}


struct ModalData {
    var image: Image? = nil
    var title: String = ""
    var description: String = ""
    var ctaText: String = ""
}
