require './questionsdatabase'
require './User'
require './question_follower'

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    Question.new(question_data.first)
  end

  def self.find_by_author_id(id)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    question_data.map { |qd| Question.new(qd) }
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options = {})
    p options
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def save
    if self.id
      update_save
    else
      insert_save
    end
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  protected

  def insert_save
    QuestionsDatabase.instance.execute(<<-SQL, title, body,author_id)
      INSERT INTO
        questions(title, body, author_id)
      VALUES
        (?,?,?);
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update_save
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body,@author_id, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?, author_id = ?
      WHERE
        id = ?
    SQL
  end
end

