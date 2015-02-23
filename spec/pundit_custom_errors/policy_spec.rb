require 'spec_helper'

describe PunditCustomErrors::Policy do
  subject { PunditCustomErrors::Policy.new }
  describe 'model attributes' do
    it { should respond_to(:error_message) }
  end
end
