require 'test_helper'

class DublinCoreMapperTest < Test::Unit::TestCase
  class MockData
    def subject; 'An awesome subject'; end
    def metadata
      DublinCoreMapper.register do |mapper|
        mapper.subject(subject)
      end
    end
  end
  def setup
    @dublin_core_mapper = DublinCoreMapper.register do |mapper|
      mapper.subject('Numeral representation of 1000 + 200 + 30 + 4')
      mapper.title('1234')
      mapper.subject('Math')
      mapper.subject('')
      mapper.type('')
    end
  end

  should 'have a single title' do
    assert_equal ['1234'], @dublin_core_mapper.title
    assert_equal ['1234'], @dublin_core_mapper['title']
  end

  should 'register multiple subjects' do
    assert_equal ['Numeral representation of 1000 + 200 + 30 + 4', 'Math'], @dublin_core_mapper['subject']
    assert_equal ['Numeral representation of 1000 + 200 + 30 + 4', 'Math'], @dublin_core_mapper.subject
  end

  should 'raise no method error if trying to register an undefined attribute' do
    assert_raises NoMethodError do
      DublinCoreMapper.register do |dcm|
        foo('bar')
      end
    end
  end

  should 'have an each method that ' do
    @yielded = []
    @dublin_core_mapper.each do |key, values|
      @yielded << [key, values]
    end

    assert_equal 3, @yielded.size, "Note, we did not register a blank"
    assert_equal( ['subject', 'Numeral representation of 1000 + 200 + 30 + 4'],  @yielded[0])
    assert_equal( ['title', '1234'],  @yielded[1])
    assert_equal( ['subject', 'Math'],  @yielded[2])
  end
  
  should "given an object with subject register that object's subject" do
    mock_data = MockData.new
    assert_equal [mock_data.subject], mock_data.metadata.subject
  end
end
