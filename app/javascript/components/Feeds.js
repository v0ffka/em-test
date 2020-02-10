import React from "react"
import PropTypes from "prop-types"
import Feed from './Feed'
import FeedEditor from './FeedEditor'

class Feeds extends React.Component {
  render () {
    return (
      <div className="feeds-wrapper">
        <table>
          <thead>
            <tr>
              <th>Feed</th>
              <th>Last updated at</th>
              <th/>
            </tr>
          </thead>

          <tbody>
            {this.state.feeds.map((feed) => {
              if (this.state.feedWithEditorId == feed.id) {
                  return <FeedEditor feed={feed} key={feed.id} updateFeedCallback={this.feedUpdated} />
                } else {
                  return <Feed feed={feed} key={feed.id} onEdit={this.startEditing} onDelete={this.deleteFeed} />
                }
              }
            )}
          </tbody>
        </table>

        <form className="add-feed-form">
          <input type="text" name="newFeedUrl" value={this.state.newFeedUrl} onChange={this.handleInput}/>
          <button className="add-feed-button" onClick={this.addNewFeed} type="button">Add</button>
        </form>
      </div>
    );
  }

  constructor(props) {
    super(props)
    this.state = {
      feeds: [],
      newFeedUrl: ''
    }
  }

  componentDidMount() {
    this.loadFeeds()
  }

  handleInput = (e) => {
    this.setState({[e.target.name]: e.target.value})
  }

  loadFeeds = () => {
    let feedsComponent = this;

    $.get('/feeds.json')
      .done(function(data) {
        feedsComponent.setState({feeds: data})
      })
  }

  addNewFeed = () => {
    let feedsComponent = this;

    $.post('/feeds.json', {url: this.state.newFeedUrl})
      .done(function(data) {
        feedsComponent.state.feeds.push(data)
        feedsComponent.setState({newFeedUrl: ''})
      })
  }

  deleteFeed = (id) => {
    let feedsComponent = this;

    $.ajax({url: `/feeds/${id}.json`, method: 'DELETE'})
      .then(function(_data) {
        let new_set_of_feeds = $.grep(feedsComponent.state.feeds, function(feed) {
          return feed.id != id
        })

        feedsComponent.setState({feeds: new_set_of_feeds})
      })
  }

  startEditing = (id) => {
    this.setState({feedWithEditorId: id})
  }

  stopEditing = () => {
    this.setState({feedWithEditorId: null})
  }

  feedUpdated = (data) => {
    $.each(this.state.feeds, function(_key, feed) {
      if (feed.id == data.id) {
        feed.url = data.url
        feed.title = data.title
        feed.last_updated_at = data.last_updated_at
      }
    })

    this.stopEditing()
  }
}

export default Feeds
