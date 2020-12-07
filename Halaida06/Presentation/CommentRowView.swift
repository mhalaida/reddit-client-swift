//
//  CommentRowView.swift
//  Halaida09
//
//  Created by Mykhailo Halaida on 06.12.2020.
//

import SwiftUI

struct CommentRowView: View {
    
    // MARK: – Data
    var comment: RedditComment
    
    // MARK: – View
    var body: some View {
        VStack {
            HStack {
                Text(comment.author ?? "")
                    .padding(5)
                    .foregroundColor(.black)
                Divider()
                Text(String(comment.created_utc ?? 0))
                    .padding(5)
                    .foregroundColor(.black)
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 25, alignment: .topLeading)
            Text(comment.body ?? "")
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 100, alignment: .topLeading)
                .padding(5)
                .foregroundColor(.black)
            Text(String(comment.ups ?? 0))
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: 25, alignment: .topLeading)
                .padding(5)
                .foregroundColor(.black)
        }
        .background(Color.gray)
        .cornerRadius(5)
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView(comment: RedditComment(
                        id: "228",
                        author: "u/bruh_bruhson",
                        created_utc: 51346,
                        body: "Bruh bruh bruh bruh",
                        ups: 322,
                        downs: 0))
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
    }
}
