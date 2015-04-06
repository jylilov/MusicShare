package by.jylilov.musicshare.model;

import javax.persistence.*;
import java.util.Collection;

@Entity
@Table(name = "playlists")
public class Playlist {

    @Id
    @GeneratedValue
    private Integer id;

    @Column
    private String name;

    @Column(length = 2048)
    private String description;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "playlist_compositions",
            joinColumns = @JoinColumn(name = "playlist_id", referencedColumnName = "id"),
            inverseJoinColumns = @JoinColumn(name = "composition_id", referencedColumnName = "id")
    )
    private Collection<Composition> compositions;

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

    public Collection<Composition> getCompositions() {
        return compositions;
    }

    public void setCompositions(Collection<Composition> compositions) {
        this.compositions = compositions;
    }
}
