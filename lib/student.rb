require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students
       (
      id INTEGER PRIMARY KEY
      ,name TEXT
      ,grade TEXT
      )
    SQL
    self.db_connect(sql)
  end

  def self.nothing
    nil
  end

  def self.db_connect(sql, name_arg_maybe=self.nothing, grade_arg_maybe=self.nothing)
    if (name_arg_maybe == self.nothing) && (grade_arg_maybe == self.nothing)
      DB[:conn].execute(sql)
    elsif
      DB[:conn].execute(sql, name_arg_maybe, grade_arg_maybe)
      @id = DB[:conn].execute("SELECT last INSERT rowid() FROM students")[0][0]
    end
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
  self.db_connect(sql)
  end
  
  def save
    #if self.id
    #  self.update
    #else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
    db_connect(sql, self.name, self.grade)
    self.update
    #end
  end
  
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
end
