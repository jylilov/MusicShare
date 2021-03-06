package by.jylilov.musicshare.controller;

import by.jylilov.musicshare.model.Composition;
import by.jylilov.musicshare.model.Playlist;
import by.jylilov.musicshare.model.PlaylistComposition;
import by.jylilov.musicshare.model.User;
import by.jylilov.musicshare.service.CompositionService;
import by.jylilov.musicshare.service.PlaylistService;
import by.jylilov.musicshare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;

@Controller
@RequestMapping("/")
public class MusicShareController {

    @Autowired
    private CompositionService compositionService;

    @Autowired
    private PlaylistService playlistService;

    @Autowired
    private UserService userService;

    @RequestMapping
    String index() {
        compositionService.getAll();
        return "index";
    }

//    @RequestMapping("/api/playlist")
//    @ResponseBody
//    Playlist getPlaylist(@RequestParam("id") Integer id) {
//        return playlistService.get(id);
//    }

    @RequestMapping("/api/playlist_list")
    @ResponseBody
    Collection<Playlist> getPlaylistList(@RequestParam("user_id") Integer userId) {
        return userService.get(userId).getPlaylists();
    }

    @RequestMapping("/api/composition_list")
    @ResponseBody
    Collection<Composition> getCompositionList(@RequestParam("user_id") Integer userId) {
        return userService.get(userId).getCompositions();
    }

    @RequestMapping("/api/user")
    @ResponseBody
    User getUser(@RequestParam("id") Integer id) {
        return userService.get(id);
    }

    @RequestMapping(value = "/api/playlist_composition", method = RequestMethod.POST)
    @ResponseBody
    PlaylistComposition postPlaylistComposition(@RequestBody PlaylistComposition playlistComposition) {
        return playlistService.updatePlaylistComposition(playlistComposition);
    }

    @RequestMapping(value = "/api/playlist_composition", method = RequestMethod.DELETE)
    @ResponseBody
    User deletePlaylistComposition(@RequestParam Integer id) {
        //TODO user from SecurityContent
        try {
            playlistService.deletePlaylistComposition(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userService.get(1);
    }

    @RequestMapping(value = "/api/playlist", method = RequestMethod.POST)
    @ResponseBody
    Playlist postPlaylist(@RequestBody Playlist playlist) {
        //TODO user from SecurityContent
        playlist.setUser(userService.get(1));
        return playlistService.updatePlaylist(playlist);
    }

    @RequestMapping(value = "/api/playlist", method = RequestMethod.DELETE)
    @ResponseBody
    User deletePlaylist(@RequestParam Integer id) {
        return playlistService.deletePlaylist(id);
    }

    @RequestMapping(value = "/api/composition", method = RequestMethod.DELETE)
    @ResponseBody
    User deleteComposition(@RequestParam Integer id) {
        compositionService.deleteComposition(id);
        return userService.get(1);
    }

    @RequestMapping(value = "/api/composition", method = RequestMethod.POST)
    @ResponseBody
    User postComposition(@RequestBody Composition composition) {
        try {
            User user = userService.get(1);
            composition.setUser(user);
            compositionService.updateComposition(composition);
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            throw  e;
        }
    }

}
