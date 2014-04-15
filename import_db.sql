CREATE TABLE users
(
id INTEGER PRIMARY KEY,
fname TEXT NOT NULL,
lname TEXT NOT NULL
);

CREATE TABLE questions
(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers
(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE replies
(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  reply_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT,

  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes
(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
users(fname, lname)
VALUES
('Bob', 'Dole'),
('Bob', 'Loblaw'),
('Archer', 'Stirling'),
('Ned', 'Stark');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Test post please ignore', "Why wasn't I elected?", (SELECT id FROM users WHERE
    fname = 'Bob' AND lname = 'Dole')),
  ('Test post2 please ignore', 'My law firm is failing! Why?', (SELECT id FROM
    users WHERE fname = 'Bob' AND lname = 'Loblaw'));








