package by.jylilov.musicshare.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "playlists")
public class Playlist {

    @Id
    @GeneratedValue
    @Column(name = "playlist_id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonBackReference
    private User user;

    @Column(name = "playlist_name")
    private String name;

    @Column(name = "playlist_description", length = 2048)
    private String description;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "playlist", cascade = CascadeType.REMOVE)
    @JsonManagedReference
    private Set<PlaylistComposition> playlistCompositions;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<PlaylistComposition> getPlaylistCompositions() {
        return playlistCompositions;
    }

    public void setPlaylistCompositions(Set<PlaylistComposition> playlistCompositions) {
        this.playlistCompositions = playlistCompositions;
    }
}
