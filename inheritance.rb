class Employee

  attr_reader :name, :title, :salary, :boss, :bonus

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    @bonus = self.salary * multiplier
  end
end

class Manager < Employee

  attr_reader :employees

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    @bonus = self.employee_salary_sum * multiplier
  end

  protected
  def employee_salary_sum
    sum = 0
    @employees.each do |employee|
      sum += employee.salary
      sum += employee.employee_salary_sum if employee.is_a?(Manager)
    end
    sum
  end

end
