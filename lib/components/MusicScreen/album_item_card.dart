import 'package:finamp/services/finamp_settings_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/generate_subtitle.dart';
import '../album_image.dart';

/// Card content for AlbumItem. You probably shouldn't use this widget directly,
/// use AlbumItem instead.
class AlbumItemCard extends ConsumerWidget {
  const AlbumItemCard({
    super.key,
    required this.item,
    this.parentType,
    this.onTap,
  });

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FinampSettings? finampSettings =
        ref.watch(finampSettingsProvider).value;
    return Column(
      children: [
        Stack(
          children: [
            AlbumImage(item: item),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            )
          ],
        ),
        if (finampSettings?.showTextOnGridView ?? false)
          SizedBox(
            height: 4,
          ),
        if (finampSettings?.showTextOnGridView ?? false)
          _AlbumItemCardText(item: item, parentType: parentType)
      ],
    );
  }
}

class _AlbumItemCardText extends StatelessWidget {
  const _AlbumItemCardText({
    required this.item,
    required this.parentType,
  });

  final BaseItemDto item;
  final String? parentType;

  @override
  Widget build(BuildContext context) {
    final subtitle = generateSubtitle(item, parentType, context);

    return Align(
      alignment: Alignment.bottomLeft,
      child: Wrap(
        // Runs must be horizontal to constrain child width.  Use large
        // spacing to force subtitle to wrap to next run
        spacing: 1000,
        children: [
          Text(item.name ?? "Unknown Name",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  )),
          if (subtitle != null)
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodySmall,
            )
        ],
      ),
    );
  }
}
