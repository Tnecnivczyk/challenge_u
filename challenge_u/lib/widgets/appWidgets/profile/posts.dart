import 'package:flutter/material.dart';

import '../../../classes/post.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: Post.readPosts(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(
                  snapshot.data!.length,
                  (index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3 - 12,
                      height: MediaQuery.of(context).size.width / 3 - 12,
                      child: Image.network(
                        snapshot.data![index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              )
            : Container();
      },
    );
  }
}
