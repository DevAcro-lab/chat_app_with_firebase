import 'package:chat_app_with_firebase/constants/colors.dart';
import 'package:chat_app_with_firebase/provider/user.dart';
import 'package:chat_app_with_firebase/service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/custom_appbar.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserNotifier>(context, listen: false)
        .fetchAllUsersExceptCurrent();
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: CustomAppBar(showLeading: false),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        child: Column(
          children: [
            Consumer<UserNotifier>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                        children: List.generate(
                      5,
                      (index) => ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                        ),
                        title: Container(
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        subtitle: Container(
                          height: 12,
                          color: Colors.grey[300],
                        ),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                      ),
                    )),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: provider.userList!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ChatScreen(
                                  receiverUserId: provider.userList![index]
                                      ["userId"],
                                  receiverName: provider.userList![index]
                                      ["name"],
                                  userProfileUrl: provider.userList![index]
                                      ["profilePictureUrl"],
                                );
                              }));
                            },
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: provider.userList![index]
                                              ["profilePictureUrl"] ==
                                          null
                                      ? AssetImage('images/user.png')
                                      : NetworkImage(provider.userList![index]
                                              ["profilePictureUrl"])
                                          as ImageProvider<Object>,
                                ),
                                title: Text(
                                  provider.userList![index]["name"],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: const Text(
                                  "Hi, I am using CHIT-CHAT",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.message_outlined,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
