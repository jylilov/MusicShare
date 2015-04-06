<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="panel panel-default">
  <div class="panel-heading">${playlist.name}</div>
  <div class="panel-body">
    <p>${playlist.description}</p>
  </div>
  <jsp:include page="/compositions?playlist_id=${playlist.id}"/>
</div>