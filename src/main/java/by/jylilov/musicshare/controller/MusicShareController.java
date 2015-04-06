package by.jylilov.musicshare.controller;

import by.jylilov.musicshare.model.Composition;
import by.jylilov.musicshare.service.CompositionService;
import by.jylilov.musicshare.service.PlaylistService;
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
    CompositionService compositionService;

    @Autowired
    PlaylistService playlistService;

    @RequestMapping
    String index() {
        return "index";
    }

    @RequestMapping("/compositions")
    ModelAndView composition(@RequestParam(required = false, value = "playlist_id") Integer playlistId) {
        ModelAndView modelAndView = new ModelAndView();
        Collection<Composition> compositions;
        if (playlistId == null) {
            compositions = compositionService.getAll();
        } else {
            compositions = playlistService.get(playlistId).getCompositions();
        }
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
