Application =
  refresh: ->
    do @currentContent.refresh

Application.playlistDialog =
  selector: "#playlist_dialog"
  show: ->
    $(@selector).modal 'show'
  hide: ->
    $(@selector).modal 'hide'
  save: (playlist) ->
    playlist.name = do $("#playlist_dialog_name_input").val
    playlist.description = do $("#playlist_dialog_description_textarea").val
    console.log playlist
    AjaxUtils.post "/api/playlist", playlist, ->
      do Application.refresh
  initializeModal: (name, description, readonly, okButtonCaption, okButtonFunction) ->
    $("#playlist_dialog_name_input").val(name).prop 'readonly', readonly
    $("#playlist_dialog_description_textarea").val(description).prop 'readonly', readonly
    $("#playlist_dialog_ok_button").html(okButtonCaption)
    $("#playlist_dialog_ok_button").click(okButtonFunction)
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
      Application.playlistDialog.save newPlaylist
      do Application.playlistDialog.hide



Application.userModel =
  createMapById: (list) ->
    map = {}
    for item in list
      map[item.id] = item
    map
  update: (@user) ->
    @compositionMap = @createMapById @user.compositions
    @playlistMap = @createMapById @user.playlists

Application.userContent =
  selector: "#content"
  refresh: ->
    AjaxUtils.get "/api/user?id=#{@userId}", (user) ->
      Application.currentContent.update user
      Application.currentModel.update user
  update: (@user) ->
    $(@selector).html TemplateHtml.userContent
    @compositionListView.update @user.compositions
    @playlistListView.update @user.playlists

Application.userContent.compositionListView =
  selector: "#composition_list"
  update: (@compositionList) ->
    $(@selector).html TemplateUtils.createCompositionListHtml @compositionList

Application.userContent.playlistView =
  selector: "#selected_playlist"
  update: (playlist) ->
    $(selector).html TemplateUtils.createPlaylistHtml playlist
    $(selector).sortable
      cancel: ".btn, .dropdown-menu"
      items: ".list-group-item"
      stop: (event, ui) ->
        array = $("#selected_playlist").sortable("toArray")
        return if not array.length > 1
        id = $(ui.item).attr('id')
        compositionItem = $(ui.item).data('object')
        index = array.indexOf(id)
        if index == 0
          compositionItem.compositionOrder = $("\##{array[1]}").data('object').compositionOrder - 1
        else if index == array.length - 1
          compositionItem.compositionOrder = $("\##{array[array.length - 2]}").data('object').compositionOrder + 1
        else
          a = $("\##{array[index - 1]}").data('object').compositionOrder
          b = $("\##{array[index + 1]}").data('object').compositionOrder
          compositionItem.compositionOrder = (a + b) / 2.0
        AjaxUtils.post "/api/playlist_composition", compositionItem

Application.userContent.playlistListView =
  selector: "#playlist_list"
  playlistSelected: (event, ui) ->
    $object = $ ui.selected
    $object.addClass "active"
    playlist = Application.userModel.playlistMap[$object.data "object-id"]
    Application.userContent.playlistView.update playlist
  playlistUnselected: (event, ui) ->
    $(ui.unselected).removeClass "active"
    $("#selected_playlist").html ""
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
  update: (@playlist_list) ->
    $(@selector).html TemplateUtils.createPlaylistListHtml @playlist_list
    do this.makeSelectable
    do @initializeButtons

####################################################################################################################
jQueryUtils =
  getId: (selector) ->
    $(selector).data 'object-id'


AjaxUtils =
  ajax: (method, url, callback, data) ->
    jqXHR = $.ajax
      method: method
      header:
        'Accept': 'application/json'
        'Content-Type': 'application/json'
#      accept: "application/json"
#      contentType: "application/json"
      dataType: "json"
      url: url
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
  createForeach: (array, createFunction) ->
    result = ""
    for element in array
      result += createFunction element
    result

  createCompositionListHtml: (composition_list) ->
    TemplateUtils.replaceAll TemplateHtml.compositionList,
      'items': this.createForeach composition_list, this.createCompositionItemHtml

  createPlaylistListHtml: (playlist_list) ->
    TemplateUtils.replaceAll TemplateHtml.list,
      'items': this.createForeach playlist_list, this.createPlaylistListItemHtml

  createPlaylistListItemHtml: (playlist) ->
    TemplateUtils.replaceAll TemplateHtml.playlistListItem,
      "name": playlist.name
      "id": playlist.id

  createPlaylistItemHtml: (playlistComposition) ->
    TemplateUtils.replaceAll TemplateHtml.compositionItem,
      'type': 'playlist'
      'id': playlistComposition.id
      'object': JSON.stringify(playlistComposition)
      'name': playlistComposition.composition.compositionName
      'artist': playlistComposition.composition.artistName

  createCompositionItemHtml: (composition) ->
    TemplateUtils.replaceAll TemplateHtml.compositionItem,
      'type': 'user'
      'name': composition.compositionName
      'artist': composition.artistName
      'id': composition.id
      'object': JSON.stringify(composition)

  createPlaylistHtml: (playlist) ->
    compositionList = playlist.playlistCompositions.sort (a, b) ->
      a.compositionOrder > b.compositionOrder
    TemplateUtils.replaceAll TemplateHtml.playlist,
      'name': playlist.name
      'description': playlist.description
      'items': this.createForeach compositionList this.createPlaylistItemHtml

  replaceAll: (text, templateMap) ->
    result = text
    for key, value of templateMap
      result = result.replace new RegExp("{{#{key}}}", "g"), value
    result

TemplateHtml = {}

TemplateHtml.playlist = "
<div class='panel panel-default'>
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
  <span class='btn-group btn-group-xs handle'>
    <span class='btn btn-default glyphicon glyphicon-play'></span>
  </span>
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
            <h3>Music Compositions</h3>
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
<div id='{{type}}_composition_item{{id}}' data-object='{{object}}' class='list-group-item'>
  <span class='btn-group btn-group-xs'>
    <span class='btn btn-default glyphicon glyphicon-play'></span>
  </span>
  {{artist}} - {{name}}
  <div class='pull-right'>
    <button class='btn btn-xs pull-right btn-default dropdown-toggle glyphicon glyphicon-option-vertical' type='button' id='dropdown_menu_composition{{id}}>' data-toggle='dropdown' aria-expanded='true'></button>
    <ul class='dropdown-menu' role='menu' aria-labelledby='composition_item{{id}}'>
      <li role='presentation'><a role='menuitem' tabindex='-1' href='#'>Show information</a></li>
      <li role='presentation'><a role='menuitem' tabindex='-1' href='#'>Edit information</a></li>
      <li role='presentation' class='divider'></li>
      <li role='presentation'><a role='menuitem' tabindex='-1' href='#'>Remove</a></li>
    </ul>
  </div>
</div>
"
####################################################################################################################

$ ->
  Application.userContent.userId = 1
  Application.currentContent = Application.userContent
  Application.currentModel = Application.userModel
  do Application.refresh

#  $("#playlist_dialog").on "show.bs.modal", ->
#    playlist = $("#playlist_dialog").data "object"
#    $("#playlist_dialog_name_input").val playlist.name
#    $("#playlist_dialog_description_textarea").val playlist.description
