import 'package:firstpro/services/post_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("TODO"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String? title;
          String? content;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 184, 144, 191),
                        labelText: "Title",
                      ),
                      onChanged: (_val) {
                        title = _val;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 184, 144, 191),
                        labelText: "Content",
                      ),
                      onChanged: (_val) {
                        content = _val;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (title == null || content == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please fill in both title and content.'),
                            ),
                          );
                          return;
                        }
                        print(title);
                        print(content);
                        Map<String, dynamic> data = {
                          'title': title,
                          'content': content
                        };
                        //CREATE POST
                        String res = await postService.createPost(data);

                        res == "success" ? print("Great") : print("ERROR");

                        print(res);

                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: const Text(
                        "ADD",
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List>(
        //GET POST
        future: postService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.length == 0) {
              return Center(
                child: Text("NOPOST"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index]['title']),
                  subtitle: Text(snapshot.data?[index]['content']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ////////////////////////////////////////UPDATE BUTTON////////////////////////////////////////

                      IconButton(
                        onPressed: () {
                          String? title = snapshot.data?[index]['title'];
                          String? content = snapshot.data?[index]['content'];

                          TextEditingController titleController =
                              TextEditingController(text: title);
                          TextEditingController contentController =
                              TextEditingController(text: content);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Form(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 184, 144, 191),
                                        labelText: "Title",
                                      ),
                                      onChanged: (_val) {
                                        title = _val;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFormField(
                                      controller: contentController,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 184, 144, 191),
                                        labelText: "Content",
                                      ),
                                      onChanged: (_val) {
                                        content = _val;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (title == null || content == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Please fill in both title and content.'),
                                            ),
                                          );
                                          return;
                                        }
                                        String link =
                                            snapshot.data?[index]['_id'];

                                        Map<String, dynamic> data = {
                                          'title': title,
                                          'content': content
                                        };

                                        ////////////////////////////////////////

                                        //UPDATE POST
                                        String res = await postService
                                            .updatePost(data, link);

                                        res == "success"
                                            ? print("Great")
                                            : print("ERROR");

                                        print(res);

                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: const Text(
                                        "EDIT",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),

                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          Map<String, dynamic> data = {
                            '_id': snapshot.data?[index]['_id']
                          };

                          var res = await postService.deletePost(data);

                          res == "success" ? print("Deleted") : print("Error");

                          print(res);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
