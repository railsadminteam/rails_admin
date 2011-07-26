As long as rails_admin routes are loaded after your routes, If you have a route that can match /admin for example /:user, you have to add a constrain in that route.

I resolve the problem by this way.

    resources :profiles, :path => '', :constraints => lambda {|req| !(req.path =~ /\A\/admin(\/.*)?\z/)  } do
      ...
    end


Any other way of doing it, is welcome.