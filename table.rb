class Table
  attr_reader :id

  def self.method_missing(*args)
    db_column_name, target_value = args
    db_column_name = db_column_name.to_s
    p db_column_name[0..7]

    super unless db_column_name[0..7] == 'find_by_'

    db_column_name = db_column_name[8..-1]

    sql_cmd = "SELECT * FROM #{table_name} WHERE #{db_column_name} = ?"
    data = QuestionsDatabase.instance.execute(sql_cmd, target_value)
    data.map { |datum| self.new(datum) }
  end

  def save
    if self.id.nil?
      insert_save
    else
      update_save
    end
  end

  def table_name
    raise NotImplementedError
  end

  protected

  def db_col_names
    instance_variables.reject { |el| el == :@id }
    .map(&:to_s).map { |str| str[1..-1] }
  end

  def col_str
    db_col_names.join(', ')
  end

  def val_str
    col_str.gsub(/\w+/, '?')
  end

  def set_str
    db_col_names.map { |el| el + " = ?" }.join(', ')
  end

  def insert_save
    sql_cmd = "INSERT INTO #{self.class.table_name}(#{self.col_str})
    VALUES (#{self.val_str});"

    QuestionsDatabase.instance.execute(sql_cmd,
    *db_col_names.map { |v| self.send(v) }
    )

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update_save
    sql_cmd = "UPDATE #{self.class.table_name}
    SET #{set_str}
    WHERE id = ?"

    QuestionsDatabase.instance.execute(sql_cmd,
    *db_col_names.map { |v| self.send(v) },
    id
    )
  end

end