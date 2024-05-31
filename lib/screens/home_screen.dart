import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ricknmorty/provider/api_provider.dart';

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

class CharacterList extends StatelessWidget {
  final ApiProvider apiProvider;
  final ScrollController scrollController;
  final bool isLoading;

  const CharacterList(
      {super.key,
      required this.apiProvider,
      required this.scrollController,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.87,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: isLoading
          ? apiProvider.characters.length + 2
          : apiProvider.characters.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < apiProvider.characters.length) {
          final character = apiProvider.characters[index];
          return GestureDetector(
            onTap: () {
              context.go('/character');
            },
            child: Card(
              child: Column(
                children: [
                  FadeInImage(
                      placeholder: const AssetImage('assets/images/portal.gif'),
                      image: NetworkImage(character.image!)),
                  Text(
                    character.name!,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green[300],
            ),
          );
        }
      },
    );
  }
}
