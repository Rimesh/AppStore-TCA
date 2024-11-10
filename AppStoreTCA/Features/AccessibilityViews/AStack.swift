import SwiftUI

/// An accessible stack view that starts as an HStack
/// then becomes a VStack once the dynamic type size
/// is an accessibility size.
///
/// Article about this gist: https://robinkanatzar.blog/accessibile-stack-in-swiftui-af8630a1cd1d
struct AHStack<Content>: View where Content: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let content: Content
    let hStackAlignment: VerticalAlignment
    let hStackSpacing: CGFloat?
    let vStackAlignment: HorizontalAlignment
    let vStackSpacing: CGFloat?

    init(hStackAlignment: VerticalAlignment = .center,
         hStackSpacing: CGFloat? = nil,
         vStackAlignment: HorizontalAlignment = .center,
         vStackSpacing: CGFloat? = nil,
         @ViewBuilder content: () -> Content)
    {
        self.hStackAlignment = hStackAlignment
        self.hStackSpacing = hStackSpacing
        self.vStackAlignment = vStackAlignment
        self.vStackSpacing = vStackSpacing
        self.content = content()
    }

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: vStackAlignment, spacing: vStackSpacing) { content }
        } else {
            HStack(alignment: hStackAlignment, spacing: hStackSpacing) { content }
        }
    }
}

/// An accessible stack view that starts as an VStack
/// then becomes a HStack once the dynamic type size
/// is an accessibility size.
///
/// Article about this gist: https://robinkanatzar.blog/accessibile-stack-in-swiftui-af8630a1cd1d
struct AVStack<Content>: View where Content: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let content: Content
    let hStackAlignment: VerticalAlignment
    let hStackSpacing: CGFloat?
    let vStackAlignment: HorizontalAlignment
    let vStackSpacing: CGFloat?

    init(hStackAlignment: VerticalAlignment = .center,
         hStackSpacing: CGFloat? = nil,
         vStackAlignment: HorizontalAlignment = .center,
         vStackSpacing: CGFloat? = nil,
         @ViewBuilder content: () -> Content)
    {
        self.hStackAlignment = hStackAlignment
        self.hStackSpacing = hStackSpacing
        self.vStackAlignment = vStackAlignment
        self.vStackSpacing = vStackSpacing
        self.content = content()
    }

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            HStack(alignment: hStackAlignment, spacing: hStackSpacing) { content }
        } else {
            VStack(alignment: vStackAlignment, spacing: vStackSpacing) { content }
        }
    }
}
