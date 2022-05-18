import 'dart:typed_data';

import 'package:at_contacts_flutter/widgets/contacts_initials.dart';
import 'package:at_contacts_group_flutter/utils/colors.dart';
import 'package:at_contacts_group_flutter/utils/text_styles.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/at_common_flutter.dart';

// ignore: must_be_immutable
class CustomPersonHorizontalTile extends StatelessWidget {
  final String? title, subTitle;
  final bool isTopRight;
  final IconData? icon;
  List<dynamic>? image;

  CustomPersonHorizontalTile({
    Key? key,
    this.image,
    this.title,
    this.subTitle,
    this.isTopRight = false,
    this.icon,
  }) : super(key: key) {
    if (image != null) {
      var intList = image!.cast<int>();
      image = Uint8List.fromList(intList);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      children: <Widget>[
        Stack(
          children: [
            CircleAvatar(
              radius: 20.toWidth,
              child: image != null
                  ? CircleAvatar(
                      radius: 20.toWidth,
                      backgroundImage: MemoryImage(image as Uint8List),
                    )
                  : CircleAvatar(
                      radius: 20.toWidth,
                      backgroundColor: const Color(0xFF565656),
                      child: ContactInitial(
                        initials: title ?? ' ',
                        minSize: 50.0,
                        maxSize: 50.0,
                      ),
                    ),
            ),
            icon != null
                ? Positioned(
                    top: isTopRight ? 0 : null,
                    right: 0,
                    bottom: !isTopRight ? 0 : null,
                    child: Icon(icon))
                : const SizedBox(),
          ],
        ),
        SizedBox(width: 10.toHeight),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: title != null
                  ? Text(
                      title!,
                      style: CustomTextStyles().grey16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : const SizedBox(),
            ),
            SizedBox(height: 5.toHeight),
            subTitle != null
                ? Text(
                    subTitle!,
                    style: CustomTextStyles().grey14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox(),
          ],
        )
      ],
    );
  }
}
