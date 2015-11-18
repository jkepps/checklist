require 'rails_helper'

RSpec.describe List, type: :model do
	let(:user) { create(:user) }
	let(:list) { create(:list) }

	it { should belong_to(:user) }
	it { should have_many(:items) }
end
