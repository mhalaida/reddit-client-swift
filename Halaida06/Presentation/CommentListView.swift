//
//  CommentListView.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 07.12.2020.
//

import SwiftUI

struct CommentListView: View {
    
    var comments: [RedditComment]
    
    var body: some View {
        List {
            ForEach(comments) {comment in
                ZStack {
                    CommentRowView(comment: comment)
                        .listRowInsets(EdgeInsets())
                        .padding(5)
                    NavigationLink(destination: CommentDetailsView(comment: comment)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    .buttonStyle(PlainButtonStyle())
                    .listRowInsets(EdgeInsets())
                }
                .listRowBackground(Color(UIColor.systemGray5))
            }
        }
    }
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView(comments: PersistenceManager.shared.freshComments)
            .preferredColorScheme(.dark)
    }
}
