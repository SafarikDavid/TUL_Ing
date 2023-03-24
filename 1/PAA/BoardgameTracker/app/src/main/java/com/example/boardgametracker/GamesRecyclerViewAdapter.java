package com.example.boardgametracker;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class GamesRecyclerViewAdapter extends RecyclerView.Adapter<GamesRecyclerViewAdapter.ViewHolder> {
    private ArrayList<Game> games;
    private LayoutInflater mInflater;
    private ItemClickListener itemClickListener;

    public GamesRecyclerViewAdapter(Context context, ArrayList<Game> games){
        this.mInflater = LayoutInflater.from(context);
        this.games = games;
    }

    public ArrayList<Game> getGames() {
        return games;
    }

    @NonNull
    @Override
    public GamesRecyclerViewAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.recyclerview_games_row, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull GamesRecyclerViewAdapter.ViewHolder holder, int position) {
        Game game = games.get(position);
        holder.myTextView.setText(game.toString());
    }

    @Override
    public int getItemCount() {
        return games.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener{
        TextView myTextView;

        ViewHolder(View itemView){
            super(itemView);
            myTextView = itemView.findViewById(R.id.game_id);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            if (itemClickListener != null) itemClickListener.onItemClick(view, getAdapterPosition());
        }
    }

    String getItem(int id) {return games.get(id).toString();}

    void setClickListener(ItemClickListener itemClickListener){
        this.itemClickListener = itemClickListener;
    }

    // parent activity will implement this method to respond to click events
    public interface ItemClickListener {
        void onItemClick(View view, int position);
    }
}
