#' ---
#' title: "Introduction to R Workshop"
#' subtitle:  "Data Visualization with ggplot2"
#' author: "Mehrgol Tiv"
#' date: "3/18/2018"
#' output: 
#'   ioslides_presentation:
#'     widescreen: true
#'     css: styles/style.css
#' smaller: true
#' ---
#' 
#' 
## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, cache = TRUE)

#' 
#' ## Data Visualization 101 | A good graph is like a good joke
#' * It's not funny if you have to explain it  
#'     + Should be appropriate for your audience  
#'     + Should be appropriate for your data 
#'   
#' * It boils down to communication--make sure your graph conveys the relevant information in a digestable way
#' 
#' <div align="center">
#' <img src="images/lol-man.jpg" height=200>
#' </div>
#'   
#' ## ggplot2
#' * Created by Hadley Wickham in 2005 for data visualization in R
#' * Alternative to base R graphics (more personalizable & versatile)
#' *  Utilizes a graphical grammar of layers, where each component of the plot needs to be separately specified
#' * Extension projects include
#'     + ggplot for Python (ggpy: https://github.com/yhat/ggpy)
#'     + ggplot for Matlab (gramm: https://github.com/piermorel/gramm)
#'     + plotly, a web-based, collaborative data visualization program (https://plot.ly/)
#'   
#' ## Grammar of ggplot2 
#' 
#' - ggplot works in layers
#' - Each layer is added sequentially to produce the plot
#' - Each layer has five components --> makes ggplot call  
#'     + A dataset  
#'     + The aesthetic mapping (**aes()**)  
#'     + A statistical transformation (**stat= **)--there are some defaults so we don't always have to specify this  
#'     + A geometric object (**geom_**)  
#'     + A position adjustment (**position = **)
#' 
#' <div align="center">
#' <img src="images/shrek.jpg" height=200>
#' </div>
#'     
#' ## (1) The Dataset
#' - First, import ggplot2 and your dataset ( + other relevant packages)
## ---- echo=T, message=FALSE, warning=FALSE-------------------------------
library(ggplot2)
library(dplyr)

df = read.csv("data/allANT.csv")
df_run = read.csv("data/ANT_runsheet.csv")

#' 
#' - We can use dplyr to read dataset into ggplot function!
#' - If we plan to use the same dataset for the whole plot, we only need to specify it once, rather than at each layer
#' 
#' - **Note, the package is called "ggplot2" and the function is called "ggplot"**
#' 
## ---- eval = FALSE-------------------------------------------------------
## df %>% ggplot(...)
## 
## #To assign a plot to a variable...
## plot1 = df %>% ggplot(...)

#' 
#' ## (2) The Aesthetic Mapping {.smaller}
#' - The aesthetic mapping is the meat (or equivalent vegetarian protein form) of the plot
#' - Identifies what specific information from the dataset will be selected and represented by the layer
#' 
#' - Let's say we want to see the distribution of 'age' in our dataset by constructing a histogram from the runsheet
#' 
#' 
## ---- warning = FALSE, error = FALSE, fig.height=3, fig.width = 3--------
plot1 = df_run %>% ggplot(aes(age))

#' 
#' 
#' - Explictly specifying the x and y is optional--ggplot will take the first as x and the second as y (or, for univariate plotting like a histogram you can enter just one variable)
#' 
#' 
#' ----
#' 
#' 
#' - What does our plot look like?
## ---- fig.height=3-------------------------------------------------------
plot1

#' 
#' -There are no layers yet so the plot can't be displayed yet
#' 
#' ## (3) The Statistical Transformation {.smaller}
#' - Performs some useful statistical transformation
#' - Or can keep data as is, which is what we will do here
#' - Each stat has a default geom (just as every geom has a default stat)
#' 
#' - We add to our previous code...
#' 
## ---- eval = FALSE, warning = FALSE, error = FALSE, fig.height=3---------
## plot1 = df_run %>% ggplot(aes(age)) +
##   layer(
##     mapping = NULL, #already provided above
##     data = NULL, #already provided above
##     stat = "bin"
##   )

#' 
#' - But this still does not create a full layer yet
#' 
#' ## (4) A Geometric Object {.smaller}
#' - Perform the actual rendering of the layer, controlling the type of plot that you create
#' - Many different types of plots supported by ggplot
#' - Can serve as a shortcut to writing out all components of a layer (we'll get to this soon)
#' 
#' ## Common Geoms {.flexbox .vcenter}
#' 
#' ![](images/univar.png){ width=30% }
#' 
#' ## Common Geoms {.flexbox .vcenter}
#' 
#' ![](images/bivar.png){ width=30% }
#' 
#' ##Adding geom to call
#' 
## ---- eval = FALSE, warning = FALSE, error = FALSE, fig.height=3---------
## plot1 = df_run %>% ggplot(aes(age)) +
##   layer(
##     mapping = NULL, #already provided above
##     data = NULL, #already provided above
##     stat = "bin",
##     geom = "bar"
##   )

#' Not quite there yet
#' 
#' 
#' ## (5) Specifying a Position {.smaller}
#' * Position adjustments apply minor tweaks to the position of elements within a layer. Four adjustments apply primarily to bars:
#'     + identity: keep the data as is
#'     + dodge: place overlapping bars (or boxplots) side-by-side.
#'     + stack: stack overlapping bars (or areas) on top of each other.
#'     + fill: stack overlapping bars, scaling so the top is always at 1.
#'  
#'  
## ----  warning = FALSE, error = FALSE, fig.height=3----------------------
plot1 = df_run %>% ggplot(aes(age)) +
  layer(
    mapping = NULL, #already provided above
    data = NULL, #already provided above
    stat = "bin",
    geom = "bar",
    position = "identity"
  )

#' 
#' ----
#' 
#' Now we finally see our plot!
#' 
## ---- fig.height=3-------------------------------------------------------
plot1

#' 
#' ## Is there a shortcut?
#' - Yes! It is very time-consuming to type out all five components of each layer 
#' - Certain components of a layer have inherent/default settings
#' - For example, each stat has a default geom, and vice versa
#' - Often, we can just specify the geom and get what we want
#' 
## ---- fig.height=3-------------------------------------------------------
df_run %>% ggplot(aes(age)) + 
  geom_histogram() #Should be identical to previous plot

#' 
#' ## Customizing our histogram
#' - We can customize the layer by adding information to the geom_ function
#' - For a histogram, we can modify the size of the bars by increasing/decreasing the number of 'bins' 
#' - The number of bins tells ggplot how many groups to split data into and count the frequencies in that group
#' - **A large number of bins = fewer bars // small number of bins = more bars**
#' 
#' 
#' 
#' ----
#' 
## ---- fig.height=2, fig.width=3------------------------------------------
df_run %>% ggplot(aes(age)) + 
  geom_histogram(binwidth = 1)

df_run %>% ggplot(aes(age)) + 
  geom_histogram(binwidth = 50) 

#' 
#' ## What if we have missing values, for example in correct RT?
#' 
## ---- fig.height=3-------------------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_histogram(binwidth = 5)

#' 
#' ----
#' 
#' - We get a message that ggplot has removed the rows with NA values
#' - If we want to avoid this error, we can remove NA's
#' 
## ---- fig.height=3-------------------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_histogram(binwidth = 5,
                 na.rm = TRUE) #Voila!

#' 
#' 
#' ## Other Univariate Plots
#' 
#' - To plot the frequency of a single, continuous variable we have lots of options
#' - Density plots are very common and function similarly to a histogram
#' - Rather than "stat = bin", density plots use "stat = density" and draw a line rather than bars
#' 
## ---- fig.height=3-------------------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_density(na.rm = T)

#' 
#' ----
#' 
#' That being said, we can tell geom_density to use the bin stat
#' 
## ---- fig.height=3-------------------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_density(stat = "bin",
               binwidth = 10, 
               na.rm = T)

#' 
#' ## Layering Geoms
#' - We can add geoms on top of each other 
#' - Remember, ggplot works in layers so each independent object can live under/on top of another
#' 
#' 
## ---- fig.height=3-------------------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_histogram(binwidth = 10,
                 na.rm = T) +
  geom_density(stat = "bin",
               binwidth = 10,
               na.rm = T)  +
  geom_rug()

#' 
#' ## Changing the Appearance
#' 
#' - The gray on gray makes this plot difficult to see
#' - We can adjust the colors and the transparencies to make this plot more readable
#' 
## ---- fig.height=3-------------------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_histogram(binwidth = 10, na.rm = T, fill = "gray", color = "black", alpha = 0.5) +
  geom_density(stat = "bin", binwidth = 10, na.rm = T, color = "red") +
  geom_rug()

#' 
#' ## Aesthetic != Aesthetic
#' 
#' <div class="columns-2">
#'   ![](images/aesthetic.png)
#' 
#'   - If we want to make the plot more aesthetically pleasing, we do it **outside** of aes()
#'   
#'   - Changes to aes() MAP colors to a variable, whereas changes outside of aes() SET a color more generally
#' 
#' </div>
#' 
#' ## Mapping vs. Setting
#' 
#' <div class="columns-2">
#' 
## ---- fig.width=3, fig.height =3-----------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_histogram(binwidth = 10,
                 na.rm = T,
                 fill = "red",
                 color = "black") 

#' 
#' 
## ---- fig.width=3, fig.height=3------------------------------------------
df %>% ggplot(aes(correctRT)) + 
  geom_histogram(aes(fill = "red"),
                 binwidth = 10,
                 na.rm = T,
                 color = "black") 


#' 
#' </div>
#' 
#' 
#' 
#' ## Discrete Univariate Plots
#' 
#' - We can plot the frequency of discrete variables with a bar graph
#' - Unlike geom_histogram, geom_bar COUNTS the observations whereas geom_histogram returns the count in each bin
#' - Geom_bar returns a more granular view of the data than geom_histogram
#' - Let's compare by looking at age
#' 
#' ----
#' 
## ---- fig.height=3-------------------------------------------------------
df_run %>% ggplot(aes(age)) + geom_histogram(binwidth = 1, na.rm = T)

df_run %>% ggplot(aes(age)) + geom_bar(na.rm = T)

#' 
#' # Multivariate Plots | Plotting two or more variables
#' 
#' ##  Scatter Plots
#' - Let's say we want to look at the relationship between age and correct reaction time
#' 
## ---- fig.height =3, fig.width=4-----------------------------------------
df %>% ggplot(aes(age, correctRT)) + #Remember, the order is x, y
  geom_point(na.rm = T)

#' 
#' ----
#' 
#' What if we first want to see the distribution of correct RT within a group?
#' 
#' Can use dplyr.
#' 
## ---- fig.height =3, fig.width=4-----------------------------------------
df.young = df %>% filter(group == "Young")
df.young %>% ggplot(aes(age, correctRT)) + #Remember, the order is x, y
  geom_point(na.rm = T, position = "jitter", alpha = 0.3, size = 1)

#' 
#' ## A more informative plot {.smaller}
#' 
#' Perhaps we are interested to see if each group changes RT across blocks (do they get slower/faster throughout the experiment?)
#' 
## ---- fig.height =3, fig.width=4-----------------------------------------
df.block = df %>% select(subnum, group, block, correctRT) %>% group_by(subnum, block, group) %>% 
  summarise(mdv = mean(correctRT, na.rm = T)) %>% ungroup() %>% group_by(block, group) %>% 
  summarise(N = n(), mean_correctRT = mean(mdv, na.rm = T), sd = sd(mdv), serr = sd/sqrt(N))

df.block %>% ggplot(aes(block, mean_correctRT)) + 
  geom_line(na.rm = T, aes(color = group)) + geom_point(na.rm = T, aes(color = group))

#' 
#' ## Adding error bars 
#' 
## ---- fig.height =3, fig.width=4-----------------------------------------
df.block %>%  ggplot(aes(block, mean_correctRT)) + 
  geom_line(na.rm = T, aes(color = group)) + geom_point(na.rm = T, aes(color = group)) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), width = 0.3)

#' 
#' Without the error bars, it seemed like perhaps younger subjects got faster with time, but adding error bars suggests that this is likely not a significant change.
#' 
#' 
#' ## Bar Plots
#' - Perhaps we want to compare young and old adults on correct reaction time 
#' - Start by making a summary table of means & standard errors to be plotted
#' 
## ---- fig.height =3, fig.width=3-----------------------------------------

df.group = df %>% select(subnum, group, correctRT) %>% 
  group_by(subnum, group) %>% 
  summarise(mdv = mean(correctRT, na.rm = T)) %>% 
  ungroup() %>% group_by(group) %>% 
  summarise(N = n(), mean_correctRT = mean(mdv, na.rm = T), 
            sd = sd(mdv), serr = sd/sqrt(N)) 

#' 
#' ----
#' 
## ---- fig.height =3, fig.width=3-----------------------------------------
df.group %>% ggplot(aes(group, mean_correctRT)) + 
  geom_bar(stat = "identity", position = "dodge", alpha = 0.7) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.3, position = "dodge") +
  coord_cartesian(ylim=c(350,450)) + 
  scale_y_continuous(breaks = c(350, 375, 400, 425, 450))

## Be cautious of setting limits in scale_y_continuous because it will 
## remove data outside the range. 

#' 
#' ## More Dodge Bar Plots
#' 
## ---- fig.width = 4, fig.height = 4--------------------------------------
df.group.err = df %>% select(subnum, group, block, error) %>% group_by(group, block) %>% 
  summarise(mean_err = mean(error, na.rm = T)) 

df.group.err %>% ggplot(aes(block, mean_err)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge")


#' 
#' 
#' ## Flipping the Axis
#' 
## ---- fig.width = 4, fig.height = 4--------------------------------------

df.group.err %>% ggplot(aes(block, mean_err)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge") + coord_flip()


#' 
#' ## Stacked Bar Plots
## ---- fig.width = 3, fig.height = 3--------------------------------------
df.group.err %>% ggplot(aes(block, mean_err)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "stack")

#' 
#' 
#' ## RT based on flank
#' 
#' 
## ---- fig.width = 3, fig.height = 3--------------------------------------
df.flank = df %>% select(subnum, group, flank, correctRT) %>% 
  group_by(subnum, group, flank) %>% 
  summarise(mdv = mean(correctRT, na.rm = T)) %>% 
  ungroup() %>% group_by(group, flank) %>% 
  summarise(N = n(), mean_correctRT = mean(mdv, na.rm = T), 
            sd = sd(mdv, na.rm=T), serr = sd/sqrt(N)) 

#' 
#' 
#' ## RT based on flank
#' 
#' 
## ---- fig.width = 4, fig.height = 3--------------------------------------
df.flank %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  coord_cartesian(ylim=c(300,500)) + 
  scale_y_continuous(breaks = c(300, 350,400, 450, 500))

#' 
#' 
#' 
#' ## Using Facets
#' 
#' - Perhaps we want to see the mean RT for each flank across blocks
#' - Facets allow you to create panels to display different information
#' 
## ------------------------------------------------------------------------
df.facet = df %>% select(subnum, group, block, flank, correctRT) %>% 
  group_by(subnum, group, block, flank) %>% 
  summarise(mdv = mean(correctRT, na.rm = T)) %>% 
  ungroup() %>% group_by(group, flank, block) %>% 
  summarise(N = n(), mean_correctRT = mean(mdv, na.rm = T), 
            sd = sd(mdv, na.rm = T), serr = sd/sqrt(N)) 


#' 
#' ----
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block)


#' 
#' 
#' ## Using facets to check for subject variability
#' 
## ---- fig.width =8-------------------------------------------------------
df.facet.subj = df %>% select(subnum, group, flank, correctRT) %>% 
  group_by(subnum, group, flank) %>% 
  summarise(N = n(), mean_correctRT = mean(correctRT, na.rm = T), 
            sd = sd(correctRT, na.rm = T), serr = sd/sqrt(N)) 

head(df.facet.subj, 3)

#' 
#' 
#' ## Using facets to check for subject variability
#' 
## ---- fig.width =8-------------------------------------------------------
df.facet.subj %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~subnum)

#' 
#' 
#' # Themes//Colors//Appearances | The fun stuff
#' 
#' ## Adjusting Axis Titles
#' 
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block) + 
  scale_y_continuous(name = "Mean Correct RT") + scale_x_discrete(name = "Flank Position")


#' 
#' 
#' ## Adjusting Axis Titles (Another way)
#' 
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block) + 
  ylab("Mean Correct RT") + xlab("Flank Position")


#' 
#' 
#' ## Adjusting Axis Text {.smaller}
#' 
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block) + 
  scale_y_continuous(name = "Mean Correct RT") +
  scale_x_discrete(breaks = c("Congruent", "Incongruent", "Neutral"), 
                   labels = c("Cong", "Incong", "Neut"))


#' 
#' 
#' ## Reordering levels {.smaller}
#' 
#' 
## ---- fig.width = 8------------------------------------------------------

df.facet$flank = factor(df.facet$flank, levels = c("Congruent", "Neutral", "Incongruent"))

df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block) + 
  scale_y_continuous(name = "Mean Correct RT") 

#' 
#' ## Reordering levels with a Reference Level {.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet.bi = df.facet %>% filter(flank != "Neutral")
df.facet.bi$flank = relevel(df.facet.bi$flank, ref = "Incongruent")

df.facet.bi %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block) + 
  scale_y_continuous(name = "Mean Correct RT") 

#' 
#' 
#' ## Renaming Facets {.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
block.names = c("1" = "Early", "2" = "Early", "3" = "Early", 
                "4" = "Late", "5"= "Late", "6" = "Late")

df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") 

#' 
#' ## Thematic Changes{.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  theme_minimal() 

#' 
#' ## Thematic Changes{.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  theme_bw() 

#' 
#' 
#' ## Changing font size{.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  theme_bw() +
  theme(axis.title.x = element_blank(), axis.text.x = element_text(size = 13,angle = 90))

#' 
#' 
#' ## Plot Titles{.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  ggtitle("Correct RT for Young and Old Adults") +
  theme_bw() + theme(plot.title = element_text(hjust = 0.5, size = 20))

#' 
#' 
#' ## Facet Font Size{.smaller}
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  ggtitle("Correct RT for Young and Old Adults") +
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5, size = 20),
        strip.text.x = element_text(size = 14))

#' 
#' 
#' ## Changing Color Schemes
#' 
#' ![](images/colors.png){width=50%}
#' 
#' ## Manual Fill {.smaller}
#' 
#' 
## ---- fig.width = 8------------------------------------------------------
df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  ggtitle("Correct RT for Young and Old Adults") +
  theme_bw() + theme(plot.title = element_text(hjust = 0.5, size = 20),
                     strip.text.x = element_text(size =14)) +
  scale_fill_manual(name = "Age Group", values = c("steelblue4", "thistle4"))

#' 
#' 
#' ## The Wes Anderson Color Palette{.flexbox .vcenter}
#' 
#' ![](images/wes.png)
#' 
#' ----
#' 
#' 
## ---- fig.height = 3-----------------------------------------------------
library(wesanderson)

df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  ggtitle("Correct RT for Young and Old Adults") +
  theme_bw() + theme(plot.title = element_text(hjust = 0.5, size = 20),
                     strip.text.x = element_text(size =14)) +
  scale_fill_manual(name = "Age Group", values=wes_palette(n=2, name="GrandBudapest"))

#' 
#' 
#' ## Saving & Exporting ggplot
#' 
## ---- fig.width = 8------------------------------------------------------
final_plot = df.facet %>% ggplot(aes(flank, mean_correctRT, group = group)) + 
  geom_bar(aes(fill = group), stat = "identity", position = "dodge", width = 0.8) + 
  geom_errorbar(aes(ymin = mean_correctRT - serr, ymax = mean_correctRT + serr), 
                width = 0.8, position = "dodge") +
  facet_wrap(~block, labeller = labeller(block = block.names)) + 
  scale_y_continuous(name = "Mean Correct RT") +
  ggtitle("Correct RT for Young and Old Adults") +
  theme_bw() + theme(plot.title = element_text(hjust = 0.5, size = 20),
                     strip.text.x = element_text(size =14)) +
  scale_fill_manual(values=wes_palette(n=2, name="GrandBudapest"))

ggsave("output/final_plot.png", final_plot)

#' 
#' 
#' ## Additional Resources
#' 
#' - http://www.storybench.org/getting-started-data-visualization-r-using-ggplot2/
#' - https://rpubs.com/hadley/ggplot2-layers
#' - https://rstudio-pubs-static.s3.amazonaws.com/85508_2affd4b9027d4c97b601d338bbf419d7.html#sec:data
#' - https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
#' - http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
#' - http://sape.inf.usi.ch/quick-reference/ggplot2/colour
#' 
#' # Happy coding!
