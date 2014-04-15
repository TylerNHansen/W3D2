require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class Table
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, TABLE_NAME, id)
      SELECT
        *
      FROM
        ?
      WHERE
        id = ?
    SQL

    self.class.new(data.first)
  end
end