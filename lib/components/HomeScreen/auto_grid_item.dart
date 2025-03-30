import 'package:finamp/components/AlbumScreen/track_list_tile.dart';
import 'package:finamp/components/MusicScreen/album_item.dart';
import 'package:finamp/components/MusicScreen/artist_item.dart';
import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AutoGridItem extends ConsumerWidget {
  final BaseItemDto baseItem;

  const AutoGridItem({super.key, required this.baseItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget gridItem;

    final BaseItemDtoType itemType = BaseItemDtoType.fromItem(baseItem);
    switch (itemType) {
      case BaseItemDtoType.album:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: false,
          isGrid: true,
          gridAddSettingsListener: true,
        );
        break;
      case BaseItemDtoType.playlist:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: true,
          isGrid: true,
          gridAddSettingsListener: true,
        );
        break;
      case BaseItemDtoType.artist:
        gridItem = ArtistItem(
          key: ValueKey(baseItem.id),
          artist: baseItem,
          isGrid: true,
          gridAddSettingsListener: true,
        );
        break;
      case BaseItemDtoType.track:
        gridItem = TrackListTile(
          key: ValueKey(baseItem.id),
          item: baseItem,
          isTrack: true,
          index: Future.value(0),
          isShownInSearch: false,
          allowDismiss: false,
        );
        break;
      case BaseItemDtoType.genre:
        gridItem = AlbumItem(
          key: ValueKey(baseItem.id),
          album: baseItem,
          isPlaylist: false,
          isGrid: true,
          gridAddSettingsListener: true,
        );
        break;
      default:
        gridItem = SizedBox.shrink();
    }

    return SizedBox(
      width: 120,
      height: 175,
      child: gridItem,
    );
  }
}
