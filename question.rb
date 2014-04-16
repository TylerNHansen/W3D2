require './questionsdatabase'
require './User'
require './question_follower'

class Question < Table
  attr_accessor :id, :title, :body, :author_id

  def self.table_name
    'questions'
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
    User.find_by_id(@author_id).first
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

end

