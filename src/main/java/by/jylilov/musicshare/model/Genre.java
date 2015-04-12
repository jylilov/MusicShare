package by.jylilov.musicshare.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum Genre {
    ROCK("Rock"),
    METAL("Metal");

    private String name;

    Genre(String name) {
        this.name = name;
    }

    @JsonValue
    public String getName() {
        return name;
    }
}
