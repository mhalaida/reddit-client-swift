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
                CommentRowView(comment: comment)
                    .listRowInsets(EdgeInsets())
                    .padding(5)
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
