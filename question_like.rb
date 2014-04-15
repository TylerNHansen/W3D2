require './questionsdatabase'
require './question'

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    QuestionLike.new(data.first)
  end

  def self.likers_for_question_id(q_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        question_likes
      JOIN
        users
      ON
        users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL

    data.map { |d| User.new(d) }
  end

  def self.num_likes_for_question_id(q_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, q_id)
    SELECT
      COUNT(1)
    FROM
      question_likes
    WHERE
      question_likes.question_id = ?
    SQL
    data.first.values.first # data is an array with a single hash as element
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      JOIN
        questions
      ON
        questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL

    data.map { |d| Question.new(d) }
  end

  def self.most_liked_questions(n)
    # Refactor to use LIMIT
    question_data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      questions.*
    FROM
      question_likes
    JOIN
      questions
    ON
      questions.id = question_likes.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(question_likes.user_id) DESC
    SQL
    question_data.take(n).map { |qd| Question.new(qd) }
  end

  def initialize(op = {})
    p options
    @id, @question_id, @user_id = op['id'], op['question_id'], op['user_id']
  end
end