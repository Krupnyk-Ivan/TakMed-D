import 'package:drift/drift.dart';
import 'app_database.dart';

/// Seed дані для першого запуску — тактична медицина.
class SeedData {
  /// Заповнює DB якщо порожня.
  static Future<void> seedIfEmpty(AppDatabase db) async {
    final existing = await db.courseDao.getAllCourses();
    final hasExam = existing.any((c) => c.remoteId == 'exam-1');
    final hasMarchLettersCourse = existing.any((c) => c.remoteId == 'mil-4');
    final now = DateTime.now();

    if (existing.isEmpty) {
      // --- MILITARY COURSES ---
      final c1 = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'mil-1',
          title: 'MARCH алгоритм',
          orderIndex: 0,
          description:
              'Покроковий алгоритм надання допомоги пораненому в бойових умовах',
          track: 'military',
          totalLessons: const Value(3),
          updatedAt: now,
        ),
      );
      final c2 = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'mil-2',
          title: 'Турнікети та гемостатики',
          orderIndex: 1,
          description: 'Зупинка масивної кровотечі: CAT, SOFT-T, QuikClot',
          track: 'military',
          totalLessons: const Value(3),
          updatedAt: now,
        ),
      );
      final c3 = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'mil-3',
          title: 'Chest Seals та пневмоторакс',
          orderIndex: 2,
          description:
              'Розпізнавання та лікування проникаючих поранень грудної клітки',
          track: 'military',
          totalLessons: const Value(3),
          updatedAt: now,
        ),
      );

      // --- CIVILIAN COURSES ---
      final c4 = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'civ-1',
          title: 'Перша допомога: основи',
          orderIndex: 0,
          description: 'Базові навички першої допомоги для повсякденного життя',
          track: 'civilian',
          totalLessons: const Value(3),
          updatedAt: now,
        ),
      );
      final c5 = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'civ-2',
          title: 'СЛР та AED',
          orderIndex: 1,
          description:
              'Серцево-легенева реанімація та використання дефібрилятора',
          track: 'civilian',
          totalLessons: const Value(3),
          updatedAt: now,
        ),
      );
      final c6 = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'civ-3',
          title: 'Кровотечі та рани',
          orderIndex: 2,
          description: 'Зупинка кровотечі, обробка ран, накладання пов\'язок',
          track: 'civilian',
          totalLessons: const Value(3),
          updatedAt: now,
        ),
      );

      // --- LESSONS ---
      await _seedMilitaryLessons(db, c1, c2, c3);
      await _seedCivilianLessons(db, c4, c5, c6);
    }

    if (!hasMarchLettersCourse) {
      final cMarchLetters = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'mil-4',
          title: 'MARCH по літерах: практичний курс',
          orderIndex: hasExam ? 4 : 3,
          description:
              'Поглиблений курс: для кожної літери MARCH окремий урок і тест',
          track: 'military',
          totalLessons: const Value(10),
          updatedAt: now,
        ),
      );

      await _seedMarchLettersLessons(db, cMarchLetters);
    }

    if (!hasExam) {
      final cExam = await db.courseDao.upsertCourse(
        CoursesCompanion.insert(
          remoteId: 'exam-1',
          title: 'Екзамен TCCC 2021',
          orderIndex: 4,
          description:
              'Фінальний іспит зі знань протоколів TCCC 2021 (10 питань)',
          track: 'military',
          totalLessons: const Value(1),
          updatedAt: now,
        ),
      );

      await db.lessonDao.upsertLesson(
        LessonsCompanion.insert(
          remoteId: 'exam-1-1',
          courseId: cExam,
          type: 'quiz',
          orderIndex: 0,
          title: 'Тест: Екзамен TCCC 2021',
          durationSeconds: 600,
          contentJson: _examQuiz,
        ),
      );
    }
  }

  static Future<void> _seedMilitaryLessons(
    AppDatabase db,
    int c1,
    int c2,
    int c3,
  ) async {
    // C1: MARCH
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-1-1',
        courseId: c1,
        type: 'theory',
        orderIndex: 0,
        title: 'Що таке MARCH?',
        durationSeconds: 300,
        contentJson: _marchTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-1-2',
        courseId: c1,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: MARCH алгоритм',
        durationSeconds: 180,
        contentJson: _marchQuiz,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-1-3',
        courseId: c1,
        type: 'checklist',
        orderIndex: 2,
        title: 'Чеклист: MARCH на практиці',
        durationSeconds: 240,
        contentJson: _marchChecklist,
      ),
    );

    // C2: Турнікети
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-2-1',
        courseId: c2,
        type: 'theory',
        orderIndex: 0,
        title: 'Типи турнікетів',
        durationSeconds: 360,
        contentJson: _tourniquetTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-2-2',
        courseId: c2,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: Турнікети',
        durationSeconds: 180,
        contentJson: _tourniquetQuiz,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-2-3',
        courseId: c2,
        type: 'checklist',
        orderIndex: 2,
        title: 'Чеклист: Накладання CAT',
        durationSeconds: 300,
        contentJson: _catChecklist,
      ),
    );

    // C3: Chest Seals
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-3-1',
        courseId: c3,
        type: 'theory',
        orderIndex: 0,
        title: 'Пневмоторакс: розпізнавання',
        durationSeconds: 420,
        contentJson: _chestSealTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-3-2',
        courseId: c3,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: Chest Seals',
        durationSeconds: 180,
        contentJson: _chestSealQuiz,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-3-3',
        courseId: c3,
        type: 'checklist',
        orderIndex: 2,
        title: 'Чеклист: Chest Seal',
        durationSeconds: 240,
        contentJson: _chestSealChecklist,
      ),
    );
  }

  static Future<void> _seedCivilianLessons(
    AppDatabase db,
    int c4,
    int c5,
    int c6,
  ) async {
    // C4: Перша допомога
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-1-1',
        courseId: c4,
        type: 'theory',
        orderIndex: 0,
        title: 'Оцінка ситуації',
        durationSeconds: 300,
        contentJson: _firstAidTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-1-2',
        courseId: c4,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: Базові принципи',
        durationSeconds: 180,
        contentJson: _firstAidQuiz,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-1-3',
        courseId: c4,
        type: 'checklist',
        orderIndex: 2,
        title: 'Чеклист: Аптечка',
        durationSeconds: 180,
        contentJson: _firstAidChecklist,
      ),
    );

    // C5: СЛР
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-2-1',
        courseId: c5,
        type: 'theory',
        orderIndex: 0,
        title: 'Як виконувати СЛР',
        durationSeconds: 360,
        contentJson: _cprTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-2-2',
        courseId: c5,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: СЛР',
        durationSeconds: 180,
        contentJson: _cprQuiz,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-2-3',
        courseId: c5,
        type: 'checklist',
        orderIndex: 2,
        title: 'Чеклист: СЛР алгоритм',
        durationSeconds: 240,
        contentJson: _cprChecklist,
      ),
    );

    // C6: Кровотечі
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-3-1',
        courseId: c6,
        type: 'theory',
        orderIndex: 0,
        title: 'Типи кровотеч',
        durationSeconds: 300,
        contentJson: _bleedingTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-3-2',
        courseId: c6,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: Кровотечі',
        durationSeconds: 180,
        contentJson: _bleedingQuiz,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'civ-3-3',
        courseId: c6,
        type: 'checklist',
        orderIndex: 2,
        title: 'Чеклист: Тиснуча пов\'язка',
        durationSeconds: 240,
        contentJson: _bleedingChecklist,
      ),
    );
  }

  static Future<void> _seedMarchLettersLessons(
    AppDatabase db,
    int courseId,
  ) async {
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-1',
        courseId: courseId,
        type: 'theory',
        orderIndex: 0,
        title: 'M: Зупинка масивної кровотечі',
        durationSeconds: 420,
        contentJson: _marchMTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-2',
        courseId: courseId,
        type: 'quiz',
        orderIndex: 1,
        title: 'Тест: M — Massive bleeding',
        durationSeconds: 180,
        contentJson: _marchMQuiz,
      ),
    );

    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-3',
        courseId: courseId,
        type: 'theory',
        orderIndex: 2,
        title: 'A: Контроль дихальних шляхів',
        durationSeconds: 420,
        contentJson: _marchATheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-4',
        courseId: courseId,
        type: 'quiz',
        orderIndex: 3,
        title: 'Тест: A — Airway',
        durationSeconds: 180,
        contentJson: _marchAQuiz,
      ),
    );

    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-5',
        courseId: courseId,
        type: 'theory',
        orderIndex: 4,
        title: 'R: Оцінка та підтримка дихання',
        durationSeconds: 420,
        contentJson: _marchRTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-6',
        courseId: courseId,
        type: 'quiz',
        orderIndex: 5,
        title: 'Тест: R — Respiration',
        durationSeconds: 180,
        contentJson: _marchRQuiz,
      ),
    );

    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-7',
        courseId: courseId,
        type: 'theory',
        orderIndex: 6,
        title: 'C: Відновлення кровообігу',
        durationSeconds: 420,
        contentJson: _marchCTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-8',
        courseId: courseId,
        type: 'quiz',
        orderIndex: 7,
        title: 'Тест: C — Circulation',
        durationSeconds: 180,
        contentJson: _marchCQuiz,
      ),
    );

    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-9',
        courseId: courseId,
        type: 'theory',
        orderIndex: 8,
        title: 'H: Гіпотермія і травма голови',
        durationSeconds: 420,
        contentJson: _marchHTheory,
      ),
    );
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'mil-4-10',
        courseId: courseId,
        type: 'quiz',
        orderIndex: 9,
        title: 'Тест: H — Hypothermia / Head injury',
        durationSeconds: 180,
        contentJson: _marchHQuiz,
      ),
    );
  }

  // ──── CONTENT JSON ────

  static const _marchTheory =
      '{"title":"Що таке MARCH?","blocks":[{"type":"heading","text":"MARCH — алгоритм порятунку","level":1},{"type":"text","text":"MARCH — це акронім, який використовують медики НАТО для пріоритетної оцінки поранених у бойових умовах."},{"type":"warning","text":"Порядок букв = порядок дій. Ніколи не пропускайте етапи!"},{"type":"heading","text":"Розшифровка","level":2},{"type":"text","text":"M — Massive hemorrhage (Масивна кровотеча)\\nA — Airway (Дихальні шляхи)\\nR — Respiration (Дихання)\\nC — Circulation (Кровообіг)\\nH — Hypothermia (Гіпотермія)"},{"type":"info","text":"Масивна кровотеча — головна причина запобіжних смертей на полі бою. Саме тому вона стоїть першою."},{"type":"text","text":"Кожен етап MARCH вимагає конкретних дій та обладнання. У наступних уроках ми розглянемо кожен етап детально."}],"keyTerms":["MARCH","Масивна кровотеча","Дихальні шляхи","Гіпотермія","Тактична медицина"]}';

  static const _marchQuiz =
      '{"questions":[{"question":"Що означає буква M у MARCH?","options":["Medical aid","Massive hemorrhage","Movement","Morphine"],"correctIndex":1,"explanation":"M = Massive hemorrhage — масивна кровотеча. Це перший і найважливіший крок."},{"question":"Який правильний порядок MARCH?","options":["Airway → Breathing → Circulation","Massive hemorrhage → Airway → Respiration → Circulation → Hypothermia","Hypothermia → Circulation → Respiration","Circulation → Airway → Massive hemorrhage"],"correctIndex":1},{"question":"Чому масивна кровотеча стоїть першою?","options":["Бо її легше лікувати","Бо це головна причина запобіжних смертей","Бо так зручніше запам\'ятати","Бо інші етапи менш важливі"],"correctIndex":1}]}';

  static const _marchChecklist =
      '{"steps":[{"title":"M — Зупинити кровотечу","description":"Накласти турнікет або тиснучу пов\'язку на місце масивної кровотечі"},{"title":"A — Відкрити дихальні шляхи","description":"Перевірити прохідність дихальних шляхів, за потреби — назофарингеальний повітровод"},{"title":"R — Перевірити дихання","description":"Огляд грудної клітки на наявність ран, накласти chest seal за потреби"},{"title":"C — Оцінити кровообіг","description":"Перевірити пульс, накласти IV доступ за потреби"},{"title":"H — Запобігти гіпотермії","description":"Вкрити постраждалого термоковдрою, ізолювати від землі"}]}';

  static const _marchMTheory =
      '{"title":"M — Massive bleeding","blocks":[{"type":"heading","text":"Зупинка масивної кровотечі — перший пріоритет","level":1},{"type":"text","text":"Критична крововтрата може вбити за 2-3 хвилини, тому етап M завжди виконується першим."},{"type":"warning","text":"Поки кровотечу не зупинено, інші втручання мають другорядний пріоритет."},{"type":"heading","text":"Що робити покроково","level":2},{"type":"text","text":"1) Визначте джерело кровотечі.\\n2) Накладіть турнікет на 5-8 см вище рани або максимально високо, якщо рану не видно.\\n3) Затягніть до повної зупинки кровотечі.\\n4) За потреби накладіть другий турнікет вище першого.\\n5) Для зон без можливості турнікета використайте гемостатик і тиснучу пов\'язку.\\n6) Обов\'язково зафіксуйте час накладання."},{"type":"info","text":"Навичка швидкого накладання турнікета під стресом рятує життя частіше за складні маніпуляції."}],"keyTerms":["Massive bleeding","Турнікет","Гемостатик","Тиснуча пов\'язка","Час накладання"]}';

  static const _marchMQuiz =
      '{"questions":[{"question":"Що виконується першим за алгоритмом MARCH?","options":["Відновлення дихання","Зупинка масивної кровотечі","Оцінка свідомості","Профілактика гіпотермії"],"correctIndex":1},{"question":"Якщо джерело кровотечі з кінцівки не видно, турнікет ставлять:","options":["На суглоб","Максимально високо на кінцівку","Нижче рани","Лише на оголену шкіру"],"correctIndex":1},{"question":"Що обов\'язково зробити після накладання турнікета?","options":["Дати воду","Записати час накладання","Зняти через 5 хвилин","Накрити бинтом"],"correctIndex":1,"explanation":"Фіксація часу потрібна для подальшого безпечного ведення постраждалого."}]}';

  static const _marchATheory =
      '{"title":"A — Airway","blocks":[{"type":"heading","text":"Контроль і забезпечення дихальних шляхів","level":1},{"type":"text","text":"Після зупинки масивної кровотечі потрібно переконатись, що повітря вільно проходить у легені."},{"type":"warning","text":"Навіть ідеально зупинена кровотеча не врятує, якщо немає прохідних дихальних шляхів."},{"type":"heading","text":"Базові дії","level":2},{"type":"text","text":"1) Оцініть наявність дихання (дивлюсь-слухаю-відчуваю).\\n2) Очистіть рот від видимих сторонніх мас.\\n3) Виконайте маневр висунення нижньої щелепи або підйом підборіддя.\\n4) Якщо постраждалий без свідомості, але дихає — стабільне бокове положення.\\n5) За наявності навичок використайте назофарингеальний повітровід."},{"type":"info","text":"Якщо постраждалий свідомий і сам обирає позу, в якій легше дихати, не заважайте цій позиції."}],"keyTerms":["Airway","Прохідність дихальних шляхів","Маневр щелепи","НПП","Стабільне бокове положення"]}';

  static const _marchAQuiz =
      '{"questions":[{"question":"Яка ціль етапу A у MARCH?","options":["Профілактика шоку","Забезпечити прохідність дихальних шляхів","Провести декомпресію","Зупинити кровотечу"],"correctIndex":1},{"question":"Постраждалий без свідомості, але дихає. Найкраща дія:","options":["Посадити його","Покласти у стабільне бокове положення","Виконати СЛР","Накласти турнікет"],"correctIndex":1},{"question":"Назофарингеальний повітровід застосовують, щоб:","options":["Підвищити тиск","Підтримати прохідність дихальних шляхів","Зупинити кровотечу","Зменшити біль"],"correctIndex":1}]}';

  static const _marchRTheory =
      '{"title":"R — Respiration","blocks":[{"type":"heading","text":"Оцінка і стабілізація дихання","level":1},{"type":"text","text":"На цьому етапі перевіряють ефективність дихання та виключають небезпечні поранення грудної клітки."},{"type":"warning","text":"Відкрита рана грудної клітки може швидко призвести до критичного стану."},{"type":"heading","text":"Що контролюємо","level":2},{"type":"text","text":"1) Частоту і глибину дихання.\\n2) Наявність поранень грудної клітки спереду і зі спини.\\n3) Ознаки погіршення після накладання оклюзійної наліпки.\\n4) Положення тіла, у якому постраждалому легше дихати."},{"type":"info","text":"За підозри на напружений пневмоторакс потрібні дії згідно з підготовкою і протоколом підрозділу."}],"keyTerms":["Respiration","Chest Seal","Пневмоторакс","Оклюзійна наліпка","Оцінка дихання"]}';

  static const _marchRQuiz =
      '{"questions":[{"question":"Що є ключовою дією при відкритій рані грудної клітки?","options":["Накласти джгут","Накласти оклюзійну наліпку","Дати знеболювальне","Посадити постраждалого"],"correctIndex":1},{"question":"Чому важливо оглядати грудну клітку ще й зі спини?","options":["Щоб перевірити пульс","Можливий другий (вихідний) отвір рани","Щоб накласти пов\'язку на шию","Щоб зняти одяг"],"correctIndex":1},{"question":"Літера R у MARCH означає:","options":["Recovery","Respiration","Rescue","Reassessment"],"correctIndex":1}]}';

  static const _marchCTheory =
      '{"title":"C — Circulation","blocks":[{"type":"heading","text":"Відновлення та контроль кровообігу","level":1},{"type":"text","text":"Після M-A-R етап C допомагає виявити приховану крововтрату і ранні ознаки шоку."},{"type":"warning","text":"Шок розвивається поступово: не пропустіть блідість, холодний піт, сплутаність свідомості."},{"type":"heading","text":"Дії на етапі C","level":2},{"type":"text","text":"1) Перевірте раніше накладені турнікети і бандажі.\\n2) Проведіть повторний огляд від голови до ніг.\\n3) Оцініть периферичний пульс і стан свідомості.\\n4) За потреби посильте контроль кровотечі.\\n5) Підготуйте постраждалого до швидкої евакуації."},{"type":"info","text":"Мета етапу C — не лише знайти проблему, а й не допустити погіршення до передачі медичній ланці."}],"keyTerms":["Circulation","Шок","Периферичний пульс","Повторний огляд","Евакуація"]}';

  static const _marchCQuiz =
      '{"questions":[{"question":"Що перевіряють на етапі C у першу чергу?","options":["Лише зіниці","Кровообіг і ознаки шоку","Тільки температуру тіла","Тільки біль"],"correctIndex":1},{"question":"Слабкий периферичний пульс може свідчити про:","options":["Норму після стресу","Початок шоку","Гіпервентиляцію","Переохолодження без крововтрати"],"correctIndex":1},{"question":"Чому потрібен повторний огляд після M-A-R?","options":["Для звітності","Щоб знайти приховані ушкодження та крововтрату","Щоб скоротити час евакуації","Щоб визначити групу крові"],"correctIndex":1}]}';

  static const _marchHTheory =
      '{"title":"H — Hypothermia / Head injury","blocks":[{"type":"heading","text":"Профілактика гіпотермії і контроль травми голови","level":1},{"type":"text","text":"Навіть у теплу погоду постраждалий з крововтратою швидко втрачає тепло, що погіршує прогноз."},{"type":"warning","text":"Гіпотермія посилює коагулопатію та підвищує ризик смерті, тому етап H обов\'язковий."},{"type":"heading","text":"Практичні дії","level":2},{"type":"text","text":"1) Ізолюйте постраждалого від землі.\\n2) Укутайте термоковдрою або сухими речами.\\n3) При підозрі на ЧМТ контролюйте свідомість і зіниці.\\n4) Не видаляйте сторонні предмети з рани голови/ока.\\n5) Продовжуйте моніторинг до евакуації."},{"type":"info","text":"Етап H завершує первинну стабілізацію і готує постраждалого до безпечного транспортування."}],"keyTerms":["Hypothermia","Head injury","Термоковдра","Моніторинг свідомості","ЧМТ"]}';

  static const _marchHQuiz =
      '{"questions":[{"question":"Навіть у теплу погоду постраждалий може мати гіпотермію через:","options":["Сонячний удар","Крововтрату і шок","Наявність пов\'язки","Високу вологість"],"correctIndex":1},{"question":"Що НЕ можна робити при проникаючій травмі ока/черепа?","options":["Контролювати стан","Накласти пов\'язку","Витягати сторонній предмет","Підготувати евакуацію"],"correctIndex":2},{"question":"Яка дія належить до етапу H?","options":["Накладання турнікета","Ізоляція від холодної поверхні","Маневр висунення щелепи","Накладання chest seal"],"correctIndex":1}]}';

  static const _tourniquetTheory =
      '{"title":"Типи турнікетів","blocks":[{"type":"heading","text":"Турнікет — головний засіб зупинки кровотечі","level":1},{"type":"text","text":"Турнікет — це пристрій для стискання кінцівки з метою повної зупинки артеріальної кровотечі."},{"type":"warning","text":"Турнікет накладається ВИСОКО та ТУГЛО. Пам\'ятайте: біль — це тимчасово, смерть від кровотечі — назавжди."},{"type":"heading","text":"Найпоширеніші типи","level":2},{"type":"text","text":"CAT (Combat Application Tourniquet) — стандарт НАТО. Найпоширеніший у ЗСУ.\\n\\nSOFT-T (Special Operations Forces Tactical Tourniquet) — альтернатива CAT.\\n\\nRATCHET — механічний турнікет з тріскачкою."},{"type":"info","text":"CAT Generation 7+ — найновіша версія. Час накладання одною рукою — 20-30 секунд."}],"keyTerms":["CAT","SOFT-T","Турнікет","Артеріальна кровотеча","Час накладання"]}';

  static const _tourniquetQuiz =
      '{"questions":[{"question":"Який турнікет є стандартом НАТО?","options":["SOFT-T","RATCHET","CAT","SWAT-T"],"correctIndex":2},{"question":"Куди накладається турнікет?","options":["Нижче рани","Якомога вище на кінцівці","На саму рану","На суглоб"],"correctIndex":1,"explanation":"Турнікет накладається якомога вище (high and tight) для повного перекриття кровотоку."},{"question":"Скільки часу має займати накладання CAT одною рукою?","options":["1-2 хвилини","5 хвилин","20-30 секунд","10 секунд"],"correctIndex":2}]}';

  static const _catChecklist =
      '{"steps":[{"title":"Витягніть CAT з чохла","description":"Тримайте турнікет напоготові, вільний кінець стрічки вже продітий через пряжку"},{"title":"Накладіть високо на кінцівку","description":"Розмістіть якомога ближче до тулуба (high and tight)"},{"title":"Затягніть стрічку","description":"Протягніть вільний кінець через пряжку та затягніть максимально туго"},{"title":"Закрутіть windlass","description":"Крутіть пластикову паличку доки кровотеча не зупиниться повністю"},{"title":"Зафіксуйте windlass","description":"Закріпіть паличку у тримачі (clip)"},{"title":"Запишіть час","description":"Напишіть час накладання на стрічці маркером"}]}';

  static const _chestSealTheory =
      '{"title":"Пневмоторакс","blocks":[{"type":"heading","text":"Проникаюче поранення грудної клітки","level":1},{"type":"text","text":"Проникаюче поранення грудної клітки може призвести до пневмотораксу — потрапляння повітря у плевральну порожнину."},{"type":"warning","text":"Напружений пневмоторакс — загроза життю! Потребує негайної декомпресії."},{"type":"heading","text":"Ознаки","level":2},{"type":"text","text":"• Задишка, що наростає\\n• Відсутність дихальних звуків з одного боку\\n• Підшкірна емфізема (хрускіт при натисканні)\\n• Девіація трахеї (пізня ознака)"},{"type":"info","text":"Chest Seal — оклюзійна пов\'язка з клапаном. Накладається на рану для запобігання потраплянню повітря."}],"keyTerms":["Пневмоторакс","Chest Seal","Декомпресія","Плевральна порожнина","Оклюзійна пов\'язка"]}';

  static const _chestSealQuiz =
      '{"questions":[{"question":"Що таке пневмоторакс?","options":["Кровотеча в легені","Потрапляння повітря у плевральну порожнину","Зупинка серця","Перелом ребер"],"correctIndex":1},{"question":"Що таке Chest Seal?","options":["Бинт","Турнікет","Оклюзійна пов\'язка з клапаном","Шина"],"correctIndex":2},{"question":"Яка ознака НЕ характерна для пневмотораксу?","options":["Задишка","Підвищений апетит","Підшкірна емфізема","Відсутність дихальних звуків"],"correctIndex":1}]}';

  static const _chestSealChecklist =
      '{"steps":[{"title":"Оголіть рану","description":"Зніміть одяг навколо рани грудної клітки"},{"title":"Очистіть шкіру","description":"Витріть шкіру навколо рани для кращого прилипання"},{"title":"Накладіть Chest Seal","description":"Розмістіть пов\'язку клапаном назовні, щільно притисніть"},{"title":"Перевірте вхідний та вихідний отвори","description":"Шукайте вихідний отвір на спині — може потребувати другого seal"},{"title":"Моніторинг","description":"Спостерігайте за диханням, при погіршенні — зніміть seal на 1-2 секунди"}]}';

  static const _firstAidTheory =
      '{"title":"Оцінка ситуації","blocks":[{"type":"heading","text":"Безпека — перш за все","level":1},{"type":"text","text":"Перед наданням першої допомоги завжди оцініть ситуацію. Ви не зможете допомогти, якщо самі станете постраждалим."},{"type":"warning","text":"Ніколи не наближайтесь до постраждалого, якщо місце небезпечне!"},{"type":"heading","text":"Алгоритм дій","level":2},{"type":"text","text":"1. Оцініть безпеку\\n2. Перевірте свідомість постраждалого\\n3. Викличте 103 (швидка)\\n4. Надайте першу допомогу\\n5. Не залишайте постраждалого до приїзду медиків"},{"type":"info","text":"Номер екстреної допомоги в Україні: 103 (швидка), 101 (пожежна), 102 (поліція), або єдиний 112."}],"keyTerms":["Безпека","103","Свідомість","Алгоритм дій","Екстрена допомога"]}';

  static const _firstAidQuiz =
      '{"questions":[{"question":"Що потрібно зробити ПЕРШИМ при наданні допомоги?","options":["Почати СЛР","Оцінити безпеку","Зателефонувати 103","Накласти пов\'язку"],"correctIndex":1},{"question":"Який номер швидкої допомоги в Україні?","options":["911","103","112","101"],"correctIndex":1,"explanation":"103 — швидка допомога. 112 — єдиний номер екстреної допомоги."},{"question":"Що робити, якщо місце небезпечне?","options":["Все одно допомагати","Чекати допомоги та не наближатись","Тікати","Кричати"],"correctIndex":1}]}';

  static const _firstAidChecklist =
      '{"steps":[{"title":"Аптечка першої допомоги","description":"Перевірте наявність: бинти, пластирі, антисептик, рукавички"},{"title":"Рукавички","description":"Нітрилові або латексні рукавички — 2-3 пари"},{"title":"Бинти та серветки","description":"Стерильні марлеві серветки різних розмірів"},{"title":"Антисептик","description":"Хлоргексидин або перекис водню"},{"title":"Ножиці та пінцет","description":"Для розрізання одягу та видалення сторонніх предметів"}]}';

  static const _cprTheory =
      '{"title":"Серцево-легенева реанімація","blocks":[{"type":"heading","text":"СЛР — врятуй життя за 5 хвилин","level":1},{"type":"text","text":"Серцево-легенева реанімація (СЛР) — це комплекс дій для підтримки кровообігу та дихання у людини із зупинкою серця."},{"type":"warning","text":"Мозок починає гинути через 4-6 хвилин без кисню. Кожна секунда на рахунку!"},{"type":"heading","text":"Техніка компресій","level":2},{"type":"text","text":"• Глибина: 5-6 см\\n• Частота: 100-120 на хвилину\\n• Співвідношення: 30 компресій : 2 вдихи\\n• Місце: нижня третина грудини"},{"type":"info","text":"Натискайте в ритмі пісні Staying Alive — це приблизно 100-120 ударів на хвилину."}],"keyTerms":["СЛР","Компресії грудної клітки","AED","30:2","Зупинка серця"]}';

  static const _cprQuiz =
      '{"questions":[{"question":"Яка глибина компресій при СЛР для дорослого?","options":["2-3 см","5-6 см","8-10 см","1-2 см"],"correctIndex":1},{"question":"Яке співвідношення компресій до вдихів?","options":["15:1","30:2","10:2","50:5"],"correctIndex":1},{"question":"Яка частота компресій?","options":["60-80 на хвилину","100-120 на хвилину","140-160 на хвилину","40-60 на хвилину"],"correctIndex":1}]}';

  static const _cprChecklist =
      '{"steps":[{"title":"Перевірте свідомість","description":"Потрусіть за плечі, гучно запитайте: Ви мене чуєте?"},{"title":"Викличте 103","description":"Або попросіть когось зателефонувати та принести AED"},{"title":"Відкрийте дихальні шляхи","description":"Закиньте голову назад, підніміть підборіддя"},{"title":"Перевірте дихання","description":"Дивіться, слухайте, відчувайте — не довше 10 секунд"},{"title":"Почніть компресії","description":"30 компресій глибиною 5-6 см, частота 100-120/хв"},{"title":"2 вдихи","description":"Затисніть ніс, зробіть 2 вдихи рот-у-рот"},{"title":"Продовжуйте цикл 30:2","description":"Не зупиняйтесь до приїзду медиків або появи AED"}]}';

  static const _bleedingTheory =
      '{"title":"Типи кровотеч","blocks":[{"type":"heading","text":"Розпізнавання кровотеч","level":1},{"type":"text","text":"Правильне визначення типу кровотечі допомагає обрати правильний метод зупинки."},{"type":"heading","text":"Артеріальна кровотеча","level":2},{"type":"text","text":"Яскраво-червона кров, б\'є пульсуючим струменем. Найнебезпечніша — смерть може настати за кілька хвилин."},{"type":"warning","text":"Артеріальна кровотеча вимагає негайного накладання турнікету або тиснучої пов\'язки!"},{"type":"heading","text":"Венозна кровотеча","level":2},{"type":"text","text":"Темно-червона кров, тече рівномірно. Зупиняється тиснучою пов\'язкою."},{"type":"heading","text":"Капілярна кровотеча","level":2},{"type":"text","text":"Кров виступає краплями. Зупиняється самостійно або простою пов\'язкою."},{"type":"info","text":"Пряме тиснення на рану — перший і найпростіший метод зупинки будь-якої кровотечі."}],"keyTerms":["Артеріальна кровотеча","Венозна кровотеча","Капілярна кровотеча","Тиснуча пов\'язка","Пряме тиснення"]}';

  static const _bleedingQuiz =
      '{"questions":[{"question":"Яка кровотеча найнебезпечніша?","options":["Капілярна","Венозна","Артеріальна","Всі однаково"],"correctIndex":2},{"question":"Як виглядає артеріальна кровотеча?","options":["Темна кров, тече рівномірно","Яскраво-червона, б\'є струменем","Кров краплями","Чорна кров"],"correctIndex":1},{"question":"Який перший метод зупинки кровотечі?","options":["Турнікет","Джгут","Пряме тиснення на рану","Підняти кінцівку"],"correctIndex":2}]}';

  static const _bleedingChecklist =
      '{"steps":[{"title":"Одягніть рукавички","description":"Захистіть себе від контакту з кров\'ю"},{"title":"Визначте тип кровотечі","description":"Артеріальна (пульсуюча), венозна (рівномірна), капілярна (краплі)"},{"title":"Пряме тиснення","description":"Натисніть на рану стерильною серветкою"},{"title":"Тиснуча пов\'язка","description":"Накладіть тугу пов\'язку поверх серветки"},{"title":"Перевірте ефективність","description":"Кровотеча має зупинитись або значно зменшитись"}]}';

  static const _examQuiz =
      '[{"type": "multiple_choice", "question": "Що є першочерговим завданням на етапі \'Допомога під вогнем\' (Care Under Fire)?", "options": ["Відкриття дихальних шляхів", "Ведення вогню у відповідь та укриття", "Внутрішньовенний доступ", "Запобігання гіпотермії"], "correctIndex": 1, "explanation": "На етапі \'Допомога під вогнем\' найважливішим є придушення ворожого вогню та пошук укриття. Медична допомога обмежується лише зупинкою масивних кровотеч турнікетом.", "tags": ["CUF", "Базові принципи", "Безпека"], "difficulty": "easy"}, {"type": "multiple_choice", "question": "Який препарат рекомендується протоколом TCCC 2021 для знеболення при легкому та помірному болю, якщо поранений у свідомості?", "options": ["Фентаніл (Fentanyl) льодяник 800 мкг", "Кетамін 50 мг в/м", "Мелоксикам 15 мг та Парацетамол 1000 мг (з Pill Pack)", "Морфін 5 мг в/в"], "correctIndex": 2, "explanation": "Відповідно до настанов TCCC (опція знеболення 1), для легкого або помірного болю у пораненого, який може ковтати, використовується таблетований набір (Combat Wound Pill Pack): Парацетамол та Мелоксикам.", "tags": ["TFC", "Медикаменти", "Знеболення", "PAWS"], "difficulty": "medium"}, {"type": "multiple_choice", "question": "Що є основним показанням для переведення з назофарингеального повітроводу на хірургічну крікотиреоїдотомію?", "options": ["Легкий храп пораненого під час сну", "Неможливість підтримувати прохідність дихальних шляхів іншими методами або значна щелепно-лицьова травма", "Відсутність дихання понад 5 секунд", "Наявність пневмотораксу"], "correctIndex": 1, "explanation": "Хірургічна крікотиреоїдотомія виконується тоді, коли попередні методи забезпечення прохідності дихальних шляхів неефективні, або є значні травми обличчя/дихальних шляхів, що роблять їх непрохідними.", "tags": ["TFC", "Airway", "Крікотиреоїдотомія", "MARCH"], "difficulty": "hard"}, {"type": "multiple_choice", "question": "Як протокол TCCC 2021 рекомендує лікувати відкритий пневмоторакс під час \'Допомоги в тактичних умовах\'?", "options": ["Затампонувати рану марлею", "Накласти оклюзійну наклейку (Chest Seal) з клапаном під час видиху", "Ввести знеболювальне", "Накласти турнікет вище рани"], "correctIndex": 1, "explanation": "Всі відкриті або смокчучі рани грудної клітки слід лікувати шляхом негайного накладання вентильованої (з клапаном) оклюзійної наклейки (Chest Seal).", "tags": ["TFC", "Respiration", "Пневмоторакс", "MARCH"], "difficulty": "medium"}, {"type": "multiple_choice", "question": "Скільки часу має пройти перед тим, як турнікет повинен бути замінений на тиснучу пов\'язку (якщо дозволяє ситуація та немає шоку)?", "options": ["Він ніколи не замінюється", "Протягом 2 годин, якщо це можливо", "Відразу після виходу з-під вогню (менше 5 хв)", "Тільки після прибуття до госпіталю (Role 3)"], "correctIndex": 1, "explanation": "Конверсія турнікета (заміна на гемостатик або тиснучу пов\'язку) має відбутися якомога швидше, бажано впродовж 2 годин, якщо поранений не в шоці і кровотечу можна контролювати іншим шляхом.", "tags": ["TFC", "Massive Hemorrhage", "Турнікет", "MARCH"], "difficulty": "medium"}, {"type": "true_false", "question": "При наданні допомоги під вогнем (CUF) єдиним медичним втручанням є накладання турнікета на масивну кровотечу з кінцівок.", "correctAnswer": true, "explanation": "Згідно з TCCC, в зоні \'Допомога під вогнем\' медики та бійці виконують лише зупинку масивної кровотечі за допомогою турнікета. Інші втручання (наприклад, оцінка дихання) відкладаються до переходу в укриття.", "tags": ["CUF", "Безпека", "Турнікет"], "difficulty": "easy"}, {"type": "true_false", "question": "Якщо у пораненого з травмою грудної клітки після накладання Chest Seal наростає задишка, слід одразу провести серцево-легеневу реанімацію (СЛР).", "correctAnswer": false, "explanation": "Наростаюча задишка може свідчити про напружений пневмоторакс. Спершу слід спробувати \'відригнути\' повітря, трохи піднявши наклейку, або виконати голкову декомпресію (NDC). СЛР на полі бою зазвичай не проводиться через травматичну зупинку серця.", "tags": ["TFC", "Respiration", "Декомпресія", "MARCH"], "difficulty": "medium"}, {"type": "true_false", "question": "Транексамова кислота (TXA) має бути введена не пізніше ніж через 3 години після отримання травми для ефективної зупинки внутрішніх кровотеч.", "correctAnswer": true, "explanation": "Згідно з TCCC, 2 г Транексамової кислоти (TXA) слід вводити якомога швидше, але НЕ пізніше ніж через 3 години після поранення. Введення після 3 годин не рекомендується.", "tags": ["TFC", "Circulation", "Медикаменти", "Шок"], "difficulty": "hard"}, {"type": "sequence", "question": "Розташуйте дії в порядку їх виконання під час первинного огляду пораненого (алгоритм MARCH):", "correctOrder": ["Зупинка масивної кровотечі турнікетом", "Оцінка та забезпечення прохідності дихальних шляхів", "Перевірка дихання, накладання Chest Seal", "Оцінка пульсу, лікування шоку, тазовий бандаж", "Огляд на наявність інших ран, запобігання гіпотермії"], "explanation": "Алгоритм MARCH розшифровується як M (Massive hemorrhage), A (Airway), R (Respiration), C (Circulation), H (Hypothermia/Head injuries).", "tags": ["MARCH", "Алгоритм", "Первинний огляд"], "difficulty": "easy"}, {"type": "sequence", "question": "Розташуйте етапи конверсії турнікета у правильному порядку:", "correctOrder": ["Перевірка відсутності шоку (наявність радіального пульсу)", "Оголення рани та очищення її від згустків крові", "Тампонування рани гемостатичним бинтом", "Натискання на затампоновану рану протягом 3 хвилин", "Повільне розслаблення турнікета зі збереженням його на кінцівці", "Накладання тиснучої пов\'язки"], "explanation": "Перед зняттям турнікета слід впевнитись, що пацієнт не в шоці. Далі рана очищується і тампонується гемостатиком (3 хв тиснення). Після цього турнікет повільно розпускається, щоб перевірити зупинку кровотечі, і накладається пов\'язка.", "tags": ["TFC", "Massive Hemorrhage", "Конверсія турнікета"], "difficulty": "hard"}]';
}
