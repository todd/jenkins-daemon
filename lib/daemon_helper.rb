require 'net/http'

module DaemonHelper
extend self

  def process_pull_requests
    github_user = SystemConfig.github['user']
    organization = SystemConfig.github['organization']
    repo = SystemConfig.github['repo']
    base_repo = "#{organization}/#{repo}"

    github = if SystemConfig.github['token']
      Github.new oauth_token: SystemConfig.github['token']
    else
      Github.new basic_auth: "#{github_user}:#{SystemConfig.github['password']}"
    end


    pull_requests = github.pull_requests.list(user: organization, repo: repo)

    pull_requests.each do |pull|
      begin
        next unless pull.state == "open"

        sha = pull.head.sha
        ref = pull.head.ref

        next if PullRequest.find_by_sha(sha)

        post = Net::HTTP.post_form(
          URI.parse(SystemConfig.jenkins["url"]), 
            {'GIT_SHA1'=>sha,
             'GIT_BASE_REPO' => base_repo,
             'GIT_HEAD_REPO' => base_repo,
             'GITHUB_URL' => '' }
          )
        
        

        raise Exception.new("#{post.code} #{post.body}") unless [302,200,201].include?(post.code)
    

        PullRequest.create(sha: sha, ref: ref)
      rescue => e
        puts "#{e.message}\n#{e.backtrace.join("\n")}"
      end #rescue
    end #loop

  end # method

end