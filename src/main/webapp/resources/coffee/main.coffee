Application =
  init: ->
    do Application.playlistDialog.init
    do Application.compositionDialog.init
    do Application.player.init
  refresh: ->
    do @currentContent.refresh

Application.player =
  init: ->
    @player = document.getElementById "player"
    do $("#player_view").draggable
    $("#player_play_button").click ->
      return if not Application.player.playingComposition?
      if Application.player.isPlaying(Application.player.playingComposition)
        do Application.player.pause
      else
        Application.player.play Application.player.playingComposition
    @player.onplay = ->
      $("#player_view .glyphicon").removeClass("glyphicon-play").addClass("glyphicon-pause")
      $("#player_title").html "#{Application.player.playingComposition.artistName} - #{Application.player.playingComposition.compositionName}"
    @player.onpause = ->
      $("#player_view .glyphicon").removeClass("glyphicon-pause").addClass("glyphicon-play")
  isPlaying: (composition) ->
    not @player.paused && @playingComposition? && @playingComposition.id == composition.id
  pause: ->
    do @player.pause
    $(".composition#{@playingComposition.id}").removeClass("glyphicon-pause").addClass("glyphicon-play")
  play: (composition) ->
    if @playingComposition?
      $(".composition#{@playingComposition.id}").removeClass("glyphicon-pause").addClass("glyphicon-play")
    $(".composition#{composition.id}").removeClass("glyphicon-play").addClass("glyphicon-pause")
    if not @playingComposition? || composition.id != @playingComposition.id
      @playingComposition = composition
      @player.src = @playingComposition.link
      do @player.load
      do @player.play
    else
      do @player.play

Application.compositionDialog =
  selector: "#composition_dialog"
  tagSelector: "#composition_dialog_tag_list"
  genreSelector: "#composition_dialog_genre_list"
  genres: ["Rock", "Pop", "Rap & Hip-Hop", "House & Dance",
           "Alternative", "Instrumental", "Easy Listening",
           "Metal", "Dubstep & Trap", "Indie pop", "Jazz & Blues",
           "Drum & Bass", "Trance", "Ethnic", "Acoustic & Vocal",
           "Reggae", "Classical", "Electropop & Disco"]
  init: ->
    $("#composition_dialog_ok_button").click ->
      do Application.compositionDialog.okButtonHandler
  show: ->
    $(@selector).modal 'show'
  hide: ->
    $(@selector).modal 'hide'
  save: (composition) ->
    composition.artistName = do $("#composition_dialog_artist_name_input").val
    composition.compositionName = do $("#composition_dialog_composition_name_input").val
    composition.link = do $("#composition_dialog_link_input").val
    composition.genreList = do $("#composition_dialog_genre_list .tags-content").tags().getTags
    composition.tagList = do $("#composition_dialog_tag_list .tags-content").tags().getTags
    AjaxUtils.post "/api/composition", composition, ->
      do Application.refresh
  updateTextInputs: (composition, readOnly) ->
    $("#composition_dialog_artist_name_input").val(composition.artistName).prop 'readonly', readOnly
    $("#composition_dialog_composition_name_input").val(composition.compositionName).prop 'readonly', readOnly
    $("#composition_dialog_link_input").val(composition.link).prop 'readonly', readOnly
  updateTagsInputs: (composition, readOnly) ->
    $(@tagSelector).html "<div class='tags-content'></div>"
    $(@genreSelector).html "<div class='tags-content'></div>"
    $("#composition_dialog_tag_list .tags-content").tags
      promptText: "Enter tags"
      readOnlyEmptyMessage: "No tags"
      caseInsensitive: true
      readOnly: readOnly
      tagData: composition.tagList
    $("#composition_dialog_genre_list .tags-content").tags
      promptText: "Enter genres"
      readOnlyEmptyMessage: "No genres"
      caseInsensitive: true
      readOnly: readOnly
      suggestions: @genres
      restrictTo: @genres
      tagData: composition.genreList
  updateInputsAndShow: (composition, readOnly) ->
    @updateTextInputs composition, readOnly
    do @show
    @updateTagsInputs composition, readOnly
  updateDialog: (composition, readOnly, okButtonCaption, okButtonFunction) ->
    @updateInputsAndShow composition, readOnly
    $("#composition_dialog_ok_button").html okButtonCaption
    @okButtonHandler = okButtonFunction
  showComposition: (composition) ->
    @updateDialog composition, true, "OK",  ->
      do Application.compositionDialog.hide
  editComposition: (composition) ->
    @updateDialog composition, false, "Save", ->
      Application.compositionDialog.save composition
  cloneComposition: (composition) ->
    composition.id = null
    @updateDialog composition, false, "Add", ->
      Application.compositionDialog.save composition
      do Application.compositionDialog.hide
  createComposition: ->
    composition =
      artistName: ""
      compositionName: ""
      genreList: []
      tagList: []
      link: ""
    @updateDialog composition, false, "Add", ->
      Application.compositionDialog.save composition
      do Application.compositionDialog.hide

Application.playlistDialog =
  selector: "#playlist_dialog"
  init: ->
    $("#playlist_dialog_ok_button").click ->
      do Application.playlistDialog.okButtonHandler
  show: ->
    $(@selector).modal 'show'
  hide: ->
    $(@selector).modal 'hide'
  save: (playlist) ->
    playlist.name = do $("#playlist_dialog_name_input").val
    playlist.description = do $("#playlist_dialog_description_textarea").val
    AjaxUtils.post "/api/playlist", playlist, ->
      do Application.refresh
  initializeModal: (name, description, readonly, okButtonCaption, okButtonFunction) ->
    $("#playlist_dialog_name_input").val(name).prop 'readonly', readonly
    $("#playlist_dialog_description_textarea").val(description).prop 'readonly', readonly
    $("#playlist_dialog_ok_button").html(okButtonCaption)
    @okButtonHandler = okButtonFunction
    do @show
  showPlaylist: (playlist) ->
    @initializeModal playlist.name, playlist.description, true, "OK", ->
      do Application.playlistDialog.hide
  editPlaylist: (playlist) ->
    @initializeModal playlist.name, playlist.description, false, "Save", ->
      Application.playlistDialog.save playlist
  addPlaylist: ->
    @initializeModal "", "", false, "Add", ->
      newPlaylist = {}
      do Application.playlistDialog.hide
      Application.playlistDialog.save newPlaylist

Application.userModel =
  createMapById: (list) ->
    map = {}
    for item in list
      map[item.id] = item
    map
  update: (@user) ->
    @compositionMap = @createMapById @user.compositions
    @playlistMap = @createMapById @user.playlists
    playlistCompositionList = []
    for playlist in @user.playlists
      for playlistComposition in playlist.playlistCompositions
        playlistCompositionList.push playlistComposition
    @playlistCompositionMap = @createMapById playlistCompositionList

Application.userContent =
  selector: "#content"
  refresh: ->
    AjaxUtils.get "/api/user?id=#{@userId}", (user) ->
      Application.currentModel.update user
      Application.currentContent.update user
  update: (@user) ->
    $(@selector).html TemplateHtml.userContent
    @compositionListView.update @user.compositions
    @playlistListView.update @user.playlists
  initializeCompositionViewButtons: (parent) ->
    $(parent).find(".composition-show-button").click ->
      composition = Application.userModel.compositionMap[$(this).data 'object-id']
      Application.compositionDialog.showComposition composition
    $(parent).find(".composition-edit-button").click ->
      composition = Application.userModel.compositionMap[$(this).data 'object-id']
      Application.compositionDialog.editComposition composition
    $(parent).find(".composition-clone-button").click ->
      composition = Application.userModel.compositionMap[$(this).data 'object-id']
      Application.compositionDialog.cloneComposition composition
    $(parent).find(".composition-play-button").click ->
      composition = Application.userModel.compositionMap[$(this).data 'object-id']
      if Application.player.isPlaying composition
        do Application.player.pause
      else
        Application.player.play composition

Application.userContent.compositionListView =
  selector: "#composition_list"
  initializeButtons: ->
    $(".composition-add-button").click ->
      do Application.compositionDialog.createComposition
    $("#composition_list .composition-delete-button").click ->
      AjaxUtils.delete "/api/composition?id=#{$(this).data 'object-id'}", ->
        do Application.refresh
  initializeDraggable: ->
    $("#composition_list .list-group-item").draggable
      cancel: ".btn, .dropdown-menu"
      helper: 'clone'
      appendTo: 'body'
      drag: (event, ui) ->
        ui.position.left = event.pageX - ui.helper.width() / 2.0
        ui.position.top = event.pageY - ui.helper.height() / 2.0
  update: (@compositionList) ->
    $(@selector).html TemplateUtils.createCompositionListHtml @compositionList
    Application.userContent.initializeCompositionViewButtons @selector
    do @initializeButtons
    do @initializeDraggable

Application.userContent.playlistView =
  selector: "#selected_playlist"
  changeOrder: (item, list) ->
    index = list.indexOf(item)
    if index == 0
      item.compositionOrder = list[1].compositionOrder - 1
    else if index == list.length - 1
      item.compositionOrder = list[list.length - 2].compositionOrder + 1
    else
      item.compositionOrder = (list[index - 1].compositionOrder + list[index + 1].compositionOrder) / 2.0
    AjaxUtils.post "/api/playlist_composition", item
  makeDroppable: ->
    $(@selector).droppable
      accept: ".user-composition-item"
      drop: (event, ui) ->
        playlistComposition =
          composition: Application.userModel.compositionMap[$(ui.helper).data 'object-id']
          playlist: Application.userModel.playlistMap[Application.userContent.playlistListView.selectedItemId]
        maxValue = null
        for item in playlistComposition.playlist.playlistCompositions
          if (maxValue != null && maxValue < item.compositionOrder) || maxValue == null
            maxValue = item.compositionOrder
        maxValue = 0 if maxValue == null
        playlistComposition.compositionOrder = maxValue + 1
        AjaxUtils.post "api/playlist_composition", playlistComposition, ->
          do Application.refresh
  makeSortable: ->
    $(@selector).sortable
      cancel: ".btn, .dropdown-menu"
      items: ".list-group-item"
      stop: (event, ui) ->
        list = []
        for item in $("#selected_playlist").sortable "toArray"
          id = $("\##{item}").data('object-id')
          list.push Application.userModel.playlistCompositionMap[id]
        return if list.length <= 1
        item = Application.userModel.playlistCompositionMap[$(ui.item).data 'object-id']
        Application.userContent.playlistView.changeOrder item, list
  initializeButtons: ->
    $(".playlist-composition-item .composition-delete-button").click ->
      playlistComposition = Application.userModel.playlistCompositionMap[$(this).data 'object-id']
      AjaxUtils.delete "/api/playlist_composition?id=#{playlistComposition.id}", ->
        do Application.refresh
      false
  update: (@playlistId) ->
    playlist = Application.userModel.playlistMap[@playlistId];
    return if not playlist?
    $(@selector).html TemplateUtils.createPlaylistHtml playlist
    Application.userContent.initializeCompositionViewButtons @selector
    do @makeSortable
    do @makeDroppable
    do @initializeButtons

Application.userContent.playlistListView =
  selector: "#playlist_list"
  playlistSelected: (event, ui) ->
    $object = $ ui.selected
    $object.addClass "active"
    playlist = Application.userModel.playlistMap[$object.data "object-id"]
    Application.userContent.playlistListView.selectedItemId = playlist.id
    Application.userContent.playlistListView.updatePlaylistView playlist.id
  playlistUnselected: (event, ui) ->
    $(ui.unselected).removeClass "active"
    $("#selected_playlist").html ""
    Application.userContent.playlistListView.selectedItemId = null
  makeSelectable: ->
    $(@selector).selectable
      tolerance: "fit"
      cancel: ".btn, .dropdown-menu"
      filter: '.list-group-item'
      selected: @playlistSelected
      unselected: @playlistUnselected
  initializeButtons: ->
    $(".playlist-edit-button").click ->
      Application.playlistDialog.editPlaylist Application.userModel.playlistMap[$(this).data 'object-id']
    $(".playlist-show-button").click ->
      Application.playlistDialog.showPlaylist Application.userModel.playlistMap[$(this).data 'object-id']
    $(".playlist-add-button").click ->
      Application.playlistDialog.addPlaylist Application.userModel.playlistMap[$(this).data 'object-id']
    $(".playlist-delete-button").click ->
      AjaxUtils.delete "/api/playlist?id=#{$(this).data 'object-id'}", ->
        do Application.refresh
    false
  updatePlaylistView: (selectedItemId)->
    if @selectedItemId?
      if selectedItemId?
        @selectedItemId = selectedItemId
      $("#playlist_list_item#{@selectedItemId}").addClass("active ui-selected")
      Application.userContent.playlistView.update @selectedItemId
  update: (@playlist_list) ->
    $(@selector).html TemplateUtils.createPlaylistListHtml @playlist_list
    do this.makeSelectable
    do @initializeButtons
    do @updatePlaylistView

####################################################################################################################
AjaxUtils =
  ajax: (method, url, callback, data) ->
    jqXHR = $.ajax
      method: method
      accept: "application/json"
      contentType: "application/json"
      dataType: "json"
      url: url
      data: JSON.stringify data
    jqXHR.done callback
    jqXHR.fail (data, textStatus, errorThrown) ->
      #TODO more beautiful alert
      alert "#{method}: #{url} (#{errorThrown})"
  get: (url, callback) ->
    this.ajax "GET", url, callback
  post: (url, data, callback) ->
    this.ajax "POST", url, callback, data
  delete: (url, callback) ->
    this.ajax "DELETE", url, callback
####################################################################################################################
TemplateUtils =
  sortById: (a, b) ->
    a.id > b.id
  createForeach: (array, createFunction) ->
    result = ""
    for element in array
      result += createFunction element
    result

  createCompositionListHtml: (composition_list) ->
    composition_list = composition_list.sort @sortById
    TemplateUtils.replaceAll TemplateHtml.compositionList,
      'items': this.createForeach composition_list, this.createCompositionItemHtml

  createPlaylistListHtml: (playlist_list) ->
    playlist_list = playlist_list.sort @sortById
    TemplateUtils.replaceAll TemplateHtml.list,
      'items': this.createForeach playlist_list, this.createPlaylistListItemHtml

  createPlaylistListItemHtml: (playlist) ->
    TemplateUtils.replaceAll TemplateHtml.playlistListItem,
      "name": playlist.name
      "id": playlist.id

  getGlyph: (composition) ->
    if Application.player.isPlaying(composition) then 'pause' else 'play'

  createPlaylistItemHtml: (playlistComposition) ->
    TemplateUtils.replaceAll TemplateHtml.compositionItem,
      'type': 'playlist'
      'id': playlistComposition.id
      'id-content': playlistComposition.composition.id
      'name': playlistComposition.composition.compositionName
      'artist': playlistComposition.composition.artistName
      'glyph': TemplateUtils.getGlyph playlistComposition.composition

  createCompositionItemHtml: (composition) ->
    TemplateUtils.replaceAll TemplateHtml.compositionItem,
      'type': 'user'
      'id': composition.id
      'id-content': composition.id
      'name': composition.compositionName
      'artist': composition.artistName
      'glyph': TemplateUtils.getGlyph composition

  createPlaylistHtml: (playlist) ->
    compositionList = playlist.playlistCompositions.sort (a, b) ->
      a.compositionOrder > b.compositionOrder
    TemplateUtils.replaceAll TemplateHtml.playlist,
      'id': playlist.id
      'name': playlist.name
      'description': playlist.description
      'items': this.createForeach compositionList, this.createPlaylistItemHtml

  replaceAll: (text, templateMap) ->
    result = text
    for key, value of templateMap
      result = result.replace new RegExp("{{#{key}}}", "g"), value
    result

TemplateHtml = {}

TemplateHtml.playlist = "
<div class='panel panel-default' data-object-id='{{id}}'>
  <div class='panel-heading'>{{name}}</div>
    <div class='panel-body'>
      <p>{{description}}</p>
  </div>
  <div class='list-group'>
    {{items}}
  </div>
</div>
"
TemplateHtml.playlistListItem = "
<div id='playlist_list_item{{id}}' class='list-group-item' data-object-id='{{id}}'>
  <!--<span class='btn-group btn-group-xs handle'>
    <span class='btn btn-default glyphicon glyphicon-play'></span>
  </span>-->
  {{name}}
  <div class='pull-right'>
    <button class='btn btn-xs pull-right btn-default dropdown-toggle glyphicon glyphicon-option-vertical' type='button' id='dropdown_menu_playlist{{id}}' data-toggle='dropdown' aria-expanded='true'></button>
    <ul class='dropdown-menu' role='menu' aria-labelledby='dropdown_menu_playlist{{id}}'>
      <li role='presentation'><a class='playlist-show-button' role='menuitem' tabindex='-1' data-object-id='{{id}}' href='#'>Show information</a></li>
      <li role='presentation'><a class='playlist-edit-button' role='menuitem' tabindex='-1' data-object-id='{{id}}' href='#'>Edit information</a></li>
      <li role='presentation' class='divider'></li>
      <li role='presentation'><a class='playlist-delete-button' role='menuitem' tabindex='-1' data-object-id='{{id}}' href='#'>Remove</a></li>
    </ul>
  </div>
</div>
"
TemplateHtml.list = "
<div class='list-group'>
{{items}}
</div>
"
TemplateHtml.userContent = "
    <div class='row'>
        <div class='col-md-6'>
            <h3>Music Compositions<button type='button' class='btn btn-default composition-add-button btn-xs glyphicon glyphicon-plus'></button></h3>
            <div id='composition_list'>
            </div>
        </div>
        <div class='col-md-6'>
            <h3>Playlists<button type='button' class='btn btn-default playlist-add-button btn-xs glyphicon glyphicon-plus'></button></h3>
            <div id='playlist_list'></div>
            <div id='selected_playlist'></div>
        </div>
    </div>"
TemplateHtml.compositionList = "
<div class='list-group'>
  {{items}}
</div>
"
TemplateHtml.compositionItem = "
<div id='{{type}}{{id}}_composition_item{{id-content}}' data-object-id='{{id}}' class='list-group-item {{type}}-composition-item'>
  <span class='btn-group btn-group-xs'>
    <span class='btn btn-default glyphicon glyphicon-{{glyph}} composition-play-button composition{{id-content}}' data-object-id='{{id-content}}'></span>
  </span>
  {{artist}} - {{name}}
  <div class='pull-right'>
    <button class='btn btn-xs pull-right btn-default dropdown-toggle glyphicon glyphicon-option-vertical' type='button' id='{{type}}{{id}}dropdown_menu_composition{{id-content}}' data-toggle='dropdown' aria-expanded='true'></button>
    <ul class='dropdown-menu' role='menu' aria-labelledby='{{type}}{{id}}dropdown_menu_composition{{id-content}}'>
      <li role='presentation'><a data-object-id='{{id-content}}' class='composition-show-button' role='menuitem' tabindex='-1' href='#'>Show information</a></li>
      <li role='presentation'><a data-object-id='{{id-content}}' class='composition-edit-button' role='menuitem' tabindex='-1' href='#'>Edit information</a></li>
      <li role='presentation' class='divider'></li>
      <li role='presentation'><a data-object-id='{{id-content}}' class='composition-clone-button' role='menuitem' tabindex='-1' href='#'>Clone</a></li>
      <li role='presentation' class='divider'></li>
      <li role='presentation'><a data-object-id='{{id}}' class='composition-delete-button' role='menuitem' tabindex='-1' href='#'>Remove</a></li>
    </ul>
  </div>
</div>
"
####################################################################################################################

$ ->
  do Application.init
  Application.userContent.userId = 1
  Application.currentContent = Application.userContent
  Application.currentModel = Application.userModel
  do Application.refresh

