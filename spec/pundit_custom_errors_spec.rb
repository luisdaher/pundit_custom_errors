require 'spec_helper'

describe PunditCustomErrors do
  class PunditMock
    prepend PunditCustomErrors
    def policy(_arg)
      DummyRecordPolicy.new
    end
  end
  class DummyRecordPolicy
    attr_accessor :error
  end

  # before(:each) do
  #   @pundit_mock = PunditMock.new
  #   @pundit_mock.extend(PunditCustomErrors)
  # end

  describe '.authorize' do
    context "when the user isn't authorized" do
      it 'raises an error' do
        expect_any_instance_of(DummyRecordPolicy).to receive(:show?).and_return(false)
        PunditMock.new.authorize(Class.new, 'show?')
      end
    end
  end

  describe '.generate_error_for' do
  end

  describe '.translate_error_message_for_query' do
  end
end
