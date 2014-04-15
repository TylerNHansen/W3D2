require './questionsdatabase'
require './question'
require './question_follower'
require './reply'

class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.find_by_id(id)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, TABLE, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(user_data.first)
  end

  def self.find_by_name(fname, lname)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    user_data.map { |ud| User.new(ud) }
  end

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def save
    if self.id.nil?
      insert_save
    else
      update_save
    end
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_author_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
    SUM(post_karma) / CAST(COUNT(1) AS float) AS average_karma
    FROM
        (SELECT
          COUNT(1) AS post_karma
        FROM
          question_likes
        JOIN
          questions
        ON
          questions.id = question_likes.question_id AND questions.author_id = ?
        GROUP BY
          questions.id) AS subquery
    SQL
    karma.first.values.first # array with exactly one hash with one value
  end

  protected

  def insert_save
    QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
        users(fname, lname)
      VALUES
        (?,?);
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update_save
    QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end
end













