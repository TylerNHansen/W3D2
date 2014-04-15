require './questionsdatabase'

class Reply
  attr_accessor :id, :question_id, :reply_id, :author_id, :body

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
      replies
      WHERE
        id = ?
    SQL

    Reply.new(data.first)
  end

  def self.find_by_question_id(question_id)
    reply_data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    reply_data.map { |rd| Reply.new(rd) }
  end

  def self.find_by_author_id(author_id)
    reply_data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
    SQL
    reply_data.map { |rd| Reply.new(rd) }
  end

  def initialize(op = {})
    p options
    @id, @question_id, @reply_id = op['id'], op['question_id'], op['reply_id']
    @author_id, @body = op['author_id'], op['body']
  end

  def author
    Author.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    reply_data = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL
    reply_data.map { |rd| Reply.new(rd) }
  end
end