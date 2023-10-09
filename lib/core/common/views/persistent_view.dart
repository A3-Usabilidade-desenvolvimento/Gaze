import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaze/core/providers/tab_navigator.dart';
import 'package:gaze/features/dashboard/presentation/views/dashboard.dart';

/// Classe necessária para fazer a NestedNavigation no [DashboardScreen]
class PersistentView extends StatefulWidget {
  const PersistentView({
    this.body,
    super.key,
  });

  final Widget? body;

  @override
  State<PersistentView> createState() => _PersistentViewState();
}

class _PersistentViewState extends State<PersistentView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentPage.child;
  }

  @override
  bool get wantKeepAlive => true;
}
