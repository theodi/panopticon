require_relative '../../test_helper'

class Artefact::ArtefactTest < ActiveSupport::TestCase

  context "app_without_tagging?" do
    context "when artefact is from a deprecated application" do

      should "return true when owning app is in the apps_without_migrated_tagging" do
        artefact = FactoryGirl.create(:artefact, slug: "low-hanging-fruit", owning_app: 'finder-api')

        assert_equal true, artefact.app_without_tagging?
      end

      should "return false when owning app is not in the apps_without_migrated_tagging" do
        artefact = FactoryGirl.create(:artefact, slug: "low-hanging-fruit", owning_app: 'whitehall')

        assert_equal false, artefact.app_without_tagging?
      end
    end
  end

  context "tagging_migrated?" do

    context 'standard set of untaggable apps (publisher, smartanswers and testapp)' do

      should "return false for artifacts not owned by publisher, smartanswers or testapp" do
        artefact = FactoryGirl.create(:artefact, slug: "low-hanging-fruit", owning_app: 'whitehall')
        assert_equal false, artefact.tagging_migrated?
      end

      should 'return true for artefacts owned by publisher, smartanswers or testapp' do
        artefact = FactoryGirl.create(:artefact, slug: "low-hanging-fruit", owning_app: 'testapp')
        assert_equal true, artefact.tagging_migrated?
      end

      should 'return false if new record and owning app is nil' do
        artefact = Artefact.new
        assert_equal true, artefact.tagging_migrated?
      end

      should 'return true if new record and owning app is in list of untaggable apps' do
        artefact = Artefact.new(owning_app: 'testapp')
        assert_equal true, artefact.tagging_migrated?
      end

      should 'return false if new record and owning app is not in list of untaggable apps' do
        artefact = Artefact.new(owning_app: 'whitehall')
        assert_equal false, artefact.tagging_migrated?
      end
    end

    context 'no untaggable apps specified' do
      should 'return false if Settings.apps_with_migrated_tagging is nil' do
        Settings.expects(:apps_with_migrated_tagging).returns(nil).at_least(1)
        artefact = FactoryGirl.create(:artefact, slug: "low-hanging-fruit", owning_app: 'testapp')
        assert_equal false, artefact.tagging_migrated?
      end
    end
  end
end