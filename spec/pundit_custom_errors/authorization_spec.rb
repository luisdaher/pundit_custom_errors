require 'spec_helper'

describe PunditCustomErrors::Authorization do
  # Pundit Mock class
  class PunditMock
    prepend PunditCustomErrors::Authorization
    def policy(_arg = nil)
      @policy ||= DummyPolicy.new
    end
  end

  # Dummy Policy class for testing purposes
  class DummyPolicy
  end

  describe '.authorize' do
    let(:pundit_mock) { PunditMock.new }

    context "when the user isn't authorized" do
      context "and it's a single error" do
        before :each do
          expect_any_instance_of(DummyPolicy).to(
            receive(:show?).and_return(false)
          )
        end

        it 'raises an error' do
          expect { pundit_mock.authorize(Class.new, :show?) }.to raise_error
        end

        context 'and a custom error message has been set' do
          it 'returns the error with the previously set error message' do
            expect_any_instance_of(DummyPolicy).to(
              receive(:error_message).and_return('error')
            )
            expect_any_instance_of(DummyPolicy).to(
              receive(:error_message=).and_return(nil)
            )
            expect { pundit_mock.authorize(Class.new, :show?) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                'error'
              )
            )
          end
        end
      end

      context 'and there is more than one error' do
        # Dummy Policy class for testing purposes
        class DummyPolicy
          attr_accessor :error_message

          def index?
            @error_message = 'error'
            false
          end

          def show?
            false
          end

          def update?
            @error_message = 'update error'
            false
          end
        end

        context "and the other error doesn't contain a custom message" do
          it 'shows the default error message' do
            class_instance = Class.new

            expect { pundit_mock.authorize(class_instance, :index?) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                'error'
              )
            )

            expect { pundit_mock.authorize(class_instance, :show?) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                "not allowed to show? this #{class_instance}"
              )
            )
          end
        end

        context 'and the other error also contains a custom message' do
          it "doesn't show the previous error message" do
            class_instance = Class.new

            expect { pundit_mock.authorize(class_instance, :index?) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                'error'
              )
            )

            expect { pundit_mock.authorize(class_instance, :update?) }.to(
              raise_error(
                Pundit::NotAuthorizedError,
                'update error'
              )
            )
          end
        end
      end

      context "and there's a translated message but no custom message" do
        before :each do
          expect(pundit_mock).to(
            receive(:t)
            .with(
              "#{pundit_mock.policy.class.to_s.underscore}.show?",
              scope: 'pundit',
              default: :default
            )
            .and_return('translated error message')
          )
        end

        it 'returns the error with the translated message' do
          expect { pundit_mock.authorize(Class.new, :show?) }.to(
            raise_error(
              Pundit::NotAuthorizedError,
              'translated error message'
            )
          )
        end
      end

      context 'and no message is found' do
        it 'returns the error with the default message' do
          record = Class.new
          expect { pundit_mock.authorize(record, :show?) }.to(
            raise_error(
              Pundit::NotAuthorizedError,
              "not allowed to show? this #{record}"
            )
          )
        end
      end
    end

    context 'when the user is authorized' do
      before :each do
        expect_any_instance_of(DummyPolicy).to(
          receive(:show?).and_return(true)
        )
      end
      it "doesn't raise an error" do
        expect { pundit_mock.authorize(Class.new, :show?) }.not_to raise_error
      end
    end
  end
end
