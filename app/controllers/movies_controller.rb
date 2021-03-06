class MoviesController < ApplicationController
    require 'httparty'
    
    def index
        if params[:movie_title].blank?  
            redirect_to(root_path, alert: "Empty field!") and return  
        else  
            @movietitle = params[:movie_title].downcase
            @response = HTTParty.get('http://www.omdbapi.com/?s='+ params[:movie_title].to_s + "&apikey=" + ENV['MOVIEVERSE_API_KEY'])
            @user=current_user
            @currentUser = current_user.id

        end

        
    end

    def new
        @newcomment = Comment.new
    end

    def create_comment
        @currentUser = current_user.id
        @comments = Comment.where(movie_id: @movie_id)
        @movie_id = params[:movie_id]
        @newcomment = Comment.create(
            user_id: @currentUser,
            movie_id: @movie_id,
            content: params[:content]
        )
            redirect_to request.referrer
    end

    def delete_comment
        @currentUser = current_user.id
        @comments = Comment.find(params[:id])
        @comments.destroy
        
        redirect_to request.referrer
        
    end

    def add_movie
        @currentUser = current_user.id
        @movie_id = params[:movie_id]
        @response = HTTParty.get('http://www.omdbapi.com/?i='+ @movie_id.to_s + "&apikey=" + ENV['MOVIEVERSE_API_KEY'])
        @addmovie = Movie.create(
            user_id: @currentUser,
            movie_id: @movie_id,
            setdate: params[:setdate],
            movietitle: @response["Title"],
            movieposter: @response["Poster"]
        )

            redirect_to root_path
    end

    def show
            @response = HTTParty.get('http://www.omdbapi.com/?i='+ params[:id].to_s + "&apikey=" + ENV['MOVIEVERSE_API_KEY'])
            @currentUser = current_user.id
            @movie_id = @response["imdbID"]
            @comments = Comment.where(movie_id: @movie_id)       
    end 

    def destroy
        
        @movie = Movie.find(params[:id])
        @movie.destroy
            redirect_to request.referrer
    end

    private
    def search_params
        params.require(:movie).permit(:movie)
      end
end
