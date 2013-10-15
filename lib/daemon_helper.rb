require 'net/http'

module DaemonHelper
  extend self

  def process_pull_requests
    github_user = SystemConfig.github['user']
    organization = SystemConfig.github['organization']
    repos = SystemConfig.github['repos']

    github = if SystemConfig.github['token']
      Github.new oauth_token: SystemConfig.github['token']
    else
      Github.new basic_auth: "#{github_user}:#{SystemConfig.github['password']}"
    end

    repos.each do |repo|
      repo_name = repo['name']
      job       = repo['job']

      base_repo = "#{organization}/#{repo_name}"
      pull_requests = github.pull_requests.list(user: organization, repo: repo_name)

      pull_requests.each do |pull|
        begin
          next unless pull.state == "open"

          sha = pull.head.sha
          ref = pull.head.ref
          url = pull.html_url

          next if PullRequest.find_by_sha(sha)

          post = Net::HTTP.post_form(
            URI.parse(jenkins_url(job)),
              {'GIT_SHA1'=>sha,
               'GIT_BASE_REPO' => base_repo,
               'GIT_HEAD_REPO' => base_repo,
               'GITHUB_URL' => url }
            )

          raise Exception.new("#{post.code} #{post.body}") unless [302,200,201].include?(post.code)

          PullRequest.create(sha: sha, ref: ref)
        rescue => e
          puts "#{e.message}\n#{e.backtrace.join("\n")}"
        end #rescue
      end #loop
    end #loop

  end # method

  def jenkins_url(job)
    "#{SystemConfig.jenkins['base_url']}/#{job}/build"
  end

end