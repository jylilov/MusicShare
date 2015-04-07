package by.jylilov.musicshare.controller;

import by.jylilov.musicshare.model.Composition;
import by.jylilov.musicshare.service.CompositionService;
import by.jylilov.musicshare.service.PlaylistService;
import by.jylilov.musicshare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

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
        return "index";
    }

    @RequestMapping("/compositions")
    ModelAndView getCompositions(
            @RequestParam(value = "playlist_id", required = false) Integer playlistId,
            @RequestParam(value = "user_id", required = false) Integer userId) {
        ModelAndView modelAndView = null;
        if (playlistId != null && userId == null)
            modelAndView = getCompositionsByPlaylist(playlistId);
        else if (userId != null && playlistId == null) {
            modelAndView = getCompositionsByUser(userId);
        }
        return modelAndView;
    }

    ModelAndView getCompositionsByPlaylist(Integer playlistId) {
        Collection<Composition> compositions;
        compositions = playlistService.get(playlistId).getCompositions();
        return getCompositions(compositions);
    }

    ModelAndView getCompositionsByUser(Integer userId) {
        Collection<Composition> compositions;
        compositions = userService.get(userId).getCompositions();
        return getCompositions(compositions);
    }

    ModelAndView getCompositions(Collection<Composition> compositions) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("compositions", compositions);
        modelAndView.setViewName("compositions");
        return modelAndView;
    }

    @RequestMapping("/playlists")
    ModelAndView playlists() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("playlists", playlistService.getAll());
        modelAndView.setViewName("playlists");
        return modelAndView;
    }

    @RequestMapping("/playlist")
    ModelAndView playlist(@RequestParam Integer id) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("playlist", playlistService.get(id));
        modelAndView.setViewName("playlist");
        return modelAndView;
    }

}
