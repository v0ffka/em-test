import React from "react"

class FeedEditor extends React.Component {
  render() {
    return (
      <tr className="feed editor">
        <td>
          <form className="add-feed-form">
            <input type="text" name="url" value={this.state.url} onChange={this.handleInput}/>
            <button className="update-feed-button" type="button" onClick={this.handleUpdate}>Update</button>
          </form>
        </td>
        <td>

        </td>
        <td>

        </td>
      </tr>
    )
  }

  constructor(props) {
    super(props)
    this.state = {
      url: props.feed.url
    }
  }

  handleInput = (e) => {
    this.setState({[e.target.name]: e.target.value})
  }

  handleUpdate = () => {
    let feedEditor = this

    $.ajax({url: `/feeds/${this.props.feed.id}.json`, method: 'PUT', data: {url: this.state.url}})
      .then(function(data) {
        feedEditor.props.updateFeedCallback(data)
      })
  }
}

export default FeedEditor
