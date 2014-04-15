require './questionsdatabase'

class QuestionFollower
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
      question_followers
      WHERE
        id = ?
    SQL

    QuestionFollower.new(data.first)
  end

  def self.followers_for_question_id

  end

  def initialize(op = {})
    p options
    @id, @question_id, @user_id = op['id'], op['question_id'], op['user_id']
  end
end