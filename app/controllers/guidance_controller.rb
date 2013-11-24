class GuidanceController < UITableViewController
  attr_accessor :guidance

  # @!group Helper Methods
  # @return [Array<Guidance>]
  def guidance
    unless @guidance
      settings = App::Persistence
      opts = {}

      opts[:credentials] = {
        username: settings['username'],
        password: settings['password'] # TODO: Mask this some how?
      }

      url = NSURL.URLWithString("#{settings['api_endpoint']}/threats/#{settings['selected_threat']}/guidance")
      request = NSURLRequest.requestWithURL(url)
      operation = AFJSONRequestOperation.JSONRequestOperationWithRequest(request,
        success: lambda { |request, response, json|
          @guidance = json.map do |guidance|
            Guidance.new(guidance)
          end
        },
        failure: lambda { |request, response, error, json|
          @error = json['message'] if json
      })

      operation.setAuthenticationChallengeBlock lambda { |connection, challenge|
        if challenge.previousFailureCount == 0
          credentials = NSURLCredential.credentialWithUser(
            settings['username'],
            password: settings['password'],
            persistence: NSURLCredentialPersistenceForSession
          )

          challenge.sender.useCredential(credentials, forAuthenticationChallenge: challenge)
        else
          puts 'Previous auth challenge failed. Are username and password correct?'
        end
      }

      operation.start

      self.tableView.reloadData
    end

    @guidance ||= []
  end

  # @return [Array<String>]
  def domains
    guidance.map(&:domain).uniq
  end

  # @return [Array<Guidance>]
  def guidance_by_domain(domain)
    guidance.find_all do |guidance|
      guidance.domain.eql? domain
    end
  end

  # @return [Guidance]
  def guidance_by_index_path(indexPath, tableView = nil)
    tableView ||= self.tableView

    domain = tableView(tableView, titleForHeaderInSection: indexPath.section)
    guidance = guidance_by_domain(domain)[indexPath.row]
  end

  # @!endgroup

  # @!group UITableViewController Methods

  # @return [GuidanceController]
  def initWithNibName(name, bundle: bundle)
    super

    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemBookmarks, tag: 1)
    self
  end

  # @return [void]
  def viewDidLoad
    super

    self.title = 'Guidance'
    self.view.backgroundColor = UIColor.whiteColor

    settings = App::Persistence
    settings['username'] = 'admin'
    settings['password'] = 'admin'
    settings['api_endpoint'] = 'http://0.0.0.0:8080/insight/controls/api'
    settings['selected_threat'] = 'overall-malware'
  end

  # @return [UITableViewCell]
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuse_identifier ||= "guidance_cell"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuse_identifier) || begin
             UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuse_identifier)
           end

    guidance = guidance_by_index_path(indexPath, tableView)
    cell.textLabel.text = guidance.title

    cell
  end

  # @return [Integer]
  def numberOfSectionsInTableView(tableView)
    domains.count
  end

  # @return [String]
  def tableView(tableView, titleForHeaderInSection: section)
    domains[section]
  end

  # @return [Integer]
  def tableView(tableView, numberOfRowsInSection: section)
    domain = domains[section]
    guidance_by_domain(domain).count
  end

  # @return [void]
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    guidance = guidance_by_index_path(indexPath, tableView)
    guidance_detail_controller = GuidanceDetailController.alloc.initWithGuidance(guidance)
    self.navigationController.pushViewController(guidance_detail_controller, animated: true)

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  end

  # @!endgroup
end
