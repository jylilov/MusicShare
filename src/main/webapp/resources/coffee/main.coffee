application =
  update: ->
    do @content.refresh

class Playlist
  @update: (playlist) ->
    $("#selected_playlist").html(TemplateUtils.createPlaylistHtml(playlist))
    $("#selected_playlist").sortable
      cancel: ".btn, .dropdown-menu"
      items: '.list-group-item'
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
        ApiUtils.post "/api/playlist_composition", compositionItem

class PlaylistList
  @update: (playlist_list) ->
    $("#playlists").html(TemplateUtils.createPlaylistListHtml(playlist_list))
    $("#playlists .playlist-edit-button").click ->
      $("#playlist_dialog").data 'object', $(this).data 'object'
    $("#playlists .playlist-delete-button").click ->
      object = $(this).data 'object'
      ApiUtils.delete "/api/playlist?id=#{object.id}", ->
        do application.update
    $("#playlists").selectable
      tolerance: "fit"
      cancel: ".btn, .dropdown-menu"
      filter: '.list-group-item'
      selected: (event, ui) ->
        $object = $(ui.selected)
        $object.addClass("active")
        Playlist.update($object.data("object"))
      unselected: (event, ui) ->
        $(ui.unselected).removeClass("active")
        $("#selected_playlist").html("")
    $("#playlist_dialog_save_button").click ->
      object = $("#playlist_dialog").data 'object'
      object.name = do $("#playlist_dialog_name_input").val
      object.description = do $("#playlist_dialog_description_textarea").val
      ApiUtils.post "/api/playlist", object, ->
        application.update()
    $("#playlist_add_button").click ->
      object =
        name: ""
        description: ""


class CompositionList
  @update: (composition_list) ->
    $("#compositions").html(TemplateUtils.createCompositionListHtml(composition_list))

class UserContent
  constructor: (@userId) ->
    do this.refresh
  refresh: ->
    ApiUtils.get "/api/user?id=#{@userId}", this.update
  update: (@user) ->
    $("#content").html(user_content_text)
    CompositionList.update @user.compositions
    PlaylistList.update @user.playlists

####################################################################################################################

class ApiUtils
  @get: (url, callback) ->
    $.ajax
      type: "GET"
      headers:
        'Accept': 'application/json'
      url: url
      success: callback
  @post: (url, data, callback) ->
    $.ajax
      type: "POST"
      headers:
        'Accept': 'application/json'
        'Content-Type': 'application/json'
      url: url
      data: JSON.stringify(data)
      success: callback
  @delete: (url, callback) ->
    $.ajax
      type: "DELETE"
      headers:
        'Accept': 'application/json'
        'Content-Type': 'application/json'
      url: url
      success: callback

####################################################################################################################
class TemplateUtils

  @createCompositionListHtml: (composition_list) ->
    items = "";
    for composition in composition_list
      items += TemplateUtils.createCompositionItemHtml(composition)
    listValueMap = {'items' : items }
    TemplateUtils.fillTemplate(list_text, listValueMap)

  @createPlaylistListHtml: (playlist_list) ->
    items = "";
    for playlist in playlist_list
      items += TemplateUtils.createPlaylistListItemHtml(playlist)
    listValueMap = {'items' : items }
    TemplateUtils.fillTemplate(list_text, listValueMap)

  @createPlaylistListItemHtml: (playlist) ->
    playlistValueMap = {
      "name": playlist.name
      "id": playlist.id
      "object": JSON.stringify(playlist)
    }
    TemplateUtils.fillTemplate(playlist_list_item_text, playlistValueMap)

  @createPlaylistItemHtml: (playlistComposition) ->
    valueMap = {
      'type': 'playlist'
      'id': playlistComposition.id
      'object': JSON.stringify(playlistComposition)
      'name': playlistComposition.composition.compositionName
      'artist': playlistComposition.composition.artistName
    }
    TemplateUtils.fillTemplate(composition_item_text, valueMap)

  @createCompositionItemHtml: (composition) ->
    compositionValueMap = {
      'type': 'user'
      'name': composition.compositionName
      'artist': composition.artistName
      'id': composition.id
      'object': JSON.stringify(composition)
    }
    TemplateUtils.fillTemplate(composition_item_text, compositionValueMap)

  @createPlaylistHtml: (playlist) ->
    items = "";
    playlistCompositions = playlist.playlistCompositions.sort (a, b) ->
      a.compositionOrder > b.compositionOrder
    for playlistComposition in playlistCompositions
      items += TemplateUtils.createPlaylistItemHtml( playlistComposition)
    listValueMap = {
      'name': playlist.name
      'description': playlist.description
      'items': items
    }
    TemplateUtils.fillTemplate(playlist_text, listValueMap)

  @fillTemplate: (template, valueMap) ->

    answer = template
    for key, value of valueMap
      answer = answer.replace new RegExp("{{#{key}}}", "g"), value
    answer

list_text = "
<div class='list-group'>
{{items}}
</div>
"

playlist_list_item_text = "
<div id='playlist_list_item{{id}}' class='list-group-item' data-object='{{object}}'>
  <span class='btn-group btn-group-xs handle'>
    <span class='btn btn-default glyphicon glyphicon-play'></span>
  </span>
  {{name}}
  <div class='pull-right'>
    <button class='btn btn-xs pull-right btn-default dropdown-toggle glyphicon glyphicon-option-vertical' type='button' id='dropdown_menu_playlist{{id}}' data-toggle='dropdown' aria-expanded='true'></button>
    <ul class='dropdown-menu' role='menu' aria-labelledby='dropdown_menu_playlist{{id}}'>
      <li role='presentation'><a class='playlist-edit-button' role='menuitem' tabindex='-1' data-object='{{object}}' data-toggle='modal' data-target='#playlist_dialog' href='#'>Show/Edit information</a></li>
      <li role='presentation' class='divider'></li>
      <li role='presentation'><a class='playlist-delete-button' role='menuitem' tabindex='-1' data-object='{{object}}' href='#'>Remove</a></li>
    </ul>
  </div>
</div>
"

playlist_text = "
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

composition_item_text = "
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

user_content_text = "
<div class='row'>
    <div class='col-md-6'>
        <h3>Music Compositions</h3>
        <div id='compositions'>
        </div>
    </div>
    <div class='col-md-6'>
        <h3>Playlists<button id='playlist_add_button' type='button' class='btn btn-default btn-xs glyphicon glyphicon-plus'></button></h3>
        <div id='playlists'></div>
        <div id='selected_playlist'></div>
    </div>
</div>
"

####################################################################################################################

$ ->
  application.content = new UserContent(1)

  $("#playlist_dialog").on "show.bs.modal", ->
    playlist = $("#playlist_dialog").data "object"
    $("#playlist_dialog_name_input").val playlist.name
    $("#playlist_dialog_description_textarea").val playlist.description
