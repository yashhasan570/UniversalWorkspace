import 'package:flutter/material.dart';

import 'package:universalworkspace/generated/uniflow_svgs.g.dart';
import 'package:universalworkspace_backend/protobuf/uniflow-database2/media_entities.pb.dart';

extension FileTypeDisplay on MediaFileTypePB {
  UniflowSvgData get icon => switch (this) {
        MediaFileTypePB.Image => UniflowSvgs.image_s,
        MediaFileTypePB.Link => UniflowSvgs.ft_link_s,
        MediaFileTypePB.Document => UniflowSvgs.icon_document_s,
        MediaFileTypePB.Archive => UniflowSvgs.ft_archive_s,
        MediaFileTypePB.Video => UniflowSvgs.ft_video_s,
        MediaFileTypePB.Audio => UniflowSvgs.ft_audio_s,
        MediaFileTypePB.Text => UniflowSvgs.ft_text_s,
        _ => UniflowSvgs.icon_document_s,
      };

  Color get color => switch (this) {
        MediaFileTypePB.Image => const Color(0xFF5465A1),
        MediaFileTypePB.Link => const Color(0xFFEBE4FF),
        MediaFileTypePB.Audio => const Color(0xFFE4FFDE),
        MediaFileTypePB.Video => const Color(0xFFE0F8FF),
        MediaFileTypePB.Archive => const Color(0xFFFFE7EE),
        MediaFileTypePB.Text ||
        MediaFileTypePB.Document ||
        MediaFileTypePB.Other =>
          const Color(0xFFF5FFDC),
        _ => const Color(0xFF87B3A8),
      };
}
