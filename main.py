import json
import mariadb
from datetime import date

def get_json_objects(file='combined.json'):
    with open(file, encoding='utf-8') as file:
        y = json.loads(file.read())
        return y


conn = mariadb.connect(
        user="root",
        password="pgeti",
        host="localhost",
        port=3306,
        database="astronomy_app"
    )

cursor = conn.cursor()

json_dict = get_json_objects()

photos = json_dict['photos']
sections = json_dict['sections']

# insert photos - WORKING CORRECTLY
for p in photos:
    try:
        cursor.execute("INSERT INTO PHOTOS (id, url, title, alt) VALUES (?, ?, ?, ?)", (p['id'], p['url'], p['title'], p['alt']))
    except mariadb.Error as e:
        print(e)
        print("Proceeding with normal operation")
conn.commit()


# insert sections
section_id = 1
chapter_id = 1
topic_id = 1
paragraph_id = 1
test_id = 1
question_id = 1
answer_id = 1

for s in sections:
    section_time_investment = 0

    for chapter in s['chapters']:
        for topic in chapter['topics']:
            section_time_investment += int(topic['time_investment'])


    try:
        cursor.execute("INSERT INTO SECTIONS (id, title, summary, photo_id, time_investment) VALUES (?, ?, ?, ?, ?)",
                       (section_id, s['title'], s['summary'], s['photo_id'], section_time_investment))
    except mariadb.Error as e:
        print(e)
        print("Proceeding with normal operation")
    conn.commit()

    # insert chapters

    for c in s['chapters']:
        chapter_time_investment = 0
        for topic in c['topics']:
            chapter_time_investment += int(topic['time_investment'])

        # chapter data
        try:
            cursor.execute(
                "INSERT INTO CHAPTERS (id, title, summary, time_investment, sections_id) VALUES (?, ?, ?, ?, ?)",
                (chapter_id, c['title'], c['summary'], chapter_time_investment, section_id))
            conn.commit()

            if c['photos'] != None:
                for pid in c['photos']:
                    cursor.execute("INSERT INTO CHAPTERS_PHOTOS (chapters_id, photos_id) VALUES (?, ?)", (chapter_id, pid))
                    conn.commit()
        except mariadb.Error as e:
            print(e)
            print("Proceeding with normal operation")


        for topic in c['topics']:
            try:
                cursor.execute("INSERT INTO TOPICS (id, title, visits, time_investment, edit_date, difficulty, chapters_id) VALUES (?, ?, ?, ?, ?, ?, ?)",
                               (topic_id, topic['title'], 0, topic['time_investment'], date.today(), topic['difficulty'], chapter_id))
                conn.commit()

                if topic['photos'] != None:
                    for pid in topic['photos']:
                        cursor.execute("INSERT INTO TOPICS_PHOTOS (topics_id, photos_id) VALUES (?, ?)",
                                       (topic_id, pid))
                        conn.commit()

            except mariadb.Error as e:
                print(e)
                print("Proceeding with normal operation")

            # paragraphs

            for p in topic['paragraphs']:
                try:
                    cursor.execute('INSERT INTO PARAGRAPHS (id, title, text, topics_id) VALUES (?, ?, ?, ?)',
                                   (paragraph_id, p['title'], p['text'], topic_id))
                    conn.commit()

                    if p['photos'] != None:
                        for pid in p['photos']:
                            cursor.execute('INSERT INTO PARAGRAPHS_PHOTOS (paragraphs_id, photos_id) VALUES (?, ?)',
                                       (paragraph_id, pid))
                            conn.commit()

                except mariadb.Error as e:
                    print(e)
                    print("Proceeding with normal operation")
                paragraph_id += 1

            topic_id += 1

        # tests
        if c['tests'] != None:
            for test in c['tests']:

                try:
                    cursor.execute('INSERT INTO TESTS (id, title, number_of_questions, chapters_id) VALUES (?, ?, ?, ?)',
                                   (test_id, test['title'], test['number_of_questions'], chapter_id))
                    conn.commit()

                    for question in test['questions']:
                        cursor.execute('INSERT INTO QUESTIONS (id, question, photo_id, tests_id) VALUES (?,?,?,?)',
                                           (question_id, question['question'], question['photo'], test_id))
                        conn.commit()

                        for answer in question['answers']:
                            cursor.execute('INSERT INTO ANSWERS (id, text, is_correct, photo_id, questions_id) VALUES (?,?,?,?,?)',
                                           (answer_id, answer['text'], answer['is_correct'], answer['photo'], question_id))
                            conn.commit()
                            answer_id += 1

                        question_id += 1

                except mariadb.Error as e:
                    print(e)
                    print("Proceeding with normal operation")

                test_id += 1

        chapter_id += 1



    section_id += 1




conn.close()



