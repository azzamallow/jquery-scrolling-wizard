#
# Name    : Scrolling Wizard
# Author  : Aaron Triantafyllidis, @azzamallow
# Version : 0.1.0
# Repo    : https://github.com/azzamallow/jquery-scrolling-wizard
#

class ScrollingWizard
  constructor: (options) -> 
    @steps = options.steps
    @finished = options.finished

    # helper - scroll to a step
    scrollTo = (element, callback) ->
      return if element.length == 0

      element.removeClass 'hidden'
        
      # animate to the top. needed to anchor at the right point
      $('html, body').animate { 
        scrollTop: element.offset().top - $('.steps').offset().top 
      }, 300, 'swing', callback

    # helper - shortcut to find by id
    $id = (id) ->
      $ '#' + id

    # any navigations within the steps need to work
    $('[data-navigate]').click (event) ->
        event.preventDefault()
        element = $(event.currentTarget)
        scrollTo $id(element.data().navigate)

    # Set up the steps
    $(@steps).each (index, step) =>
      $step = $(step.id)
      data = $step.data()
      $submit = $id(data.submit)
      $navigation = $id(data.navigation)

      # default the nextStep function if one is not provided
      step.nextStep = step.nextStep || -> data.next

      # when the step is submitted
      $submit.click (event) =>
        event.preventDefault();
        $next = $id(step.nextStep())
        value = step.validation()

        # dont bother scrolling if there is no outcome for the step
        return if value == null

        # update the navigation bar
        $navigation.empty().append "<button class=\"btn btn-info\">#{value}</button>"

        # when a navigation button is clicked
        $navigation.find('button').click ->
          scrollTo $step, step.focus

        # done, make sure the finished function is executed
        do @finished if step.finish == true

        # when the next step is not on the screen
        if $next.hasClass 'hidden'

          # ensure every next step is hidden
          $id(attr).addClass 'hidden' for attr in data when attr == 'next'
          
          # clear the now stale navigation item
          do $id($next.data().navigation).empty

        scrollTo $next;

jQuery ->
  $.scrollingWizard = ( options ) ->
    # current state
    state = ''

    # plugin settings
    @settings = {}

    # set current state
    @setState = ( _state ) -> state = _state

    #get current state
    @getState = -> state

    # get particular plugin setting
    @getSetting = ( key ) ->
      @settings[ key ]

    # call one of the plugin setting functions
    @callSettingFunction = ( name, args = [] ) ->
      @settings[name].apply( this, args )

    @init = ->
      @settings = $.extend( {}, @defaults, options )

      new ScrollingWizard @settings

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.scrollingWizard::defaults =
      steps: [],
      finished: ->

  $.fn.scrollingWizard = ( options ) ->
    this.each ->
      if $( this ).data( 'scrollingWizard' ) is undefined
        plugin = new $.scrollingWizard( this, options )
        $( this).data( 'scrollingWizard', plugin )