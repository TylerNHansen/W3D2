class QuestionTag < Table
  def self.most_popular_questions(tag_id, n)
    data = QuestionsDatabase.instance.execute(<<-SQL, tag_id, n)
      SELECT
        questions.*
      FROM
        question_tags
      JOIN
        questions
      ON
        questions.id = question_tags.question_id AND question_tags.tag_id = ?
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(1) DESC
      LIMIT
        ?
    SQL

    data.map{ |datum| Question.new(datum) }
  end
end