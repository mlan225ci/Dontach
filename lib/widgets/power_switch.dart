import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dontach/l10n/app_localizations.dart';

class PowerSwitch extends StatelessWidget {
  const PowerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isLoading;

  static const _width = 280.0;
  static const _height = 140.0;
  static const _knobWidth = 116.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const activeColor = Color(0xFF2E7D32);
    const inactiveColor = Color(0xFFE53935);
    final trackColor = value ? activeColor : inactiveColor;
    final labelWidth = (_width - _knobWidth - 20) / 2;

    return Semantics(
      button: true,
      toggled: value,
      label: value ? l10n.switchActiveLabel : l10n.switchInactiveLabel,
      child: GestureDetector(
        onTap: isLoading || onChanged == null
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onChanged!(!value);
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_height / 2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(trackColor, Colors.black, 0.18)!,
                trackColor,
                Color.lerp(trackColor, Colors.white, 0.12)!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: trackColor.withValues(alpha: 0.45),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: _SideLabel(
                      text: l10n.offLabel,
                      active: !value,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  const SizedBox(width: _knobWidth),
                  SizedBox(
                    width: labelWidth,
                    child: _SideLabel(
                      text: l10n.onLabel,
                      active: value,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    width: _knobWidth,
                    height: _knobWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isLoading
                          ? SizedBox(
                              width: 34,
                              height: 34,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: trackColor,
                              ),
                            )
                          : Icon(
                              value ? Icons.shield_rounded : Icons.shield_outlined,
                              size: 42,
                              color: trackColor,
                            ),
                    ),
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

class _SideLabel extends StatelessWidget {
  const _SideLabel({
    required this.text,
    required this.active,
    required this.alignment,
  });

  final String text;
  final bool active;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: active ? 26 : 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Colors.white.withValues(alpha: active ? 0.95 : 0.45),
            ),
          ),
        ),
      ),
    );
  }
}
