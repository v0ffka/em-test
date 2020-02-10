require 'rails_helper'

RSpec.describe FeedsController, type: :request do
  describe 'index' do
    subject { get '/feeds' }

    it 'responds with with empty json if no feeds' do
      subject

      expect(response).to be_ok
      expect(JSON.parse(response.body)).to be_empty
    end

    context 'with feeds in db' do
      before do
        5.times { create(:feed) }
      end

      it 'responds with feeds' do
        subject

        expect(response).to be_ok
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end

  describe 'show' do
    let(:feed) { double('Feed', id: 1) }
    subject { get "/feeds/#{feed&.id}" }

    it 'responds with not found' do
      subject

      expect(response).to be_not_found
    end

    context 'with target feed in db' do
      let(:feed) { create(:feed) }

      it 'responds with feeds' do
        subject

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match(feed.as_json)
      end
    end
  end

  describe 'update' do
    let(:feed) { create(:feed) }
    let(:new_attributes) { { url: 'New URL' } }
    subject { put "/feeds/#{feed.id}", params: new_attributes }

    it 'updates the feed with new params' do
      subject

      expect(response).to be_ok
      feed.reload
      expect(feed.url).to eq(new_attributes[:url])
    end
  end

  describe 'create' do
    let(:new_attributes) { { url: 'URL' } }
    subject { post "/feeds", params: new_attributes }

    it 'creates feed with new params' do
      expect { subject }.to change { Feed.count }.by(1)
      expect(response).to be_created

      response_json = JSON.parse(response.body)
      feed = Feed.find(response_json['id'])

      expect(feed.url).to eq(new_attributes[:url])
    end
  end

  describe 'destroy' do
    let!(:feed) { create(:feed) }
    subject { delete "/feeds/#{feed.id}" }

    it 'markes record as destroyed' do
      expect { subject }.to(change { Feed.count }.by(-1))
      expect(response).to be_no_content
    end
  end
end
