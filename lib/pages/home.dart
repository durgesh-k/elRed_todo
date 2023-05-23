import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/new_task.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/widgets/loader.dart';
import 'package:todo_app/widgets/todo_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final now = DateTime.now();
  final formatter = DateFormat('MMM d, y');

  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900.withOpacity(0.05),
            blurRadius: 20.0,
            spreadRadius: 5.0,
            offset: const Offset(-20.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      drawer: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
            child: SizedBox(
          height: getHeight(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Logged in as',
                    style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 24,
                        color: secondary.withOpacity(0.1)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withOpacity(0.08), width: 1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: getWidth(context) * 0.2,
                      width: getWidth(context) * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: NetworkImage(
                                  authProvider.getUserInfo()!.photoURL!),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    authProvider.getUserInfo()!.displayName!,
                    style: TextStyle(
                        fontFamily: 'SemiBold', fontSize: 24, color: secondary),
                  ),
                ),
                InkWell(
                  onTap: () => authProvider.googlelogout(context),
                  child: Container(
                    decoration: BoxDecoration(
                        color: tertiary,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                          ),
                          authProvider.loader
                              ? const Loader(
                                  color: Colors.white,
                                )
                              : const Text(
                                  ' Sign out',
                                  style: TextStyle(
                                      fontFamily: 'SemiBold',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
      child: Consumer<TaskProvider>(
        builder: (context, todoProvider, child) => Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(slivers: [
            SliverAppBar(
                expandedHeight: 200.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: PreferredSize(
                    preferredSize: Size.fromHeight(200),
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://images.unsplash.com/photo-1552152370-fb05b25ff17d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=869&q=80'),
                              fit: BoxFit.cover)),
                      child: Row(
                        children: [
                          Container(
                            width: getWidth(context) * 0.6,
                            child: SafeArea(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 28.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: (() =>
                                                _handleMenuButtonPressed()),
                                            child: SvgPicture.asset(
                                              'assets/icons/menu.svg',
                                              color: Colors.white,
                                              height: 30,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 14, bottom: 14),
                                            child: Text(
                                              'Your\nThings',
                                              style: TextStyle(
                                                  fontFamily: 'Medium',
                                                  fontSize: 45,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            formatter.format(now),
                                            style: TextStyle(
                                                fontFamily: 'Medium',
                                                fontSize: 20,
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 5,
                                    width: getWidth(context),
                                    color: primary,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: getWidth(context) * 0.4,
                            color: Colors.black.withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                todoProvider.businessTodoCount
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Bold',
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              const Text(
                                                'Business',
                                                style: TextStyle(
                                                    fontFamily: 'Regular',
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                todoProvider.personalTodoCount
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Bold',
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              const Text(
                                                'Personal',
                                                style: TextStyle(
                                                    fontFamily: 'Regular',
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),

            //Below is the main tasks list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (todoProvider.isLoading) {
                    return SizedBox(
                        height: getHeight(context) - 200,
                        child: Center(child: Loader(color: primary)));
                  }
                  if (todoProvider.todos.isEmpty) {
                    return SizedBox(
                      height: getHeight(context) - 200,
                      child: Center(
                        child: Text(
                          'Done for today\nAdd tasks to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'SemiBold',
                              fontSize: 20,
                              color: secondary.withOpacity(0.3)),
                        ),
                      ),
                    );
                  }
                  return TodoCard(todo: todoProvider.todos[index]);
                },
                childCount:
                    todoProvider.isLoading ? 1 : todoProvider.todos.length,
              ),
            ),
          ]),
          floatingActionButton: SizedBox(
            height: getHeight(context) * 0.08,
            width: getHeight(context) * 0.08,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                      type: PageTransitionType.bottomToTop,
                      child: const NewTask())),
              backgroundColor: primary,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: Container(
            height: getHeight(context) * 0.1,
            width: getWidth(context),
            decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(color: Colors.black.withOpacity(0.05)))),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Text(
                    'COMPLETED  ',
                    style: TextStyle(
                        fontFamily: 'SemiBold',
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.3)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        todoProvider.completedTodoCount.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Regular'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
