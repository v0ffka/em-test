require 'rails_helper'

RSpec.describe FeedsController, type: :feature do
  before { WebMock.allow_net_connect! }

  describe 'working with feeds', js: true do
    before do
      create(:feed, url: 'The URL 1', title: nil)
      visit '/'
    end

    it 'displays existing feeds' do
      expect(page).to have_content('The URL 1')
    end

    it 'creates a new feed by url' do
      visit '/'
      within 'form.add-feed-form' do
        fill_in 'newFeedUrl', with: 'news.yandex.ru/first.rss'
        click_button 'Add'
        fill_in 'newFeedUrl', with: 'news.yandex.ru/second.rss'
        click_button 'Add'
      end

      expect(page).to have_content('news.yandex.ru/first.rss')
      expect(page).to have_content('news.yandex.ru/second.rss')
    end

    it 'can update feed URL' do
      within 'div.feeds-wrapper' do
        click_button 'Edit'
        fill_in 'url', with: 'The New URL'
        click_button 'Update'

        expect(page).to have_content('The New URL')
        expect(page).not_to have_content('The Feed')
      end
    end

    it 'can delete feeds' do
      within 'div.feeds-wrapper' do
        click_button 'Delete'

        expect(page).not_to have_content('The URL 1')

        #just check if it got removed for real
        page.driver.browser.navigate.refresh
        expect(page).not_to have_content('The URL 1')
      end
    end
  end
end
