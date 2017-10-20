require "project_metric_commit_message/version"
require 'json'
require 'octokit'

class ProjectMetricCommitMessage
  attr_reader :raw_data

  def initialize(credentials, raw_data = nil)
    @project_url = credentials[:github_project]
    @identifier = URI.parse(@project_url).path[1..-1]
    @client = Octokit::Client.new access_token: credentials[:github_access_token]
    @client.auto_paginate = true

    @raw_data = raw_data
  end

  def refresh
    @raw_data = commits
    @score = @image = nil
  end

  def raw_data=(new)
    @raw_data = new
    @score = nil
    @image = nil
  end

  def score
    @raw_data ||= commits
    synthesize
    @score ||= @commit_types.reject(&:nil?).length / @raw_data.length.to_f
  end

  def image
    @raw_data ||= commits
    synthesize
    @image ||= { chartType: 'commit_message',
                 titleText: 'Github commit messages',
                 data: { bad_commits: @commit_types.select(&:nil?).length,
                         type_counting: @type_counting
                 } }.to_json
  end

  def self.credentials
    %I[github_project github_access_token]
  end

  private

  def commits
    @client.commits_since @identifier, Date.today - 7
  end

  def synthesize
    @raw_data ||= commits
    @commit_types = @raw_data.map { |cmit| commit_type(cmit['commit']['message']) }
    @type_counting = @commit_types.reject(&:nil?).inject(Hash.new(0)) do |sum, type|
      sum[type] += 1
      sum
    end
  end

  def commit_type(msg)
    m = /\[(.*)\].*/.match(msg)
    m.nil? ? merge_type(msg) : m.captures.first.to_sym
  end

  def merge_type(msg)
    /merge/.match(msg.downcase).nil? ? nil : :merge
  end
end
