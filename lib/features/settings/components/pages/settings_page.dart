import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/config/theme/theme_provider.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/core/resources/widgets/colored_safe_area_body.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/settings/components/widgets/settings_card.dart';
import 'package:training_partner/features/settings/logic/cubits/settings_cubit.dart';
import 'package:training_partner/features/settings/logic/cubits/user_delete_cubit.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:wakelock/wakelock.dart';

class SettingsPage extends StatefulWidget {
  final AppSettings settings;

  const SettingsPage({super.key, required this.settings});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode currentTheme;
  late WeightUnit currentWeightUnit;
  late DistanceUnit currentDistanceUnit;

  late bool is24HourFormat;
  late bool isSleepPrevented;

  late SettingsCubit settingsCubit;

  @override
  void initState() {
    super.initState();

    currentTheme = widget.settings.theme;
    currentWeightUnit = widget.settings.weightUnit;
    currentDistanceUnit = widget.settings.distanceUnit;
    is24HourFormat = widget.settings.is24HourFormat;
    isSleepPrevented = widget.settings.isSleepPrevented;

    settingsCubit = context.read<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (allowed) async {
        settingsCubit.updateSettings(AppSettings(
          theme: currentTheme,
          weightUnit: currentWeightUnit,
          distanceUnit: currentDistanceUnit,
          is24HourFormat: is24HourFormat,
          isSleepPrevented: isSleepPrevented,
        ));
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ColoredSafeAreaBody(
          safeAreaColor: Theme.of(context).colorScheme.background,
          isLightTheme: Theme.of(context).brightness == Brightness.light,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomBackButton(context: context),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Omnes',
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: _getBodyContent(),
                ),
              ),
              _getDeleteAccountCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: const EdgeInsets.only(left: 7.5), child: Text('Units', style: CustomTextStyle.subtitlePrimary(context))),
        _getWeightCard(),
        _getDistanceCard(),
        _getTimeCard(),
        const SizedBox(height: 25),
        Padding(padding: const EdgeInsets.only(left: 7.5), child: Text('Appearance', style: CustomTextStyle.subtitlePrimary(context))),
        _getThemePickerCard(),
        _getAwakeCard(),
      ],
    );
  }

  Widget _getWeightCard() {
    return SettingsCard(
      icon: Icon(FontAwesomeIcons.weightScale, color: Theme.of(context).colorScheme.secondary),
      title: 'Weight',
      isFirst: true,
      child: CupertinoSlidingSegmentedControl<WeightUnit>(
        groupValue: currentWeightUnit,
        padding: const EdgeInsets.all(5),
        onValueChanged: (value) {
          setState(() {
            currentWeightUnit = value!;
          });
        },
        children: {
          WeightUnit.kg: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            child: Text(
              'kg',
              style: currentWeightUnit == WeightUnit.kg ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
              textAlign: TextAlign.center,
            ),
          ),
          WeightUnit.lbs: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
            child: Text(
              'lbs',
              style: currentWeightUnit == WeightUnit.lbs ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
              textAlign: TextAlign.center,
            ),
          ),
        },
      ),
    );
  }

  Widget _getDistanceCard() {
    return SettingsCard(
      icon: Icon(FontAwesomeIcons.ruler, color: Theme.of(context).colorScheme.secondary),
      title: 'Distance',
      isFirst: true,
      isLast: true,
      child: CupertinoSlidingSegmentedControl<DistanceUnit>(
        groupValue: currentDistanceUnit,
        padding: const EdgeInsets.all(5),
        onValueChanged: (value) {
          setState(() {
            currentDistanceUnit = value!;
          });
        },
        children: {
          DistanceUnit.km: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              'km',
              style: currentDistanceUnit == DistanceUnit.km ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
              textAlign: TextAlign.center,
            ),
          ),
          DistanceUnit.miles: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              'miles',
              style:
                  currentDistanceUnit == DistanceUnit.miles ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
              textAlign: TextAlign.center,
            ),
          ),
        },
      ),
    );
  }

  Widget _getTimeCard() {
    return SettingsCard(
      icon: Icon(FontAwesomeIcons.solidClock, color: Theme.of(context).colorScheme.secondary),
      title: '24 hour format',
      isLast: true,
      child: CupertinoSwitch(
        value: is24HourFormat,
        onChanged: (value) {
          setState(() {
            is24HourFormat = value;
          });

          setState(() {});
        },
      ),
    );
  }

  Widget _getThemePickerCard() {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: CupertinoSlidingSegmentedControl<ThemeMode>(
                groupValue: currentTheme,
                padding: const EdgeInsets.all(5),
                onValueChanged: (value) {
                  setState(() {
                    currentTheme = value!;
                    _onThemeChanged(context, currentTheme);
                  });
                },
                children: {
                  ThemeMode.system: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'System default',
                      style:
                          currentTheme == ThemeMode.system ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ThemeMode.light: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Light theme',
                      style:
                          currentTheme == ThemeMode.light ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ThemeMode.dark: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Dark theme',
                      style: currentTheme == ThemeMode.dark ? CustomTextStyle.bodySmallPrimary(context) : CustomTextStyle.bodySmallSecondary(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAwakeCard() {
    return SettingsCard(
      icon: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: Icon(FontAwesomeIcons.bed, color: Theme.of(context).colorScheme.secondary, size: 20),
      ),
      title: 'Keep phone awake',
      isLast: true,
      child: CupertinoSwitch(
        value: isSleepPrevented,
        onChanged: (value) {
          setState(() {
            isSleepPrevented = value;
          });

          if (isSleepPrevented) {
            Wakelock.enable();
          } else {
            Wakelock.disable();
          }
        },
      ),
    );
  }

  Widget _getDeleteAccountCard() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text('Last login: ${DateTimeUtil.dateToStringWithHour(currentUser.metadata.lastSignInTime!, is24HourFormat)}',
              style: CustomTextStyle.bodySmallSecondary(context)),
          const SizedBox(height: 5),
          Card(
            elevation: 0,
            shape: defaultCornerShape,
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: defaultBorderRadius,
              onTap: () {
                context.read<UserDeleteCubit>().deleteUser();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.trash, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      'Delete Account',
                      style: CustomTextStyle.getCustomTextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onThemeChanged(BuildContext context, ThemeMode newMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setThemeMode(newMode);
  }
}
