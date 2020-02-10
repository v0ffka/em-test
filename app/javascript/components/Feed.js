import React from "react"

class Feed extends React.Component {
  render() {
    return (
      <tr className="feed">
        <td>{this.props.feed.title || this.props.feed.url}</td>
        <td>{this.props.feed.last_updated_at}</td>
        <td>
          <button type="button" onClick={this.handleEdit}>Edit</button>
          |
          <button type="button" onClick={this.handleDelete}>Delete</button>
        </td>
      </tr>
    )
  }

  handleDelete = () => {
    this.props.onDelete(this.props.feed.id)
  }

  handleEdit = () => {
    this.props.onEdit(this.props.feed.id)
  }
}

export default Feed
