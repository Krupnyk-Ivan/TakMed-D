import 'package:equatable/equatable.dart';
import '../../../march/domain/models/march_step.dart';

/// Мікро-питання після кожного кроку MARCH — перевірка знань.
class MarchQuizQuestion extends Equatable {
  const MarchQuizQuestion({
    required this.step,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final MarchStep step;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  @override
  List<Object?> get props => [step, question, options, correctIndex, explanation];

  /// Стандартні питання для тренувального режиму — по 1 на крок.
  static const List<MarchQuizQuestion> defaults = [
    MarchQuizQuestion(
      step: MarchStep.massiveHemorrhage,
      question: 'Куди саме накладається турнікет CAT?',
      options: [
        '2–3 см вище рани, але не на суглоб',
        'Прямо на рану',
        'Якомога вище на кінцівці',
        'Над колінним суглобом',
      ],
      correctIndex: 0,
      explanation:
          'Турнікет накладається на 2–3 см вище рани (high & tight), оминаючи суглоби. '
          'Якщо рана близько до суглоба — переносимо вище. '
          'Накладання на суглоб неефективне через анатомію (кістки заважають перетиснути судини).',
    ),
    MarchQuizQuestion(
      step: MarchStep.airway,
      question: 'Який маневр відкриває дихальні шляхи при підозрі на травму шиї?',
      options: [
        'Висування нижньої щелепи (jaw thrust)',
        'Закидання голови назад',
        'Нічого не робити — чекати медика',
        'Перевернути на живіт',
      ],
      correctIndex: 0,
      explanation:
          'При підозрі на травму шийного відділу використовуємо jaw thrust — '
          'висування нижньої щелепи без розгинання шиї. '
          'Закидання голови (head-tilt) протипоказане при можливій травмі хребта.',
    ),
    MarchQuizQuestion(
      step: MarchStep.respiration,
      question: 'Що свідчить про напружений пневмоторакс?',
      options: [
        'Однобічне ослаблене дихання + наростаюча задишка + набухання шийних вен',
        'Кашель з мокротинням',
        'Біль у животі',
        'Кровотеча з вуха',
      ],
      correctIndex: 0,
      explanation:
          'Напружений пневмоторакс: однобічне відсутнє/ослаблене дихання, '
          'наростаюча задишка, набряклі шийні вени, гіпотензія, '
          'зміщення трахеї у здоровий бік. Лікування — голкова декомпресія '
          'у 2-му міжребер'
          'ї по середньоключичній лінії.',
    ),
    MarchQuizQuestion(
      step: MarchStep.circulation,
      question: 'Що першочергово перевіряємо у блоці Circulation?',
      options: [
        'Пульс, перфузію, ознаки шоку та приховані кровотечі',
        'Тільки артеріальний тиск',
        'Колір губ',
        'Температуру тіла',
      ],
      correctIndex: 0,
      explanation:
          'C — це не тільки контроль кровотечі. Оцінюємо пульс (наявність/якість), '
          'capillary refill, ознаки шоку (тахікардія, блідість, сплутаність), '
          'шукаємо приховані кровотечі (живіт, таз, стегно). '
          'Якщо є ознаки шоку — інфузія за протоколом.',
    ),
    MarchQuizQuestion(
      step: MarchStep.hypothermia,
      question: 'Що НЕ слід робити при гіпотермії потерпілого?',
      options: [
        'Розтирати кінцівки снігом або алкоголем',
        'Загорнути у термоковдру',
        'Ізолювати від холодної поверхні',
        'Зняти мокрий одяг',
      ],
      correctIndex: 0,
      explanation:
          'Розтирання снігом/алкоголем прискорює тепловтрату і може спровокувати '
          'аритмію через приток холодної крові до серця. '
          'Правильно: ізолювати від холоду, зняти мокре, загорнути у термоковдру, '
          'теплі напої (якщо притомний), пасивне зігрівання.',
    ),
  ];

  static MarchQuizQuestion forStep(MarchStep step) =>
      defaults.firstWhere((q) => q.step == step);
}
