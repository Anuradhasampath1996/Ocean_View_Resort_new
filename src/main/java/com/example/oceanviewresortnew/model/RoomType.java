package com.example.oceanviewresortnew.model;

public class RoomType {
    private int id;
    private String name; // e.g. "ocean_view"
    private String displayName; // e.g. "Ocean View"

    public RoomType() {
    }

    public RoomType(int id, String name, String displayName) {
        this.id = id;
        this.name = name;
        this.displayName = displayName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
}
