require 'questionsdatabase'

class Question < Table
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    self.class.new(question_data.first)
  end

  def initialize(options = {})
    p options
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end

