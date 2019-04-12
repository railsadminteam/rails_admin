require 'spec_helper'

describe "config/locales/rails_admin.id.yml" do
  it { is_expected.to be_parseable }
  it { is_expected.to have_valid_pluralization_keys }
  it { is_expected.to_not have_missing_pluralization_keys }
  it { is_expected.to have_one_top_level_namespace }
  it { is_expected.to_not have_legacy_interpolations }
  it { is_expected.to have_a_valid_locale }  
  it { is_expected.to be_a_subset_of 'config/locales/rails_admin.en.yml' }
  it { is_expected.to be_a_complete_translation_of 'config/locales/rails_admin.en.yml' }
end