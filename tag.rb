class Tag < Table
  attr_accessor :tag

  def self.most_popular(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        tags.*
      FROM
      tags
      JOIN
      question_tags
      ON
      tags.id = question_tags.tag_id
      JOIN
      question_likes
      ON
      question_tags.question_id = question_likes.question_id
      GROUP BY
      tags.id
      ORDER BY
      COUNT(tags.*)
      LIMIT
        ?
    SQL

    data.map { |datum| Tag.new(datum) }
  end

  def table_name
    'tags'
  end

  def most_popular_questions(n)
    QuestionTag.most_popular_questions(@id, n)
  end

  def initialize(options = {})
    @tag = options['tag']
    @id = options['id']
  end
end