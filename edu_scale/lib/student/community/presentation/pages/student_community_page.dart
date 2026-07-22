import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/community/data/models/student_channel_model.dart';
import 'package:edu_scale/student/community/presentation/pages/student_channel_page.dart';
import 'package:edu_scale/student/community/presentation/providers/student_channel_provider.dart';
import 'package:edu_scale/student/community/presentation/widgets/student_channel_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentCommunityPage extends StatefulWidget {
  const StudentCommunityPage({super.key});

  @override
  State<StudentCommunityPage> createState() => _StudentCommunityPageState();
}

class _StudentCommunityPageState extends State<StudentCommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentChannelsProvider>().getChannels();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentChannelsProvider>();

    final filteredChannels = provider.channels.where((channel) {
      return _channelName(
        channel,
      ).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 64, 18, 32),
            decoration: BoxDecoration(
              color: AppStyle.colors.blue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/pics/shape_2.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              style: TextStyle(color: AppStyle.colors.black),
              cursorColor: AppStyle.colors.black,
              decoration: InputDecoration(
                hintText: 'Search channels...',
                hintStyle: TextStyle(color: AppStyle.colors.black),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppStyle.colors.black,
                ),
                filled: true,
                fillColor: AppStyle.colors.grey,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Builder(
            builder: (context) {
              if (provider.isLoading && provider.channels.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: LinearProgressIndicator(),
                );
              }

              if (provider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    provider.errorMessage!,
                    style: TextStyle(color: AppStyle.colors.red),
                  ),
                );
              }

              if (provider.channels.isEmpty && !provider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No channels available'),
                );
              }

              if (filteredChannels.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No matching channels found'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredChannels.length,
                itemBuilder: (context, index) {
                  final channel = filteredChannels[index];

                  return StudentChannelCard(
                    channelName: _channelName(channel),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentChannelPage(channel: channel),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _channelName(StudentChannelModel channel) {
    if (channel.grade == null) {
      return 'School Community';
    }

    if (channel.classroom == null) {
      return channel.grade!.name;
    }

    return '${channel.grade!.name} • ${channel.classroom!.nickname}';
  }
}
