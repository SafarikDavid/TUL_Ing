package com.example.boardgametracker;

import java.time.LocalDate;

public class Game {
    private int _id;
    private String name;
    private LocalDate localDate;

    public Game(int _id, String name, LocalDate localDate) {
        this._id = _id;
        this.name = name;
        this.localDate = localDate;
    }

    @Override
    public String toString() {
        return "Game{" +
                "_id=" + _id +
                ", name='" + name + '\'' +
                ", localDate=" + localDate +
                '}';
    }

    public int get_id() {
        return _id;
    }

    public void set_id(int _id) {
        this._id = _id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDate getLocalDate() {
        return localDate;
    }

    public void setLocalDate(LocalDate localDate) {
        this.localDate = localDate;
    }
}
