import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/global_auth_manager/data/data_sources/sign_out_remote_data_source.dart';
import 'package:edu_scale/global_auth_manager/presentation/pages/sign_in_page.dart';
import 'package:edu_scale/core/account_manager/account_manager.dart';
import 'package:edu_scale/core/account_manager/cached_account_model.dart';
import 'package:edu_scale/core/app_meta/app_meta.dart';
import 'package:edu_scale/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/home_base/presentation/pages/parent_home_base.dart';
import 'package:edu_scale/student/home_base/presentation/pages/student_home_base.dart';
import 'package:edu_scale/teacher/home_base/presentation/pages/teacher_home_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// This file needs refactor becuase it access the AccountManager directly and not from data layer
class AccountManagerPage extends StatefulWidget {
  const AccountManagerPage({super.key});

  @override
  State<AccountManagerPage> createState() => _AccountManagerPageState();
}

class _AccountManagerPageState extends State<AccountManagerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.colors.brown,

        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/pics/shape_1.png'),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  final role = SupabaseAuthService()
                                      .currentUser
                                      ?.appMetadata['role'];
                                  if (role == 'student') {
                                    return StudentHomeBase();
                                  } else if (role == 'parent') {
                                    return ParentHomeBase();
                                  } else if (role == 'teacher') {
                                    return TeacherHomeBase();
                                  } else {
                                    return SafeArea(
                                      child: Scaffold(
                                        body: Text('No role cached'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppStyle.colors.surface,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Manager',
                              style: AppStyle.theme.primaryTextTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.colors.surface,
                                  ),
                            ),
                            Text(
                              'Accounts',
                              style: AppStyle.theme.primaryTextTheme.bodyMedium
                                  ?.copyWith(color: AppStyle.colors.surface),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 120),
                  FutureBuilder(
                    future: AccountManager.accountsList(),
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.error == null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<CachedAccount> accounts =
                                snapshot.data as List<CachedAccount>;

                            return InkWell(
                              onTap: () async {
                                debugPrint(accounts[index].toString());

                                if (accounts[index].id !=
                                    SupabaseAuthService().currentUser!.id) {
                                  SupabaseAuthService().signOut();

                                  PushNotificationsService.topics
                                      .unSubscribeFromAllTopics();

                                  AccountManager.setCurrentAccount(
                                    accounts[index],
                                  );

                                  SupabaseAuthService().signIn(
                                    email: accounts[index].email,
                                    password: accounts[index].password,
                                  );

                                  String currentUserRole = accounts[index].role;

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) {
                                        if (currentUserRole == 'student') {
                                          return StudentHomeBase();
                                        } else if (currentUserRole ==
                                            'parent') {
                                          return ParentHomeBase();
                                        } else if (currentUserRole ==
                                            'teacher') {
                                          return TeacherHomeBase();
                                        } else {
                                          return SafeArea(
                                            child: Scaffold(
                                              body: Text('No role cached'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Already signed in to this account',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppStyle.colors.onBrown,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: AppStyle.colors.grey,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: Icon(CupertinoIcons.person),
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${accounts[index].displayName}  (${accounts[index].role})',

                                          style: AppStyle
                                              .theme
                                              .primaryTextTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppStyle.colors.surface,
                                              ),
                                        ),
                                        Text(
                                          accounts[index].id ==
                                                  SupabaseAuthService()
                                                      .currentUser
                                                      ?.id
                                              ? 'Current account'
                                              : 'First sign in: ${accounts[index].lastSignIn.toString().split(' ')[0]}',
                                          style:
                                              accounts[index].id ==
                                                  SupabaseAuthService()
                                                      .currentUser
                                                      ?.id
                                              ? AppStyle
                                                    .theme
                                                    .primaryTextTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color:
                                                          AppStyle.colors.green,
                                                    )
                                              : AppStyle
                                                    .theme
                                                    .primaryTextTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppStyle
                                                          .colors
                                                          .surface,
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Text('No accounts found in account manager');
                      }
                    },
                  ),

                  InkWell(
                    onTap: () {
                      SignOutRemoteDataSource().signOut();
                      AccountManager.setCurrentAccountNull();
                        PushNotificationsService.topics
                                      .unSubscribeFromAllTopics();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const SignInPage(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(color: AppStyle.colors.onBrown),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppStyle.colors.grey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(CupertinoIcons.add),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign out',

                                style: AppStyle
                                    .theme
                                    .primaryTextTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppStyle.colors.surface,
                                    ),
                              ),
                              Text(
                                'Sign out and add another account',
                                style: TextStyle(
                                  color: AppStyle.colors.surface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppMeta.appName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyle.colors.surface,
                    ),
                  ),
                  Text(
                    AppMeta.appVersion,
                    style: TextStyle(color: AppStyle.colors.surface),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
