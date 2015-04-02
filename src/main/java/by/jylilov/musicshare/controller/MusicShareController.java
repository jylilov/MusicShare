package by.jylilov.musicshare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MusicShareController {

    @RequestMapping
    String index() {
        return "index";
    }

}
