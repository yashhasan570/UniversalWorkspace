import 'package:universalworkspace/core/helpers/url_launcher.dart';
import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace/generated/locale_keys.g.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/bottom_sheet_media_upload.dart';
import 'package:universalworkspace/mobile/presentation/bottom_sheet/show_mobile_bottom_sheet.dart';
import 'package:universalworkspace/mobile/presentation/widgets/uniflow_option_tile.dart';
import 'package:universalworkspace/plugins/base/drag_handler.dart';
import 'package:universalworkspace/plugins/database/application/cell/bloc/media_cell_bloc.dart';
import 'package:universalworkspace/plugins/database/widgets/cell_editor/media_cell_editor.dart';
import 'package:universalworkspace/plugins/database/widgets/media_file_type_ext.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/file/file_util.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/image/common.dart';
import 'package:universalworkspace/plugins/document/presentation/editor_plugins/image/multi_image_block_component/image_render.dart';
import 'package:universalworkspace/shared/loading.dart';
import 'package:universalworkspace/workspace/presentation/widgets/image_viewer/interactive_image_viewer.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/file_entities.pbenum.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/media_entities.pb.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/row_entities.pb.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uniflow_infra_ui/uniflow_infra_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MobileMediaCellEditor extends StatelessWidget {
  const MobileMediaCellEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(height: 420),
      child: BlocProvider.value(
        value: context.read<MediaCellBloc>(),
        child: BlocBuilder<MediaCellBloc, MediaCellState>(
          builder: (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DragHandle(),
              SizedBox(
                height: 46.0,
                child: Stack(
                  children: [
                    Align(
                      child: UniflowText.medium(
                        LocaleKeys.grid_field_mediaFieldName.tr(),
                        fontSize: 18,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 18,
                      child: GestureDetector(
                        onTap: () => showMobileBottomSheet(
                          context,
                          title: LocaleKeys.grid_media_addFileMobile.tr(),
                          showHeader: true,
                          showCloseButton: true,
                          showDragHandle: true,
                          builder: (dContext) => BlocProvider.value(
                            value: context.read<MediaCellBloc>(),
                            child: MobileMediaUploadSheetContent(
                              dialogContext: dContext,
                            ),
                          ),
                        ),
                        child: const UniflowSvg(
                          UniflowSvgs.add_m,
                          size: Size.square(28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0.5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state.files.isNotEmpty) const Divider(height: .5),
                      ...state.files.map(
                        (file) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: _FileItem(key: Key(file.id), file: file),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileItem extends StatelessWidget {
  const _FileItem({super.key, required this.file});

  final MediaFilePB file;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        title: Row(
          crossAxisAlignment: file.fileType == MediaFileTypePB.Image
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (file.fileType != MediaFileTypePB.Image) ...[
              Flexible(
                child: GestureDetector(
                  onTap: () => afLaunchUrlString(file.url),
                  child: Row(
                    children: [
                      UniflowSvg(file.fileType.icon, size: const Size.square(24)),
                      const HSpace(12),
                      Expanded(
                        child: UniflowText(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: const BoxConstraints(maxHeight: 96),
                  child: GestureDetector(
                    onTap: () => openInteractiveViewer(context),
                    child: ImageRender(
                      userProfile:
                          context.read<MediaCellBloc>().state.userProfile,
                      fit: BoxFit.fitHeight,
                      borderRadius: BorderRadius.zero,
                      image: ImageBlockData(
                        url: file.url,
                        type: file.uploadType.toCustomImageType(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            UniflowIconButton(
              width: 20,
              icon: const UniflowSvg(
                UniflowSvgs.three_dots_s,
                size: Size.square(20),
              ),
              onPressed: () => showMobileBottomSheet(
                context,
                backgroundColor: Theme.of(context).colorScheme.surface,
                showDragHandle: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<MediaCellBloc>(),
                  child: _EditFileSheet(file: file),
                ),
              ),
            ),
            const HSpace(6),
          ],
        ),
      ),
    );
  }

  void openInteractiveViewer(BuildContext context) =>
      openInteractiveViewerFromFile(
        context,
        file,
        onDeleteImage: (_) => context.read<MediaCellBloc>().deleteFile(file.id),
        userProfile: context.read<MediaCellBloc>().state.userProfile,
      );
}

class _EditFileSheet extends StatefulWidget {
  const _EditFileSheet({required this.file});

  final MediaFilePB file;

  @override
  State<_EditFileSheet> createState() => _EditFileSheetState();
}

class _EditFileSheetState extends State<_EditFileSheet> {
  late final controller = TextEditingController(text: widget.file.name);
  Loading? loader;

  MediaFilePB get file => widget.file;

  @override
  void dispose() {
    controller.dispose();
    loader?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VSpace(16),
          if (file.fileType == MediaFileTypePB.Image) ...[
            UniflowOptionTile.text(
              showTopBorder: false,
              text: LocaleKeys.grid_media_expand.tr(),
              leftIcon: const UniflowSvg(
                UniflowSvgs.full_view_s,
                size: Size.square(20),
              ),
              onTap: () => openInteractiveViewer(context),
            ),
            UniflowOptionTile.text(
              showTopBorder: false,
              text: LocaleKeys.grid_media_setAsCover.tr(),
              leftIcon: const UniflowSvg(
                UniflowSvgs.cover_s,
                size: Size.square(20),
              ),
              onTap: () => context.read<MediaCellBloc>().add(
                    MediaCellEvent.setCover(
                      RowCoverPB(
                        data: file.url,
                        uploadType: file.uploadType,
                        coverType: CoverTypePB.FileCover,
                      ),
                    ),
                  ),
            ),
          ],
          UniflowOptionTile.text(
            showTopBorder: file.fileType == MediaFileTypePB.Image,
            text: LocaleKeys.grid_media_openInBrowser.tr(),
            leftIcon: const UniflowSvg(
              UniflowSvgs.open_in_browser_s,
              size: Size.square(20),
            ),
            onTap: () => afLaunchUrlString(file.url),
          ),
          // TODO(Mathias): Rename interaction need design
          // UniflowOptionTile.text(
          //   text: LocaleKeys.grid_media_rename.tr(),
          //   leftIcon: const UniflowSvg(
          //     UniflowSvgs.rename_s,
          //     size: Size.square(20),
          //   ),
          //   onTap: () {},
          // ),
          if (widget.file.uploadType == FileUploadTypePB.CloudFile) ...[
            UniflowOptionTile.text(
              onTap: () async => downloadMediaFile(
                context,
                file,
                userProfile: context.read<MediaCellBloc>().state.userProfile,
                onDownloadBegin: () {
                  loader?.stop();
                  loader = Loading(context);
                  loader?.start();
                },
                onDownloadEnd: () => loader?.stop(),
              ),
              text: LocaleKeys.button_download.tr(),
              leftIcon: const UniflowSvg(
                UniflowSvgs.save_as_s,
                size: Size.square(20),
              ),
            ),
          ],
          UniflowOptionTile.text(
            text: LocaleKeys.grid_media_delete.tr(),
            textColor: Theme.of(context).colorScheme.error,
            leftIcon: UniflowSvg(
              UniflowSvgs.trash_s,
              size: const Size.square(20),
              color: Theme.of(context).colorScheme.error,
            ),
            onTap: () {
              context.pop();
              context.read<MediaCellBloc>().deleteFile(file.id);
            },
          ),
        ],
      ),
    );
  }

  void openInteractiveViewer(BuildContext context) =>
      openInteractiveViewerFromFile(
        context,
        file,
        onDeleteImage: (_) => context.read<MediaCellBloc>().deleteFile(file.id),
        userProfile: context.read<MediaCellBloc>().state.userProfile,
      );
}
