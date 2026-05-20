import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/features/march/domain/models/march_step.dart';
import 'package:takmed/features/march/domain/models/march_step_state.dart';
import 'package:takmed/features/march/presentation/bloc/march_checklist_state.dart';

void main() {
  final now = DateTime.now();
  
  group('MarchChecklistState', () {
    test('successRate should reflect correct percentage of non-failed steps', () {
      final state = MarchChecklistState(
        steps: {
          MarchStep.massiveHemorrhage: StepCompleted(maxTimeSeconds: 120, completedAt: now, elapsedSeconds: 30),
          MarchStep.airway: StepCompleted(maxTimeSeconds: 60, completedAt: now, elapsedSeconds: 30),
          MarchStep.respiration: StepFailed(maxTimeSeconds: 90, reason: 'Bleeding not stopped', failedAt: now),
          MarchStep.circulation: StepCompleted(maxTimeSeconds: 90, completedAt: now, elapsedSeconds: 30),
          MarchStep.hypothermia: StepCompleted(maxTimeSeconds: 120, completedAt: now, elapsedSeconds: 30),
        },
      );

      // 4 out of 5 are not failed = 80%
      expect(state.successRate, 80);
      expect(state.hasCriticalFailure, isTrue);
    });

    test('successRate should be 100% when no steps failed', () {
      final state = MarchChecklistState(
        steps: {
          MarchStep.massiveHemorrhage: StepCompleted(maxTimeSeconds: 120, completedAt: now, elapsedSeconds: 30),
          MarchStep.airway: StepCompleted(maxTimeSeconds: 60, completedAt: now, elapsedSeconds: 30),
          MarchStep.respiration: StepCompleted(maxTimeSeconds: 90, completedAt: now, elapsedSeconds: 30),
          MarchStep.circulation: StepCompleted(maxTimeSeconds: 90, completedAt: now, elapsedSeconds: 30),
          MarchStep.hypothermia: StepCompleted(maxTimeSeconds: 120, completedAt: now, elapsedSeconds: 30),
        },
      );

      expect(state.successRate, 100);
      expect(state.hasCriticalFailure, isFalse);
    });

    test('successRate should be 0% when all steps failed', () {
      final state = MarchChecklistState(
        steps: {
          MarchStep.massiveHemorrhage: StepFailed(maxTimeSeconds: 120, reason: '', failedAt: now),
          MarchStep.airway: StepFailed(maxTimeSeconds: 60, reason: '', failedAt: now),
          MarchStep.respiration: StepFailed(maxTimeSeconds: 90, reason: '', failedAt: now),
          MarchStep.circulation: StepFailed(maxTimeSeconds: 90, reason: '', failedAt: now),
          MarchStep.hypothermia: StepFailed(maxTimeSeconds: 120, reason: '', failedAt: now),
        },
      );

      expect(state.successRate, 0);
    });
  });
}
