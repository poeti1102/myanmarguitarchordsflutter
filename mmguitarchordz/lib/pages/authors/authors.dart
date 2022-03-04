import 'package:flutter/material.dart';
import 'package:mmguitarchordz/models/authorModel.dart';
import 'package:mmguitarchordz/pages/songs/songsByAuthor.dart';
import 'package:mmguitarchordz/services/authorService.dart';
import 'package:mmguitarchordz/widgets/authorList.dart';
import 'package:mmguitarchordz/widgets/sideMenu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthorPage extends StatefulWidget {
  AuthorPage({Key? key}) : super(key: key);

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  List<Author> authors = [];
  bool isLoading = true;
  AuthorService authorServ = AuthorService();

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getAuthors() async {
    var data = await authorServ.getAuthors();
    setState(() {
      authors = data;
      isLoading = false;
    });
  }

  void searchAuthor(String searchTerm) async {
    var data = await authorServ.searchAuthors(searchTerm);
    setState(() {
      authors = data;
    });
  }

  @override
  void initState() {
    getAuthors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Singers"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
      ),
      drawer: SideMenu(authorPage: true),
      body: Visibility(
        visible: isLoading,
        child: Container(
          child: spinkit,
        ),
        replacement: Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        hintText: 'အဆိုတော်ရှာမယ်',
                      ),
                      onSubmitted: (text) {
                        searchAuthor(text);
                      },
                    ),
                  ),
                  Column(
                    children: authors
                        .map((author) => AuthorList(
                              author: author,
                              showSongs: () => () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SongListByAuthorPage(author: author)));
                              },
                            ))
                        .toList(),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
