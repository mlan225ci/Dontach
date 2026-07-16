import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.pinLength,
    required this.enteredLength,
    required this.onDigit,
    required this.onBackspace,
    this.errorText,
  });

  final int pinLength;
  final int enteredLength;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pinLength, (index) {
            final filled = index < enteredLength;
            return Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            );
          }),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(
            errorText!,
            style: const TextStyle(color: Color(0xFFFF8A80), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 28),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', 'back'],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((label) {
                if (label.isEmpty) {
                  return const SizedBox(width: 88, height: 72);
                }
                if (label == 'back') {
                  return _PinKey(
                    child: const Icon(Icons.backspace_outlined, color: Colors.white),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onBackspace();
                    },
                  );
                }
                return _PinKey(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onDigit(label);
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(width: 72, height: 72, child: Center(child: child)),
        ),
      ),
    );
  }
}
