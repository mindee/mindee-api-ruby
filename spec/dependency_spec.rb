# frozen_string_literal: true

require 'mindee'
describe Mindee::Dependency do
  before(:each) do
    if Mindee::Dependency.instance_variable_defined?(:@all_deps_available)
      Mindee::Dependency.remove_instance_variable(:@all_deps_available)
    end
  end

  describe '.all_deps_available?' do
    context 'when evaluating the full mindee gem' do
      before do
        allow(Mindee::Dependency).to receive(:require).and_return(true)

        Mindee::Dependency.instance_variable_set(:@all_deps_available, Mindee::Dependency.check_all_dependencies)
      end

      it 'returns true' do
        expect(Mindee::Dependency.all_deps_available?).to be true
      end
    end

    context 'when evaluating the mindee-lite gem' do
      before do
        allow(Mindee::Dependency).to receive(:require).and_raise(LoadError)

        Mindee::Dependency.instance_variable_set(:@all_deps_available, Mindee::Dependency.check_all_dependencies)
      end

      it 'returns false' do
        expect(Mindee::Dependency.all_deps_available?).to be false
      end
    end
  end
end

describe 'Mindee PDF Module Loading' do
  let(:pdf_tools_module_path) { File.expand_path('../lib/mindee/pdf/pdf_tools.rb', __dir__) }

  context 'when initialized in a mindee-lite environment' do
    before do
      allow(Mindee::Dependency).to receive(:all_deps_available?).and_return(false)
    end

    it 'raises a LoadError with the lite exception message' do
      expect do
        load pdf_tools_module_path
      end.to raise_error(LoadError, Mindee::Dependency::MINDEE_DEPENDENCIES_LOAD_ERROR)
    end
  end

  context 'when initialized in a full mindee environment' do
    around do |example|
      original_require = Kernel.instance_method(:require)

      Kernel.define_method(:require) do |name|
        ['origami', 'mini_magick', 'pdf-reader'].include?(name) || original_require.bind_call(self, name)
      end

      begin
        example.run
      ensure
        Kernel.define_method(:require, original_require) # Restore original require
      end
    end

    before do
      allow(Mindee::Dependency).to receive(:all_deps_available?).and_return(true)
    end

    it 'loads the module successfully without raising errors' do
      expect do
        load pdf_tools_module_path
      end.not_to raise_error
    end
  end
end
