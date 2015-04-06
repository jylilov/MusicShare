<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="list-group">
  <c:forEach items="${playlists}" var="playlist">
    <div class="list-group-item">
      <span class="btn-group btn-group-xs">
        <span class="btn btn-default glyphicon glyphicon-play"></span>
      </span>
      ${playlist.name}
      <div class="pull-right">
        <button class="btn btn-xs pull-right btn-default dropdown-toggle glyphicon glyphicon-option-vertical" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true"></button>
        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
          <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Show information</a></li>
          <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Edit information</a></li>
          <li role="presentation" class="divider"></li>
          <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Rate</a></li>
          <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Like</a></li>
          <li role="presentation" class="divider"></li>
          <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Remove</a></li>
        </ul>
      </div>
    </div>
  </c:forEach>
</div>