//
//  CommentListView.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 07.12.2020.
//

import SwiftUI

struct CommentListView: View {
    
    @EnvironmentObject var persistence: PersistenceManager
    
    var body: some View {
//        List(persistence.freshComments, id: \.id) { comment in
//            CommentRowView(comment: comment)
//        }
        List {
            ForEach(persistence.freshComments) {comment in
                CommentRowView(comment: comment)
            }
        }
    }
}

struct CommentListView_Previews: PreviewProvider {
    static var previews: some View {
        CommentListView()
            .preferredColorScheme(.dark)
    }
}
