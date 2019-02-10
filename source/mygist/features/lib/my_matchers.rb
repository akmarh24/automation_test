require 'rspec/expectations'

class MyMatchers

  include RSpec::Matchers
  def my_expect(expected, via, actual)
    expected = format_if_string expected
    actual = format_if_string actual
    p [expected, actual]
    eval("expect(#{expected}).to #{via} #{actual}")
  end

  def format_if_string param
    if param.class == String
      if param.include? "'"
      '"' + param + '"'
      else
        "'" + param + "'"
      end
    else
      param
    end
  end
end

