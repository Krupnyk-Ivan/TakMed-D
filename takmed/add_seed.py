import json

with open('tccc_questions_10.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

json_str = json.dumps(data, ensure_ascii=False).replace("'", "\\'")

with open('lib/core/database/seed_data.dart', 'a', encoding='utf-8') as f:
    f.write(f"\n  static const _examQuiz = '{json_str}';\n")
