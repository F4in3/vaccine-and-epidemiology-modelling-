install.packages("deSolve")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tidyr")
library(deSolve)
library(ggplot2)
library(dplyr)
library(tidyr)
#parameters 
R0_basic <- 3
gamma <- 1 / 7
beta <- R0_basic * gamma
params_sir <- c(beta = beta, gamma = gamma)
initial_infected <- 0.001
time <- seq(0, 160, by = 0.1)
herd_threshold <- 1 - (1 / R0_basic)
herd_threshold
#herd threshold 0.6666667

#Sir(model)prize
model_sir <- function(t, y, params) {
with(as.list(c(params, y)), {
dS <- -beta * S * I
dI <- beta * S * I - gamma * I
dR <- gamma * I
list(c(dS, dI, dR))
  })
}
# one vaccination coverage 
simulate_sir <- function(vaccination_coverage) {
init_sir <- c(
S = 1 - initial_infected - vaccination_coverage,
I = initial_infected,
R = vaccination_coverage
)
out_sir <- as.data.frame(
ode(
y = init_sir,
times = time,
func = model_sir,
parms = params_sir
)
)
out_sir$vaccination_coverage <- vaccination_coverage
out_sir$vaccination_percent <- vaccination_coverage * 100
  
return(out_sir)
}
#vaccination with dif cover
selected_vaccination <- c(0, 0.30, 0.50, herd_threshold, 0.80, 0.90)
selected_models <- lapply(selected_vaccination, simulate_sir)
sir_curves <- bind_rows(selected_models)
sir_curves$vaccination_label <- paste0(
round(sir_curves$vaccination_coverage * 100, 1),
"% vaccinated"
)
#graph time for figure 
figure_1 <- ggplot(
sir_curves,
aes(
  x = time,
  y = I * 100,
  colour = vaccination_label
)
) +
geom_line(linewidth = 1) +
  labs(
title = "Effect of vaccination coverage on active infections",
  x = "Time since infectious disease introduction (days)",
  y = "Active infections (% of population)",
  colour = "Vaccination coverage"
) +
theme_bw()
figure_1

# outbreaks across vaccination cover
vaccination_gradient <- seq(0, 0.95, by = 0.01)
all_models <- lapply(vaccination_gradient, simulate_sir)
all_outputs <- bind_rows(all_models)
#measure outbreak size, time and infections 
summary_results <- all_outputs %>%
group_by(vaccination_coverage) %>%
 summarise(
  vaccination_percent = first(vaccination_percent),
  initial_Re = R0_basic * first(S),
  peak_infectious = max(I),
  time_to_peak = time[which.max(I)],
  final_recovered = last(R),
  final_epidemic_size = final_recovered - first(vaccination_coverage),
  .groups = "drop"
  )
summary_results <- summary_results %>%
 mutate(
  Peak_active_infections = peak_infectious * 100,
  final_epidemic_size_percent = final_epidemic_size * 100
 )
head(summary_results)

#another figure
summary_long <- summary_results %>%
select(
  vaccination_percent,
  final_epidemic_size_percent,
  Peak_active_infections
) %>%
pivot_longer(
  cols = c(final_epidemic_size_percent, Peak_active_infections),
  names_to = "outcome",
  values_to = "value"
) %>%
mutate(
  outcome = recode(
    outcome,
    final_epidemic_size_percent = "Final epidemic size",
    Peak_active_infections = "Peak active infections"
    )
  )
#ggplot time.. finally
figure_2 <- ggplot(
  summary_long,
  aes(
    x = vaccination_percent,
    y = value
  )
) +
  geom_line(linewidth = 1) +
  geom_vline(
    xintercept = herd_threshold * 100,
    linetype = "dashed"
  ) +
 facet_wrap(~ outcome, scales = "free_y") +
 labs(
    title = "How vaccination coverage changes outbreak severity",
    x = "People vaccinated before the outbreak (%)",
    y = "Population affected (%)"
  ) +
  theme_bw()
figure_2

#results section 
selected_outputs <- sir_curves %>%
  group_by(vaccination_coverage) %>%
summarise(
  vaccination_percent = first(vaccination_percent),
  initial_Re = R0_basic * first(S),
  peak_active_infections = max(I),
  time_to_peak = time[which.max(I)],
  final_recovered = last(R),
  total_infected_during_outbreak = final_recovered - first(vaccination_coverage),
  .groups = "drop"
  ) %>%
mutate(
  peak_active_infections_percent = peak_active_infections * 100,
  total_infected_during_outbreak_percent = total_infected_during_outbreak * 100
)
selected_outputs_report <- selected_outputs %>%
transmute(
  vaccination_percent = round(vaccination_percent, 1),
  initial_Re = round(initial_Re, 2),
  peak_active_infections_percent = round(peak_active_infections_percent, 2),
  time_to_peak_days = round(time_to_peak, 1),
  total_infected_during_outbreak_percent = round(total_infected_during_outbreak_percent, 2)
  )

selected_outputs_report
print(selected_outputs_report, width = Inf)
