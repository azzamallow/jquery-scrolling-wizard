#
# Name    : Scrolling Wizard
# Author  : Aaron Triantafyllidis, @azzamallow
# Version : 0.1.0
# Repo    : https://github.com/azzamallow/jquery-scrolling-wizard
#

jQuery ->
  $.scrollingWizard = ( element, options ) ->
    # current state
    state = ''

    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

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

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.scrollingWizard::defaults =
      message: 'Hello world'  # option description

  $.fn.scrollingWizard = ( options ) ->
    this.each ->
      if $( this ).data( 'scrollingWizard' ) is undefined
        plugin = new $.scrollingWizard( this, options )
        $( this).data( 'scrollingWizard', plugin )