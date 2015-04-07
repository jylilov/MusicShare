package by.jylilov.musicshare.model;

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
    private User user;

    @Column(name = "playlist_name")
    private String name;

    @Column(name = "playlist_description", length = 2048)
    private String description;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "playlist_compositions",
            joinColumns = @JoinColumn(name = "playlist_id"),
            inverseJoinColumns = @JoinColumn(name = "composition_id")
    )
    private Set<Composition> compositions;

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

    public Set<Composition> getCompositions() {
        return compositions;
    }

    public void setCompositions(Set<Composition> compositions) {
        this.compositions = compositions;
    }
}
