package by.jylilov.musicshare.model;

import javax.persistence.*;

@Entity
@Table(name = "compositions")
public class Composition {

    @Id
    @GeneratedValue
    private Integer id;

    @Column(name = "artist_name")
    private String artistName;

    @Column(name = "composition_name")
    private String compositionName;

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
}
