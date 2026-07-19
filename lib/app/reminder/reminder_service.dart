// Sélectionne l'implémentation selon la plateforme : native (mobile/desktop)
// avec notifications locales, ou stub vide sur le web.
export 'reminder_service_stub.dart'
    if (dart.library.io) 'reminder_service_native.dart';
