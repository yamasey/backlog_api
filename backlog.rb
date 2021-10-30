require 'backlog_kit'
require 'Date'
require_relative 'Util'

class BacklogIssuesBuilder
  attr_reader :client, :space_id

  def initialize(args)
    @client = args[:client]
    @space_id = args[:space_id]
  end

  def execute
    issues.each do |issue|
      p '---------------------'
      p "担当者: #{issue.assignee.name}"
      p "ステータス: #{issue.status.name}"
      p "タイトル: #{issue.summary}"
      p "期限日: #{issue.due_date}"
      p "url: https://#{space_id}.backlog.com/view/#{issue.issueKey}"
    end
  end

  private

  def issues
    client.get_issues(
      {
        projectId: [13169],
        statusId: [1, 2],
        dueDateSince: (Date.today - 1).to_s, #当日指定ができない。多分どこかでミスっている
        dueDateUntil: (Date.today + 3).to_s,
        assigneeId: [300091, 300092]
      }
    ).body
  end
end

secret = Util.load_secret_file

client = BacklogKit::Client.new(
  space_id: secret['space_id'],
  api_key: secret['api_key']
)

BacklogIssuesBuilder.new(
  client: client,
  space_id: secret['space_id']
).execute
