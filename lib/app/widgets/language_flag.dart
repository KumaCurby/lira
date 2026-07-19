import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Drapeaux **SVG** des langues de l'interface. Rendu identique sur toutes les
/// plateformes (web compris), contrairement aux emojis (« tofu » sur CanvasKit).
const Map<String, String> _flagSvg = {
  'fr':
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
      '<rect width="3" height="2" fill="#ffffff"/>'
      '<rect width="1" height="2" fill="#0055A4"/>'
      '<rect x="2" width="1" height="2" fill="#EF4135"/></svg>',
  'en':
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 30">'
      '<clipPath id="ukc"><path d="M30,15 h30 v15 z v15 h-30 z h-30 v-15 z v-15 h30 z"/></clipPath>'
      '<rect width="60" height="30" fill="#012169"/>'
      '<path d="M0,0 L60,30 M60,0 L0,30" stroke="#ffffff" stroke-width="6"/>'
      '<path d="M0,0 L60,30 M60,0 L0,30" clip-path="url(#ukc)" stroke="#C8102E" stroke-width="4"/>'
      '<path d="M30,0 v30 M0,15 h60" stroke="#ffffff" stroke-width="10"/>'
      '<path d="M30,0 v30 M0,15 h60" stroke="#C8102E" stroke-width="6"/></svg>',
  'es':
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
      '<rect width="3" height="2" fill="#AA151B"/>'
      '<rect y="0.5" width="3" height="1" fill="#F1BF00"/></svg>',
  'it':
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
      '<rect width="3" height="2" fill="#ffffff"/>'
      '<rect width="1" height="2" fill="#009246"/>'
      '<rect x="2" width="1" height="2" fill="#CE2B37"/></svg>',
  'de':
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5 3">'
      '<rect width="5" height="3" fill="#FFCE00"/>'
      '<rect width="5" height="2" fill="#DD0000"/>'
      '<rect width="5" height="1" fill="#000000"/></svg>',
  'pt':
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 20">'
      '<rect width="30" height="20" fill="#DA291C"/>'
      '<rect width="12" height="20" fill="#046A38"/>'
      '<circle cx="12" cy="10" r="4.3" fill="#FFE900"/>'
      '<circle cx="12" cy="10" r="3" fill="#DA291C"/>'
      '<rect x="10.4" y="7.1" width="3.2" height="5.8" rx="0.6" fill="#ffffff" stroke="#002776" stroke-width="0.7"/></svg>',
};

/// Petit drapeau SVG arrondi pour la langue [code].
class LanguageFlag extends StatelessWidget {
  const LanguageFlag({super.key, required this.code, this.width = 26});

  final String code;
  final double width;

  @override
  Widget build(BuildContext context) {
    final svg = _flagSvg[code] ?? _flagSvg['fr']!;
    return Container(
      width: width,
      height: width * 2 / 3,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: SvgPicture.string(svg, fit: BoxFit.fill),
    );
  }
}
