package by.jylilov.musicshare.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "compositions")
public class Composition {

    @Id
    @GeneratedValue
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonBackReference
    private User user;

    @Column(name = "artist_name")
    private String artistName;

    @Column(name = "composition_name")
    private String compositionName;

    @ElementCollection(targetClass = String.class, fetch = FetchType.EAGER)
    @JoinTable(
            name = "composition_tags",
            joinColumns = @JoinColumn(name = "composition_id", referencedColumnName = "id")
    )
    private Set<String> tagList;

    @ElementCollection(targetClass = Genre.class, fetch = FetchType.EAGER)
    @Enumerated
    @JoinTable(
            name = "composition_genres",
            joinColumns = @JoinColumn(name = "composition_id", referencedColumnName = "id")
    )
    private Set<Genre> genreList;

    @Column
    private String link;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "composition")
    @JsonIgnore
    private Set<PlaylistComposition> playlistCompositionSet;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public String getCompositionName() {
        return compositionName;
    }

    public void setCompositionName(String compositionName) {
        this.compositionName = compositionName;
    }

    public Set<Genre> getGenreList() {
        return genreList;
    }

    public void setGenreList(Set<Genre> genreList) {
        this.genreList = genreList;
    }

    public Set<String> getTagList() {
        return tagList;
    }

    public void setTagList(Set<String> tagList) {
        this.tagList = tagList;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }
}
