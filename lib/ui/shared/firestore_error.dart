import 'package:cloud_firestore/cloud_firestore.dart';

class UiErrorMessage {
  const UiErrorMessage(this.title, this.body);
  final String title;
  final String body;
}

UiErrorMessage historyErrorMessage(Object error) {
  if (error is FirebaseException) {
    if (error.code == 'failed-precondition') {
      return const UiErrorMessage(
        'Historique indisponible',
        'Cette requête Firestore nécessite un index composite.\n'
            'Voir README > Firestore indexes.',
      );
    }
    if (error.code == 'permission-denied') {
      return const UiErrorMessage(
        'Accès refusé',
        'Tu n\'as pas la permission d\'accéder à l\'historique.',
      );
    }
  }

  return const UiErrorMessage(
    'Une erreur est survenue',
    'Impossible de charger l\'historique pour le moment.',
  );
}
