<%@ taglib prefix="sf" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MusicShare</title>
    <link href="<sf:url value="/resources/css/bootstrap.min.css"/>" rel="stylesheet">
    <script src="<sf:url value="/resources/js/jquery.min.js"/>"></script>
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
        <div class="row">
            <div class="col-md-6">
                <h3>Music compositions</h3>
                <div id="compositions">
                </div>
            </div>
            <div class="col-md-6">
                <h3>Playlists</h3>
                <div id="playlists"></div>
                <div id="selected_playlist"></div>
            </div>
        </div>
    </div>
</body>
</html>
