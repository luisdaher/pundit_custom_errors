require 'spec_helper'

describe PunditCustomErrors::Authorization do
  # Pundit Mock class
  class PunditMock
    prepend PunditCustomErrors::Authorization
    def policy(_arg = nil)
      @policy ||= PunditCustomErrors::Policy.new
    end
  end

  class DummyPolicy
  end

  describe '.authorize' do
    before :each do
      @pundit_mock = PunditMock.new
      @query = 'show?'
      @record = Class.new
    end
    context "when the user isn't authorized" do
      context 'and PunditCustomErrors::Policy is being extended' do
        before :each do
          expect_any_instance_of(PunditCustomErrors::Policy).to(
            receive(:show?).and_return(false)
          )
        end

        it 'raises an error' do
          expect { @pundit_mock.authorize(@record, @query) }.to(
           raise_error(Pundit::NotAuthorizedError)
          )
        end

        context 'and a custom error message has been set' do
          before :each do
            expect_any_instance_of(PunditCustomErrors::Policy).to(
              receive(:error_message).and_return('error message')
            )
          end

          it 'returns the error with the previously set error message' do
            expect { @pundit_mock.authorize(@record, @query) }.to(
             raise_error(Pundit::NotAuthorizedError, 'error message')
            )
          end
        end

        context "and there's a translated message but no custom message" do
          before :each do
            expect(@pundit_mock).to(
              receive(:t)
              .with(
                "#{@pundit_mock.policy.class.to_s.underscore}.#{@query}",
                scope: 'pundit',
                default: :default
              )
              .and_return('translated error message')
            )
          end

          it 'returns the error with the translated message' do
            expect { @pundit_mock.authorize(@record, @query) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                'translated error message'
              )
            )
          end
        end

        context 'and no message is found' do
          it 'returns the error with the default message' do
            expect { @pundit_mock.authorize(@record, @query) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                "not allowed to #{@query} this #{@record}"
              )
            )
          end
        end
      end

      context "and Policy class doesn't extend PunditCustomErrors::Policy" do
        before :each do
          expect(@pundit_mock).to(
            receive(:policy).twice.and_return(DummyPolicy.new)
          )

          expect(@pundit_mock).to(
            receive(:t)
            .with(
              "#{@pundit_mock.policy.class.to_s.underscore}.#{@query}",
              scope: 'pundit',
              default: :default
            )
            .and_return('translated error message')
          )
          expect_any_instance_of(DummyPolicy).to(
            receive(:show?).and_return(false)
          )
        end

        it 'returns the error with the translated message' do
          expect { @pundit_mock.authorize(@record, @query) }.to(
            raise_error(
              Pundit::NotAuthorizedError,
              'translated error message'
            )
          )
        end
      end
    end

    context 'when the user is authorized' do
      before :each do
        expect_any_instance_of(PunditCustomErrors::Policy).to(
          receive(:show?).and_return(true)
        )
      end
      it "doesn't raise an error" do
        expect { @pundit_mock.authorize(@record, @query) }.not_to raise_error
      end
    end
  end
end
