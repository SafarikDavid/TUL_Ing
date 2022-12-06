package com.example.boardgametracker;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class Game {
    private int _id;
    private String name;
    private LocalDate localDate;

    public Game(int _id, String name, LocalDate localDate) {
        this._id = _id;
        this.name = name;
        this.localDate = localDate;
    }

    public Game(int _id, String name, String localDate) {
        this._id = _id;
        this.name = name;
        this.localDate = LocalDate.from(
                DateTimeFormatter.ISO_LOCAL_DATE.parse(localDate)
        );
    }

    @Override
    public String toString() {
        return name + ", " + localDate.format(DateTimeFormatter.ofPattern("dd.MM.yyyy"));
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

    public String getLocalDateString() {return localDate.toString();}

    public void setLocalDate(LocalDate localDate) {
        this.localDate = localDate;
    }
}
