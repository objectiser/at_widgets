import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/services/onboarding_service.dart';
import 'package:at_onboarding_flutter/utils/at_onboarding_dimens.dart';
import 'package:at_onboarding_flutter/widgets/at_onboarding_button.dart';
import 'package:at_sync_ui_flutter/at_sync_material.dart';
import 'package:flutter/material.dart';

import '../at_onboarding.dart';
import '../services/at_onboarding_config.dart';
import '../widgets/at_onboarding_dialog.dart';

class AtOnboardingStartScreen extends StatefulWidget {
  final AtOnboardingConfig config;

  const AtOnboardingStartScreen({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  _AtOnboardingStartScreenState createState() =>
      _AtOnboardingStartScreenState();
}

class _AtOnboardingStartScreenState extends State<AtOnboardingStartScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final OnboardingService _onboardingService =
        OnboardingService.getInstance();
    final isUsingSharedStorage =
        await _onboardingService.isUsingSharedStorage();
    if (isUsingSharedStorage == null) {
      //No defind yet
      final result = await askUserUseSharedStorage();
      await _onboardingService.initialSetup(usingSharedStorage: result);
    } else {
      await _onboardingService.initialSetup(
          usingSharedStorage: isUsingSharedStorage);
    }

    _onboardingService.setAtClientPreference = widget.config.atClientPreference;
    try {
      final result = await _onboardingService.onboard();
      debugPrint("AtOnboardingInitScreen: result - $result");
      Navigator.pop(context, AtOnboardingResult.success);
    } catch (e) {
      debugPrint("AtOnboardingInitScreen: error - $e");
      if (e == OnboardingStatus.ATSIGN_NOT_FOUND ||
          e == OnboardingStatus.PRIVATE_KEY_NOT_FOUND) {
        final result = await AtOnboarding.start(
          context: context,
          config: widget.config,
        );
        Navigator.pop(context, result);
      } else if (e == OnboardingStatus.ACTIVATE) {
        final result = await AtOnboarding.activateAccount(
          context: context,
        );
        Navigator.pop(context, result);
      } else {
        Navigator.pop(context, AtOnboardingResult.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AtOnboardingDimens.paddingNormal),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            AtSyncIndicator(),
            SizedBox(width: AtOnboardingDimens.paddingSmall),
            Text('Onboarding'),
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              BorderRadius.circular(AtOnboardingDimens.dialogBorderRadius),
        ),
      ),
    );
  }

  Future<bool> askUserUseSharedStorage() async {
    final result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AtOnboardingDialog(
            title:
                'Do you want to share this onboarded atsign with other apps on @platform?',
            message:
                'This would save you the process to onboard this atsign on other apps again.',
            actions: [
              AtOnboardingSecondaryButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              AtOnboardingPrimaryButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
    if (result is bool) {
      return result;
    }
    return false;
  }
}
