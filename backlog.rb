require 'backlog_kit'
require 'Date'
require_relative 'Util'

class BacklogIssuesBuilder
  attr_reader :client, :secrets_info

  def initialize(args)
    @client = args[:client]
    @secrets_info = args[:secrets_info]
  end

  def execute
    issues.each do |issue|
      p '---------------------'
      p "担当者: #{issue.assignee.name}"
      p "ステータス: #{issue.status.name}"
      p "タイトル: #{issue.summary}"
      p "期限日: #{issue.due_date}"
      p "url: https://#{secrets_info['space_id']}.backlog.com/view/#{issue.issueKey}"
    end
  end

  private

  def issues
    client.get_issues(
      {
        projectId: secrets_info['project_id'],
        statusId: [1, 2],
        dueDateSince: (Date.today - 1).to_s, #当日指定ができない。多分どこかでミスっている
        dueDateUntil: (Date.today + 3).to_s,
        assigneeId: secrets_info['assignee_id']
      }
    ).body
  end
end

secrets_info = Util.load_secret_file

client = BacklogKit::Client.new(
  space_id: secrets_info['space_id'],
  api_key: secrets_info['api_key']
)

BacklogIssuesBuilder.new(
  client: client,
  secrets_info: secrets_info
).execute
