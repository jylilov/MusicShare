$ ->
  $("#compositions").load "/compositions?user_id=1"
  $("#playlists").load "/playlists"
  $("#selected_playlist").load "/playlist?id=2"