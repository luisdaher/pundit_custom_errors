require 'spec_helper'

describe PunditCustomErrors do
  class DummyClass
    prepend PunditCustomErrors
    def policy(_arg)
      DummyRecordPolicy.new
    end
  end
  class DummyRecordPolicy
    attr_accessor :error
  end

  describe '.authorize' do
    before :each do
      @dummy_class = DummyClass.new
    end
    context "when the user isn't authorized" do
      before :each do
        expect_any_instance_of(DummyRecordPolicy).to(
          receive(:show?).and_return(false)
        )
      end
      it 'raises an error' do
        expect { @dummy_class.authorize(Class.new, 'show?') }.to(
         raise_error(Pundit::NotAuthorizedError)
        )
      end
    end

    context 'when the user is authorized' do
      before :each do
        expect_any_instance_of(DummyRecordPolicy).to(
          receive(:show?).and_return(true)
        )
      end
      it "doesn't raise an error" do
        expect { @dummy_class.authorize(Class.new, 'show?') }.not_to raise_error
      end
    end
  end

  describe '.generate_error_for' do
    
  end

  describe '.translate_error_message_for_query' do
  end
end
