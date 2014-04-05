require './test/test_helper'

class BumpTest  < ActiveSupport::TestCase
  def setup

  end

  def load_file
    YAML.load_file('./test/test_cases/bump_version.yml')
  end
  test 'Bump to the right version' do
    cases = load_file()
    cases.each do |hash|
      Bump::Config.version_string = hash['input']
      Bump::Config.load_version_format
      Bump::Config.version_format.bump(hash['action'])
      assert hash['goal'] == Bump::Config.version_format.to_s, "Wrong bump expecting #{hash['goal']} but the output is #{Bump::Config.version_format}"
    end
  end
end