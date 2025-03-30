import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/finamp_settings_helper.dart';
import '../../services/generate_subtitle.dart';
import '../album_image.dart';

/// Card content for AlbumItem. You probably shouldn't use this widget directly,
/// use AlbumItem instead.
class AlbumItemCard extends StatelessWidget {
  const AlbumItemCard({
    super.key,
    required this.item,
    this.parentType,
    this.onTap,
    this.addSettingsListener = false,
  });

  final BaseItemDto item;
  final String? parentType;
  final void Function()? onTap;
  final bool addSettingsListener;

  @override
  Widget build(BuildContext context) {
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
        SizedBox(
          height: 4,
        ),
        addSettingsListener
            ? // We need this ValueListenableBuilder to react to changes to
            // showTextOnGridView. When shown in a MusicScreen, this widget
            // would refresh anyway since MusicScreen also listens to
            // FinampSettings, but there may be cases where this widget is used
            // elsewhere.
            ValueListenableBuilder<Box<FinampSettings>>(
                valueListenable: FinampSettingsHelper.finampSettingsListener,
                builder: (_, box, __) {
                  if (box.get("FinampSettings")!.showTextOnGridView) {
                    return _AlbumItemCardText(
                        item: item, parentType: parentType);
                  } else {
                    // ValueListenableBuilder doesn't let us return null, so we
                    // return a 0-sized SizedBox.
                    return const SizedBox.shrink();
                  }
                },
              )
            : FinampSettingsHelper.finampSettings.showTextOnGridView
                ? _AlbumItemCardText(item: item, parentType: parentType)
                : const SizedBox.shrink(),
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
      alignment: Alignment.bottomCenter,
      child: Align(
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
      ),
    );
  }
}
