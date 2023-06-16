class UserController < ApplicationController

  skip_before_action(:force_user_sign_in, { :only => [:home]})

  def home

    matching_users = User.all

     @list_of_users = matching_users.order({ :username => :asc})

     match_following = FollowRequest.all


      render({:template => "users/homepage.html.erb"})
  end

  def show
    user = params.fetch("path_id")

    @the_user = User.where({ :username => user}).at(0)

    @follower_count = FollowRequest.where(:recipient_id => @the_user.id )

    match_following = FollowRequest.where({:sender_id => session.fetch(:user_id)}).where({:recipient_id => @the_user.id}).at(0)

    if @the_user.id == session.fetch(:user_id)

      render({:template => "users/show.html.erb"})
      
    elsif @the_user.private == false

        render({:template => "users/show.html.erb"})
    
    else

      if match_following != nil && match_following.status == "accepted"
  
        render({:template => "users/show.html.erb"})

      else
          redirect_to("/", { :alert => "You're not authorized for that." })

        end

    end

  end

  def feed

    user = params.fetch("path_id")

    @get_user = User.where({:username => user}).at(0)

    @get_following = FollowRequest.where({:sender_id => @get_user.id}).where({:status => "accepted" }).map_relation_to_array(:recipient_id)

    render({:template => "users/feed.html.erb"})
  end

  def liked_photos

    user = params.fetch("path_id")

    @get_user = User.where({:username => user}).at(0)

    @get_likes = Like.where({:fan_id => @get_user.id}).map_relation_to_array(:photo_id)

    @get_photos = Photo.where({:id => @get_likes}).order({ :created_at => :desc })

    render({:template => "users/liked_photos.html.erb"})
  end

  def discover

    user = params.fetch("path_id")

    @get_user = User.where({:username => user}).at(0)

    get_following = FollowRequest.where({:sender_id => @get_user.id}).where({:status => "accepted" }).map_relation_to_array(:recipient_id)

    get_likes = Like.where({ :fan_id => get_following }).map_relation_to_array(:photo_id)

    @get_photos = Photo.where({:id => get_likes}).order({ :created_at => :desc })

    render({:template => "users/discover.html.erb"})
  end

end
