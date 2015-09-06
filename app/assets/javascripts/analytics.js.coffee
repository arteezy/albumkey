class @GoogleAnalytics

  @load: ->
    # Load the analytics code
    window['GoogleAnalyticsObject'] = 'ga'
    window['ga'] = window['ga'] || ->
      (window['ga'].q = window['ga'].q || []).push arguments
    window['ga'].l = 1 * new Date()

    # Add the script
    googleScript = document.createElement("script")
    googleScript.async = 1
    googleScript.src = '//www.google-analytics.com/analytics.js'

    firstScript = document.getElementsByTagName("script")[0]
    firstScript.parentNode.insertBefore googleScript, firstScript

    # Create the analytics
    ga 'create', GoogleAnalytics.analyticsId(), 'auto'

    # You can enable additional modules like so
    # ga 'require', 'displayfeatures'

    if typeof Turbolinks isnt 'undefined' and Turbolinks.supported
      document.addEventListener "page:change", GoogleAnalytics.trackPageview, true
    else
      GoogleAnalytics.trackPageview()

  @trackPageview: (url) ->
    unless GoogleAnalytics.isLocalRequest()
      if url
        ga 'send', 'pageview', url
      else
        ga 'send', 'pageview'

  # Change to match your development enviroment
  @isLocalRequest: ->
    document.domain.indexOf('dev') isnt -1

  @analyticsId: ->
    'UA-68119887-1'

GoogleAnalytics.load()
