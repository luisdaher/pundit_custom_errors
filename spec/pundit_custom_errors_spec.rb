require 'spec_helper'

describe PunditCustomErrors do
  class PunditMock
    prepend PunditCustomErrors
    def policy
      DummyClassPolicy.new
    end
  end
  class DummyRecord
  end
  class DummyRecordPolicy
  end

  # before(:each) do
  #   @pundit_mock = PunditMock.new
  #   @pundit_mock.extend(PunditCustomErrors)
  # end

  describe '.authorize' do
    context "when the user isn't authorized" do
      it 'raises an error' do
        binding.pry
        PunditMock.new.authorize(DummyRecord.new, 'show?')
      end
    end
  end

  describe '.generate_error_for' do
  end

  describe '.translate_error_message_for_query' do
  end
end
