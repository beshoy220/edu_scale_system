import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_components/builders/custom_state_builder.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../providers/template_provider.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: TemplateSmallView(),
      medium: TemplateMediumView(),
    );
  }
}

class TemplateSmallView extends StatelessWidget {
  const TemplateSmallView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TemplateProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Template Small Screen')),

      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomStateBuilder(
              state: provider.state,
              onSuccess: () {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.items.length,
                  itemBuilder: (context, i) {
                    final item = provider.items[i];
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        ListTile(
                          title: Text(
                            'ID: ${item.id}',
                            style: Theme.of(
                              context,
                            ).primaryTextTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            item.name,
                            style: Theme.of(
                              context,
                            ).primaryTextTheme.bodyMedium,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TemplateProvider>().fetch(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class TemplateMediumView extends StatelessWidget {
  const TemplateMediumView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TemplateProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Template Medium Screen')),
      body: Row(
        children: [
          // CustomSideBar(),
          Expanded(
            child: CustomStateBuilder(
              state: provider.state,
              onSuccess: () {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.items.length,
                  itemBuilder: (context, i) {
                    final item = provider.items[i];
                    return ListTile(
                      title: Text('ID: ${item.id}'),
                      subtitle: Text(item.name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<TemplateProvider>().fetch(),
        label: Row(children: [const Icon(Icons.refresh), Text('  Refresh  ')]),
      ),
    );
  }
}
