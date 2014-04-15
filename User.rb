require 'questionsdatabase'

class User
  attr_accessor :id, :fname, :lname
  TABLE_NAME = 'users'

  def self.find_by_id(id)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(user_data.first)
  end

  def initialize(options = {})
    p options
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end