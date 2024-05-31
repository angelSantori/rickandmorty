import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ricknmorty/provider/api_provider.dart';
import 'package:ricknmorty/widgets/character_list.dart';
import 'package:ricknmorty/widgets/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });

        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Rick & Morty",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchCharacter());
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: apiProvider.characters.isNotEmpty
              ? CharacterList(
                  apiProvider: apiProvider,
                  isLoading: isLoading,
                  scrollController: scrollController,
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.green[300],
                  ),
                ),
        ));
  }
}
