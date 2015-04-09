<%@ taglib prefix="sf" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MusicShare</title>
    <link href="<sf:url value="/resources/css/bootstrap.min.css"/>" rel="stylesheet">
    <script src="<sf:url value="/resources/js/jquery.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/jquery-ui.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/bootstrap.min.js"/>"></script>
    <script src="<sf:url value="/resources/js/coffee-script.min.js"/>"></script>
    <script type="text/coffeescript" src="<sf:url value="/resources/coffee/main.coffee"/>"></script>
</head>
<body>
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
    <div class='modal fade' id='playlist_dialog' tabindex='-1' role='dialog' aria-labelledby='playlist_edit_dialog_label' aria-hidden='true'>
        <div class='modal-dialog'>
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
                    <h4 class='modal-title' id='playlist_edit_dialog_label'>Playlist</h4>
                </div>
                <div class='modal-body'>
                    <div class='form-group'>
                        <label for='playlist_dialog_name_input'>Name</label>
                        <input type='email' class='form-control' id='playlist_dialog_name_input' placeholder='Enter name'>
                    </div>
                    <div class='form-group'>
                        <label for='playlist_dialog_description_textarea'>Description</label>
                        <textarea class='form-control' id='playlist_dialog_description_textarea' rows='10' placeholder='Enter description'></textarea>
                    </div>
                </div>
                <div class='modal-footer'>
                    <button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>
                    <button id='playlist_dialog_save_button' type='button' class='btn btn-primary'>Save</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
