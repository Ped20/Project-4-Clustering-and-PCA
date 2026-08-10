# PROJECT 4: Unsupervised Genotype Clustering & PCA
# Goal: Grouping of 100 genotypes into clusters based on physical measurements.
# Tasks: Perform PCA, apply clustering algorithms, and visualize results.

# Process- simplified
# 1. Get tools           → library(...)
# 2. Get data            → read_excel(), keep 4 columns with numeric variable
# 3. Same measuring tape → scale()
# 4. Sort into 3 groups  → kmeans()
# 5. Squeeze 4D into 2D  → prcomp()
# 6. Draw the groups     → fviz_cluster()
# 7. Save the picture    → ggsave()


# 1. Load Libraries
library(readxl)
library(ggplot2)
library(factoextra)

# 2. Load Data and Extract Numerical Features

d <- read_excel("C:/Users/prath/OneDrive/Desktop/proj1.xlsx", 
                    col_types = c("text", "numeric", "numeric", 
                                  "numeric", "numeric", "text"))
View(d)
trait <- d[ , c( "L", "B", "SL", "RL")]


# 3. Scaling the data (Important for clustering)

st <- scale(trait)    # st = scale trait object created for scaling the trait


# 4. Running K-Means (Group into 3 clusters)

set.seed(123) #Setting a seed fixes the randomness so I get the same result every time
km <- kmeans(st, centers = 3)  # km= k-means object created 

table(km$cluster) # to see how many plants are in each group when clustered


# 5. Principal Component Analysis (PCA)
pca <- prcomp(st, center = TRUE, scale. = TRUE)
print(summary(pca))


# 6. Visualize the Clusters

p<- fviz_cluster(km, data = trait,
             palette      = c("#E41A1C", "#377EB8", "#4DAF4A"),
             ellipse.type = "t",
             repel        = TRUE)+
  labs(title    = "Clustering of 100 Plant Genotypes",
       subtitle = "K-Means (K = 3) on Scaled Trait Data",
       x = "PC-1 (99.6 % of variation)",
       y = "PC-2 (0.3 % of variation)")+
  theme_minimal()
print(p)

# 7. saving the plots
ggsave("PCA_plot.png", p, width = 8, height = 6, dpi = 300)

# 8. Interpreting the Cluster
aggregate(trait, by = list(Cluster = km$cluster), FUN = mean)
# where Cluster 1 -> tall, wide, long roots = "High performers"
# where Cluster 2 -> middle                 = "Average"
# where Cluster 3 -> smallest overall       = "Low performers"



