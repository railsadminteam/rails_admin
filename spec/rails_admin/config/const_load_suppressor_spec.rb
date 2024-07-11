

require 'spec_helper'

RSpec.describe RailsAdmin::Config::ConstLoadSuppressor do
  describe '.suppressing' do
    it 'suppresses constant loading' do
      expect do
        subject.suppressing { UnknownConstant }
      end.not_to raise_error
    end

    it 'raises the error on recursion' do
      expect do
        subject.suppressing do
          subject.suppressing {}
        end
      end.to raise_error(/already suppressed/)
    end
  end

  describe '.allowing' do
    it 'suspends constant loading suppression' do
      expect do
        subject.suppressing do
          subject.allowing { UnknownConstant }
        end
      end.to raise_error NameError
    end

    it 'does not break when suppression is disabled' do
      expect do
        subject.allowing {}
      end.not_to raise_error
    end
  end
end
