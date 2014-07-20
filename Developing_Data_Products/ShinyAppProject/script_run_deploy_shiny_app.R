

# to run the app
library(shiny)

# to run the app in the browser 
runApp()

# to run the app in the browser and show the code
runApp(display.mode = "showcase")


# to display the app within RStudio
rstudio::viewer("http://localhost:8100")
# to run the app in RStudio viewer and show the code
runApp(display.mode = "showcase", launch.browser = rstudio::viewer)



install.packages('devtools')
devtools::install_github('rstudio/shinyapps')
library(shinyapps)
shinyapps::setAccountInfo(name='diegolopezpozueta', token='F3DF687050242E4E59BEFBD4F30C5704', secret='xudQAotljNW5ayn7NhfhcUGJisSuD4sTwXYWhGJh')

library(shinyapps)
deployApp()
