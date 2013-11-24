class GuidanceDetailController < UIViewController
  # @!group UIViewController Methods

  # @!attr [r]
  #   @return [Guidance]
  attr_reader :guidance

  # @return [GuidanceDetailController]
  def initWithGuidance(guidance)
    @guidance = guidance
    self
  end

  # @return [void]
  def viewDidLoad
    super

    self.title = guidance.title
    self.view.backgroundColor = UIColor.whiteColor

    @web_view = UIWebView.alloc.initWithFrame(content_frame)
    @web_view.backgroundColor = UIColor.whiteColor

    print_button = BW::UIBarButtonItem.system(:action) do
      print_info                       = UIPrintInfo.printInfo
      print_info.outputType            = UIPrintInfoOutputPhoto

      print_controller                = UIPrintInteractionController.sharedPrintController
      print_controller.showsPageRange = true
      print_controller.printInfo      = print_info
      print_controller.printFormatter = @web_view.viewPrintFormatter

      completion_handler = lambda do |print_controller, completed, error|
        if BW.debug? && !completed && error
          puts error
        end
      end

      print_controller.presentAnimated(true, completionHandler: completion_handler)
    end

    self.navigationItem.rightBarButtonItem = print_button

    @html = "<html><head><title>#{guidance.title}</title>"
    path = NSBundle.mainBundle.pathForResource('guidance', ofType: 'css')
    css = NSData.dataWithContentsOfFile(path)
    @html << "<style type=\"text/css\">#{css}</style>"
    @html << '</head><body id="page"><div>'
    guidance.sections.each_with_index do |section, index|
      @html << "<h2>#{section['title']}</h2>"
      @html << "<p>#{section['content']}".split(%r{<br\s*.?>}).join('</p><p>')
      @html << '</p>'
      @html << '<hr class="hr0">' if index == 2
    end
    @html << '</div></body></html>'

    Motion::Layout.new do |layout|
      layout.view view

      layout.subviews 'web_view' => @web_view
      layout.metrics  'vertical_margin' => -5, 'horizontal_margin' => 0
      # layout.vertical     '|-[web_view]-|'
      layout.vertical     '|-vertical_margin-[web_view]-vertical_margin-|'
      layout.horizontal   '|-horizontal_margin-[web_view]-horizontal_margin-|'
    end

    @web_view.loadHTMLString(@html, baseURL: nil)
  end

  # @!endgroup
end
