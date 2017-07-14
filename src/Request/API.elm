module Request.API exposing (baseUrl)

import Config exposing (baseUrl)

-- API BASE URL --
baseUrl : String
baseUrl = Config.baseUrl ++ "/api"
