import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../../../../core/themes/themes.dart';
import '../../data/models/library_item_model.dart';
import '../providers/library_resources_provider.dart';
import '../widgets/custom_table.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryResourcesProvider>().loadResources();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<LibraryResourcesProvider>().loadResources();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryResourcesProvider>();

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Library'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'My school library material'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: const SizedBox(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// INITIAL LOADING
          if (provider.isLoading && provider.resources.isEmpty)
            const LinearProgressIndicator()
          /// INITIAL ERROR
          else if (provider.errorMessage != null && provider.resources.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  provider.errorMessage!,
                  style: TextStyle(color: AppStyle.colors.red),
                ),
              ),
            )
          /// EMPTY STATE
          else if (provider.resources.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 260),

                  Icon(
                    CupertinoIcons.book,
                    size: 48,
                    color: AppStyle.colors.black.withAlpha(150),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'No library resources uploaded yet.\nAsk your teachers to upload some materials!'
                        .tr(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          /// TABLE
          else
            Column(
              children: [
                ResponsiveLayoutBuilder(
                  small: CustomTable(
                    shrinkLastColumn: true,
                    headersText: [
                      'File name'.tr(),
                      'Subject'.tr(),
                      'Grade'.tr(),
                      'Class'.tr(),
                      'Uploaded by'.tr(),
                      'State'.tr(),
                    ],
                    rows: provider.resources.map((item) {
                      return [
                        Text(item.title),
                        Text(item.subjectName),
                        Text(item.gradeName),
                        Text(item.classNickname ?? 'Whole grade'.tr()),
                        Text(item.uploadedBy),
                        Text(
                          item.status.tr(),
                          style: TextStyle(
                            color: (item.status == 'approved')
                                ? AppStyle.colors.green
                                : (item.status == 'rejected')
                                ? AppStyle.colors.red
                                : AppStyle.colors.black.withAlpha(230),
                          ),
                        ),
                      ];
                    }).toList(),
                  ),

                  medium: CustomTable(
                    fitWidth: true,
                    shrinkLastColumn: true,
                    headersText: [
                      'File name'.tr(),
                      'Subject'.tr(),
                      'Grade'.tr(),
                      'Class'.tr(),
                      'Uploaded by'.tr(),
                      'State'.tr(),
                      '',
                    ],
                    rows: provider.resources.map((item) {
                      return [
                        Text(item.title),
                        Text(item.subjectName),
                        Text(item.gradeName),
                        Text(item.classNickname ?? 'Whole grade'.tr()),
                        Text(item.uploadedBy),
                        Text(
                          item.status.tr(),
                          style: TextStyle(
                            color: (item.status == 'approved')
                                ? AppStyle.colors.green
                                : (item.status == 'rejected')
                                ? AppStyle.colors.red
                                : AppStyle.colors.black.withAlpha(230),
                          ),
                        ),
                        _OptionsButton(item),
                      ];
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                /// PAGINATION LOADER
                if (provider.isLoading && provider.resources.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: LinearProgressIndicator(),
                  ),

                /// END OF LIST
                if (!provider.hasMore && provider.resources.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'All resources loaded'.tr(),
                      style: AppStyle.theme.primaryTextTheme.bodySmall,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _OptionsButton extends StatelessWidget {
  final LibraryItemModel item;

  const _OptionsButton(this.item);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LibraryResourcesProvider>();

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_outlined),

      onSelected: (value) {
        switch (value) {
          case 'approve':
            provider.updateStatus(resourceId: item.id, status: 'approved');

            break;

          case 'reject':
            provider.updateStatus(resourceId: item.id, status: 'rejected');

            break;
        }
      },

      itemBuilder: (context) {
        if (item.status == 'pendding') {
          return [
            PopupMenuItem(value: 'approve', child: Text('Approve'.tr())),
            PopupMenuItem(value: 'reject', child: Text('Reject'.tr())),
          ];
        } else if (item.status == 'rejected') {
          return [PopupMenuItem(value: 'approve', child: Text('Approve'.tr()))];
        } else {
          return [PopupMenuItem(value: 'reject', child: Text('Reject'.tr()))];
        }
      },
    );
  }
}
