<%@ taglib prefix="sf" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MusicShare</title>
    <link href="<sf:url value="/resources/css/bootstrap.min.css"/>" rel="stylesheet">
    <link href="<sf:url value="/resources/css/bootstrap-tags.css"/>" rel="stylesheet">
    <script src="<sf:url value="/resources/js/jquery.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/jquery-ui.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/bootstrap.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/bootstrap-tags.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/coffee-script.min.js"/>"></script>
    <script type="text/coffeescript" src="<sf:url value="/resources/coffee/main.coffee"/>"></script>
</head>
<body>
    <audio id="player">
    </audio>
    <div id="player_view" class="input-group" style="width: 20%; position: absolute; z-index: 1">
        <span class="input-group-btn">
            <button id="player_play_button" class="btn btn-default" type="button"><span class="glyphicon glyphicon-play"></span></button>
        </span>
        <span id="player_title" class="input-group-addon" style="width: 100%"></span>
    </div>
    <div class="col-md-8 col-md-offset-2">
        <nav id="title" class="navbar navbar-default">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="<sf:url value="/"/>">MusicShare</a>
                </div>
            </div>
        </nav>
        <div id="content">
            <i class='fa fa-refresh fa-spin'></i>
        </div>
    </div>
    <div id="playlist_dialog" class='modal' tabindex='-1' role='dialog' aria-labelledby='playlist_edit_dialog_label' aria-hidden='true'>
        <div class='modal-dialog'>
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                    <h4 class='modal-title' id='playlist_edit_dialog_label'>Playlist</h4>
                </div>
                <div class='modal-body'>
                    <div class='form-group'>
                        <label for='playlist_dialog_name_input'>Name</label>
                        <input type='text' class='form-control' id='playlist_dialog_name_input' placeholder='Enter name'>
                    </div>
                    <div class='form-group'>
                        <label for='playlist_dialog_description_textarea'>Description</label>
                        <textarea class='form-control'  id='playlist_dialog_description_textarea' rows='10' placeholder='Enter description'></textarea>
                    </div>
                </div>
                <div class='modal-footer'>
                    <button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>
                    <button id='playlist_dialog_ok_button' type='button' class='btn btn-primary'></button>
                </div>
            </div>
        </div>
    </div>
    <div id="composition_dialog" class='modal' tabindex='-1' role='dialog' aria-labelledby='composition_dialog_label' aria-hidden='true'>
        <div class='modal-dialog'>
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                    <h4 class='modal-title' id='composition_dialog_label'>Composition</h4>
                </div>
                <div class='modal-body'>
                    <div class='form-group'>
                        <label for='playlist_dialog_name_input'>Name</label>
                        <input type='text' class='form-control' id='composition_dialog_artist_name_input' placeholder='Enter artist name'>
                    </div>
                    <div class='form-group'>
                        <label for='playlist_dialog_name_input'>Name</label>
                        <input type='text' class='form-control' id='composition_dialog_composition_name_input' placeholder='Enter composition name'>
                    </div>
                    <div class='form-group'>
                        <label for='composition_dialog_genre_list'>Genre</label>
                        <div id="composition_dialog_genre_list"></div>
                    </div>
                    <div class='form-group'>
                        <label for='composition_dialog_tag_list'>Tags</label>
                        <div id="composition_dialog_tag_list"></div>
                    </div>
                    <div class='form-group'>
                        <label for='composition_dialog_link_input'>Music link</label>
                        <input type='text' class='form-control' id='composition_dialog_link_input' placeholder='Enter music link'>
                    </div>
                </div>
                <div class='modal-footer'>
                    <button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>
                    <button id='composition_dialog_ok_button' type='button' class='btn btn-primary'></button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
