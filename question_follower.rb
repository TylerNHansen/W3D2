require './questionsdatabase'
require './User'
require './table'

class QuestionFollower < Table
  attr_accessor :id, :question_id, :user_id

  def self.table_name
    'question_followers'
  end

  def self.followers_for_question_id(q_id)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, q_id)
      SELECT
        *
      FROM
        question_followers
      JOIN
        users
      ON
        question_followers.user_id = users.id
      WHERE
        question_followers.question_id = ?
    SQL
    user_data.map { |ud| User.new(ud) }
  end

  def self.followed_questions_for_user_id(user_id)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      question_followers
    JOIN
      questions
    ON
      question_followers.question_id = questions.id
    WHERE
      question_followers.user_id = ?
    SQL
    question_data.map { |qd| Question.new(qd) }
  end

  def self.most_followed_questions(n)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
    questions.*
    FROM
    question_followers
    JOIN
    questions
    ON
    questions.id = question_followers.question_id
    GROUP BY
    questions.id
    ORDER BY
    COUNT(question_followers.user_id) DESC
    LIMIT ?
    SQL
    question_data.map { |qd| Question.new(qd) }
  end

  def initialize(op = {})
    p options
    @id, @question_id, @user_id = op['id'], op['question_id'], op['user_id']
  end
end