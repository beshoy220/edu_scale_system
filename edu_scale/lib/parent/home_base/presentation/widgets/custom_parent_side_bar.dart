import 'package:edu_scale/core/app_meta/app_meta.dart';
import 'package:edu_scale/core/app_meta/parent_nav.dart';
import 'package:edu_scale/parent/home_base/presentation/providers/parent_nav_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomParentSideBar extends StatelessWidget {
  const CustomParentSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('${AppMeta.appName} Parent'),
          Text('V ${AppMeta.appVersion}'),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: parentNav.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  final provider = context.read<ParentNavIndexProvider>();
                  provider.setIndex(index);
                },
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(parentNav[index]['label']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
