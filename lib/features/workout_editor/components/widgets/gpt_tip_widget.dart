import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/resources/gpt/gpt_cubit.dart';
import 'package:training_partner/core/resources/gpt/gpt_state.dart';
import 'package:training_partner/generated/assets.dart';

class GptTipWidget extends StatefulWidget {
  final Function() onTap;
  final bool isTipVisible;

  const GptTipWidget({Key? key, required this.onTap, required this.isTipVisible}) : super(key: key);

  @override
  State<GptTipWidget> createState() => _GptTipWidgetState();
}

class _GptTipWidgetState extends State<GptTipWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF28a08c),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: widget.isTipVisible ? 50 : 0,
      width: double.infinity,
      child: widget.isTipVisible ? _getTipWidgetContent(context) : const SizedBox(),
    );
  }

  Widget _getTipWidgetContent(BuildContext context) {
    return BlocBuilder<GptCubit, GptState>(
      builder: (context, state) {
        if (state is GptResponseLoading || state is GptUninitializedState) {
          return Expanded(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Lottie.asset(Assets.animationsLoadingBar, repeat: true),
              ),
            ),
          );
        } else if (state is GptResponseLoaded) {
          return Expanded(
            child: SizedBox(
              height: 20,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.transparent, Colors.white, Colors.white, Colors.transparent],
                    stops: [0.0, 0.05, 0.95, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Marquee(
                  text: processText(state.message.content),
                  style: CustomTextStyle.bodySmallTetriary(context),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0,
                  velocity: 50,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 2),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 2),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
            ),
          );
        } else if (state is GptResponseError) {
          return Text(state.message, style: CustomTextStyle.bodySmallSecondary(context));
        }

        throw Exception('Unknown state: $state');
      },
    );
  }

  String processText(String text) {
    String withoutNewlines = text.replaceAll('\n', '');

    return withoutNewlines.replaceAllMapped(RegExp(r'(\d+)\.'), (match) {
      return '${match.group(1)}.) ';
    });
  }
}
