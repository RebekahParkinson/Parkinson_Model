library(ggplot2) 
library(corrr)
library(ggcorrplot)
library(factoextra)
library(dplyr)

data_raw = read.csv("Data/DigiGait_AllStandardVariables.csv")
data_raw[data_raw == '-' | data_raw == ' - ' | data_raw == '#DIV/0!' | data_raw == ''] <- NA 
colnames(data_raw) #
colSums(is.na(data_raw)) 
data_raw <- data_raw %>%
  mutate(Condition = case_when(
      Condition == "Sham Sham" ~ "Sham", 
      Condition == "Peptide DMSO" ~ "Peptide",
      Condition == "Peptide Sham" ~ "Peptide",
      # Condition == "Sham DMSO" ~ "Sham",
      TRUE ~ Condition
  ))
filtered_data <- data_raw %>%
  filter(Condition %in% c("Sham","Peptide"),
        Batch !=7,
        Time.point..weeks. == 8
        )
str(filtered_data)
filtered_data <- filtered_data %>%
  mutate(across(c(StanceWidth, StepAngle, SWVar, StepAngleVar, Stance.Width.CV, Step.Angle.CV, Hind.Limb.Shared.Stance.Time, X..Shared.Stance, StanceFactor, Tau...Propulsion, Paw.Drag), as.numeric, .default = NA_real_))
averaged_data <- filtered_data %>%
  group_by(Ms., Batch, Condition) %>%
  summarise(across(.cols = where(is.numeric), 
                   .fns = ~mean(.x, na.rm = TRUE)),
            .groups = "drop")
unique_combinations <- filtered_data %>%
  distinct(Ms., Batch)
unique_combinations 
condition_values <- averaged_data $Condition
columns_to_remove <- c('Batch', 'Ms.', 'Condition','Time.point..weeks.')
averaged_data <- averaged_data %>% dplyr::select(-all_of(columns_to_remove))
print(paste("Number of rows in the dataset:", nrow(averaged_data)))
data.pca <- prcomp(averaged_data, center = TRUE, scale. = TRUE)  
whitened_scores <- sweep(data.pca$x, 2, data.pca$sdev, FUN="/")
whitened_df <- data.frame(Whitened_PC1 = whitened_scores[, 1], 
                          Whitened_PC2 = whitened_scores[, 2], 
                          Condition = condition_values)
ggplot(whitened_df, aes(x = Whitened_PC1, y = Whitened_PC2, color = Condition)) +
  geom_point() +  # Plot the points
  stat_ellipse(aes(fill = Condition), geom = "polygon", alpha = 0.2, level = 0.75) + 
  scale_fill_manual(values = c("cyan", "black")) +  
  scale_color_manual(values = c("cyan", "black")) + 
  theme_minimal() +
  labs(title = "Whitened PCA Results by Condition", x = "Whitened PC1", y = "Whitened PC2") +
  guides(fill = guide_legend(title = "Condition"), color = guide_legend(title = "Condition"))
data.pca$loadings[, 1:2]
fviz_eig(data.pca, addlabels = TRUE) 
pca_scores <- data.pca$scores
unique_conditions <- unique(condition_values)
color_palette <- c( "cyan","black")
fviz_cos2(data.pca, choice = "var", axes = 2)
pca_df <- data.frame(data.pca$x, Condition = condition_values) 
pca_df$Condition <- as.factor(pca_df$Condition)
pc1_data <- data.frame(PC1 = data.pca$x[, "PC1"], Condition = condition_values)
means <- pc1_data %>% group_by(Condition) %>% summarise(MeanPC1 = mean(PC1))
ggplot(pc1_data, aes(x = PC1, fill = Condition)) +
  geom_histogram(bins = 50, position = "identity", alpha = 0.6) +
  scale_fill_manual(values = color_palette) +
  geom_vline(data = means, aes(xintercept = MeanPC1, color = Condition), linetype = "dashed", size = 1) +
  scale_color_manual(values = color_palette) +
  theme_minimal() +
  labs(title = "Histogram of PC1", x = "PC1 Scores", y = "Count", fill = "Condition") +
  theme(legend.position = "bottom")
ggplot(pc1_data, aes(x = PC1, fill = Condition)) +
  geom_histogram(aes(y = ..density..), bins = 50, position = "identity", alpha = 0.6) +
  geom_density(aes(color = Condition), size = 1, alpha = 0) + # Adjust alpha for density curves
  scale_fill_manual(values = color_palette) +
  scale_color_manual(values = color_palette) +
  theme_minimal() +
  labs(title = "Histogram of PC1", x = "PC1 Scores", y = "Density", fill = "Condition", color = "Condition") +
  theme(legend.position = "bottom")

pc2_data <- data.frame(PC2 = data.pca$x[, "PC2"], Condition = condition_values)
means <- pc2_data %>% group_by(Condition) %>% summarise(MeanPC1 = mean(PC2))
ggplot(pc2_data, aes(x = PC2, fill = Condition)) +
  geom_histogram(bins = 50, position = "identity", alpha = 0.6) +
  scale_fill_manual(values = color_palette) +
  geom_vline(data = means, aes(xintercept = MeanPC1, color = Condition), linetype = "dashed", size = 1) +
  scale_color_manual(values = color_palette) +
  theme_minimal() +
  labs(title = "Histogram of PC2", x = "PC2 Scores", y = "Count", fill = "Condition") +
  theme(legend.position = "bottom")
ggplot(pc2_data, aes(x = PC2, fill = Condition)) +
  geom_histogram(aes(y = ..density..), bins = 50, position = "identity", alpha = 0.6) +
  geom_density(aes(color = Condition), size = 1, alpha = 0) + # Adjust alpha for density curves
  scale_fill_manual(values = color_palette) +
  scale_color_manual(values = color_palette) +
  theme_minimal() +
  labs(title = "Histogram of PC2", x = "PC2 Scores", y = "Density", fill = "Condition", color = "Condition") +
  theme(legend.position = "bottom")
fviz_pca_biplot(data.pca, 
                geom_ind = "point", 
                geom_var = "arrow", 
                col.ind = pca_df$Condition,  # Color by 'Condition'
                fill.ind = pca_df$Condition,
                palette = color_palette,     # Use the specified color palette
                col.var = "black",           # Color for variables
                repel = TRUE,                # Avoid text overlapping
                pointsize = 2,               # Size of the points
                pointshape = 21,             # Shape of the points
                arrowsize = 0.4,             # Size of the arrows
                labelsize = 3,               # Size of the labels
                addEllipses = TRUE,          # Add ellipses around clusters
                ellipse.level = 0.75,
                ellipse.type = "t") # Type of ellipse
print(fviz_pca_biplot)



#####Stats
# Extract PC1 scores and combine with condition values
pc1_data <- data.frame(PC1 = data.pca$x[, "PC1"], Condition = condition_values)

# Check Normality: Shapiro-Wilk test
pc1_data %>%
  group_by(Condition) %>%
  summarise(shapiro_test_p_value = shapiro.test(PC1)$p.value)
##if test is significant (p < . 05) then the distribution in question is significantly different from a normal distribution

# Checking Homogeneity of Variances: Levene's Test
library(car)
levene_test_result <- leveneTest(PC1 ~ Condition, data = pc1_data)
print(levene_test_result)
#If the p-value for the Levene's test is less than . 05, then there is a Significant difference between the variances.

# # Perform ANOVA & multiple comparisons
# anova_result <- aov(PC1 ~ Condition, data = pc1_data)
# summary(anova_result)
# anova_summary <- summary(anova_result)
# if (anova_summary[[1]]$'Pr(>F)'[1] < 0.05) {
#   # Perform Post-hoc test
#   posthoc_result <- TukeyHSD(anova_result)
#   print(posthoc_result)
# } else {
#   print("No significant differences found by ANOVA")
# }

##OR (if failto meet normality and homogeneity assumptions) Kruskal-Wallis test
kruskal_test_result <- kruskal.test(PC1 ~ Condition, data = pc1_data)
print(kruskal_test_result)
library(dunn.test)
dunn_test_result <- dunn.test(pc1_data$PC1, pc1_data$Condition, method = "bonferroni")
print(dunn_test_result)



#TTEST
group1 <- pc1_data$PC1[pc1_data$Condition == "No Induction and Sham"]
group2 <- pc1_data$PC1[pc1_data$Condition == "Peptide"]
t_test_result <- t.test(group1, group2)
p_value <- t_test_result$p.value

#Boxplot
ggplot(pc1_data, aes(x = Condition, y = PC1, color = Condition)) +
  geom_boxplot() +
  geom_jitter() +
  annotate("text", x = 1.5, y = max(pc1_data$PC1), label = paste("p-value:", round(p_value, 3)), 
           vjust = -0.5, size = 4, color = "black") +
  theme_minimal() +
  labs(title = "PC1 Scores by Condition", x = "Condition", y = "PC1 Score")

