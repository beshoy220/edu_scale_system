import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/community/data/models/teacher_channel_model.dart';
import 'package:edu_scale/teacher/community/presentation/pages/teacher_channel_page.dart';
import 'package:edu_scale/teacher/community/presentation/providers/teacher_channels_provider.dart';
import 'package:edu_scale/teacher/community/presentation/widgets/teacher_channel_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherCommunityPage extends StatefulWidget {
  const TeacherCommunityPage({super.key});

  @override
  State<TeacherCommunityPage> createState() => _TeacherCommunityPageState();
}

class _TeacherCommunityPageState extends State<TeacherCommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherChannelsProvider>().loadChannels();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TeacherChannelsProvider>();

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
              image: DecorationImage(
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

                  return TeacherChannelCard(
                    channelName: _channelName(channel),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeacherChannelPage(channel: channel),
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

  String _channelName(TeacherChannelModel channel) {
    if (channel.grade == null) {
      return 'School Community';
    }

    if (channel.classroom == null) {
      return channel.grade!.name;
    }

    return '${channel.grade!.name} • ${channel.classroom!.nickname}';
  }
}
